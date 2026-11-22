using Microsoft.AspNetCore.Identity;
using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Auth;

namespace MyPlanner.BLL.Auth;

// Đăng nhập một tài khoản. Chỉ dùng PasswordHasher của Identity (PBKDF2, salt ngẫu nhiên, nhiều vòng lặp),
// không kéo cả ASP.NET Core Identity (UserManager, 7 bảng AspNet*) vì app chỉ có một người dùng.
public class AuthService(
    IUserRepository users,
    IPasswordHasher<AppUser> hasher,
    ITokenIssuer tokens,
    TimeProvider clock) : IAuthService
{
    public const int MinPasswordLength = 8;
    public const int MaxUserNameLength = 64; // khớp HasMaxLength(64) của cột UserName

    // Dùng để băm "giả" khi tên đăng nhập không tồn tại, để thời gian trả lời giống trường hợp sai mật khẩu.
    private static readonly AppUser DummyUser = new() { UserName = "dummy" };

    public async Task<LoginResponse> LoginAsync(LoginRequest request, CancellationToken ct)
    {
        var user = await users.FindByUserNameAsync(Normalize(request.UserName), ct);
        if (user is null)
        {
            // Không có user mà trả lời ngay thì kẻ dò đo thời gian là biết tên nào có thật (timing attack).
            hasher.HashPassword(DummyUser, request.Password);
            throw AppException.Unauthorized(Messages.InvalidCredentials);
        }

        var result = hasher.VerifyHashedPassword(user, user.PasswordHash, request.Password);
        if (result == PasswordVerificationResult.Failed)
            throw AppException.Unauthorized(Messages.InvalidCredentials);

        // Hash cũ dùng tham số yếu hơn bản hiện tại (ví dụ ít vòng lặp hơn): băm lại khi đang có mật khẩu gốc trong tay.
        if (result == PasswordVerificationResult.SuccessRehashNeeded)
        {
            user.PasswordHash = hasher.HashPassword(user, request.Password);
            await users.SaveChangesAsync(ct);
        }

        var token = tokens.Issue(user);
        return new LoginResponse(token.Token, token.ExpiresAt, user.UserName);
    }

    public async Task<bool> EnsureAccountAsync(string? userName, string? password, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(userName) || string.IsNullOrEmpty(password)) return false;
        if (await users.AnyAsync(ct)) return false;
        // Lỗi cấu hình của người deploy, không phải lỗi của người dùng cuối: ném để app dừng và log rõ.
        if (password.Length < MinPasswordLength)
            throw new InvalidOperationException($"Auth:Password phải dài ít nhất {MinPasswordLength} ký tự.");
        var normalized = Normalize(userName);
        if (normalized.Length > MaxUserNameLength)
            throw new InvalidOperationException($"Auth:UserName dài tối đa {MaxUserNameLength} ký tự.");

        var user = new AppUser { Id = Guid.NewGuid(), UserName = normalized, CreatedAt = clock.GetUtcNow() };
        user.PasswordHash = hasher.HashPassword(user, password);
        users.Add(user);
        await users.SaveChangesAsync(ct);
        return true;
    }

    // Tên đăng nhập không phân biệt hoa thường: "Tin" và "tin" là một.
    private static string Normalize(string userName) => userName.Trim().ToLowerInvariant();
}
