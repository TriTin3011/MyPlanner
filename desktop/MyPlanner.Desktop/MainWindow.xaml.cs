using System.ComponentModel;
using System.Windows;
using Microsoft.Web.WebView2.Core;
using MyPlanner.Desktop.Hosting;
using MyPlanner.Desktop.ViewModels;

namespace MyPlanner.Desktop;

// Cửa sổ duy nhất, là "khung" (shell). Nội dung là giao diện web nhúng, hoặc các màn XAML theo ShellViewModel.CurrentPage.
public partial class MainWindow : Window
{
    // Đủ lâu để logo không nháy rồi biến mất khi backend đã chạy sẵn.
    private static readonly TimeSpan MinSplashTime = TimeSpan.FromMilliseconds(900);
    // Trang lỗi hoặc treo thì vẫn mở app, không kẹt mãi ở màn khởi động.
    private static readonly TimeSpan PageLoadTimeout = TimeSpan.FromSeconds(10);

    private readonly ShellViewModel _shell;
    private bool _webParked;

    public MainWindow(ShellViewModel shell)
    {
        InitializeComponent();
        // Chỉ giao diện web có theme; nền cửa sổ đổi theo để lúc splash mờ đi không lộ màu xanh.
        if (WebUiHost.IsAvailable && SplashTheme.Load() is { } palette)
        {
            Splash.ApplyPalette(palette);
            Background = Splash.Background;
        }
        _shell = shell;
        DataContext = shell;
        shell.PropertyChanged += OnShellChanged;
        Root.SizeChanged += (_, _) => { if (_webParked) ParkWebOffscreen(); };
        Loaded += async (_, _) => await shell.StartAsync();
    }

    private async void OnShellChanged(object? sender, PropertyChangedEventArgs e)
    {
        switch (e.PropertyName)
        {
            case nameof(ShellViewModel.StartupError):
                Splash.SetFailed(_shell.StartupError is not null);
                break;
            case nameof(ShellViewModel.StartupProgress):
                Splash.SetProgress(_shell.StartupProgress);
                break;
            case nameof(ShellViewModel.StartupMessage)
                when _shell.StartupMessage is null && _shell.StartupError is null && !WebUiHost.IsAvailable:
                await Splash.FadeOutAsync(); // Chế độ XAML: backend xong là có màn hình.
                break;
            case nameof(ShellViewModel.WebUiReady) when _shell.WebUiReady:
                await ShowWebUiAsync();
                break;
        }
    }

    private async Task ShowWebUiAsync()
    {
        var minimum = Task.Delay(MinSplashTime);
        var pageLoaded = new TaskCompletionSource();
        void OnNavigated(object? s, CoreWebView2NavigationCompletedEventArgs a) => pageLoaded.TrySetResult();

        // WebView2 là cửa sổ Win32 riêng, luôn vẽ đè lên WPF (airspace). Nó cần được hiển thị mới khởi tạo được,
        // nên cho nó chạy đúng kích thước nhưng nằm ngoài vùng nhìn thấy, tải xong mới đưa vào.
        ParkWebOffscreen();
        Web.Visibility = Visibility.Visible;
        NativeShell.Visibility = Visibility.Collapsed;
        Web.NavigationCompleted += OnNavigated;
        try
        {
            await WebUiHost.AttachAsync(Web);
            await Task.WhenAny(pageLoaded.Task, Task.Delay(PageLoadTimeout));
            await minimum;
            await Splash.FadeOutAsync();
            UnparkWeb();
        }
        catch (WebView2RuntimeNotFoundException)
        {
            UnparkWeb();
            Web.Visibility = Visibility.Collapsed;
            NativeShell.Visibility = Visibility.Visible;
            _shell.WebUiReady = false;
            _shell.StartupError = "Máy chưa có Microsoft Edge WebView2 Runtime. Hãy cài rồi bấm Thử lại.";
        }
        finally
        {
            Web.NavigationCompleted -= OnNavigated;
        }
    }

    // Lề trái âm và lề phải dương cùng độ lớn: control giữ nguyên bề rộng nhưng bị đẩy ra ngoài cửa sổ.
    private void ParkWebOffscreen()
    {
        _webParked = true;
        var offset = Root.ActualWidth + 64;
        Web.Margin = new Thickness(-offset, 0, offset, 0);
    }

    private void UnparkWeb()
    {
        _webParked = false;
        Web.Margin = new Thickness(0);
    }
}
