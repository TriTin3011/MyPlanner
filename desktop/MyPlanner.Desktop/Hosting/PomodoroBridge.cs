using System.Text.Json;
using System.Windows;
using Microsoft.Web.WebView2.Core;
using MyPlanner.Desktop.Views;
using Forms = System.Windows.Forms;

namespace MyPlanner.Desktop.Hosting;

// Phần "của Windows" cho Pomodoro: React vẫn giữ trạng thái, host chỉ hiện thông báo và cửa sổ nổi.
internal sealed class PomodoroBridge
{
    private const int MaxLabel = 60;
    private const int MaxBody = 200;

    private readonly CoreWebView2 _core;
    private Forms.NotifyIcon? _tray;
    private PomodoroFloatWindow? _float;
    private bool _shuttingDown;

    public PomodoroBridge(CoreWebView2 core)
    {
        _core = core;
        // Cửa sổ nổi không có Owner, nên phải tự đóng theo app để tiến trình không chạy mãi.
        Application.Current.MainWindow!.Closed += (_, _) =>
        {
            _shuttingDown = true;
            _float?.Close();
            _tray?.Dispose();
            _tray = null;
        };
    }

    public bool TryHandle(string? type, JsonElement message)
    {
        switch (type)
        {
            case "pomodoro-notify":
                ShowNotice(Text(message, "title", MaxLabel), Text(message, "body", MaxBody));
                return true;
            case "pomodoro-float":
                ApplyFloat(message);
                return true;
            case "pomodoro-float-close":
                _float?.Close();
                return true;
            default:
                return false;
        }
    }

    private void ShowNotice(string title, string body)
    {
        if (title.Length == 0 || body.Length == 0) return;

        _tray ??= CreateTray();
        // Theme có thể đã đổi từ lần báo trước.
        var previousIcon = _tray.Icon;
        _tray.Icon = AppIcon.ForTray();
        previousIcon?.Dispose();
        _tray.Visible = true;
        _tray.ShowBalloonTip(8000, title, body, Forms.ToolTipIcon.None);
    }

    private Forms.NotifyIcon CreateTray()
    {
        var tray = new Forms.NotifyIcon
        {
            Text = "Mầm",
        };
        tray.BalloonTipClicked += (_, _) =>
        {
            ActivateMain();
            tray.Visible = false;
        };
        tray.BalloonTipClosed += (_, _) => tray.Visible = false;
        return tray;
    }

    private void ApplyFloat(JsonElement message)
    {
        if (_shuttingDown) return;

        var endsAt = message.GetProperty("endsAt");
        var state = new PomodoroFloatState(
            endsAt.ValueKind == JsonValueKind.Number ? (long)endsAt.GetDouble() : null,
            Math.Max(0, (long)message.GetProperty("remainingMs").GetDouble()),
            Text(message, "status", MaxLabel),
            Text(message, "toggleLabel", MaxLabel),
            Text(message, "expandLabel", MaxLabel),
            Text(message, "closeLabel", MaxLabel));

        if (_float is null)
        {
            _float = new PomodoroFloatWindow();
            _float.CommandRequested += OnFloatCommand;
            _float.Closed += OnFloatClosed;
            _float.Apply(state);
            _float.Show();
            return;
        }
        _float.Apply(state);
    }

    private void OnFloatCommand(string command)
    {
        _core.PostWebMessageAsJson(JsonSerializer.Serialize(new { type = "pomodoro-command", command }));
        if (command != "expand") return;
        ActivateMain();
        _float?.Close();
    }

    private void OnFloatClosed(object? sender, EventArgs e)
    {
        _float = null;
        if (!_shuttingDown) _core.PostWebMessageAsJson("""{"type":"pomodoro-float-closed"}""");
    }

    private static void ActivateMain()
    {
        if (Application.Current.MainWindow is not { } main) return;
        if (main.WindowState == WindowState.Minimized) main.WindowState = WindowState.Normal;
        main.Activate();
    }

    // Chuỗi đến từ trang web: giới hạn độ dài trước khi đưa lên giao diện Windows.
    private static string Text(JsonElement message, string name, int max)
    {
        var value = message.GetProperty(name).GetString()?.Trim() ?? "";
        return value.Length <= max ? value : value[..max];
    }
}
