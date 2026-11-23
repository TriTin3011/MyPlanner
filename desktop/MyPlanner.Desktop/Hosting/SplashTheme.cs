using System.IO;
using System.Text.Json;

namespace MyPlanner.Desktop.Hosting;

public sealed record SplashPalette(string Paper, string Primary, string PrimaryInk, string AccentTint);

// Splash vẽ trước khi WebView2 chạy nên không đọc được localStorage.
// React báo theme qua cầu nối, file này giữ lại cho lần mở sau. File chỉ có tên theme và hạn phiên, không có token.
public static class SplashTheme
{
    private static readonly string FilePath = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Mam", "splash-theme.json");

    // Cùng giá trị với frontend/src/styles/tokens.css. Rừng xanh là màu mặc định sẵn trong XAML.
    private static readonly Dictionary<string, SplashPalette> Palettes = new()
    {
        ["ocean"] = new("#F3F6FC", "#1D4ED8", "#1E3A8A", "#DBEAFE"),
        ["sunset"] = new("#FCF5EF", "#C2410C", "#7C2D12", "#FFEDD5"),
        ["lavender"] = new("#F7F5FC", "#6D28D9", "#4C1D95", "#EDE9FE"),
    };

    private sealed record Stored(string Theme, DateTimeOffset? ExpiresAt);

    public static void Save(string? theme, string? expiresAt)
    {
        var known = theme is not null && Palettes.ContainsKey(theme);
        DateTimeOffset? expiry = DateTimeOffset.TryParse(expiresAt, out var parsed) ? parsed : null;
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(FilePath)!);
            File.WriteAllText(FilePath, JsonSerializer.Serialize(new Stored(known ? theme! : "forest", expiry)));
        }
        catch (Exception ex) when (ex is IOException or UnauthorizedAccessException)
        {
            // Không lưu được chỉ làm splash lần sau về màu xanh, không đáng chặn app.
        }
    }

    // null nghĩa là dùng màu xanh: chưa đăng nhập, phiên đã hết hạn, hoặc file thiếu/hỏng.
    public static SplashPalette? Load()
    {
        try
        {
            if (!File.Exists(FilePath)) return null;
            var stored = JsonSerializer.Deserialize<Stored>(File.ReadAllText(FilePath));
            if (stored?.ExpiresAt is not { } expiry || expiry <= DateTimeOffset.UtcNow) return null;
            return Palettes.GetValueOrDefault(stored.Theme);
        }
        catch (Exception ex) when (ex is IOException or UnauthorizedAccessException or JsonException)
        {
            return null;
        }
    }
}
