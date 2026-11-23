using System.Windows;
using Microsoft.Extensions.DependencyInjection;
using MyPlanner.Desktop.Api;
using MyPlanner.Desktop.Auth;
using MyPlanner.Desktop.Hosting;
using MyPlanner.Desktop.ViewModels;

namespace MyPlanner.Desktop;

// Composition root: nơi duy nhất "lắp" các lớp với nhau, giống Program.cs của API.
public partial class App : Application
{
    private ServiceProvider? _services;
    private Mutex? _singleInstance;

    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);

        // Chỉ một cửa sổ: hai bản cùng mở sẽ tranh nhau quản lý tiến trình API.
        _singleInstance = new Mutex(initiallyOwned: true, @"Local\Mam.Desktop", out var isFirst);
        if (!isFirst)
        {
            MessageBox.Show("Mầm đang mở rồi.", "Mầm", MessageBoxButton.OK, MessageBoxImage.Information);
            Shutdown();
            return;
        }

        // Biến môi trường cho phép trỏ sang API deploy mà không build lại.
        var apiUrl = Environment.GetEnvironmentVariable("MYPLANNER_API_URL")
            ?? (LocalBackend.IsPackaged ? LocalBackend.PackagedUrl : "http://localhost:5274/");

        var services = new ServiceCollection();

        services.AddSingleton<LocalBackend>();
        // Phiên đăng nhập dùng chung cả app → Singleton.
        services.AddSingleton<TokenStore>();
        services.AddSingleton<SessionEvents>();
        // Handler phải Transient: IHttpClientFactory tự tạo và gom vào pipeline của mỗi handler chain.
        services.AddTransient<BearerTokenHandler>();

        services.AddHttpClient<PlannerApiClient>(c =>
        {
            c.BaseAddress = new Uri(apiUrl);
            c.DefaultRequestHeaders.AcceptLanguage.ParseAdd("vi");
        }).AddHttpMessageHandler<BearerTokenHandler>();

        services.AddSingleton<ShellViewModel>();
        services.AddTransient<LoginViewModel>();
        services.AddTransient<TodayViewModel>();
        services.AddTransient<WeekViewModel>();
        services.AddTransient<HabitsViewModel>();
        services.AddTransient<GoalsViewModel>();
        services.AddTransient<YearViewModel>();
        services.AddTransient<StatsViewModel>();
        services.AddTransient<MainWindow>();
        _services = services.BuildServiceProvider();

        var window = _services.GetRequiredService<MainWindow>();
        window.Show();
    }

    protected override void OnExit(ExitEventArgs e)
    {
        _services?.Dispose(); // kéo theo LocalBackend.Dispose: tắt API do app mở
        _singleInstance?.Dispose();
        base.OnExit(e);
    }
}
