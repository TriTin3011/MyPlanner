using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Common;

namespace MyPlanner.Api.Common;

// Đổi AppException (lỗi nghiệp vụ do service ném) thành ProblemDetails đúng status code (404, 400...).
// Exception khác trả false → handler mặc định của UseExceptionHandler trả 500, không lộ stack trace.
// Cách khác: try/catch trong từng action (lặp code), hoặc middleware tự viết. IExceptionHandler (.NET 8+) là cách chuẩn hiện nay.
public class AppExceptionHandler(IProblemDetailsService problemDetails) : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(HttpContext http, Exception exception, CancellationToken ct)
    {
        if (exception is not AppException app) return false;

        http.Response.StatusCode = app.StatusCode;
        return await problemDetails.TryWriteAsync(new ProblemDetailsContext
        {
            HttpContext = http,
            Exception = exception,
            ProblemDetails = new ProblemDetails { Status = app.StatusCode, Title = app.Title, Detail = app.Detail },
        });
    }
}
