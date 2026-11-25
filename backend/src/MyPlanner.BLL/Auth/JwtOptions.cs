using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace MyPlanner.BLL.Auth;

// Cấu hình JWT, đọc từ section "Jwt" (deploy: Jwt__Key, Jwt__Issuer...). Cùng một object dùng cho cả hai đầu:
// BLL ký token khi đăng nhập, Api kiểm chữ ký khi nhận request. Hai đầu lệch nhau là token tự ký bị từ chối.
public sealed class JwtOptions
{
    public const string Section = "Jwt";
    // HS256 cần khoá tối thiểu 256 bit (32 byte). Program.cs kiểm tra lúc khởi động để lỗi cấu hình lộ ra sớm.
    public const int MinKeyBytes = 32;

    // Bí mật dùng để ký. Không commit: dev đặt trong appsettings.Development.json (gitignore), deploy đặt Jwt__Key.
    public string Key { get; set; } = "";
    public string Issuer { get; set; } = "MyPlanner";
    public string Audience { get; set; } = "MyPlanner";
    // Access token sống ngắn vì không thu hồi được; client dùng refresh token để đổi cái mới.
    public int ExpiresMinutes { get; set; } = 15;
    // Không dùng app quá số ngày này thì phải đăng nhập lại. Mỗi lần gia hạn, hạn được tính lại từ đầu.
    public int RefreshDays { get; set; } = 30;

    public bool HasValidKey => Encoding.UTF8.GetByteCount(Key) >= MinKeyBytes;

    public SymmetricSecurityKey SigningKey() => new(Encoding.UTF8.GetBytes(Key));
}
