using System.Diagnostics;
using System.IO;
using System.Net.Http;

namespace MyPlanner.Desktop.Hosting;

// Một bước khởi động: chữ hiển thị và mốc phần trăm của thanh tiến độ.
public readonly record struct StartupStep(string Message, double Percent);

// Bản cài trên laptop: app tự lo Docker, Postgres và API trước khi hiện giao diện.
// Luồng: Docker Desktop → container myplanner-db (healthy) → MyPlanner.Api.exe → GET /api/health.
// Khi chạy từ mã nguồn (không có thư mục api/) lớp này không làm gì, dev vẫn tự chạy API ở cổng 5274.
public sealed class LocalBackend : IDisposable
{
    // Khác cổng dev 5274 để app đã cài và API đang code chạy song song được.
    public const string PackagedUrl = "http://127.0.0.1:5275/";

    private const string DbContainer = "myplanner-db";
    private const string StorageContainer = "myplanner-minio";
    private static readonly string ApiDir = Path.Combine(AppContext.BaseDirectory, "api");
    private static readonly string ApiExe = Path.Combine(ApiDir, "MyPlanner.Api.exe");
    private static readonly string LogPath = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Mam", "api.log");

    // Lần gọi đầu mất khoảng 3 giây vì EF dựng model; timeout ngắn hơn sẽ huỷ rồi gọi lại mãi.
    private readonly HttpClient _health = new() { Timeout = TimeSpan.FromSeconds(10) };
    private Process? _api;
    private StreamWriter? _log;

    public static bool IsPackaged =>
        Environment.GetEnvironmentVariable("MYPLANNER_API_URL") is null && File.Exists(ApiExe);

    public async Task EnsureStartedAsync(IProgress<StartupStep> progress)
    {
        if (!IsPackaged) return;

        // API còn sống từ lần trước (app bị tắt đột ngột) thì dùng lại, không mở tiến trình thứ hai.
        if (await IsApiHealthyAsync()) return;

        progress.Report(new StartupStep("Đang khởi động Docker...", 15));
        await EnsureDockerAsync();

        progress.Report(new StartupStep("Đang mở cơ sở dữ liệu...", 40));
        await EnsureDatabaseAsync();

        // Kho ảnh là phần phụ: không mở được thì app vẫn chạy, avatar quay về chữ cái đầu.
        await RunDockerAsync("start", StorageContainer);

        progress.Report(new StartupStep("Đang khởi động máy chủ...", 65));
        StartApi();
        await WaitUntilAsync(async () =>
        {
            if (_api is { HasExited: true })
                throw new InvalidOperationException($"Máy chủ đã dừng khi khởi động. Xem nhật ký tại {LogPath}");
            return await IsApiHealthyAsync();
        }, TimeSpan.FromSeconds(45), $"Máy chủ không phản hồi. Xem nhật ký tại {LogPath}");
    }

    private static async Task EnsureDockerAsync()
    {
        if (await IsDockerReadyAsync()) return;

        var desktop = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "Docker", "Docker", "Docker Desktop.exe");
        if (!File.Exists(desktop))
            throw new InvalidOperationException("Không tìm thấy Docker Desktop trên máy này.");

        Process.Start(new ProcessStartInfo(desktop) { UseShellExecute = true });
        await WaitUntilAsync(IsDockerReadyAsync, TimeSpan.FromMinutes(3),
            "Docker Desktop chưa sẵn sàng sau 3 phút.");
    }

    private static async Task<bool> IsDockerReadyAsync() => (await RunDockerAsync("info", "--format", "{{.ServerVersion}}")).ExitCode == 0;

    private static async Task EnsureDatabaseAsync()
    {
        var start = await RunDockerAsync("start", DbContainer);
        if (start.ExitCode != 0)
            throw new InvalidOperationException($"Không mở được container {DbContainer}: {start.Output.Trim()}");

        await WaitUntilAsync(async () =>
        {
            var state = await RunDockerAsync("inspect", "-f", "{{.State.Health.Status}}", DbContainer);
            return state.ExitCode == 0 && state.Output.Trim() == "healthy";
        }, TimeSpan.FromSeconds(60), "Cơ sở dữ liệu chưa sẵn sàng sau 60 giây.");
    }

    private void StartApi()
    {
        // Bấm "Thử lại" khi API vẫn đang khởi động: chờ tiếp, không mở tiến trình thứ hai.
        if (_api is { HasExited: false }) return;
        _api?.Dispose();

        Directory.CreateDirectory(Path.GetDirectoryName(LogPath)!);
        lock (LogPath)
        {
            _log?.Dispose();
            _log = new StreamWriter(LogPath, append: false) { AutoFlush = true };
        }

        var info = new ProcessStartInfo(ApiExe)
        {
            WorkingDirectory = ApiDir, // content root: nơi API tìm appsettings.Production.json
            CreateNoWindow = true,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
        };
        info.Environment["ASPNETCORE_ENVIRONMENT"] = "Production";
        info.Environment["ASPNETCORE_URLS"] = PackagedUrl.TrimEnd('/'); // chỉ nghe 127.0.0.1, máy khác không gọi được
        info.Environment["Cors__Origins__0"] = WebUiHost.Origin; // giao diện web nhúng gọi API từ origin này

        _api = Process.Start(info) ?? throw new InvalidOperationException("Không chạy được máy chủ.");
        _api.OutputDataReceived += (_, e) => WriteLog(e.Data);
        _api.ErrorDataReceived += (_, e) => WriteLog(e.Data);
        _api.BeginOutputReadLine();
        _api.BeginErrorReadLine();
    }

    private void WriteLog(string? line)
    {
        if (line is null) return;
        lock (LogPath) _log?.WriteLine(line);
    }

    private async Task<bool> IsApiHealthyAsync()
    {
        try
        {
            using var response = await _health.GetAsync($"{PackagedUrl}api/health");
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex) when (ex is HttpRequestException or TaskCanceledException)
        {
            return false;
        }
    }

    private static async Task WaitUntilAsync(Func<Task<bool>> condition, TimeSpan timeout, string error)
    {
        var clock = Stopwatch.StartNew();
        while (clock.Elapsed < timeout)
        {
            if (await condition()) return;
            await Task.Delay(750);
        }
        throw new TimeoutException(error);
    }

    private static async Task<(int ExitCode, string Output)> RunDockerAsync(params string[] args)
    {
        // App mở từ shortcut có thể không có docker trong PATH, nên ưu tiên đường dẫn cài đặt chuẩn.
        var installed = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "Docker", "Docker", "resources", "bin", "docker.exe");
        var info = new ProcessStartInfo(File.Exists(installed) ? installed : "docker")
        {
            CreateNoWindow = true,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
        };
        foreach (var arg in args) info.ArgumentList.Add(arg);

        try
        {
            using var process = Process.Start(info)!;
            var stdout = process.StandardOutput.ReadToEndAsync();
            var stderr = process.StandardError.ReadToEndAsync();
            await process.WaitForExitAsync();
            return (process.ExitCode, await stdout + await stderr);
        }
        catch (System.ComponentModel.Win32Exception ex)
        {
            return (-1, ex.Message); // chưa cài docker CLI
        }
    }

    // Chỉ tắt API do chính app mở. Container Postgres được giữ lại vì có thể đang phục vụ việc khác.
    public void Dispose()
    {
        try
        {
            if (_api is { HasExited: false }) _api.Kill(entireProcessTree: true);
        }
        catch (InvalidOperationException) { /* tiến trình vừa tự thoát */ }
        _api?.Dispose();
        lock (LogPath) { _log?.Dispose(); _log = null; }
        _health.Dispose();
    }
}
