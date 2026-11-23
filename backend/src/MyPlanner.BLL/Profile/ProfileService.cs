using System.Security.Cryptography;
using Microsoft.Extensions.Logging;
using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Auth;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.Core.Storage;
using MyPlanner.DAL.Auth;

namespace MyPlanner.BLL.Profile;

// DB chỉ giữ key của object; byte ảnh nằm trong object storage. Client nhận link có chữ ký và hết hạn.
public class ProfileService(
    IUserRepository users,
    IFileStorage storage,
    ICurrentUser currentUser,
    ILogger<ProfileService> logger) : IProfileService
{
    public const int MaxDisplayNameLength = 50; // khớp HasMaxLength(50) của cột DisplayName
    public const long MaxUploadBytes = 5 * 1024 * 1024;
    private static readonly TimeSpan ReadUrlLifetime = TimeSpan.FromHours(1);

    public async Task<CurrentUserDto> GetCurrentAsync(CancellationToken ct) => ToDto(await RequireUserAsync(ct));

    public async Task<CurrentUserDto> UpdateAsync(UpdateProfileRequest request, CancellationToken ct)
    {
        var user = await RequireUserAsync(ct);
        var name = request.DisplayName?.Trim();
        user.DisplayName = string.IsNullOrEmpty(name) ? null : name;
        await users.SaveChangesAsync(ct);
        return ToDto(user);
    }

    private CurrentUserDto ToDto(AppUser user) => new(user.UserName, ReadUrl(user.AvatarKey), user.DisplayName);

    public async Task<AvatarDto> UploadAvatarAsync(Stream content, long length, CancellationToken ct)
    {
        if (!storage.IsConfigured) throw AppException.ServiceUnavailable(Messages.StorageUnavailable);
        if (length <= 0) throw AppException.BadRequest(Messages.AvatarInvalid);
        if (length > MaxUploadBytes) throw AppException.BadRequest(Messages.AvatarTooLarge);

        var user = await RequireUserAsync(ct);

        using var buffer = new MemoryStream((int)length);
        await content.CopyToAsync(buffer, ct);
        var webp = AvatarImageProcessor.Process(buffer.ToArray())
            ?? throw AppException.BadRequest(Messages.AvatarInvalid);

        // Key ngẫu nhiên: không đoán được, không ghi đè nhầm, và link cũ trong cache không hiện ảnh mới sai lệch.
        var newKey = $"avatars/{RandomNumberGenerator.GetHexString(32, lowercase: true)}.webp";
        try
        {
            using var output = new MemoryStream(webp, writable: false);
            await storage.PutAsync(newKey, output, "image/webp", ct);
        }
        catch (FileStorageException ex)
        {
            logger.LogError(ex, "Could not store avatar.");
            throw AppException.ServiceUnavailable(Messages.StorageUnavailable);
        }

        var oldKey = user.AvatarKey;
        user.AvatarKey = newKey;
        try
        {
            await users.SaveChangesAsync(ct);
        }
        catch
        {
            // DB không ghi được thì object mới thành rác: dọn ngay rồi báo lỗi như thường.
            await TryDeleteAsync(newKey);
            throw;
        }

        // Xoá ảnh cũ sau khi DB đã trỏ sang ảnh mới. Xoá lỗi chỉ để lại rác, người dùng không bị ảnh hưởng.
        if (oldKey is not null) await TryDeleteAsync(oldKey);
        return new AvatarDto(ReadUrl(newKey));
    }

    public async Task<AvatarDto> DeleteAvatarAsync(CancellationToken ct)
    {
        var user = await RequireUserAsync(ct);
        var oldKey = user.AvatarKey;
        if (oldKey is null) return new AvatarDto(null);

        user.AvatarKey = null;
        await users.SaveChangesAsync(ct);
        await TryDeleteAsync(oldKey);
        return new AvatarDto(null);
    }

    private async Task<AppUser> RequireUserAsync(CancellationToken ct)
    {
        if (currentUser.UserId is not { } id) throw AppException.Unauthorized(Messages.UnauthorizedTitle);
        return await users.FindByIdAsync(id, ct) ?? throw AppException.Unauthorized(Messages.UnauthorizedTitle);
    }

    private string? ReadUrl(string? key) =>
        key is null || !storage.IsConfigured ? null : storage.GetReadUrl(key, ReadUrlLifetime);

    private async Task TryDeleteAsync(string key)
    {
        try
        {
            await storage.DeleteAsync(key, CancellationToken.None);
        }
        catch (FileStorageException ex)
        {
            logger.LogWarning(ex, "Could not delete old avatar object {Key}.", key);
        }
    }
}
