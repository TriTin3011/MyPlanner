using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace MyPlanner.Desktop.Hosting;

// Google chặn đăng nhập trong trình duyệt nhúng, nên bước chọn tài khoản chạy ở trình duyệt hệ thống.
// App mở một trang tạm trên localhost, trang đó lấy ID token từ Google rồi POST về đúng tiến trình này.
// "state" ngẫu nhiên bảo đảm chỉ trang do lần đăng nhập này mở mới nộp được token.
public static partial class GoogleBrowserSignIn
{
    // Địa chỉ này phải nằm trong Authorized JavaScript origins của OAuth client.
    public const string Origin = "http://localhost:5276";

    private const int MaxBodyBytes = 16 * 1024;
    private static readonly TimeSpan Timeout = TimeSpan.FromMinutes(3);
    private static readonly SemaphoreSlim Gate = new(1, 1);
    private static CancellationTokenSource? _current;

    // Trả ID token. Trả null khi người dùng bấm đăng nhập lại (lần mới thay lần này).
    // Ném TimeoutException khi hết giờ, HttpListenerException khi cổng đang bị chiếm.
    public static async Task<string?> SignInAsync(string clientId)
    {
        if (!ClientIdPattern().IsMatch(clientId)) throw new ArgumentException("Invalid Google client id", nameof(clientId));

        using var cts = new CancellationTokenSource();
        Interlocked.Exchange(ref _current, cts)?.Cancel();
        await Gate.WaitAsync();
        try
        {
            if (cts.IsCancellationRequested) return null;
            cts.CancelAfter(Timeout);

            using var listener = new HttpListener();
            listener.Prefixes.Add(Origin + "/");
            listener.Start();
            using var stop = cts.Token.Register(listener.Stop);

            var state = RandomNumberGenerator.GetHexString(32, lowercase: true);
            WebUiHost.OpenExternal($"{Origin}/?state={state}");

            while (true)
            {
                HttpListenerContext context;
                try
                {
                    context = await listener.GetContextAsync();
                }
                catch (Exception ex) when (ex is HttpListenerException or ObjectDisposedException && cts.IsCancellationRequested)
                {
                    return ReferenceEquals(_current, cts) ? throw new TimeoutException() : null;
                }

                var token = await HandleAsync(context, clientId, state);
                if (token is not null) return token;
            }
        }
        finally
        {
            Interlocked.CompareExchange(ref _current, null, cts);
            Gate.Release();
        }
    }

    private static async Task<string?> HandleAsync(HttpListenerContext context, string clientId, string state)
    {
        var (request, response) = (context.Request, context.Response);
        try
        {
            if (request.HttpMethod == "GET" && request.Url?.AbsolutePath == "/" && request.QueryString["state"] == state)
            {
                await WriteHtmlAsync(response, Page(clientId, state));
                return null;
            }

            if (request.HttpMethod == "POST" && request.Url?.AbsolutePath == "/callback"
                && request.Headers["Origin"] == Origin
                && request.ContentLength64 is > 0 and <= MaxBodyBytes)
            {
                using var reader = new StreamReader(request.InputStream, Encoding.UTF8);
                using var body = JsonDocument.Parse(await reader.ReadToEndAsync());
                var sentState = body.RootElement.GetProperty("state").GetString() ?? "";
                var credential = body.RootElement.GetProperty("credential").GetString();
                if (CryptographicOperations.FixedTimeEquals(Encoding.UTF8.GetBytes(sentState), Encoding.UTF8.GetBytes(state))
                    && !string.IsNullOrEmpty(credential))
                {
                    response.StatusCode = 204;
                    return credential;
                }
            }

            response.StatusCode = 404;
            return null;
        }
        catch (Exception ex) when (ex is JsonException or KeyNotFoundException or InvalidOperationException or IOException)
        {
            response.StatusCode = 400;
            return null;
        }
        finally
        {
            response.Close();
        }
    }

    private static async Task WriteHtmlAsync(HttpListenerResponse response, string html)
    {
        var bytes = Encoding.UTF8.GetBytes(html);
        response.ContentType = "text/html; charset=utf-8";
        // Google Identity Services cần hai header này khi chạy trên http://localhost.
        response.Headers["Referrer-Policy"] = "no-referrer-when-downgrade";
        response.Headers["Cross-Origin-Opener-Policy"] = "same-origin-allow-popups";
        response.Headers["Cache-Control"] = "no-store";
        response.ContentLength64 = bytes.Length;
        await response.OutputStream.WriteAsync(bytes);
    }

    private static string Page(string clientId, string state) => """
        <!doctype html>
        <html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Đăng nhập Mầm</title>
        <style>
          body{margin:0;min-height:100vh;display:grid;place-items:center;background:#f1f6ef;color:#123c2e;font-family:system-ui,"Segoe UI",sans-serif}
          main{width:min(360px,calc(100vw - 32px));box-sizing:border-box;padding:28px;background:#fff;border:2px solid #123c2e;border-radius:18px;box-shadow:4px 4px 0 #123c2e;text-align:center}
          h1{margin:0 0 8px;font-size:24px}p{margin:0 0 20px;line-height:1.5}#button{display:flex;justify-content:center;min-height:44px}
        </style></head>
        <body><main><h1>Mầm</h1><p id="message">Chọn tài khoản Google để vào app.</p><div id="button"></div></main>
        <script>
          const message = document.getElementById('message');
          async function done(r) {
            document.getElementById('button').remove();
            message.textContent = 'Đang gửi về app…';
            const res = await fetch('/callback', { method: 'POST', headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ state: '__STATE__', credential: r.credential }) }).catch(() => null);
            message.textContent = res && res.ok ? 'Xong. Bạn có thể đóng tab này và quay lại Mầm.' : 'Không gửi được về app. Hãy bấm đăng nhập lại trong Mầm.';
            if (res && res.ok) window.close();
          }
          function start() {
            google.accounts.id.initialize({ client_id: '__CLIENT_ID__', callback: done });
            google.accounts.id.renderButton(document.getElementById('button'), { theme: 'outline', size: 'large', text: 'signin_with', width: 280, locale: 'vi' });
          }
        </script>
        <script src="https://accounts.google.com/gsi/client" async onload="start()" onerror="message.textContent='Không tải được Google. Kiểm tra mạng rồi thử lại.'"></script>
        </body></html>
        """.Replace("__STATE__", state).Replace("__CLIENT_ID__", clientId);

    [GeneratedRegex(@"^[A-Za-z0-9.\-]+\.apps\.googleusercontent\.com$")]
    private static partial Regex ClientIdPattern();
}
