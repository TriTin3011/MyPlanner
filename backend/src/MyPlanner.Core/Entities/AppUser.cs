namespace MyPlanner.Core.Entities;

// Tài khoản đăng nhập. Mỗi tài khoản sở hữu dữ liệu riêng: các bảng IUserOwned có UserId trỏ về đây (SPEC §12.0).
// Mật khẩu nằm trong DB dạng băm, không nằm trong biến môi trường lâu dài.
public class AppUser
{
    public Guid Id { get; set; }
    public string UserName { get; set; } = "";
    // Chuỗi do PasswordHasher sinh: chứa phiên bản thuật toán, salt, số vòng lặp và hash (PBKDF2). Không bao giờ lưu mật khẩu gốc.
    public string PasswordHash { get; set; } = "";
    public DateTimeOffset CreatedAt { get; set; }
}
