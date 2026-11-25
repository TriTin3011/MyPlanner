using Microsoft.Extensions.Options;
using MyPlanner.BLL.Auth;
using MyPlanner.BLL.Common;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Auth;

namespace MyPlanner.BLL.Tests;

public class SessionServiceTests
{
    private static readonly JwtOptions Jwt = new()
    {
        Key = "khoa-test-dai-hon-32-byte-cho-hs256-0123456789",
        ExpiresMinutes = 15,
        RefreshDays = 30,
    };

    private readonly MutableClock clock = new(new DateTimeOffset(2026, 11, 24, 8, 0, 0, TimeSpan.Zero));
    private readonly FakeRefreshTokenRepository store = new();
    private readonly AuthServiceTests.FakeUserRepository users = new();
    private readonly AppUser user = new() { Id = Guid.NewGuid(), UserName = "tin" };
    private readonly SessionService service;

    public SessionServiceTests()
    {
        users.Add(user);
        service = new SessionService(store, users, new JwtTokenIssuer(Options.Create(Jwt), clock), Options.Create(Jwt), clock);
    }

    private Task<LoginResponse> Refresh(string? token) =>
        service.RefreshAsync(new RefreshRequest(token!), CancellationToken.None);

    private Task<LoginResponse> Start() => service.StartAsync(user, CancellationToken.None);

    private async Task AssertRejected(string? token)
    {
        var error = await Assert.ThrowsAsync<AppException>(() => Refresh(token));
        Assert.Equal(401, error.StatusCode);
    }

    [Fact]
    public async Task Start_stores_only_the_hash_of_the_refresh_token()
    {
        var session = await Start();

        var row = Assert.Single(store.Items);
        Assert.NotEqual(session.RefreshToken, row.TokenHash);
        Assert.Equal(64, row.TokenHash.Length);
        Assert.Equal(clock.GetUtcNow().AddDays(30), session.RefreshExpiresAt);
    }

    [Fact]
    public async Task Refresh_rotates_token_and_slides_expiry()
    {
        var first = await Start();
        clock.Advance(TimeSpan.FromDays(29));

        var second = await Refresh(first.RefreshToken);

        Assert.NotEqual(first.RefreshToken, second.RefreshToken);
        Assert.Equal(clock.GetUtcNow().AddDays(30), second.RefreshExpiresAt);
        Assert.Equal(first.RefreshExpiresAt!.Value.AddDays(29), second.RefreshExpiresAt);
    }

    [Fact]
    public async Task Resend_within_grace_gets_a_new_token_in_same_family()
    {
        var first = await Start();
        await Refresh(first.RefreshToken);
        clock.Advance(SessionService.ReuseGrace);

        var retried = await Refresh(first.RefreshToken);

        Assert.False(string.IsNullOrEmpty(retried.RefreshToken));
        Assert.Single(store.Items.Select(t => t.FamilyId).Distinct());
        Assert.All(store.Items, t => Assert.Null(t.RevokedAt));
    }

    [Fact]
    public async Task Reuse_after_grace_revokes_the_whole_family()
    {
        var first = await Start();
        var second = await Refresh(first.RefreshToken);
        clock.Advance(SessionService.ReuseGrace + TimeSpan.FromSeconds(1));

        await AssertRejected(first.RefreshToken);

        Assert.All(store.Items, t => Assert.NotNull(t.RevokedAt));
        await AssertRejected(second.RefreshToken); // token mới nhất cũng mất hiệu lực
    }

    [Fact]
    public async Task Reuse_does_not_touch_other_sessions()
    {
        var stolen = await Start();
        var otherDevice = await Start();
        await Refresh(stolen.RefreshToken);
        clock.Advance(TimeSpan.FromMinutes(1));

        await AssertRejected(stolen.RefreshToken);

        Assert.NotNull(await Refresh(otherDevice.RefreshToken));
    }

    [Fact]
    public async Task Losing_the_consume_race_is_treated_as_grace()
    {
        var first = await Start();
        store.ConsumeBeforeNextTry = clock.GetUtcNow();

        var result = await Refresh(first.RefreshToken);

        Assert.False(string.IsNullOrEmpty(result.RefreshToken));
    }

    [Fact]
    public async Task Losing_the_race_to_a_logout_is_rejected()
    {
        var first = await Start();
        store.RevokeBeforeNextTry = clock.GetUtcNow();

        await AssertRejected(first.RefreshToken);
        Assert.Single(store.Items); // không cấp token mới cho phiên vừa đăng xuất
    }

    [Fact]
    public async Task Expired_and_unknown_tokens_are_rejected()
    {
        var session = await Start();
        await AssertRejected("khong-ton-tai");

        clock.Advance(TimeSpan.FromDays(30));
        await AssertRejected(session.RefreshToken);
    }

    [Fact]
    public async Task Logout_revokes_session_and_ignores_unknown_token()
    {
        var session = await Start();
        await service.LogoutAsync(new RefreshRequest("khong-ton-tai"), CancellationToken.None);
        Assert.Null(store.Items[0].RevokedAt);

        await service.LogoutAsync(new RefreshRequest(session.RefreshToken!), CancellationToken.None);

        await AssertRejected(session.RefreshToken);
    }

    [Fact]
    public async Task Start_cleans_up_expired_tokens_of_the_user()
    {
        await Start();
        clock.Advance(TimeSpan.FromDays(31));

        await Start();

        Assert.Single(store.Items);
    }

    private sealed class MutableClock(DateTimeOffset now) : TimeProvider
    {
        private DateTimeOffset current = now;
        public override DateTimeOffset GetUtcNow() => current;
        public void Advance(TimeSpan by) => current += by;
    }
}

// Giữ dữ liệu trong bộ nhớ, mô phỏng đúng điều kiện của các câu UPDATE trong repository thật.
internal sealed class FakeRefreshTokenRepository : IRefreshTokenRepository
{
    public List<RefreshToken> Items { get; } = [];
    // Mô phỏng request khác chen vào giữa lúc đọc và lúc tiêu thụ token.
    public DateTimeOffset? ConsumeBeforeNextTry { get; set; }
    public DateTimeOffset? RevokeBeforeNextTry { get; set; }

    // Trả bản sao giống AsNoTracking: service không sửa được dòng gốc.
    public Task<RefreshToken?> FindByHashAsync(string tokenHash, CancellationToken ct)
    {
        var row = Items.FirstOrDefault(t => t.TokenHash == tokenHash);
        return Task.FromResult(row is null ? null : Copy(row));
    }

    public Task AddAsync(RefreshToken token, CancellationToken ct)
    {
        Items.Add(token);
        return Task.CompletedTask;
    }

    public Task<bool> TryConsumeAsync(Guid id, DateTimeOffset now, CancellationToken ct)
    {
        var row = Items.Single(t => t.Id == id);
        if (ConsumeBeforeNextTry is { } consumedAt) { row.ConsumedAt = consumedAt; ConsumeBeforeNextTry = null; }
        if (RevokeBeforeNextTry is { } revokedAt) { row.RevokedAt = revokedAt; RevokeBeforeNextTry = null; }
        if (row.ConsumedAt is not null || row.RevokedAt is not null) return Task.FromResult(false);
        row.ConsumedAt = now;
        return Task.FromResult(true);
    }

    public Task RevokeFamilyAsync(Guid familyId, DateTimeOffset now, CancellationToken ct)
    {
        foreach (var row in Items.Where(t => t.FamilyId == familyId && t.RevokedAt is null)) row.RevokedAt = now;
        return Task.CompletedTask;
    }

    public Task DeleteExpiredAsync(Guid userId, DateTimeOffset now, CancellationToken ct)
    {
        Items.RemoveAll(t => t.UserId == userId && t.ExpiresAt <= now);
        return Task.CompletedTask;
    }

    private static RefreshToken Copy(RefreshToken t) => new()
    {
        Id = t.Id,
        UserId = t.UserId,
        FamilyId = t.FamilyId,
        TokenHash = t.TokenHash,
        CreatedAt = t.CreatedAt,
        ExpiresAt = t.ExpiresAt,
        ConsumedAt = t.ConsumedAt,
        RevokedAt = t.RevokedAt,
    };
}
