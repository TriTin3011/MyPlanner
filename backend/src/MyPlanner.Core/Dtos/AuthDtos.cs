namespace MyPlanner.Core.Dtos;

public record LoginRequest(string UserName, string Password);

// accessToken là JWT; client gửi lại trong header "Authorization: Bearer <accessToken>" ở mọi request sau.
// expiresAt để client biết lúc nào phải đăng nhập lại mà không cần tự giải mã token.
public record LoginResponse(string AccessToken, DateTimeOffset ExpiresAt, string UserName);

// Đăng ký thành công trả luôn LoginResponse (đăng nhập ngay), client không phải gọi /login lần nữa.
public record RegisterRequest(string UserName, string Password);

// idToken là JWT do Google cấp cho trình duyệt. Backend tự kiểm rồi đổi lấy JWT của app.
public record GoogleLoginRequest(string IdToken);

public record CurrentUserDto(string UserName);
