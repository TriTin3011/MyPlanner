using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using MyPlanner.BLL.Auth;
using MyPlanner.BLL.Profile;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController(IAuthService auth) : ControllerBase
{
    public const string LoginRateLimitPolicy = "login";
    public const string RegisterRateLimitPolicy = "register";

    // Cùng register và health là các endpoint không cần token. Giới hạn số lần thử theo IP để chặn dò mật khẩu.
    [HttpPost("login")]
    [AllowAnonymous]
    [EnableRateLimiting(LoginRateLimitPolicy)]
    [ProducesResponseType<LoginResponse>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status429TooManyRequests)]
    public Task<LoginResponse> Login(LoginRequest request, CancellationToken ct) => auth.LoginAsync(request, ct);

    // Mở cho mọi người. Trả 201 kèm token để client vào app luôn. Giới hạn theo IP để không ai tạo hàng loạt tài khoản.
    [HttpPost("register")]
    [AllowAnonymous]
    [EnableRateLimiting(RegisterRateLimitPolicy)]
    [ProducesResponseType<LoginResponse>(StatusCodes.Status201Created)]
    [ProducesResponseType<ValidationProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status429TooManyRequests)]
    public async Task<ActionResult<LoginResponse>> Register(RegisterRequest request, CancellationToken ct) =>
        StatusCode(StatusCodes.Status201Created, await auth.RegisterAsync(request, ct));

    // Client gửi ID token của Google, nhận JWT của app. Dùng chung giới hạn với đăng nhập.
    [HttpPost("google")]
    [AllowAnonymous]
    [EnableRateLimiting(LoginRateLimitPolicy)]
    [ProducesResponseType<LoginResponse>(StatusCodes.Status200OK)]
    [ProducesResponseType<ValidationProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status429TooManyRequests)]
    public Task<LoginResponse> Google(GoogleLoginRequest request, CancellationToken ct) => auth.GoogleLoginAsync(request, ct);

    // Client gọi khi mở app để biết token đang giữ còn dùng được không (hết hạn → 401 → về màn đăng nhập).
    // Đọc từ DB vì tên hiển thị đổi được sau khi token đã cấp; link ảnh có hạn nên phải tạo mới mỗi lần.
    [HttpGet("me")]
    [ProducesResponseType<CurrentUserDto>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public Task<CurrentUserDto> Me([FromServices] IProfileService profile, CancellationToken ct) =>
        profile.GetCurrentAsync(ct);
}
