using System.IO;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Media.Imaging;

namespace MyPlanner.Desktop.Hosting;

// Icon đi theo theme. Icon trong Mam.exe đóng cứng lúc build nên không đổi;
// đổi được là icon cửa sổ, và file app-icon.ico mà shortcut ngoài Desktop trỏ tới.
public static class AppIcon
{
    private const int ShcneAssocChanged = 0x08000000;

    private static readonly string ShortcutIconPath = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Mam", "app-icon.ico");

    private static string? _current;

    // theme có thể đến từ trang web nên luôn đi qua danh sách theme hợp lệ trước khi ghép thành đường dẫn.
    public static void Apply(Window? window, string? theme)
    {
        var id = SplashTheme.Normalize(theme);
        if (id == _current) return;

        var source = Path.Combine(AppContext.BaseDirectory, "Assets", "ThemeIcons", $"{id}.ico");
        if (!File.Exists(source)) return;

        if (window is not null)
            window.Icon = BitmapFrame.Create(new Uri(source), BitmapCreateOptions.None, BitmapCacheOption.OnLoad);
        _current = id;
        UpdateShortcutIcon(source);
    }

    // Khay hệ thống dùng System.Drawing nên cần đối tượng icon riêng; bên gọi chịu trách nhiệm Dispose.
    public static System.Drawing.Icon ForTray()
    {
        var source = Path.Combine(AppContext.BaseDirectory, "Assets", "ThemeIcons", $"{_current ?? SplashTheme.DefaultTheme}.ico");
        return File.Exists(source)
            ? new System.Drawing.Icon(source, System.Windows.Forms.SystemInformation.SmallIconSize)
            : System.Drawing.Icon.ExtractAssociatedIcon(Environment.ProcessPath!)!;
    }

    private static void UpdateShortcutIcon(string source)
    {
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ShortcutIconPath)!);
            if (File.Exists(ShortcutIconPath)
                && File.ReadAllBytes(ShortcutIconPath).AsSpan().SequenceEqual(File.ReadAllBytes(source)))
                return;
            File.Copy(source, ShortcutIconPath, overwrite: true);
            // Explorer giữ icon trong cache, phải báo thì shortcut mới vẽ lại.
            SHChangeNotify(ShcneAssocChanged, 0, IntPtr.Zero, IntPtr.Zero);
        }
        catch (Exception ex) when (ex is IOException or UnauthorizedAccessException)
        {
            // Shortcut giữ icon cũ cũng không ảnh hưởng việc dùng app.
        }
    }

    [DllImport("shell32.dll")]
    private static extern void SHChangeNotify(int eventId, uint flags, IntPtr item1, IntPtr item2);
}
