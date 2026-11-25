using System.Data.Common;
using System.Globalization;
using System.Threading.RateLimiting;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Localization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using MyPlanner.Api.Common;
using MyPlanner.Api.Controllers;
using MyPlanner.BLL;
using MyPlanner.BLL.Auth;
using MyPlanner.BLL.Localization;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// ---------- Services (DI container) ----------

// Connection string: dev lấy từ appsettings.Development.json, deploy lấy từ biến môi trường ConnectionStrings__Default.
var connectionString = builder.Configuration.GetConnectionString("Default")
    ?? throw new InvalidOperationException("Thiếu ConnectionStrings:Default");

// Api chỉ gọi BLL. BLL đăng ký service + validator rồi tự gọi DAL (DbContext, repository).
builder.Services.AddBusinessLogic(connectionString);

// "Ai đang gọi" lấy từ JWT của request; DAL dùng để lọc dữ liệu theo tài khoản (SPEC §12.0).
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<MyPlanner.Core.Auth.ICurrentUser, HttpContextCurrentUser>();

builder.Services.AddLocalization();
builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    var supportedCultures = new[] { new CultureInfo("vi"), new CultureInfo("en") };
    options.DefaultRequestCulture = new RequestCulture("vi");
    options.SupportedCultures = supportedCultures;
    options.SupportedUICultures = supportedCultures;
    // API language comes only from Accept-Language; query-string and cookie providers are disabled.
    options.RequestCultureProviders = [new AcceptLanguageHeaderRequestCultureProvider()];
});

builder.Services.AddControllers(options => options.Filters.Add<ValidationFilter>())
    // Mặc định "web" cho phép đọc số từ chuỗi ("5"), khiến OpenAPI mô tả int là `number | string`.
    // Strict: số phải là số, nên kiểu sinh cho TS/Dart là `number`/`int` gọn gàng.
    .AddJsonOptions(o => o.JsonSerializerOptions.NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.Strict);
// Bộ sinh OpenAPI đọc options của Http.Json (không phải của MVC), nên đặt cả ở đây cho tài liệu khớp hành vi.
builder.Services.ConfigureHttpJsonOptions(o => o.SerializerOptions.NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.Strict);
// sinh /openapi/v1.json: hợp đồng chung cho web, WPF, Flutter. Transformer khai báo "API dùng Bearer JWT"
// để Scalar hiện ô nhập token và client sinh từ OpenAPI biết phải gửi header Authorization.
builder.Services.AddOpenApi(options => options.AddDocumentTransformer<BearerSecuritySchemeTransformer>());
builder.Services.AddProblemDetails(); // mọi lỗi trả JSON chuẩn RFC 9457 { type, title, status, detail, traceId }
builder.Services.AddExceptionHandler<AppExceptionHandler>(); // AppException (404/400 nghiệp vụ) -> ProblemDetails

// CORS: chỉ cho phép origin của FE. Dev đọc appsettings.json; deploy đặt Cors__Origins__0, Cors__Origins__1, ...
var corsOrigins = builder.Configuration.GetSection("Cors:Origins").Get<string[]>() ?? [];
builder.Services.AddCors(options => options.AddDefaultPolicy(policy =>
    policy.WithOrigins(corsOrigins).AllowAnyHeader().AllowAnyMethod()));

// ---------- Xác thực (JWT Bearer) ----------

// Một JwtOptions cho cả hai đầu: AuthService ký token, JwtBearer kiểm token. Thiếu/ngắn Jwt:Key thì app dừng ngay khi khởi động.
builder.Services.AddOptions<JwtOptions>()
    .Bind(builder.Configuration.GetSection(JwtOptions.Section))
    .Validate(o => o.HasValidKey, $"Jwt:Key phải dài ít nhất {JwtOptions.MinKeyBytes} byte.")
    // Issuer/Audience rỗng hoặc ExpiresMinutes <= 0 vẫn khởi động được nhưng mọi token phát ra đều hỏng: chặn ngay từ đầu.
    .Validate(o => !string.IsNullOrWhiteSpace(o.Issuer) && !string.IsNullOrWhiteSpace(o.Audience),
        "Jwt:Issuer và Jwt:Audience không được trống.")
    .Validate(o => o.ExpiresMinutes > 0, "Jwt:ExpiresMinutes phải lớn hơn 0.")
    .Validate(o => o.RefreshDays > 0, "Jwt:RefreshDays phải lớn hơn 0.")
    .ValidateOnStart();

// Đăng nhập Google là tuỳ chọn: thiếu Google:ClientId thì app vẫn chạy, POST /auth/google luôn trả 401.
builder.Services.Configure<GoogleOptions>(builder.Configuration.GetSection(GoogleOptions.Section));

// Lưu ảnh cũng là tuỳ chọn: thiếu Storage thì app vẫn chạy và avatar hiện chữ cái đầu.
builder.Services.Configure<MyPlanner.Core.Storage.StorageOptions>(
    builder.Configuration.GetSection(MyPlanner.Core.Storage.StorageOptions.Section));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer();
// Cấu hình JwtBearer từ JwtOptions đã bind ở trên (không đọc IConfiguration lần hai).
builder.Services.AddOptions<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme)
    .Configure<IOptions<JwtOptions>>((bearer, jwt) =>
    {
        var o = jwt.Value;
        // Giữ tên claim gốc của JWT ("sub", "unique_name") thay vì đổi sang URI dài kiểu ClaimTypes.NameIdentifier.
        bearer.MapInboundClaims = false;
        bearer.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = o.Issuer,
            ValidateAudience = true,
            ValidAudience = o.Audience,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = o.SigningKey(),
            ValidAlgorithms = [SecurityAlgorithms.HmacSha256], // chặn token đổi "alg" sang thuật toán khác
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromSeconds(30), // mặc định 5 phút là quá rộng khi chỉ có một server
            NameClaimType = JwtRegisteredClaimNames.UniqueName, // để User.Identity.Name đọc được tên đăng nhập
        };
    });

// Fallback policy: endpoint nào không ghi gì thì mặc định phải đăng nhập. Mở ra bằng [AllowAnonymous] (login, register, health).
// An toàn hơn cách ngược lại (gắn [Authorize] từng controller), vì quên gắn chỉ làm endpoint bị khoá chứ không bị lộ.
builder.Services.AddAuthorizationBuilder()
    .SetFallbackPolicy(new AuthorizationPolicyBuilder().RequireAuthenticatedUser().Build());

// Chống dò mật khẩu: mỗi IP tối đa 5 lần đăng nhập mỗi phút, quá thì trả 429.
// Khi deploy sau reverse proxy cần UseForwardedHeaders để RemoteIpAddress là IP thật của người dùng.
builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    // Mặc định 429 không có body. Viết ProblemDetails để client xử lý mọi lỗi theo một khuôn (status, title, detail).
    options.OnRejected = async (context, ct) =>
    {
        var http = context.HttpContext;
        if (context.Lease.TryGetMetadata(MetadataName.RetryAfter, out var retryAfter))
            http.Response.Headers.RetryAfter = ((int)retryAfter.TotalSeconds).ToString(CultureInfo.InvariantCulture);
        await http.RequestServices.GetRequiredService<IProblemDetailsService>().WriteAsync(new ProblemDetailsContext
        {
            HttpContext = http,
            ProblemDetails =
            {
                Status = StatusCodes.Status429TooManyRequests,
                Detail = http.Request.Path.StartsWithSegments("/api/profile") ? Messages.TooManyUploads
                    : http.Request.Path.StartsWithSegments("/api/auth/register") ? Messages.TooManyRegistrations
                    : http.Request.Path.StartsWithSegments("/api/auth/refresh") || http.Request.Path.StartsWithSegments("/api/auth/logout") ? Messages.TooManyRefreshes
                    : Messages.TooManyLoginAttempts,
            },
        });
    };
    options.AddPolicy(AuthController.LoginRateLimitPolicy, http => RateLimitPartition.GetFixedWindowLimiter(
        http.Connection.RemoteIpAddress?.ToString() ?? "unknown",
        _ => new FixedWindowRateLimiterOptions { PermitLimit = 5, Window = TimeSpan.FromMinutes(1), QueueLimit = 0 }));
    // Đăng ký: mỗi IP tối đa 5 tài khoản mỗi giờ. Người thật hiếm khi cần hơn; bot tạo hàng loạt thì bị chặn.
    options.AddPolicy(AuthController.RegisterRateLimitPolicy, http => RateLimitPartition.GetFixedWindowLimiter(
        http.Connection.RemoteIpAddress?.ToString() ?? "unknown",
        _ => new FixedWindowRateLimiterOptions { PermitLimit = 5, Window = TimeSpan.FromHours(1), QueueLimit = 0 }));
    // Gia hạn chạy ngầm và nhiều thiết bị có thể chung một IP, nên rộng hơn đăng nhập. Token 256 bit không dò được.
    options.AddPolicy(AuthController.RefreshRateLimitPolicy, http => RateLimitPartition.GetFixedWindowLimiter(
        http.Connection.RemoteIpAddress?.ToString() ?? "unknown",
        _ => new FixedWindowRateLimiterOptions { PermitLimit = 30, Window = TimeSpan.FromMinutes(1), QueueLimit = 0 }));
    // Xử lý ảnh tốn CPU nên giới hạn theo tài khoản: 20 lần mỗi giờ.
    options.AddPolicy(ProfileController.AvatarRateLimitPolicy, http => RateLimitPartition.GetFixedWindowLimiter(
        http.User.FindFirst(JwtRegisteredClaimNames.Sub)?.Value ?? http.Connection.RemoteIpAddress?.ToString() ?? "unknown",
        _ => new FixedWindowRateLimiterOptions { PermitLimit = 20, Window = TimeSpan.FromHours(1), QueueLimit = 0 }));
});

var app = builder.Build();

// Tạo tài khoản duy nhất từ cấu hình (Auth:UserName, Auth:Password) nếu bảng Users còn trống.
// DB chưa chạy hoặc chưa migrate thì chỉ log lỗi, app vẫn lên để /api/health báo tình trạng.
using (var scope = app.Services.CreateScope())
{
    try
    {
        var auth = scope.ServiceProvider.GetRequiredService<IAuthService>();
        if (await auth.EnsureAccountAsync(app.Configuration["Auth:UserName"], app.Configuration["Auth:Password"], CancellationToken.None))
            app.Logger.LogInformation("Đã tạo tài khoản đăng nhập từ cấu hình Auth:UserName.");
    }
    // DbUpdateException (lỗi khi SaveChanges) không kế thừa DbException nên phải bắt riêng.
    catch (Exception ex) when (ex is DbException or DbUpdateException)
    {
        app.Logger.LogError(ex, "Không tạo được tài khoản đăng nhập: database chưa sẵn sàng hoặc chưa chạy migration.");
    }
}

// ---------- Middleware pipeline (thứ tự quan trọng) ----------

app.UseRequestLocalization(); // đặt CurrentCulture/CurrentUICulture trước validation, service và exception handler
app.UseExceptionHandler(); // exception chưa bắt -> 500 dạng ProblemDetails, không lộ stack trace
app.UseStatusCodePages();  // 404/405... không có body -> ProblemDetails

if (app.Environment.IsDevelopment())
{
    // AllowAnonymous: tài liệu API mở công khai ở dev (npm run gen:api đọc file này mà không có token).
    app.MapOpenApi().AllowAnonymous();              // /openapi/v1.json
    app.MapScalarApiReference().AllowAnonymous();   // UI gọi thử API: /scalar/v1
}

app.UseHttpsRedirection();
app.UseCors();             // trước auth: preflight OPTIONS của trình duyệt không mang token, phải được trả lời trước
app.UseAuthentication();   // đọc header Authorization, kiểm chữ ký + hạn, gán HttpContext.User
app.UseAuthorization();    // áp policy: chưa đăng nhập → 401
app.UseRateLimiter();

app.MapControllers();

app.Run();
