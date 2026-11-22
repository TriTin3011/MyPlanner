namespace MyPlanner.BLL.Common;

// Lỗi nghiệp vụ có chủ đích. Service ném, Api (AppExceptionHandler) đổi thành ProblemDetails với đúng status code.
// Cách khác: trả Result<T>/OneOf. Ở đây chọn exception cho gọn vì số loại lỗi ít (404, 400, 409).
public class AppException(int statusCode, string title, string? detail = null) : Exception(detail ?? title)
{
    public int StatusCode { get; } = statusCode;
    public string Title { get; } = title;
    public string? Detail { get; } = detail;

    public static AppException NotFound(string what) => new(404, "Không tìm thấy", $"{what} không tồn tại.");
    public static AppException BadRequest(string detail) => new(400, "Yêu cầu không hợp lệ", detail);
}
