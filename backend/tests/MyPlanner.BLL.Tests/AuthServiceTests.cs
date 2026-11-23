using System.Globalization;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using MyPlanner.BLL.Auth;
using MyPlanner.BLL.Common;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Auth;

namespace MyPlanner.BLL.Tests;

public class AuthServiceTests : IDisposable
{
    private static readonly DateTimeOffset Now = new(2026, 11, 22, 8, 0, 0, TimeSpan.Zero);
    private const string Password = "mat-khau-dev-123";

    private static readonly JwtOptions Jwt = new()
    {
        Key = "khoa-test-dai-hon-32-byte-cho-hs256-0123456789",
        Issuer = "MyPlanner",
        Audience = "MyPlanner",
        ExpiresMinutes = 60,
    };

    private readonly CultureInfo previousUiCulture = CultureInfo.CurrentUICulture;
    private readonly FakeUserRepository users = new();
    private readonly FakeGoogleVerifier googleVerifier = new();
    private readonly AuthService service;

    public AuthServiceTests()
    {
        CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo("vi");
        var clock = new FixedTimeProvider(Now);
        service = new AuthService(users, new PasswordHasher<AppUser>(), new JwtTokenIssuer(Options.Create(Jwt), clock), googleVerifier, clock);
    }

    public void Dispose() => CultureInfo.CurrentUICulture = previousUiCulture;

    [Fact]
    public async Task EnsureAccountAsync_creates_user_with_hashed_password_when_table_is_empty()
    {
        var created = await service.EnsureAccountAsync("  Tin ", Password, CancellationToken.None);

        Assert.True(created);
        var user = Assert.Single(users.Items);
        Assert.Equal("tin", user.UserName);           // tên được chuẩn hoá
        Assert.NotEqual(Password, user.PasswordHash); // không lưu mật khẩu gốc
        Assert.Equal(Now, user.CreatedAt);
    }

    [Fact]
    public async Task EnsureAccountAsync_does_nothing_when_a_user_already_exists()
    {
        await service.EnsureAccountAsync("tin", Password, CancellationToken.None);

        var created = await service.EnsureAccountAsync("other", "mat-khau-khac-456", CancellationToken.None);

        Assert.False(created);
        Assert.Single(users.Items);
    }

    [Theory]
    [InlineData(null, Password)]
    [InlineData("tin", null)]
    [InlineData("  ", Password)]
    public async Task EnsureAccountAsync_skips_when_config_is_missing(string? userName, string? password)
    {
        Assert.False(await service.EnsureAccountAsync(userName, password, CancellationToken.None));
        Assert.Empty(users.Items);
    }

    [Fact]
    public async Task EnsureAccountAsync_rejects_short_password()
    {
        await Assert.ThrowsAsync<InvalidOperationException>(
            () => service.EnsureAccountAsync("tin", "ngan", CancellationToken.None));
    }

    [Fact]
    public async Task LoginAsync_returns_valid_signed_token_for_correct_credentials()
    {
        await service.EnsureAccountAsync("tin", Password, CancellationToken.None);

        var result = await service.LoginAsync(new LoginRequest("TIN", Password), CancellationToken.None);

        Assert.Equal("tin", result.UserName);
        Assert.Equal(Now.AddMinutes(Jwt.ExpiresMinutes), result.ExpiresAt);

        // Kiểm token bằng đúng tham số mà JwtBearer ở Api dùng. Lifetime tắt vì token phát theo đồng hồ giả.
        var validation = await new JsonWebTokenHandler().ValidateTokenAsync(result.AccessToken, new TokenValidationParameters
        {
            ValidIssuer = Jwt.Issuer,
            ValidAudience = Jwt.Audience,
            IssuerSigningKey = Jwt.SigningKey(),
            ValidAlgorithms = [SecurityAlgorithms.HmacSha256],
            ValidateLifetime = false,
        });
        Assert.True(validation.IsValid, validation.Exception?.Message);
        Assert.Equal("tin", validation.Claims[JwtRegisteredClaimNames.UniqueName]);
        Assert.Equal(users.Items[0].Id.ToString(), validation.Claims[JwtRegisteredClaimNames.Sub]);
    }

    [Fact]
    public async Task Token_signed_with_other_key_is_rejected()
    {
        await service.EnsureAccountAsync("tin", Password, CancellationToken.None);
        var result = await service.LoginAsync(new LoginRequest("tin", Password), CancellationToken.None);

        var validation = await new JsonWebTokenHandler().ValidateTokenAsync(result.AccessToken, new TokenValidationParameters
        {
            ValidIssuer = Jwt.Issuer,
            ValidAudience = Jwt.Audience,
            IssuerSigningKey = new JwtOptions { Key = "mot-khoa-khac-hoan-toan-dai-hon-32-byte-xyz" }.SigningKey(),
            ValidateLifetime = false,
        });

        Assert.False(validation.IsValid);
    }

    [Fact]
    public async Task LoginAsync_wrong_password_and_unknown_user_give_same_401()
    {
        await service.EnsureAccountAsync("tin", Password, CancellationToken.None);

        var wrongPassword = await Assert.ThrowsAsync<AppException>(
            () => service.LoginAsync(new LoginRequest("tin", "sai-mat-khau"), CancellationToken.None));
        var unknownUser = await Assert.ThrowsAsync<AppException>(
            () => service.LoginAsync(new LoginRequest("khong-co", Password), CancellationToken.None));

        Assert.Equal(401, wrongPassword.StatusCode);
        Assert.Equal(401, unknownUser.StatusCode);
        // Cùng một thông báo: không cho kẻ dò biết tên đăng nhập nào có thật.
        Assert.Equal(wrongPassword.Detail, unknownUser.Detail);
    }

    [Fact]
    public async Task EnsureAccountAsync_rejects_user_name_longer_than_column()
    {
        await Assert.ThrowsAsync<InvalidOperationException>(
            () => service.EnsureAccountAsync(new string('a', AuthService.MaxUserNameLength + 1), Password, CancellationToken.None));
        Assert.Empty(users.Items);
    }

    [Fact]
    public async Task LoginAsync_rehashes_and_saves_when_hash_is_outdated()
    {
        var clock = new FixedTimeProvider(Now);
        var rehashing = new AuthService(users, new RehashNeededHasher(), new JwtTokenIssuer(Options.Create(Jwt), clock), googleVerifier, clock);
        await rehashing.EnsureAccountAsync("tin", Password, CancellationToken.None);
        var oldHash = users.Items[0].PasswordHash;
        users.SaveCount = 0;

        await rehashing.LoginAsync(new LoginRequest("tin", Password), CancellationToken.None);

        Assert.NotEqual(oldHash, users.Items[0].PasswordHash); // hash mới (salt mới) đã thay hash cũ
        Assert.Equal(1, users.SaveCount);                      // và được lưu xuống DB
    }

    [Theory]
    [InlineData(31, false)]
    [InlineData(32, true)]
    public void JwtOptions_requires_key_of_at_least_32_bytes(int length, bool expected) =>
        Assert.Equal(expected, new JwtOptions { Key = new string('k', length) }.HasValidKey);

    [Theory]
    [InlineData("", Password, false)]
    [InlineData("tin", "", false)]
    [InlineData("tin", Password, true)]
    public void LoginRequestValidator_requires_user_name_and_password(string userName, string password, bool valid) =>
        Assert.Equal(valid, new LoginRequestValidator().Validate(new LoginRequest(userName, password)).IsValid);

    [Fact]
    public void LoginRequestValidator_caps_password_length_to_protect_cpu() =>
        Assert.False(new LoginRequestValidator().Validate(new LoginRequest("tin", new string('x', 257))).IsValid);

    [Fact]
    public async Task RegisterAsync_creates_normalized_user_and_returns_token_for_it()
    {
        var result = await service.RegisterAsync(new RegisterRequest("  An.Nguyen ", Password), CancellationToken.None);

        var user = Assert.Single(users.Items);
        Assert.Equal("an.nguyen", user.UserName);
        Assert.NotEqual(Password, user.PasswordHash);
        Assert.Equal("an.nguyen", result.UserName);
        Assert.False(string.IsNullOrEmpty(result.AccessToken));

        // Đăng ký xong đăng nhập lại bằng chính mật khẩu đó được.
        var login = await service.LoginAsync(new LoginRequest("AN.NGUYEN", Password), CancellationToken.None);
        Assert.Equal("an.nguyen", login.UserName);
    }

    [Fact]
    public async Task RegisterAsync_rejects_taken_user_name_case_insensitively_with_409()
    {
        await service.RegisterAsync(new RegisterRequest("tin", Password), CancellationToken.None);

        var error = await Assert.ThrowsAsync<AppException>(
            () => service.RegisterAsync(new RegisterRequest("TIN", "mat-khau-khac-456"), CancellationToken.None));

        Assert.Equal(409, error.StatusCode);
        Assert.Single(users.Items);
    }

    [Theory]
    [InlineData("tin", Password, true)]
    [InlineData(" Tin_2026 ", Password, true)]       // được trim + hạ chữ thường trước khi kiểm
    [InlineData("ab", Password, false)]              // quá ngắn
    [InlineData("tin nguyen", Password, false)]      // có khoảng trắng
    [InlineData("tín", Password, false)]             // có dấu
    [InlineData("tin", "1234567", false)]            // mật khẩu 7 ký tự
    [InlineData("tin", "12345678", true)]
    public void RegisterRequestValidator_checks_user_name_format_and_password_length(string userName, string password, bool valid) =>
        Assert.Equal(valid, new RegisterRequestValidator().Validate(new RegisterRequest(userName, password)).IsValid);

    [Fact]
    public void RegisterRequestValidator_rejects_user_name_longer_than_column() =>
        Assert.False(new RegisterRequestValidator().Validate(new RegisterRequest(new string('a', 65), Password)).IsValid);

    [Fact]
    public async Task GoogleLoginAsync_rejects_invalid_token_without_creating_user()
    {
        var error = await Assert.ThrowsAsync<AppException>(
            () => service.GoogleLoginAsync(new GoogleLoginRequest("bad"), CancellationToken.None));

        Assert.Equal(401, error.StatusCode);
        Assert.Empty(users.Items);
    }

    [Fact]
    public async Task GoogleLoginAsync_creates_user_once_then_reuses_it()
    {
        googleVerifier.Identity = new GoogleIdentity("sub-1", "Tin.Nguyen+x@example.com");

        var first = await service.GoogleLoginAsync(new GoogleLoginRequest("t"), CancellationToken.None);
        var second = await service.GoogleLoginAsync(new GoogleLoginRequest("t"), CancellationToken.None);

        var user = Assert.Single(users.Items);
        Assert.Equal("tin.nguyenx", user.UserName);
        Assert.Equal("", user.PasswordHash);
        Assert.Equal(first.UserName, second.UserName);
    }

    [Fact]
    public async Task GoogleLoginAsync_does_not_take_over_an_account_with_the_same_name()
    {
        await service.RegisterAsync(new RegisterRequest("tin", Password), CancellationToken.None);
        googleVerifier.Identity = new GoogleIdentity("sub-2", "tin@example.com");

        var result = await service.GoogleLoginAsync(new GoogleLoginRequest("t"), CancellationToken.None);

        Assert.StartsWith("tin-", result.UserName);
        Assert.Equal(2, users.Items.Count);
        Assert.Null(users.Items.Single(u => u.UserName == "tin").GoogleSubject);
    }

    [Fact]
    public async Task LoginAsync_rejects_password_for_google_only_account()
    {
        googleVerifier.Identity = new GoogleIdentity("sub-3", "tin@example.com");
        await service.GoogleLoginAsync(new GoogleLoginRequest("t"), CancellationToken.None);

        var error = await Assert.ThrowsAsync<AppException>(
            () => service.LoginAsync(new LoginRequest("tin", ""), CancellationToken.None));

        Assert.Equal(401, error.StatusCode);
    }

    [Fact]
    public async Task GoogleTokenVerifier_returns_null_when_client_id_is_missing()
    {
        var verifier = new GoogleTokenVerifier(Options.Create(new GoogleOptions()));

        Assert.Null(await verifier.VerifyAsync("any-token", CancellationToken.None));
    }

    private sealed class FakeGoogleVerifier : IGoogleTokenVerifier
    {
        public GoogleIdentity? Identity { get; set; }

        public Task<GoogleIdentity?> VerifyAsync(string idToken, CancellationToken ct) => Task.FromResult(Identity);
    }

    // Giả lập hash cũ: mật khẩu đúng nhưng hasher báo "cần băm lại" (như khi .NET tăng số vòng lặp PBKDF2).
    private sealed class RehashNeededHasher : PasswordHasher<AppUser>
    {
        public override PasswordVerificationResult VerifyHashedPassword(AppUser user, string hashedPassword, string providedPassword) =>
            base.VerifyHashedPassword(user, hashedPassword, providedPassword) == PasswordVerificationResult.Failed
                ? PasswordVerificationResult.Failed
                : PasswordVerificationResult.SuccessRehashNeeded;
    }

    private sealed class FixedTimeProvider(DateTimeOffset now) : TimeProvider
    {
        public override DateTimeOffset GetUtcNow() => now;
    }

    private sealed class FakeUserRepository : IUserRepository
    {
        public List<AppUser> Items { get; } = [];

        public Task<AppUser?> FindByUserNameAsync(string userName, CancellationToken ct) =>
            Task.FromResult(Items.FirstOrDefault(u => u.UserName == userName));

        public Task<AppUser?> FindByGoogleSubjectAsync(string subject, CancellationToken ct) =>
            Task.FromResult(Items.FirstOrDefault(u => u.GoogleSubject == subject));

        public Task<bool> AnyAsync(CancellationToken ct) => Task.FromResult(Items.Count > 0);

        public void Add(AppUser user) => Items.Add(user);

        // Giống index unique của DB: trùng tên thì không thêm.
        public Task<bool> TryAddAsync(AppUser user, CancellationToken ct)
        {
            if (Items.Any(u => u.UserName == user.UserName)) return Task.FromResult(false);
            Items.Add(user);
            return Task.FromResult(true);
        }

        public int SaveCount { get; set; }

        public Task SaveChangesAsync(CancellationToken ct)
        {
            SaveCount++;
            return Task.CompletedTask;
        }
    }
}
