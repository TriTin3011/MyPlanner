using System.Net.Http;
using System.Windows;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Extensions.DependencyInjection;
using MyPlanner.Desktop.Api;
using MyPlanner.Desktop.Auth;
using MyPlanner.Desktop.Hosting;

namespace MyPlanner.Desktop.ViewModels;

// "Router" của app desktop: giữ ViewModel đang hiển thị (CurrentPage).
// MainWindow có một ContentControl bind vào CurrentPage; DataTemplate theo kiểu VM chọn View tương ứng.
// Giống <Outlet/> + route của React Router, nhưng điều hướng bằng cách đổi object chứ không đổi URL.
public partial class ShellViewModel : ObservableObject
{
    private readonly IServiceProvider _services;
    private readonly TokenStore _tokens;
    private readonly PlannerApiClient _api;
    private readonly LocalBackend _backend;

    [ObservableProperty] private ObservableObject? _currentPage;
    [ObservableProperty] private string? _userName;
    [ObservableProperty] private string? _startupMessage;
    [ObservableProperty] private string? _startupError;
    // Mốc tiến độ khởi động, 0 đến 100.
    [ObservableProperty] private double _startupProgress;
    // Backend đã sẵn sàng và bản cài có giao diện web: MainWindow chuyển sang WebView2.
    [ObservableProperty] private bool _webUiReady;

    public ShellViewModel(IServiceProvider services, TokenStore tokens, PlannerApiClient api, SessionEvents events, LocalBackend backend)
    {
        _backend = backend;
        _services = services;
        _tokens = tokens;
        _api = api;
        // Handler HTTP có thể chạy ở thread pool; đổi màn hình phải về UI thread qua Dispatcher.
        events.SessionExpired += (_, _) => Application.Current?.Dispatcher.Invoke(ShowLogin);
    }

    // Mở app: có token còn hạn thì hỏi /auth/me để chắc server vẫn chấp nhận, không thì về đăng nhập.
    [RelayCommand]
    public async Task StartAsync()
    {
        StartupError = null;
        WebUiReady = false;
        StartupMessage = "Đang mở Mầm...";
        StartupProgress = 5;
        try
        {
            // Progress<T> tạo trên UI thread nên báo tiến độ về đúng thread của giao diện.
            await _backend.EnsureStartedAsync(new Progress<StartupStep>(step =>
            {
                StartupMessage = step.Message;
                StartupProgress = step.Percent;
            }));
        }
        catch (Exception ex) when (ex is InvalidOperationException or TimeoutException or System.IO.IOException or System.ComponentModel.Win32Exception)
        {
            // Gán lỗi trước: MainWindow coi "không còn message, không có lỗi" là đã khởi động xong.
            StartupError = ex.Message;
            StartupMessage = null;
            return;
        }
        StartupProgress = 85;
        StartupMessage = null;

        // Giao diện web tự lo đăng nhập và lưu token của nó.
        if (WebUiHost.IsAvailable)
        {
            WebUiReady = true;
            return;
        }

        _tokens.Load();
        if (!_tokens.HasValidToken) { ShowLogin(); return; }
        try
        {
            var me = await _api.MeAsync();
            if (me is null) { ShowLogin(); return; }
            await ShowTodayAsync();
        }
        catch (HttpRequestException)
        {
            // 401 đã được BearerTokenHandler xử lý (xoá token, về đăng nhập); lỗi mạng thì cũng về đăng nhập.
            ShowLogin();
        }
    }

    [RelayCommand]
    private void Logout()
    {
        _tokens.Clear();
        ShowLogin();
    }

    private void ShowLogin()
    {
        UserName = null;
        var login = _services.GetRequiredService<LoginViewModel>();
        login.LoggedIn = () => _ = ShowTodayAsync();
        CurrentPage = login;
    }

    private Task ShowTodayAsync()
    {
        UserName = _tokens.Current?.UserName;
        return NavigateAsync("today");
    }

    // Thanh điều hướng gửi một khoá trang; shell xin DI tạo VM mới (Transient) rồi gọi ActivateAsync.
    // Shell chỉ biết IPageViewModel, không biết trang nạp dữ liệu thế nào (giống loader của route).
    [RelayCommand]
    private async Task NavigateAsync(string page)
    {
        IPageViewModel vm = page switch
        {
            "week" => _services.GetRequiredService<WeekViewModel>(),
            "habits" => _services.GetRequiredService<HabitsViewModel>(),
            "goals" => _services.GetRequiredService<GoalsViewModel>(),
            "year" => _services.GetRequiredService<YearViewModel>(),
            "stats" => _services.GetRequiredService<StatsViewModel>(),
            _ => _services.GetRequiredService<TodayViewModel>(),
        };
        CurrentPage = (ObservableObject)vm;
        await vm.ActivateAsync();
    }
}
