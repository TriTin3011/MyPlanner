using Google.Apis.Auth;
using Microsoft.Extensions.Options;

namespace MyPlanner.BLL.Auth;

public class GoogleOptions
{
    public const string Section = "Google";

    // Client ID của ứng dụng trên Google Cloud. Không phải bí mật (FE cũng dùng), nhưng là thứ quyết định token có dành cho app này không.
    public string ClientId { get; set; } = "";
}

// Subject ("sub") là mã định danh cố định của tài khoản Google. Email có thể đổi nên không dùng làm khoá.
public record GoogleIdentity(string Subject, string? Email);

// Interface để test AuthService không phải gọi Google thật.
public interface IGoogleTokenVerifier
{
    // Trả null khi token không hợp lệ hoặc server chưa cấu hình Client ID.
    Task<GoogleIdentity?> VerifyAsync(string idToken, CancellationToken ct);
}

public class GoogleTokenVerifier(IOptions<GoogleOptions> options) : IGoogleTokenVerifier
{
    public async Task<GoogleIdentity?> VerifyAsync(string idToken, CancellationToken ct)
    {
        var clientId = options.Value.ClientId;
        // Bắt buộc dừng ở đây: Audience rỗng thì thư viện bỏ qua kiểm tra aud,
        // và token Google cấp cho bất kỳ app nào khác cũng sẽ qua.
        if (string.IsNullOrWhiteSpace(clientId)) return null;

        try
        {
            // Kiểm chữ ký bằng khoá công khai của Google, issuer, hạn dùng và aud = Client ID của app.
            var payload = await GoogleJsonWebSignature.ValidateAsync(
                idToken,
                new GoogleJsonWebSignature.ValidationSettings { Audience = [clientId] });
            return new GoogleIdentity(payload.Subject, payload.Email);
        }
        catch (InvalidJwtException)
        {
            return null;
        }
    }
}
