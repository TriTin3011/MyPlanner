namespace MyPlanner.Core.Storage;

// Local trỏ vào MinIO, deploy trỏ vào Cloudflare R2. Khoá chỉ đến từ cấu hình bị gitignore hoặc biến môi trường Storage__*.
public class StorageOptions
{
    public const string Section = "Storage";

    public string Endpoint { get; set; } = "";
    public string Bucket { get; set; } = "";
    public string AccessKey { get; set; } = "";
    public string SecretKey { get; set; } = "";

    // R2 dùng region "auto".
    public string Region { get; set; } = "us-east-1";

    // Chỉ bật ở local. Production tạo bucket trước và cấp cho app khoá quyền tối thiểu.
    public bool AutoCreateBucket { get; set; }

    public bool IsConfigured =>
        !string.IsNullOrWhiteSpace(Endpoint) && !string.IsNullOrWhiteSpace(Bucket)
        && !string.IsNullOrWhiteSpace(AccessKey) && !string.IsNullOrWhiteSpace(SecretKey);
}
