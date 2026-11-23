using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Profile;

public interface IProfileService
{
    // Tên và link đọc ảnh có hạn của người đang đăng nhập.
    Task<CurrentUserDto> GetCurrentAsync(CancellationToken ct);

    // Đổi tên hiển thị. Không đụng UserName nên cách đăng nhập và JWT đang giữ vẫn nguyên.
    Task<CurrentUserDto> UpdateAsync(UpdateProfileRequest request, CancellationToken ct);

    // Kiểm tra, xử lý và lưu ảnh mới, rồi dọn ảnh cũ. File sai thì ném 400, kho lưu lỗi thì ném 503.
    Task<AvatarDto> UploadAvatarAsync(Stream content, long length, CancellationToken ct);

    Task<AvatarDto> DeleteAvatarAsync(CancellationToken ct);
}
