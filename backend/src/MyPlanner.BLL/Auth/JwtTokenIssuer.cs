using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using MyPlanner.Core.Entities;

namespace MyPlanner.BLL.Auth;

public record IssuedToken(string Token, DateTimeOffset ExpiresAt);

// Tách việc tạo token ra interface để AuthService test được mà không phụ thuộc thư viện JWT,
// và để sau này đổi cách ký (khoá bất đối xứng RS256, nhà cung cấp ngoài) không phải sửa AuthService.
public interface ITokenIssuer
{
    IssuedToken Issue(AppUser user);
}

public sealed class JwtTokenIssuer(IOptions<JwtOptions> options, TimeProvider clock) : ITokenIssuer
{
    private static readonly JsonWebTokenHandler Handler = new();

    public IssuedToken Issue(AppUser user)
    {
        var o = options.Value;
        var now = clock.GetUtcNow();
        var expires = now.AddMinutes(o.ExpiresMinutes);

        var descriptor = new SecurityTokenDescriptor
        {
            Issuer = o.Issuer,       // "iss": ai phát hành
            Audience = o.Audience,   // "aud": token dành cho API nào
            IssuedAt = now.UtcDateTime,
            NotBefore = now.UtcDateTime,
            Expires = expires.UtcDateTime,
            // Payload chỉ chứa định danh, không chứa bí mật: JWT chỉ được ký, không mã hoá, ai cũng đọc được phần này.
            Claims = new Dictionary<string, object>
            {
                [JwtRegisteredClaimNames.Sub] = user.Id.ToString(),
                [JwtRegisteredClaimNames.UniqueName] = user.UserName,
                [JwtRegisteredClaimNames.Jti] = Guid.NewGuid().ToString(),
            },
            // HMAC-SHA256 với khoá bí mật dùng chung: cùng một khoá để ký (ở đây) và để kiểm (JwtBearer ở Api).
            SigningCredentials = new SigningCredentials(o.SigningKey(), SecurityAlgorithms.HmacSha256),
        };

        return new IssuedToken(Handler.CreateToken(descriptor), expires);
    }
}
