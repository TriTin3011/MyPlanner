using System.Collections.ObjectModel;
using System.Globalization;
using System.Net.Http;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using LiveChartsCore;
using LiveChartsCore.SkiaSharpView;
using LiveChartsCore.SkiaSharpView.Painting;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Desktop.Api;
using SkiaSharp;

namespace MyPlanner.Desktop.ViewModels;

// Màn "Kế hoạch tuần" (SPEC §9) bản desktop: header + số liệu + biểu đồ tiến độ 7 ngày + nhận xét.
// WeekKeys lấy thẳng từ MyPlanner.Core: cùng một hàm tính tuần ISO với backend, không viết lại.
public partial class WeekViewModel(PlannerApiClient api) : ObservableObject, IPageViewModel
{
    private static readonly CultureInfo Vi = new("vi-VN");
    private static readonly SKColor Primary = SKColor.Parse("#0B7A55");
    private static readonly SKColor Muted = SKColor.Parse("#C9CDD1");

    public string PageTitle => "Tuần";

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(WeekKey), nameof(RangeLabel))]
    private DateOnly _monday = WeekKeys.MondayOf(DateOnly.FromDateTime(DateTime.Now));

    [ObservableProperty] private string _tasksLabel = "";
    [ObservableProperty] private int _habitPercent;
    [ObservableProperty] private int _todayRemaining;
    [ObservableProperty] private string _comment = "";
    [ObservableProperty] private string? _error;
    [ObservableProperty] private bool _isBusy;

    // Đường hay Cột: chỉ là cách vẽ, đổi thì dựng lại Series từ cùng dữ liệu đã tải.
    [ObservableProperty] private bool _showBars;

    [ObservableProperty] private ISeries[] _series = [];
    [ObservableProperty] private Axis[] _xAxes = [new Axis()];

    public Axis[] YAxes { get; } = [new Axis { MinLimit = 0, MinStep = 1, LabelsPaint = new SolidColorPaint(SKColor.Parse("#6B7A72")) }];

    public ObservableCollection<string> Insights { get; } = [];

    // Bảng số (chế độ "Bảng" của ChartCard ở web): đọc số chính xác, trình đọc màn hình đọc được.
    public ObservableCollection<DayRow> Days { get; } = [];

    public string WeekKey => WeekKeys.ToKey(Monday);
    public string RangeLabel => $"{Monday.ToString("d/M", Vi)} – {Monday.AddDays(6).ToString("d/M/yyyy", Vi)}";

    private IReadOnlyList<DayProgressDto> _lastDays = [];

    public Task ActivateAsync() => LoadCommand.ExecuteAsync(null);

    [RelayCommand]
    private async Task LoadAsync()
    {
        IsBusy = true;
        Error = null;
        try
        {
            var dto = await api.GetWeekAsync(WeekKey, DateOnly.FromDateTime(DateTime.Now));
            TasksLabel = $"{dto.TasksDone}/{dto.TasksTotal}";
            HabitPercent = dto.HabitPercent;
            TodayRemaining = dto.TodayRemaining;
            Comment = dto.Comment;
            Insights.Clear();
            foreach (var s in dto.Insights) Insights.Add(s);
            Days.Clear();
            foreach (var d in dto.Days)
                Days.Add(new DayRow(d.Date.ToString("ddd d/M", Vi), d.TasksDone, d.TasksTotal, d.Percent));
            _lastDays = dto.Days;
            BuildChart();
        }
        catch (HttpRequestException ex) when (ex.StatusCode == System.Net.HttpStatusCode.Unauthorized) { }
        catch (HttpRequestException ex)
        {
            Error = $"Không gọi được API: {ex.Message}";
        }
        finally
        {
            IsBusy = false;
        }
    }

    partial void OnShowBarsChanged(bool value) => BuildChart();

    // Hai chuỗi giống web: "Đã xong" (màu chính) và "Tổng" (xám). Số liệu từ BE, chỉ đổi hình dạng.
    private void BuildChart()
    {
        var done = _lastDays.Select(d => d.TasksDone).ToArray();
        var total = _lastDays.Select(d => d.TasksTotal).ToArray();

        Series = ShowBars
            ? [
                new ColumnSeries<int> { Name = "Tổng", Values = total, Fill = new SolidColorPaint(Muted) },
                new ColumnSeries<int> { Name = "Đã xong", Values = done, Fill = new SolidColorPaint(Primary) },
              ]
            : [
                new LineSeries<int> { Name = "Tổng", Values = total, Fill = null, GeometrySize = 6,
                    Stroke = new SolidColorPaint(Muted, 2), GeometryStroke = new SolidColorPaint(Muted, 2) },
                new LineSeries<int> { Name = "Đã xong", Values = done, GeometrySize = 8,
                    Fill = new SolidColorPaint(Primary.WithAlpha(40)),
                    Stroke = new SolidColorPaint(Primary, 3), GeometryStroke = new SolidColorPaint(Primary, 3) },
              ];

        XAxes = [new Axis
        {
            Labels = _lastDays.Select(d => d.Date.ToString("ddd", Vi)).ToArray(),
            LabelsPaint = new SolidColorPaint(SKColor.Parse("#6B7A72")),
        }];
    }

    [RelayCommand]
    private Task PreviousWeekAsync() { Monday = Monday.AddDays(-7); return LoadAsync(); }

    [RelayCommand]
    private Task NextWeekAsync() { Monday = Monday.AddDays(7); return LoadAsync(); }

    [RelayCommand]
    private Task ThisWeekAsync() { Monday = WeekKeys.MondayOf(DateOnly.FromDateTime(DateTime.Now)); return LoadAsync(); }

    public sealed record DayRow(string Day, int Done, int Total, int Percent);
}
