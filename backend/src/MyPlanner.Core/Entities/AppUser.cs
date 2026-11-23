namespace MyPlanner.Core.Entities;

// Tài khoản đăng nhập. Mỗi tài khoản sở hữu dữ liệu riêng: các bảng IUserOwned có UserId trỏ về đây (SPEC §12.0).
// Mật khẩu nằm trong DB dạng băm, không nằm trong biến môi trường lâu dài.
public class AppUser
{
    public Guid Id { get; set; }
    public string UserName { get; set; } = "";
    // Tên hiển thị, đổi tự do và được có dấu. Tách khỏi UserName vì UserName là định danh để đăng nhập. Null thì hiện UserName.
    public string? DisplayName { get; set; }
    // Chuỗi do PasswordHasher sinh: chứa phiên bản thuật toán, salt, số vòng lặp và hash (PBKDF2). Không bao giờ lưu mật khẩu gốc.
    // Tài khoản chỉ dùng Google có chuỗi rỗng ở đây và không đăng nhập được bằng mật khẩu.
    public string PasswordHash { get; set; } = "";
    // Claim "sub" của Google. Null nếu tài khoản không liên kết Google.
    public string? GoogleSubject { get; set; }
    // Key của ảnh trong object storage (avatars/<ngẫu nhiên>.webp). Không lưu URL vì URL có hạn và đổi theo nơi lưu.
    public string? AvatarKey { get; set; }
    public DateTimeOffset CreatedAt { get; set; }
}
