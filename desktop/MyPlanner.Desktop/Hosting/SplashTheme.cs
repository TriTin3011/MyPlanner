using System.IO;
using System.Text.Json;

namespace MyPlanner.Desktop.Hosting;

// Theme sáng giữ màu chữ và thanh tiến độ trong XAML; theme tối truyền thêm ba màu cuối.
public sealed record SplashPalette(
    string Paper, string Primary, string PrimaryInk, string AccentTint,
    string? Surface = null, string? Ink = null, string? InkMuted = null);

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
        ["night"] = new("#141B1D", "#0E8159", "#8CE6C2", "#1A3329", "#1B2426", "#E6EEEA", "#9FB0A8"),
    };

    private sealed record Stored(string Theme, DateTimeOffset? ExpiresAt);

    public const string DefaultTheme = "forest";

    // Giá trị lạ đều về màu mặc định, nên nơi dùng tên theme để ghép đường dẫn file luôn an toàn.
    public static string Normalize(string? theme) =>
        theme is not null && Palettes.ContainsKey(theme) ? theme : DefaultTheme;

    public static void Save(string? theme, string? expiresAt)
    {
        DateTimeOffset? expiry = DateTimeOffset.TryParse(expiresAt, out var parsed) ? parsed : null;
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(FilePath)!);
            File.WriteAllText(FilePath, JsonSerializer.Serialize(new Stored(Normalize(theme), expiry)));
        }
        catch (Exception ex) when (ex is IOException or UnauthorizedAccessException)
        {
            // Không lưu được chỉ làm splash lần sau về màu xanh, không đáng chặn app.
        }
    }

    // null nghĩa là dùng màu xanh: chưa đăng nhập, phiên đã hết hạn, hoặc file thiếu/hỏng.
    public static SplashPalette? Load() => Palettes.GetValueOrDefault(LoadThemeId());

    // Tên theme dùng lúc mở app; chưa đăng nhập, phiên hết hạn hoặc file hỏng đều là màu mặc định.
    public static string LoadThemeId()
    {
        try
        {
            if (!File.Exists(FilePath)) return DefaultTheme;
            var stored = JsonSerializer.Deserialize<Stored>(File.ReadAllText(FilePath));
            if (stored?.ExpiresAt is not { } expiry || expiry <= DateTimeOffset.UtcNow) return DefaultTheme;
            return Normalize(stored.Theme);
        }
        catch (Exception ex) when (ex is IOException or UnauthorizedAccessException or JsonException)
        {
            return DefaultTheme;
        }
    }
}
