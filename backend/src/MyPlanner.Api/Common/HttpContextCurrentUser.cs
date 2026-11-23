using Microsoft.IdentityModel.JsonWebTokens;
using MyPlanner.Core.Auth;

namespace MyPlanner.Api.Common;

// Cài đặt ICurrentUser cho request HTTP: đọc claim "sub" (Id tài khoản) trong JWT đã được middleware xác thực.
// MapInboundClaims = false nên claim giữ đúng tên "sub", không bị đổi thành ClaimTypes.NameIdentifier.
// Không có HttpContext (lúc khởi động, lệnh dotnet ef) hoặc chưa đăng nhập → null, DbContext sẽ không thấy dòng nào.
public sealed class HttpContextCurrentUser(IHttpContextAccessor accessor) : ICurrentUser
{
    public Guid? UserId =>
        accessor.HttpContext?.User.FindFirst(JwtRegisteredClaimNames.Sub)?.Value is { } sub && Guid.TryParse(sub, out var id)
            ? id
            : null;
}
