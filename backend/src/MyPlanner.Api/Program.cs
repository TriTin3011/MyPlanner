using MyPlanner.Api.Common;
using MyPlanner.BLL;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// ---------- Services (DI container) ----------

// Connection string: dev lấy từ appsettings.Development.json, deploy lấy từ biến môi trường ConnectionStrings__Default.
var connectionString = builder.Configuration.GetConnectionString("Default")
    ?? throw new InvalidOperationException("Thiếu ConnectionStrings:Default");

// Api chỉ gọi BLL. BLL đăng ký service + validator rồi tự gọi DAL (DbContext, repository).
builder.Services.AddBusinessLogic(connectionString);

builder.Services.AddControllers(options => options.Filters.Add<ValidationFilter>())
    // Mặc định "web" cho phép đọc số từ chuỗi ("5"), khiến OpenAPI mô tả int là `number | string`.
    // Strict: số phải là số, nên kiểu sinh cho TS/Dart là `number`/`int` gọn gàng.
    .AddJsonOptions(o => o.JsonSerializerOptions.NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.Strict);
// Bộ sinh OpenAPI đọc options của Http.Json (không phải của MVC), nên đặt cả ở đây cho tài liệu khớp hành vi.
builder.Services.ConfigureHttpJsonOptions(o => o.SerializerOptions.NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.Strict);
builder.Services.AddOpenApi();       // sinh /openapi/v1.json: hợp đồng chung cho web, WPF, Flutter
builder.Services.AddProblemDetails(); // mọi lỗi trả JSON chuẩn RFC 9457 { type, title, status, detail, traceId }
builder.Services.AddExceptionHandler<AppExceptionHandler>(); // AppException (404/400 nghiệp vụ) -> ProblemDetails

// CORS: chỉ cho phép origin của FE. Dev đọc appsettings.json; deploy đặt Cors__Origins__0, Cors__Origins__1, ...
var corsOrigins = builder.Configuration.GetSection("Cors:Origins").Get<string[]>() ?? [];
builder.Services.AddCors(options => options.AddDefaultPolicy(policy =>
    policy.WithOrigins(corsOrigins).AllowAnyHeader().AllowAnyMethod()));

var app = builder.Build();

// ---------- Middleware pipeline (thứ tự quan trọng) ----------

app.UseExceptionHandler(); // exception chưa bắt -> 500 dạng ProblemDetails, không lộ stack trace
app.UseStatusCodePages();  // 404/405... không có body -> ProblemDetails

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();              // /openapi/v1.json
    app.MapScalarApiReference();   // UI gọi thử API: /scalar/v1
}

app.UseHttpsRedirection();
app.UseCors();
app.UseAuthorization();

app.MapControllers();

app.Run();
