using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;

namespace MyPlanner.Desktop.Auth;

// DelegatingHandler: một mắt xích trong pipeline của HttpClient, chạy quanh mọi request.
// Giống axios interceptor ở web và middleware ở ASP.NET Core, nhưng phía client.
// Request đi: gắn "Authorization: Bearer <token>". Response về: gặp 401 thì báo phiên hết hạn.
public sealed class BearerTokenHandler(TokenStore tokens, SessionEvents events) : DelegatingHandler
{
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct)
    {
        if (tokens.Current is { } session)
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", session.AccessToken);

        var response = await base.SendAsync(request, ct);

        // Không báo cho chính request đăng nhập (sai mật khẩu cũng là 401, đó không phải "hết phiên").
        var isLogin = request.RequestUri?.AbsolutePath.EndsWith("/api/auth/login", StringComparison.OrdinalIgnoreCase) == true;
        if (response.StatusCode == HttpStatusCode.Unauthorized && !isLogin)
        {
            tokens.Clear();
            events.RaiseSessionExpired();
        }
        return response;
    }
}

// Kênh báo "phiên hết hạn" từ tầng HTTP lên ShellViewModel mà hai bên không tham chiếu nhau.
public sealed class SessionEvents
{
    public event EventHandler? SessionExpired;
    public void RaiseSessionExpired() => SessionExpired?.Invoke(this, EventArgs.Empty);
}
