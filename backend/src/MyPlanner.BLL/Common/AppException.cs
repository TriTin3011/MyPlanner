using MyPlanner.BLL.Localization;

namespace MyPlanner.BLL.Common;

// Lỗi nghiệp vụ có chủ đích. Service ném, Api (AppExceptionHandler) đổi thành ProblemDetails với đúng status code.
// Cách khác: trả Result<T>/OneOf. Ở đây chọn exception cho gọn vì số loại lỗi ít (404, 400, 409).
public class AppException(int statusCode, string title, string? detail = null) : Exception(detail ?? title)
{
    public int StatusCode { get; } = statusCode;
    public string Title { get; } = title;
    public string? Detail { get; } = detail;

    public static AppException NotFound(string what) => new(404, Messages.NotFoundTitle, Messages.NotFoundDetail(what));
    public static AppException BadRequest(string detail) => new(400, Messages.BadRequestTitle, detail);
    public static AppException Unauthorized(string detail) => new(401, Messages.UnauthorizedTitle, detail);
}
