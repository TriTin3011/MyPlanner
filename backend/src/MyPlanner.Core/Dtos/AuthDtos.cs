namespace MyPlanner.Core.Dtos;

public record LoginRequest(string UserName, string Password);

// accessToken là JWT; client gửi lại trong header "Authorization: Bearer <accessToken>" ở mọi request sau.
// expiresAt để client biết lúc nào phải đăng nhập lại mà không cần tự giải mã token.
public record LoginResponse(string AccessToken, DateTimeOffset ExpiresAt, string UserName, string? DisplayName = null);

// Đăng ký thành công trả luôn LoginResponse (đăng nhập ngay), client không phải gọi /login lần nữa.
public record RegisterRequest(string UserName, string Password);

// idToken là JWT do Google cấp cho trình duyệt. Backend tự kiểm rồi đổi lấy JWT của app.
public record GoogleLoginRequest(string IdToken);

// avatarUrl là link có chữ ký, hết hạn sau một giờ; null khi chưa có ảnh. Có giá trị mặc định để client cũ (WPF) không vỡ.
public record CurrentUserDto(string UserName, string? AvatarUrl = null, string? DisplayName = null);

// Chuỗi rỗng hoặc null nghĩa là bỏ tên hiển thị, quay về hiện tên đăng nhập.
public record UpdateProfileRequest(string? DisplayName);

public record AvatarDto(string? AvatarUrl);
