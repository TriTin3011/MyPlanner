using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.BLL.Auth;

public interface ISessionService
{
    // Mở phiên mới sau khi đã xác thực người dùng: cấp access token và refresh token đầu tiên.
    Task<LoginResponse> StartAsync(AppUser user, CancellationToken ct);

    // Đổi refresh token lấy cặp token mới. Token sai, hết hạn hoặc bị dùng lại thì ném AppException 401.
    Task<LoginResponse> RefreshAsync(RefreshRequest request, CancellationToken ct);

    // Thu hồi cả phiên. Token không tồn tại thì bỏ qua, để đăng xuất luôn thành công.
    Task LogoutAsync(RefreshRequest request, CancellationToken ct);
}
