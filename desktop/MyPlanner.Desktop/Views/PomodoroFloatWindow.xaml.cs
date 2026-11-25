using System.Windows;
using System.Windows.Automation;
using System.Windows.Input;
using System.Windows.Threading;

namespace MyPlanner.Desktop.Views;

public sealed record PomodoroFloatState(
    long? EndsAt, long RemainingMs, string Status, string ToggleLabel, string ExpandLabel, string CloseLabel);

// Cửa sổ nhỏ luôn nổi trên mọi app. Không đặt Owner, vì cửa sổ có Owner sẽ bị ẩn theo khi thu nhỏ app chính.
public partial class PomodoroFloatWindow : Window
{
    private const string PlayGlyph = "";
    private const string PauseGlyph = "";

    private readonly DispatcherTimer _ticker = new() { Interval = TimeSpan.FromMilliseconds(250) };
    private long? _endsAt;
    private long _remainingMs;

    public event Action<string>? CommandRequested;

    public PomodoroFloatWindow()
    {
        InitializeComponent();
        _ticker.Tick += (_, _) => RenderClock();
        Closed += (_, _) => _ticker.Stop();
        Loaded += (_, _) =>
        {
            var area = SystemParameters.WorkArea;
            Left = area.Right - ActualWidth - 16;
            Top = area.Bottom - ActualHeight - 16;
        };
    }

    public void Apply(PomodoroFloatState state)
    {
        _endsAt = state.EndsAt;
        _remainingMs = state.RemainingMs;
        Status.Text = state.Status;
        ToggleButton.Content = state.EndsAt is null ? PlayGlyph : PauseGlyph;
        SetLabel(ToggleButton, state.ToggleLabel);
        SetLabel(ExpandButton, state.ExpandLabel);
        SetLabel(CloseButton, state.CloseLabel);

        if (state.EndsAt is null) _ticker.Stop();
        else _ticker.Start();
        RenderClock();
    }

    private static void SetLabel(FrameworkElement element, string label)
    {
        element.ToolTip = label;
        AutomationProperties.SetName(element, label);
    }

    // Tính từ mốc endsAt như web, nên nhịp bị trễ cũng không làm sai giờ.
    private void RenderClock()
    {
        var remaining = _endsAt is { } endsAt
            ? Math.Max(0, endsAt - DateTimeOffset.UtcNow.ToUnixTimeMilliseconds())
            : _remainingMs;
        var seconds = (long)Math.Ceiling(remaining / 1000d);
        Clock.Text = $"{seconds / 60:00}:{seconds % 60:00}";
    }

    private void OnDrag(object sender, MouseButtonEventArgs e) => DragMove();
    private void OnToggle(object sender, RoutedEventArgs e) => CommandRequested?.Invoke("toggle");
    private void OnExpand(object sender, RoutedEventArgs e) => CommandRequested?.Invoke("expand");
    private void OnClose(object sender, RoutedEventArgs e) => Close();
}
