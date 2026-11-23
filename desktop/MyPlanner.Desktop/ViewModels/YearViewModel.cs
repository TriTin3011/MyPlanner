using System.Collections.ObjectModel;
using System.Globalization;
using System.Net.Http;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using LiveChartsCore;
using LiveChartsCore.SkiaSharpView;
using LiveChartsCore.SkiaSharpView.Painting;
using MyPlanner.Core.Dtos;
using MyPlanner.Desktop.Api;
using SkiaSharp;

namespace MyPlanner.Desktop.ViewModels;

// Màn "Kế hoạch năm" (SPEC §10) bản desktop:
// - Header năm + điều hướng ‹ Năm nay › + tổng tiến độ cả năm.
// - Từ khoá của năm & Tầm nhìn năm nay (PUT /api/years/{year}) + Biểu đồ Tiến độ 12 tháng (LiveCharts2).
// - 12 thẻ tháng thu gọn/mở rộng (mở sẵn tháng hiện tại, có nhãn "Nay"), dòng hạn ⚑, tick và thêm kế hoạch.
public partial class YearViewModel(PlannerApiClient api) : ObservableObject, IPageViewModel
{
    private static readonly CultureInfo Vi = new("vi-VN");
    private static readonly SKColor Primary = SKColor.Parse("#0B7A55");
    private static readonly SKColor Muted = SKColor.Parse("#C9CDD1");

    public string PageTitle => "Năm";

    [ObservableProperty] private int _year = DateTime.Now.Year;
    [ObservableProperty] private int _percent;
    [ObservableProperty] private string _summaryLabel = "0/0 kế hoạch đã xong";
    [ObservableProperty] private string _keyword = "";
    [ObservableProperty] private string _vision = "";
    [ObservableProperty] private string _metaStatus = "";
    [ObservableProperty] private string? _error;
    [ObservableProperty] private bool _isBusy;
    [ObservableProperty] private bool _showBars;
    [ObservableProperty] private ISeries[] _series = [];
    [ObservableProperty] private Axis[] _xAxes = [new Axis()];

    public Axis[] YAxes { get; } = [new Axis { MinLimit = 0, MinStep = 1, LabelsPaint = new SolidColorPaint(SKColor.Parse("#6B7A72")) }];

    public ObservableCollection<YearMonthCardViewModel> Months { get; } = [];

    private IReadOnlyList<YearMonthDto> _lastMonths = [];
    private int? _currentMonth;

    public Task ActivateAsync() => LoadCommand.ExecuteAsync(null);

    [RelayCommand]
    private async Task LoadAsync()
    {
        IsBusy = true;
        Error = null;
        // Giữ trạng thái mở/đóng các tháng nếu đang tải lại cùng năm; đổi năm thì chỉ mở tháng hiện tại.
        var previouslyOpen = Months.Where(m => m.IsOpen).Select(m => m.Month).ToHashSet();
        try
        {
            var today = DateOnly.FromDateTime(DateTime.Now);
            var dto = await api.GetYearBoardAsync(Year, today);
            Percent = dto.Percent;
            SummaryLabel = $"{dto.Done}/{dto.Total} kế hoạch đã xong";
            Keyword = dto.Keyword;
            Vision = dto.Vision;
            _currentMonth = dto.CurrentMonth;
            _lastMonths = dto.Months;

            Months.Clear();
            foreach (var m in dto.Months.OrderBy(x => x.Month))
            {
                var isCurrent = dto.CurrentMonth == m.Month;
                var isOpen = previouslyOpen.Count > 0 ? previouslyOpen.Contains(m.Month) : isCurrent;
                Months.Add(new YearMonthCardViewModel(m, isCurrent, isOpen, ToggleItemAsync, AddItemAsync, Vi));
            }

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

    private void BuildChart()
    {
        var done = _lastMonths.Select(m => m.Done).ToArray();
        var total = _lastMonths.Select(m => m.Total).ToArray();

        Series = ShowBars
            ? [
                new ColumnSeries<int> { Name = "Tổng kế hoạch", Values = total, Fill = new SolidColorPaint(Muted) },
                new ColumnSeries<int> { Name = "Đã xong", Values = done, Fill = new SolidColorPaint(Primary) },
              ]
            : [
                new LineSeries<int> { Name = "Tổng kế hoạch", Values = total, Fill = null, GeometrySize = 5,
                    Stroke = new SolidColorPaint(Muted, 2), GeometryStroke = new SolidColorPaint(Muted, 2) },
                new LineSeries<int> { Name = "Đã xong", Values = done, GeometrySize = 7,
                    Fill = new SolidColorPaint(Primary.WithAlpha(40)),
                    Stroke = new SolidColorPaint(Primary, 3), GeometryStroke = new SolidColorPaint(Primary, 3) },
              ];

        XAxes = [new Axis
        {
            Labels = _lastMonths.Select(m => m.Month == _currentMonth ? $"•T{m.Month}" : $"T{m.Month}").ToArray(),
            LabelsPaint = new SolidColorPaint(SKColor.Parse("#6B7A72")),
        }];
    }

    [RelayCommand]
    private async Task SaveMetaAsync()
    {
        MetaStatus = "Đang lưu…";
        Error = null;
        try
        {
            await api.SaveYearMetaAsync(Year, new SaveYearMetaRequest(Keyword.Trim(), Vision.Trim()));
            MetaStatus = "Đã lưu ✓";
        }
        catch (HttpRequestException ex)
        {
            MetaStatus = "";
            Error = $"Không lưu được từ khoá & tầm nhìn: {ex.Message}";
        }
    }

    private async Task ToggleItemAsync(YearPlanItemRowViewModel item, bool done)
    {
        try
        {
            await api.UpdateYearItemAsync(item.Id, new UpdateYearItemRequest(item.Month, item.Title, done));
            await LoadAsync();
        }
        catch (HttpRequestException ex)
        {
            item.Revert(!done);
            Error = $"Không lưu được kế hoạch: {ex.Message}";
        }
    }

    private async Task AddItemAsync(YearMonthCardViewModel card, string title)
    {
        try
        {
            await api.AddYearItemAsync(Year, new CreateYearItemRequest(card.Month, title));
            card.NewItemTitle = "";
            await LoadAsync();
        }
        catch (HttpRequestException ex)
        {
            Error = $"Không thêm được kế hoạch: {ex.Message}";
        }
    }

    [RelayCommand]
    private Task PreviousYearAsync() { Months.Clear(); Year--; MetaStatus = ""; return LoadAsync(); }

    [RelayCommand]
    private Task NextYearAsync() { Months.Clear(); Year++; MetaStatus = ""; return LoadAsync(); }

    [RelayCommand]
    private Task ThisYearAsync() { Months.Clear(); Year = DateTime.Now.Year; MetaStatus = ""; return LoadAsync(); }
}

public partial class YearMonthCardViewModel : ObservableObject
{
    private readonly Func<YearMonthCardViewModel, string, Task> _onAdd;

    public int Month { get; }
    public string MonthTitle { get; }
    public bool IsCurrent { get; }
    public int Percent { get; }
    public string ProgressLabel { get; }
    public string DeadlineBadge { get; }
    public bool HasDeadlines { get; }
    public IReadOnlyList<string> Deadlines { get; }
    public ObservableCollection<YearPlanItemRowViewModel> Items { get; } = [];

    [ObservableProperty] private bool _isOpen;
    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(AddItemCommand))]
    private string _newItemTitle = "";

    public YearMonthCardViewModel(
        YearMonthDto dto,
        bool isCurrent,
        bool isOpen,
        Func<YearPlanItemRowViewModel, bool, Task> onToggle,
        Func<YearMonthCardViewModel, string, Task> onAdd,
        CultureInfo culture)
    {
        _onAdd = onAdd;
        Month = dto.Month;
        MonthTitle = $"Tháng {dto.Month}";
        IsCurrent = isCurrent;
        _isOpen = isOpen;
        Percent = dto.Percent;
        ProgressLabel = $"{dto.Done}/{dto.Total}";
        HasDeadlines = dto.Deadlines.Count > 0;
        DeadlineBadge = HasDeadlines ? $"⚑ {dto.Deadlines.Count}" : "";

        Deadlines = dto.Deadlines.Select(d =>
        {
            var kind = d.Kind == DeadlineKind.Step ? "Hạn bước" : "Hạn mục tiêu";
            var goalPart = d.Kind == DeadlineKind.Step ? $" · {d.GoalTitle}" : "";
            var overduePart = d.Overdue ? " · quá hạn" : "";
            return $"⚑ {d.Date.ToString("dd/MM", culture)} · {kind}: {d.Title}{goalPart}{overduePart}";
        }).ToList();

        foreach (var it in dto.Items.OrderBy(i => i.Order))
            Items.Add(new YearPlanItemRowViewModel(it, onToggle));
    }

    private bool CanAddItem() => !string.IsNullOrWhiteSpace(NewItemTitle);

    [RelayCommand(CanExecute = nameof(CanAddItem))]
    private Task AddItemAsync() => _onAdd(this, NewItemTitle.Trim());
}

public partial class YearPlanItemRowViewModel(
    YearPlanItemDto dto,
    Func<YearPlanItemRowViewModel, bool, Task> onToggle) : ObservableObject
{
    public Guid Id { get; } = dto.Id;
    public int Month { get; } = dto.Month;
    public string Title { get; } = dto.Title;

    [ObservableProperty] private bool _done = dto.Done;

    partial void OnDoneChanged(bool value) => _ = onToggle(this, value);

#pragma warning disable MVVMTK0034 // Ghi thẳng field để hoàn tác khi API lỗi mà không gọi lại OnDoneChanged.
    public void Revert(bool value)
    {
        _done = value;
        OnPropertyChanged(nameof(Done));
    }
#pragma warning restore MVVMTK0034
}
