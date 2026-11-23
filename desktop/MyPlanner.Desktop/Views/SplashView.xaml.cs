using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;
using MyPlanner.Desktop.Hosting;

namespace MyPlanner.Desktop.Views;

// Màn khởi động. Chỉ lo phần hình ảnh; khi nào hiện, khi nào ẩn do MainWindow quyết định.
public partial class SplashView : UserControl
{
    private static readonly TimeSpan BarStepTime = TimeSpan.FromMilliseconds(400);
    // Bước chờ lâu (bật Docker) thì thanh vẫn nhích chậm để người dùng biết app không bị treo.
    private static readonly TimeSpan BarCreepTime = TimeSpan.FromSeconds(25);

    private readonly Storyboard _loop;
    private bool _running;

    public SplashView()
    {
        InitializeComponent();
        _loop = (Storyboard)Resources["LoopStoryboard"];
        Loaded += (_, _) => SetAnimating(true);
        Unloaded += (_, _) => SetAnimating(false);
    }

    // Đổi màu logo, thanh tiến độ và nền giấy theo theme, cùng cách phối màu với BrandMark bên web.
    public void ApplyPalette(SplashPalette palette)
    {
        var primary = ToBrush(palette.Primary);
        var primaryInk = ToBrush(palette.PrimaryInk);
        LogoDisc.Fill = ToBrush(palette.AccentTint);
        LogoRing.Stroke = primary;
        LogoLeaf.Fill = primary;
        LogoLeaf.Stroke = primaryInk;
        Dot1.Fill = primaryInk;
        Dot2.Fill = primaryInk;
        Dot3.Fill = primary;
        BarFill.Background = primary;

        var paper = ((DrawingBrush)FindResource("PaperBrush")).Clone();
        ((GeometryDrawing)((DrawingGroup)paper.Drawing).Children[0]).Brush = ToBrush(palette.Paper);
        Background = paper;
    }

    private static SolidColorBrush ToBrush(string hex) => new((Color)ColorConverter.ConvertFromString(hex));

    // Windows tắt hiệu ứng thì logo đứng yên, tương tự prefers-reduced-motion trên web.
    private static bool MotionAllowed => SystemParameters.ClientAreaAnimation;

    // percent là mốc thật của bước hiện tại. Phần nhích thêm chỉ đi 1/4 quãng còn lại nên không vượt mốc kế tiếp.
    public void SetProgress(double percent)
    {
        var target = Math.Clamp(percent / 100, 0, 1);
        if (!MotionAllowed)
        {
            BarScale.BeginAnimation(ScaleTransform.ScaleXProperty, null);
            BarScale.ScaleX = target;
            return;
        }

        var animation = new DoubleAnimationUsingKeyFrames();
        animation.KeyFrames.Add(new EasingDoubleKeyFrame(target, KeyTime.FromTimeSpan(BarStepTime),
            new CubicEase { EasingMode = EasingMode.EaseOut }));
        animation.KeyFrames.Add(new LinearDoubleKeyFrame(target + (1 - target) * 0.25,
            KeyTime.FromTimeSpan(BarStepTime + BarCreepTime)));
        BarScale.BeginAnimation(ScaleTransform.ScaleXProperty, animation);
    }

    // Lỗi khởi động: dừng chuyển động và ẩn thanh để không có cảm giác app vẫn đang chạy tiếp.
    public void SetFailed(bool failed)
    {
        var state = failed ? Visibility.Collapsed : Visibility.Visible;
        Status.Visibility = state;
        Bar.Visibility = state;
        SetAnimating(!failed);
    }

    // Cho thanh chạy tới 100% rồi mới mờ dần.
    public async Task FadeOutAsync()
    {
        SetProgress(100);
        if (MotionAllowed)
        {
            await Task.Delay(BarStepTime);
            var done = new TaskCompletionSource();
            var fade = new DoubleAnimation(0, TimeSpan.FromMilliseconds(220));
            fade.Completed += (_, _) => done.TrySetResult();
            BeginAnimation(OpacityProperty, fade);
            await done.Task;
        }

        SetAnimating(false);
        Visibility = Visibility.Collapsed;
        BeginAnimation(OpacityProperty, null);
    }

    private void SetAnimating(bool on)
    {
        if (on == _running || (on && !MotionAllowed)) return;
        _running = on;
        if (on) _loop.Begin(this, isControllable: true);
        else _loop.Stop(this); // Về trạng thái gốc, không tốn CPU sau khi ẩn.
    }
}
