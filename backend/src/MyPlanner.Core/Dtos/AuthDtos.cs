namespace MyPlanner.Core.Dtos;

public record LoginRequest(string UserName, string Password);

// accessToken là JWT; client gửi lại trong header "Authorization: Bearer <accessToken>" ở mọi request sau.
// expiresAt là hạn của access token. refreshToken dùng để lấy cặp token mới, refreshExpiresAt là hạn của cả phiên.
// Hai trường cuối có mặc định để phiên đã lưu từ trước khi có refresh token vẫn đọc được.
public record LoginResponse(
    string AccessToken,
    DateTimeOffset ExpiresAt,
    string UserName,
    string? DisplayName = null,
    string? RefreshToken = null,
    DateTimeOffset? RefreshExpiresAt = null);

// Dùng cho cả /auth/refresh và /auth/logout. Đi qua body vì API không dựa vào cookie (web, WPF, Flutter dùng chung).
public record RefreshRequest(string RefreshToken);

// Đăng ký thành công trả luôn LoginResponse (đăng nhập ngay), client không phải gọi /login lần nữa.
public record RegisterRequest(string UserName, string Password);

// idToken là JWT do Google cấp cho trình duyệt. Backend tự kiểm rồi đổi lấy JWT của app.
public record GoogleLoginRequest(string IdToken);

// avatarUrl là link có chữ ký, hết hạn sau một giờ; null khi chưa có ảnh. Có giá trị mặc định để client cũ (WPF) không vỡ.
public record CurrentUserDto(string UserName, string? AvatarUrl = null, string? DisplayName = null);

// Chuỗi rỗng hoặc null nghĩa là bỏ tên hiển thị, quay về hiện tên đăng nhập.
public record UpdateProfileRequest(string? DisplayName);

public record AvatarDto(string? AvatarUrl);
