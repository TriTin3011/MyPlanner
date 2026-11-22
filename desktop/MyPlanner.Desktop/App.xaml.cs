using System.Windows;
using Microsoft.Extensions.DependencyInjection;
using MyPlanner.Desktop.Api;
using MyPlanner.Desktop.ViewModels;

namespace MyPlanner.Desktop;

// Composition root: nơi duy nhất "lắp" các lớp với nhau, giống Program.cs của API.
public partial class App : Application
{
    private ServiceProvider? _services;

    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);

        // Biến môi trường cho phép trỏ sang API deploy mà không build lại.
        var apiUrl = Environment.GetEnvironmentVariable("MYPLANNER_API_URL") ?? "http://localhost:5274/";

        var services = new ServiceCollection();
        services.AddHttpClient<PlannerApiClient>(c =>
        {
            c.BaseAddress = new Uri(apiUrl);
            c.DefaultRequestHeaders.AcceptLanguage.ParseAdd("vi");
        });
        services.AddTransient<TodayViewModel>();
        services.AddTransient<MainWindow>();
        _services = services.BuildServiceProvider();

        var window = _services.GetRequiredService<MainWindow>();
        window.Show();
    }

    protected override void OnExit(ExitEventArgs e)
    {
        _services?.Dispose();
        base.OnExit(e);
    }
}
