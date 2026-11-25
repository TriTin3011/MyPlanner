using System.Buffers.Text;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Options;
using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Auth;

namespace MyPlanner.BLL.Auth;

// Quản lý vòng đời phiên: mỗi lần gia hạn, refresh token cũ bị tiêu thụ và một token mới thay thế (rotation).
public class SessionService(
    IRefreshTokenRepository refreshTokens,
    IUserRepository users,
    ITokenIssuer tokens,
    IOptions<JwtOptions> options,
    TimeProvider clock) : ISessionService
{
    // Hai tab cùng gia hạn, hoặc mất mạng lúc nhận response, sẽ gửi lại token vừa dùng. Trong khoảng này không coi là tấn công.
    public static readonly TimeSpan ReuseGrace = TimeSpan.FromSeconds(30);
    private const int TokenBytes = 32; // 256 bit ngẫu nhiên: không thể đoán, nên SHA-256 không cần salt

    public async Task<LoginResponse> StartAsync(AppUser user, CancellationToken ct)
    {
        await refreshTokens.DeleteExpiredAsync(user.Id, clock.GetUtcNow(), ct);
        return await IssueAsync(user, Guid.NewGuid(), ct);
    }

    public async Task<LoginResponse> RefreshAsync(RefreshRequest request, CancellationToken ct)
    {
        var hash = Hash(request.RefreshToken);
        var now = clock.GetUtcNow();
        var stored = await refreshTokens.FindByHashAsync(hash, ct);
        if (!IsUsable(stored, now)) throw Invalid();

        if (stored!.ConsumedAt is null && !await refreshTokens.TryConsumeAsync(stored.Id, now, ct))
        {
            // Thua cuộc đua với request khác: đọc lại để biết token vừa được dùng hay vừa bị thu hồi.
            stored = await refreshTokens.FindByHashAsync(hash, ct);
            if (!IsUsable(stored, now)) throw Invalid();
        }

        // ConsumedAt có từ trước: token cũ được gửi lại. Quá khoảng ân hạn thì coi là bị đánh cắp.
        if (stored!.ConsumedAt is { } consumedAt && now - consumedAt > ReuseGrace)
        {
            await refreshTokens.RevokeFamilyAsync(stored.FamilyId, now, ct);
            throw Invalid();
        }

        var user = await users.FindByIdAsync(stored.UserId, ct) ?? throw Invalid();
        return await IssueAsync(user, stored.FamilyId, ct);
    }

    public async Task LogoutAsync(RefreshRequest request, CancellationToken ct)
    {
        var stored = await refreshTokens.FindByHashAsync(Hash(request.RefreshToken), ct);
        if (stored is not null) await refreshTokens.RevokeFamilyAsync(stored.FamilyId, clock.GetUtcNow(), ct);
    }

    private async Task<LoginResponse> IssueAsync(AppUser user, Guid familyId, CancellationToken ct)
    {
        var now = clock.GetUtcNow();
        var refreshExpiresAt = now.AddDays(options.Value.RefreshDays); // tính lại mỗi lần gia hạn: phiên trượt
        var refreshToken = Base64Url.EncodeToString(RandomNumberGenerator.GetBytes(TokenBytes));

        await refreshTokens.AddAsync(new RefreshToken
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            FamilyId = familyId,
            TokenHash = Hash(refreshToken),
            CreatedAt = now,
            ExpiresAt = refreshExpiresAt,
        }, ct);

        var access = tokens.Issue(user);
        return new LoginResponse(access.Token, access.ExpiresAt, user.UserName, user.DisplayName, refreshToken, refreshExpiresAt);
    }

    private static bool IsUsable(RefreshToken? token, DateTimeOffset now) =>
        token is { RevokedAt: null } && token.ExpiresAt > now;

    private static string Hash(string token) =>
        Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(token)));

    // Cùng một lỗi cho mọi trường hợp: không cho người dò biết token có tồn tại hay không.
    private static AppException Invalid() => AppException.Unauthorized(Messages.InvalidRefreshToken);
}
