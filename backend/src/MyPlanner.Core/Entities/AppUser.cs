namespace MyPlanner.Core.Entities;

// Tài khoản đăng nhập. App chỉ có một người dùng, nhưng vẫn lưu thành bảng để mật khẩu nằm trong DB dạng băm
// (không nằm trong biến môi trường lâu dài) và để sau này thêm người dùng không phải đổi cấu trúc.
public class AppUser
{
    public Guid Id { get; set; }
    public string UserName { get; set; } = "";
    // Chuỗi do PasswordHasher sinh: chứa phiên bản thuật toán, salt, số vòng lặp và hash (PBKDF2). Không bao giờ lưu mật khẩu gốc.
    public string PasswordHash { get; set; } = "";
    public DateTimeOffset CreatedAt { get; set; }
}
