using System.Globalization;
using System.Net.Http;
using System.Windows;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using LiveChartsCore;
using LiveChartsCore.Measure;
using LiveChartsCore.SkiaSharpView;
using LiveChartsCore.SkiaSharpView.Painting;
using MyPlanner.Core.Dtos;
using MyPlanner.Desktop.Api;
using SkiaSharp;

namespace MyPlanner.Desktop.ViewModels;

public sealed record StatsRangeOption(string Value, string Label);

// Màn "Thống kê" (SPEC §11) bản desktop. Một lần gọi GET /api/stats cấp số cho mọi thẻ.
// ViewModel chỉ đổi DTO sang dạng dễ hiển thị (nhãn, ô lưới, độ dài thanh), không tính lại %, chuỗi hay trung bình.
public partial class StatsViewModel(PlannerApiClient api) : ObservableObject, IPageViewModel
{
    private static readonly CultureInfo Vi = new("vi-VN");
    private static readonly SKColor PrimaryColor = SKColor.Parse("#0B7A55");
    private static readonly SKColor InkColor = SKColor.Parse("#1C2B24");
    private static readonly SKColor LabelColor = SKColor.Parse("#6B7A72");

    // Đánh số mỗi lần tải: đổi khoảng nhanh thì response cũ về sau cũng bị bỏ qua (chống race condition).
    private int _loadVersion;
    private StatsDto? _data;

    public string PageTitle => "Thống kê";

    public IReadOnlyList<StatsRangeOption> Ranges { get; } =
    [
        new("4w", "4 tuần"),
        new("8w", "8 tuần"),
        new("12w", "12 tuần"),
        new("6m", "6 tháng"),
        new("1y", "1 năm"),
    ];

    [ObservableProperty] private StatsRangeOption? _selectedRange;
    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private string? _error;
    [ObservableProperty] private bool _hasData;

    [ObservableProperty] private string _periodLabel = "";
    [ObservableProperty] private string _heroTitle = "";
    [ObservableProperty] private int _completionPercent;
    [ObservableProperty] private StatsDelta _heroDelta = StatsDelta.None;
    [ObservableProperty] private string _heroCompare = "";
    [ObservableProperty] private string _heroSummary = "";
    [ObservableProperty] private ISeries[] _sparkSeries = [];

    [ObservableProperty] private int _tasksDone;
    [ObservableProperty] private StatsDelta _tasksDelta = StatsDelta.None;
    [ObservableProperty] private string _streakLabel = "";
    [ObservableProperty] private string _longestStreakLabel = "";
    [ObservableProperty] private int _habitPercent;
    [ObservableProperty] private StatsDelta _habitDelta = StatsDelta.None;

    [ObservableProperty] private string _trendAverage = "";
    [ObservableProperty] private bool _showBars;
    [ObservableProperty] private ISeries[] _trendSeries = [];
    [ObservableProperty] private Axis[] _trendXAxes = [new Axis()];

    [ObservableProperty] private IReadOnlyList<HeatmapColumn> _heatmapColumns = [];
    [ObservableProperty] private IReadOnlyList<WeekdayBar> _weekdays = [];
    [ObservableProperty] private IReadOnlyList<HabitConsistencyRow> _habits = [];
    [ObservableProperty] private bool _hasHabits;

    [ObservableProperty] private string _goalsSubtitle = "";
    [ObservableProperty] private bool _hasGoals;
    [ObservableProperty] private GridLength _notStartedWidth = new(0, GridUnitType.Star);
    [ObservableProperty] private GridLength _inProgressWidth = new(0, GridUnitType.Star);
    [ObservableProperty] private GridLength _doneWidth = new(0, GridUnitType.Star);
    [ObservableProperty] private string _notStartedLabel = "";
    [ObservableProperty] private string _inProgressLabel = "";
    [ObservableProperty] private string _doneLabel = "";
    [ObservableProperty] private IReadOnlyList<GoalAreaRow> _goalAreas = [];

    // Mỗi thẻ có toggle "Bảng" (SPEC §11): cùng dữ liệu, dạng đọc được bằng trình đọc màn hình.
    [ObservableProperty] private bool _showTrendTable;
    [ObservableProperty] private bool _showHeatmapTable;
    [ObservableProperty] private bool _showWeekdayTable;
    [ObservableProperty] private bool _showHabitTable;
    [ObservableProperty] private bool _showGoalTable;
    [ObservableProperty] private StatsTable _trendTable = StatsTable.Empty;
    [ObservableProperty] private StatsTable _heatmapTable = StatsTable.Empty;
    [ObservableProperty] private StatsTable _weekdayTable = StatsTable.Empty;
    [ObservableProperty] private StatsTable _habitTable = StatsTable.Empty;
    [ObservableProperty] private StatsTable _goalTable = StatsTable.Empty;

    public Axis[] HiddenXAxes { get; } = [new Axis { IsVisible = false }];
    public Axis[] SparkYAxes { get; } = [new Axis { IsVisible = false, MinLimit = 0, MaxLimit = 100 }];
    public Axis[] TrendYAxes { get; } =
    [
        new Axis
        {
            MinLimit = 0,
            MaxLimit = 110,
            MinStep = 50,
            Labeler = v => v > 100 ? "" : $"{v:0}%",
            LabelsPaint = new SolidColorPaint(LabelColor),
        },
    ];

    public Task ActivateAsync()
    {
        // Gán field để không kích hoạt OnSelectedRangeChanged, tránh gọi API hai lần lúc mở trang.
#pragma warning disable MVVMTK0034
        _selectedRange ??= Ranges[1];
#pragma warning restore MVVMTK0034
        OnPropertyChanged(nameof(SelectedRange));
        return LoadAsync();
    }

    partial void OnSelectedRangeChanged(StatsRangeOption? value)
    {
        if (value is not null) _ = LoadAsync();
    }

    partial void OnShowBarsChanged(bool value) => BuildTrendChart();

    [RelayCommand]
    private async Task LoadAsync()
    {
        var range = SelectedRange ?? Ranges[1];
        var version = ++_loadVersion;
        IsBusy = true;
        Error = null;
        try
        {
            // "Hôm nay" theo giờ máy người dùng, không theo đồng hồ server.
            var today = DateOnly.FromDateTime(DateTime.Now);
            var dto = await api.GetStatsAsync(range.Value, today);
            if (version != _loadVersion) return;
            Apply(dto, range, today);
        }
        catch (HttpRequestException ex) when (ex.StatusCode == System.Net.HttpStatusCode.Unauthorized) { }
        catch (Exception ex) when (ex is HttpRequestException or TaskCanceledException or InvalidOperationException)
        {
            if (version == _loadVersion) Error = $"Không tải được thống kê: {ex.Message}";
        }
        finally
        {
            if (version == _loadVersion) IsBusy = false;
        }
    }

    private void Apply(StatsDto dto, StatsRangeOption range, DateOnly today)
    {
        _data = dto;
        // Khoảng vắt qua năm (vd "1 năm") phải ghi cả năm, nếu không sẽ thành "24/11 – 23/11" gây hiểu nhầm.
        var format = dto.PreviousFrom.Year != dto.To.Year ? "dd/MM/yyyy" : "dd/MM";
        string F(DateOnly d) => d.ToString(format, CultureInfo.InvariantCulture);
        PeriodLabel = $"{F(dto.From)} – {F(dto.To)} · so với {F(dto.PreviousFrom)} – {F(dto.PreviousTo)}";

        var hero = dto.Hero;
        HeroTitle = $"TỈ LỆ HOÀN THÀNH VIỆC · {range.Label.ToUpper(Vi)} QUA";
        CompletionPercent = hero.CompletionPercent;
        HeroDelta = StatsDelta.From(hero.DeltaPoints, " điểm");
        HeroCompare = $"so với {range.Label} trước";
        HeroSummary = $"{hero.TasksDone}/{hero.TasksTotal} việc"
            + (hero.BestWeekday is int best ? $" · hiệu quả nhất {WeekdayLabel(best)}" : "");
        SparkSeries =
        [
            new LineSeries<int>
            {
                Values = hero.WeeklySparkline.Select(p => p.Percent).ToArray(),
                GeometrySize = 0,
                Fill = new SolidColorPaint(PrimaryColor.WithAlpha(35)),
                Stroke = new SolidColorPaint(PrimaryColor, 2),
                IsHoverable = false,
            },
        ];

        var kpis = dto.Kpis;
        TasksDone = kpis.TasksDone;
        TasksDelta = StatsDelta.From(kpis.TasksDonePercentChange, "%");
        StreakLabel = $"{kpis.ActivityCurrentStreak} ngày";
        LongestStreakLabel = $"Dài nhất {kpis.ActivityLongestStreak} ngày";
        HabitPercent = kpis.HabitPercent;
        HabitDelta = StatsDelta.From(kpis.HabitDeltaPoints, " điểm");

        TrendAverage = $"TB {dto.Trend.AveragePercent}%";
        BuildTrendChart();
        TrendTable = new StatsTable(
            ["Tuần", "Xong", "Tổng", "%"],
            dto.Trend.Points.Select(p => (IReadOnlyList<string>)[Dm(p.Monday), $"{p.Done}", $"{p.Total}", $"{p.Percent}%"]).ToList());

        HeatmapColumns = BuildHeatmap(dto.Heatmap, today);
        HeatmapTable = new StatsTable(
            ["Ngày", "Việc xong"],
            dto.Heatmap.Where(d => d.Done > 0)
                .Select(d => (IReadOnlyList<string>)[$"{WeekdayShort(d.Date)} {Dm(d.Date)}", $"{d.Done}"]).ToList());

        var maxAverage = dto.WeekdayProductivity.Select(w => w.AverageDone).DefaultIfEmpty(0).Max();
        Weekdays = dto.WeekdayProductivity.Select(w => new WeekdayBar(
            WeekdayLabel(w.Weekday),
            maxAverage > 0 ? w.AverageDone / maxAverage * 100 : 0,
            w.AverageDone.ToString("0.0", Vi),
            maxAverage > 0 && w.AverageDone == maxAverage)).ToList();
        WeekdayTable = new StatsTable(
            ["Thứ", "TB việc xong"],
            Weekdays.Select(w => (IReadOnlyList<string>)[w.Label, w.Value]).ToList());

        Habits = dto.HabitConsistency.OrderByDescending(h => h.Percent).Select(h => new HabitConsistencyRow(
            h.Title,
            h.Percent,
            $"{h.DoneDays}/{h.PossibleDays} ngày · chuỗi hiện tại {h.CurrentStreak} · dài nhất {h.LongestStreak}")).ToList();
        HasHabits = Habits.Count > 0;
        HabitTable = new StatsTable(
            ["Thói quen", "%", "Ngày", "Chuỗi", "Dài nhất"],
            dto.HabitConsistency.OrderByDescending(h => h.Percent)
                .Select(h => (IReadOnlyList<string>)[h.Title, $"{h.Percent}%", $"{h.DoneDays}/{h.PossibleDays}", $"{h.CurrentStreak}", $"{h.LongestStreak}"]).ToList());

        ApplyGoals(dto.Goals);
        HasData = true;
    }

    private void ApplyGoals(StatsGoalsDto goals)
    {
        HasGoals = goals.Total > 0;
        GoalsSubtitle = $"{goals.Total} mục tiêu · {goals.PercentDone}% đã hoàn thành";
        NotStartedWidth = new GridLength(goals.ByStatus.NotStarted, GridUnitType.Star);
        InProgressWidth = new GridLength(goals.ByStatus.InProgress, GridUnitType.Star);
        DoneWidth = new GridLength(goals.ByStatus.Done, GridUnitType.Star);
        NotStartedLabel = $"Chưa bắt đầu {goals.ByStatus.NotStarted}";
        InProgressLabel = $"Đang thực hiện {goals.ByStatus.InProgress}";
        DoneLabel = $"Đã hoàn thành {goals.ByStatus.Done}";
        GoalAreas = goals.ByArea.Select(a => new GoalAreaRow(
            GoalsViewModel.AreaFullLabel(a.Area),
            a.Total > 0 ? (double)a.Done / a.Total * 100 : 0,
            $"{a.Done}/{a.Total} xong")).ToList();
        GoalTable = new StatsTable(
            ["Lĩnh vực", "Xong", "Tổng"],
            goals.ByArea.Select(a => (IReadOnlyList<string>)[GoalsViewModel.AreaFullLabel(a.Area), $"{a.Done}", $"{a.Total}"]).ToList());
    }

    private void BuildTrendChart()
    {
        if (_data is null) return;
        var points = _data.Trend.Points;
        var percents = points.Select(p => p.Percent).ToArray();

        // Chuỗi phụ chỉ có giá trị ở điểm cao nhất và điểm cuối, dùng để ghi nhãn đúng hai điểm đó (SPEC §11.3).
        var highlightIndex = percents.Length > 0 ? Array.IndexOf(percents, percents.Max()) : -1;
        var highlights = percents
            .Select((v, i) => i == highlightIndex || i == percents.Length - 1 ? (int?)v : null)
            .ToArray();

        ISeries main = ShowBars
            ? new ColumnSeries<int> { Name = "Hoàn thành", Values = percents, Fill = new SolidColorPaint(PrimaryColor), MaxBarWidth = 36 }
            : new LineSeries<int>
            {
                Name = "Hoàn thành",
                Values = percents,
                GeometrySize = 0,
                Fill = new SolidColorPaint(PrimaryColor.WithAlpha(35)),
                Stroke = new SolidColorPaint(PrimaryColor, 3),
            };

        TrendSeries =
        [
            main,
            new LineSeries<int?>
            {
                Values = highlights,
                Fill = null,
                Stroke = null,
                GeometrySize = ShowBars ? 0 : 8,
                GeometryFill = new SolidColorPaint(PrimaryColor),
                GeometryStroke = new SolidColorPaint(PrimaryColor, 1),
                DataLabelsPaint = new SolidColorPaint(InkColor),
                DataLabelsSize = 12,
                DataLabelsPosition = DataLabelsPosition.Top,
                DataLabelsFormatter = p => $"{p.Coordinate.PrimaryValue:0}%",
                IsHoverable = false,
            },
        ];

        TrendXAxes =
        [
            new Axis
            {
                Labels = points.Select(p => Dm(p.Monday)).ToArray(),
                LabelsPaint = new SolidColorPaint(LabelColor),
            },
        ];
    }

    // Xếp ngày vào lưới: mỗi cột là một tuần (bắt đầu Thứ 2), mỗi hàng là một thứ.
    private static List<HeatmapColumn> BuildHeatmap(IReadOnlyList<StatsHeatmapDayDto> days, DateOnly today)
    {
        if (days.Count == 0) return [];
        var ordered = days.OrderBy(d => d.Date).ToList();
        var origin = ordered[0].Date.AddDays(-RowOf(ordered[0].Date));
        var columnCount = (ordered[^1].Date.DayNumber - origin.DayNumber) / 7 + 1;
        var cells = new HeatmapCell[columnCount, 7];
        var labels = new string[columnCount];

        for (var i = 0; i < ordered.Count; i++)
        {
            var day = ordered[i];
            var col = (day.Date.DayNumber - origin.DayNumber) / 7;
            cells[col, RowOf(day.Date)] = new HeatmapCell(
                Math.Clamp(day.Level, 0, 4), day.Date == today, $"{Dm(day.Date)}: {day.Done} việc");
            if (i == 0 || day.Date.Day == 1) labels[col] = $"Th{day.Date.Month}";
        }

        return Enumerable.Range(0, columnCount)
            .Select(col => new HeatmapColumn(
                labels[col] ?? "",
                Enumerable.Range(0, 7).Select(row => cells[col, row] ?? HeatmapCell.Blank).ToList()))
            .ToList();
    }

    private static int RowOf(DateOnly date) => ((int)date.DayOfWeek + 6) % 7;
    private static string Dm(DateOnly date) => date.ToString("dd/MM", CultureInfo.InvariantCulture);
    private static string WeekdayLabel(int weekday) => weekday == 7 ? "Chủ nhật" : $"Thứ {weekday + 1}";
    private static string WeekdayShort(DateOnly date) => RowOf(date) == 6 ? "CN" : $"T{RowOf(date) + 2}";
}

// Mức thay đổi so với kỳ trước: IsDown để View đổi màu xanh/đỏ, null hiển thị "–".
public sealed record StatsDelta(string Text, bool IsDown)
{
    public static readonly StatsDelta None = new("–", false);

    public static StatsDelta From(int? value, string unit) => value switch
    {
        null => None,
        >= 0 => new StatsDelta($"▲ +{value}{unit}", false),
        _ => new StatsDelta($"▼ {value}{unit}", true),
    };
}

public sealed record HeatmapCell(int Level, bool IsToday, string? Tooltip)
{
    // Ô đệm đầu/cuối lưới, không thuộc khoảng đang xem.
    public static readonly HeatmapCell Blank = new(-1, false, null);
}

public sealed record HeatmapColumn(string MonthLabel, IReadOnlyList<HeatmapCell> Cells);
public sealed record WeekdayBar(string Label, double BarPercent, string Value, bool IsTop);
public sealed record HabitConsistencyRow(string Title, int Percent, string Detail);
public sealed record GoalAreaRow(string Label, double Percent, string Progress);

public sealed record StatsTable(IReadOnlyList<string> Headers, IReadOnlyList<IReadOnlyList<string>> Rows)
{
    public static readonly StatsTable Empty = new([], []);
}
