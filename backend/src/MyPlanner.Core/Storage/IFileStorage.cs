namespace MyPlanner.Core.Storage;

// Cổng lưu file: nghiệp vụ chỉ biết "lưu, lấy link, xoá", không biết phía sau là MinIO, R2 hay S3.
// Đặt ở Core để BLL dùng được mà không phụ thuộc AWS SDK; DAL là nơi cài đặt.
public interface IFileStorage
{
    // False khi chưa cấu hình Storage: app vẫn chạy, chỉ không có ảnh đại diện.
    bool IsConfigured { get; }

    Task PutAsync(string key, Stream content, string contentType, CancellationToken ct);

    // Link đọc có chữ ký và hết hạn. Chỉ tính toán cục bộ, không gọi mạng, nên dịch vụ lưu trữ tắt cũng không làm chậm API.
    string? GetReadUrl(string key, TimeSpan lifetime);

    Task DeleteAsync(string key, CancellationToken ct);
}

// Lỗi hạ tầng lưu trữ, đã bọc lại để BLL không phải bắt exception của AWS SDK.
public class FileStorageException(string message, Exception? inner = null) : Exception(message, inner);
