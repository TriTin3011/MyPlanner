using System.Security.Cryptography;
using Microsoft.AspNetCore.Identity;
using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Auth;

namespace MyPlanner.BLL.Auth;

// Đăng ký và đăng nhập. Chỉ dùng PasswordHasher của Identity (PBKDF2, salt ngẫu nhiên, nhiều vòng lặp), không kéo cả
// ASP.NET Core Identity (UserManager, 7 bảng AspNet*): app chỉ cần tên + mật khẩu (+ Google ở bước 11.7),
// không cần role, khoá tài khoản, xác thực email.
public class AuthService(
    IUserRepository users,
    IPasswordHasher<AppUser> hasher,
    ISessionService sessions,
    IGoogleTokenVerifier google,
    TimeProvider clock) : IAuthService
{
    public const int MinPasswordLength = 8;
    public const int MaxUserNameLength = 64; // khớp HasMaxLength(64) của cột UserName
    private const int MaxGoogleNameAttempts = 5;

    // Dùng để băm "giả" khi tên đăng nhập không tồn tại, để thời gian trả lời giống trường hợp sai mật khẩu.
    private static readonly AppUser DummyUser = new() { UserName = "dummy" };

    public async Task<LoginResponse> LoginAsync(LoginRequest request, CancellationToken ct)
    {
        var user = await users.FindByUserNameAsync(Normalize(request.UserName), ct);
        // Tài khoản chỉ dùng Google không có mật khẩu: xử lý y như tên không tồn tại.
        if (user is null || user.PasswordHash.Length == 0)
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

        return await sessions.StartAsync(user, ct);
    }

    public async Task<LoginResponse> RegisterAsync(RegisterRequest request, CancellationToken ct)
    {
        var user = new AppUser { Id = Guid.NewGuid(), UserName = Normalize(request.UserName), CreatedAt = clock.GetUtcNow() };
        user.PasswordHash = hasher.HashPassword(user, request.Password);

        // Không "kiểm tra có chưa rồi mới thêm": hai request cùng tên đến cùng lúc đều qua bước kiểm tra.
        // Để index unique của DB quyết định, repository báo false khi bị trùng.
        if (!await users.TryAddAsync(user, ct))
            throw AppException.Conflict(Messages.UserNameTaken);

        return await sessions.StartAsync(user, ct);
    }

    public async Task<LoginResponse> GoogleLoginAsync(GoogleLoginRequest request, CancellationToken ct)
    {
        var identity = await google.VerifyAsync(request.IdToken, ct)
            ?? throw AppException.Unauthorized(Messages.InvalidGoogleToken);

        var user = await users.FindByGoogleSubjectAsync(identity.Subject, ct)
            ?? await CreateGoogleUserAsync(identity, ct);

        return await sessions.StartAsync(user, ct);
    }

    // Không tự gộp vào tài khoản cũ theo email: tài khoản mật khẩu của app không có email đã xác thực,
    // nên không có căn cứ nào để nói hai bên là cùng một người.
    private async Task<AppUser> CreateGoogleUserAsync(GoogleIdentity identity, CancellationToken ct)
    {
        var baseName = GoogleUserNameBase(identity.Email);
        for (var attempt = 0; attempt < MaxGoogleNameAttempts; attempt++)
        {
            var name = attempt == 0 ? baseName : $"{baseName}-{RandomNumberGenerator.GetHexString(6, lowercase: true)}";
            var user = new AppUser { Id = Guid.NewGuid(), UserName = name, GoogleSubject = identity.Subject, CreatedAt = clock.GetUtcNow() };
            if (await users.TryAddAsync(user, ct)) return user;

            // Bị trùng có thể do hai request đăng nhập lần đầu chạy song song: request kia đã tạo xong.
            var existing = await users.FindByGoogleSubjectAsync(identity.Subject, ct);
            if (existing is not null) return existing;
        }
        throw AppException.Conflict(Messages.UserNameTaken);
    }

    // Lấy phần trước @ của email, chỉ giữ ký tự hợp lệ. Chừa chỗ cho hậu tố "-xxxxxx" trong giới hạn 64 ký tự.
    private static string GoogleUserNameBase(string? email)
    {
        var local = Normalize((email ?? "").Split('@')[0]);
        var clean = new string(local.Where(c => char.IsAsciiLetterOrDigit(c) || c is '.' or '_' or '-').ToArray());
        if (clean.Length < 3) clean = "user";
        return clean.Length > MaxUserNameLength - 7 ? clean[..(MaxUserNameLength - 7)] : clean;
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
    internal static string Normalize(string userName) => userName.Trim().ToLowerInvariant();
}
