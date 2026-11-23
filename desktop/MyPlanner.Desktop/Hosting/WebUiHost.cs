using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text.Json;
using System.Windows;
using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.Wpf;

namespace MyPlanner.Desktop.Hosting;

// Bản cài dùng chính frontend React làm giao diện: WebView2 là "khung trình duyệt", thư mục web/ là bản build.
// Tự trả file qua WebResourceRequested (thay vì map thư mục) để route SPA như /goals rơi về index.html khi tải lại.
// Đặt biến MYPLANNER_UI=native để quay về các màn XAML.
public static class WebUiHost
{
    public const string Origin = "https://mam.localhost";

    private static readonly string Root = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "web"));
    private static readonly string IndexPath = Path.Combine(Root, "index.html");
    private static readonly string UserDataDir = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Mam", "WebView2");

    public static bool IsAvailable =>
        LocalBackend.IsPackaged
        && File.Exists(IndexPath)
        && !string.Equals(Environment.GetEnvironmentVariable("MYPLANNER_UI"), "native", StringComparison.OrdinalIgnoreCase);

    public static async Task AttachAsync(WebView2 view)
    {
        if (view.CoreWebView2 is not null) return;

        // Thư mục riêng ngoài nơi cài: phiên đăng nhập và cài đặt (localStorage) không mất khi cài lại app.
        // Language đặt navigator.language: lần mở đầu hiện tiếng Việt dù Windows dùng tiếng Anh; nút VI/EN vẫn đổi được.
        var environment = await CoreWebView2Environment.CreateAsync(
            userDataFolder: UserDataDir,
            options: new CoreWebView2EnvironmentOptions { Language = "vi" });
        await view.EnsureCoreWebView2Async(environment);

        var core = view.CoreWebView2!;
        core.Settings.AreDevToolsEnabled = false;
        core.Settings.IsStatusBarEnabled = false;
        core.AddWebResourceRequestedFilter($"{Origin}/*", CoreWebView2WebResourceContext.All);
        core.WebResourceRequested += (_, e) => e.Response = CreateResponse(core.Environment, e.Request.Uri);

        // Link ra ngoài mở bằng trình duyệt mặc định, cửa sổ app chỉ hiển thị Mầm.
        core.NewWindowRequested += (_, e) =>
        {
            e.Handled = true;
            OpenExternal(e.Uri);
        };
        core.NavigationStarting += (_, e) =>
        {
            if (e.Uri.StartsWith(Origin, StringComparison.OrdinalIgnoreCase)) return;
            e.Cancel = true;
            OpenExternal(e.Uri);
        };

        core.WebMessageReceived += async (_, e) => await HandleWebMessageAsync(core, e.Source, e.WebMessageAsJson);

        core.Navigate($"{Origin}/");
    }

    // Cầu nối React ↔ C#: React xin đăng nhập Google, host trả ID token để React gọi POST /auth/google như trên web.
    private static async Task HandleWebMessageAsync(CoreWebView2 core, string source, string json)
    {
        if (!source.StartsWith(Origin + "/", StringComparison.OrdinalIgnoreCase)) return;

        string? clientId;
        try
        {
            using var message = JsonDocument.Parse(json);
            var type = message.RootElement.GetProperty("type").GetString();
            if (type == "splash-theme")
            {
                SplashTheme.Save(
                    message.RootElement.GetProperty("theme").GetString(),
                    message.RootElement.GetProperty("expiresAt").GetString());
                return;
            }
            if (type != "google-signin") return;
            clientId = message.RootElement.GetProperty("clientId").GetString();
        }
        catch (Exception ex) when (ex is JsonException or KeyNotFoundException or InvalidOperationException)
        {
            return;
        }

        try
        {
            var credential = await GoogleBrowserSignIn.SignInAsync(clientId ?? "");
            if (credential is null) return; // Người dùng đã bấm lại, lần mới sẽ trả kết quả.
            core.PostWebMessageAsJson(JsonSerializer.Serialize(new { type = "google-credential", credential }));
            Application.Current.MainWindow?.Activate();
        }
        catch (Exception ex) when (ex is TimeoutException or HttpListenerException or ArgumentException or Win32Exception)
        {
            core.PostWebMessageAsJson("""{"type":"google-error"}""");
        }
    }

    private static CoreWebView2WebResourceResponse CreateResponse(CoreWebView2Environment env, string uri)
    {
        var relative = Uri.UnescapeDataString(new Uri(uri).AbsolutePath).TrimStart('/');

        // Service worker của PWA sẽ giữ bản cũ sau khi cài lại; app đã có file tại chỗ nên không cần nó.
        if (relative.Equals("sw.js", StringComparison.OrdinalIgnoreCase)) return NotFound(env);

        var path = Path.GetFullPath(Path.Combine(Root, relative));
        // Chặn path traversal: chỉ được đọc file nằm trong thư mục web/.
        if (path != Root && !path.StartsWith(Root + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase))
            return NotFound(env);

        if (!File.Exists(path))
        {
            // Có đuôi file mà không tồn tại là thiếu tài nguyên; không đuôi là route của React Router.
            if (Path.HasExtension(relative)) return NotFound(env);
            path = IndexPath;
        }

        var body = new MemoryStream(File.ReadAllBytes(path));
        return env.CreateWebResourceResponse(body, 200, "OK",
            $"Content-Type: {ContentType(path)}\r\nCache-Control: no-cache");
    }

    private static CoreWebView2WebResourceResponse NotFound(CoreWebView2Environment env) =>
        env.CreateWebResourceResponse(null, 404, "Not Found", "");

    private static string ContentType(string path) => Path.GetExtension(path).ToLowerInvariant() switch
    {
        ".html" => "text/html; charset=utf-8",
        ".js" or ".mjs" => "text/javascript; charset=utf-8",
        ".css" => "text/css; charset=utf-8",
        ".json" => "application/json",
        ".webmanifest" => "application/manifest+json",
        ".svg" => "image/svg+xml",
        ".png" => "image/png",
        ".jpg" or ".jpeg" => "image/jpeg",
        ".webp" => "image/webp",
        ".gif" => "image/gif",
        ".ico" => "image/x-icon",
        ".woff" => "font/woff",
        ".woff2" => "font/woff2",
        ".mp3" => "audio/mpeg",
        _ => "application/octet-stream",
    };

    internal static void OpenExternal(string uri)
    {
        // Chỉ http/https: không để nội dung trang kích hoạt scheme tuỳ ý của hệ điều hành.
        if (Uri.TryCreate(uri, UriKind.Absolute, out var parsed) && parsed.Scheme is "http" or "https")
            Process.Start(new ProcessStartInfo(parsed.AbsoluteUri) { UseShellExecute = true });
    }
}
