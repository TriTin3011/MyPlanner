using System.IO;
using System.Security.Cryptography;
using System.Text.Json;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Desktop.Auth;

// Giữ JWT trong bộ nhớ và lưu xuống đĩa đã mã hoá bằng DPAPI (chỉ đúng user Windows này giải mã được).
// Tương đương flutter_secure_storage ở mobile; web thì giữ token trong bộ nhớ/localStorage.
// Đăng ký Singleton: cả app dùng chung một phiên đăng nhập.
public sealed class TokenStore
{
    private static readonly string FilePath = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Mam", "session.bin");

    // Entropy phụ: app khác cùng user dùng DPAPI cũng không giải mã nhầm được file này.
    private static readonly byte[] Entropy = "MyPlanner.Desktop.v1"u8.ToArray();

    public LoginResponse? Current { get; private set; }

    // Còn hạn thì mới coi là đăng nhập; trừ 1 phút để tránh token hết hạn giữa chừng một request.
    public bool HasValidToken => Current is { } s && s.ExpiresAt > DateTimeOffset.UtcNow.AddMinutes(1);

    public void Save(LoginResponse session)
    {
        Current = session;
        var json = JsonSerializer.SerializeToUtf8Bytes(session);
        var cipher = ProtectedData.Protect(json, Entropy, DataProtectionScope.CurrentUser);
        Directory.CreateDirectory(Path.GetDirectoryName(FilePath)!);
        File.WriteAllBytes(FilePath, cipher);
    }

    public void Load()
    {
        try
        {
            if (!File.Exists(FilePath)) return;
            var json = ProtectedData.Unprotect(File.ReadAllBytes(FilePath), Entropy, DataProtectionScope.CurrentUser);
            Current = JsonSerializer.Deserialize<LoginResponse>(json);
        }
        catch (Exception ex) when (ex is CryptographicException or JsonException or IOException)
        {
            // File hỏng hoặc của user khác: coi như chưa đăng nhập.
            Clear();
        }
    }

    public void Clear()
    {
        Current = null;
        try { File.Delete(FilePath); } catch (IOException) { }
    }
}
