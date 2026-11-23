using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Auth;

public interface IAuthService
{
    // Đúng tên + mật khẩu thì trả JWT, sai thì ném AppException 401.
    Task<LoginResponse> LoginAsync(LoginRequest request, CancellationToken ct);

    // Tạo tài khoản mới rồi trả JWT như đăng nhập. Tên đã có người dùng thì ném AppException 409.
    Task<LoginResponse> RegisterAsync(RegisterRequest request, CancellationToken ct);

    // Đổi ID token của Google lấy JWT của app; lần đầu thì tạo tài khoản. Token không hợp lệ thì ném AppException 401.
    Task<LoginResponse> GoogleLoginAsync(GoogleLoginRequest request, CancellationToken ct);

    // Gọi một lần lúc khởi động: nếu bảng Users còn trống và cấu hình có Auth:UserName + Auth:Password thì tạo tài khoản.
    // Trả true khi vừa tạo. Có người dùng rồi thì không làm gì (đổi biến môi trường sau đó không ghi đè mật khẩu).
    Task<bool> EnsureAccountAsync(string? userName, string? password, CancellationToken ct);
}
