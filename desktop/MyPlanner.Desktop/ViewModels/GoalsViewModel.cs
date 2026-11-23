using System.Collections.ObjectModel;
using System.Globalization;
using System.Net.Http;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.Desktop.Api;

namespace MyPlanner.Desktop.ViewModels;

// Màn "Mục tiêu & tầm nhìn" (SPEC §7) bản desktop:
// - Tổng quan (% hoàn thành, x/y mục tiêu) + 8 chip lọc theo lĩnh vực.
// - Cân bằng 8 lĩnh vực (tiến độ trung bình từng lĩnh vực do BE tính).
// - Danh sách thẻ mục tiêu (checkbox hoàn thành lạc quan, hạn còn/quá hạn, hai thanh Tiến độ & Thời gian, cảnh báo Behind).
public partial class GoalsViewModel(PlannerApiClient api) : ObservableObject, IPageViewModel
{
    private static readonly CultureInfo Vi = new("vi-VN");

    public string PageTitle => "Mục tiêu";

    [ObservableProperty] private int _percent;
    [ObservableProperty] private string _summaryLabel = "0/0 mục tiêu";
    [ObservableProperty] private LifeArea? _selectedArea;
    [ObservableProperty] private string? _error;
    [ObservableProperty] private bool _isBusy;

    public ObservableCollection<AreaChipViewModel> AreaChips { get; } = [];
    public ObservableCollection<GoalCardRowViewModel> Goals { get; } = [];

    private IReadOnlyList<GoalCardDto> _allGoals = [];

    public Task ActivateAsync() => LoadCommand.ExecuteAsync(null);

    [RelayCommand]
    private async Task LoadAsync()
    {
        IsBusy = true;
        Error = null;
        try
        {
            var today = DateOnly.FromDateTime(DateTime.Now);
            var dto = await api.GetGoalBoardAsync(today);
            Percent = dto.Percent;
            SummaryLabel = $"{dto.Done}/{dto.Total} mục tiêu";
            _allGoals = dto.Goals;

            AreaChips.Clear();
            foreach (var a in dto.Areas)
            {
                AreaChips.Add(new AreaChipViewModel(
                    a.Area,
                    AreaChipLabel(a.Area),
                    AreaFullLabel(a.Area),
                    a.Count,
                    a.Percent,
                    SelectedArea == a.Area,
                    ToggleAreaFilter));
            }

            ApplyFilter();
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

    // Bấm một chip để lọc theo lĩnh vực đó; bấm lại chính chip đang chọn để bỏ lọc (SPEC §7.2).
    private void ToggleAreaFilter(LifeArea area)
    {
        SelectedArea = SelectedArea == area ? null : area;
        foreach (var chip in AreaChips)
            chip.IsSelected = SelectedArea == chip.Area;
        ApplyFilter();
    }

    private void ApplyFilter()
    {
        Goals.Clear();
        var filtered = SelectedArea is { } area
            ? _allGoals.Where(g => g.Area == area)
            : _allGoals;

        foreach (var g in filtered)
            Goals.Add(new GoalCardRowViewModel(g, ToggleGoalDoneAsync, Vi));
    }

    private async Task ToggleGoalDoneAsync(GoalCardRowViewModel row, bool done)
    {
        try
        {
            await api.SetGoalDoneAsync(row.Id, done);
            await LoadAsync();
        }
        catch (HttpRequestException ex)
        {
            row.Revert(!done);
            Error = $"Không lưu được mục tiêu: {ex.Message}";
        }
    }

    public static string AreaChipLabel(LifeArea area) => area switch
    {
        LifeArea.Health => "Sức khỏe",
        LifeArea.Finance => "Tài chính",
        LifeArea.Career => "Sự nghiệp",
        LifeArea.Growth => "Phát triển",
        LifeArea.Relationship => "Quan hệ",
        LifeArea.Learning => "Học tập",
        LifeArea.Family => "Gia đình",
        LifeArea.Hobby => "Sở thích",
        _ => area.ToString(),
    };

    public static string AreaFullLabel(LifeArea area) => area switch
    {
        LifeArea.Health => "Sức khỏe & Lành mạnh",
        LifeArea.Finance => "Tài chính",
        LifeArea.Career => "Sự nghiệp",
        LifeArea.Growth => "Phát triển bản thân",
        LifeArea.Relationship => "Mối quan hệ",
        LifeArea.Learning => "Học tập",
        LifeArea.Family => "Gia đình",
        LifeArea.Hobby => "Sở thích",
        _ => area.ToString(),
    };

    public static string StatusLabel(GoalStatus status) => status switch
    {
        GoalStatus.NotStarted => "Chưa bắt đầu",
        GoalStatus.InProgress => "Đang thực hiện",
        GoalStatus.Done => "Đã hoàn thành",
        _ => status.ToString(),
    };
}

public partial class AreaChipViewModel(
    LifeArea area,
    string chipLabel,
    string fullLabel,
    int count,
    int percent,
    bool isSelected,
    Action<LifeArea> onSelect) : ObservableObject
{
    public LifeArea Area { get; } = area;
    public string ChipLabel { get; } = chipLabel;
    public string FullLabel { get; } = fullLabel;
    public int Count { get; } = count;
    public int Percent { get; } = percent;
    public string DisplayText => $"{ChipLabel} {Count}";

    [ObservableProperty] private bool _isSelected = isSelected;

    [RelayCommand]
    private void Select() => onSelect(Area);
}

public partial class GoalCardRowViewModel : ObservableObject
{
    private readonly Func<GoalCardRowViewModel, bool, Task> _onToggle;

    public Guid Id { get; }
    public string Title { get; }
    public string StatusText { get; }
    public string AreaText { get; }
    public string DeadlineText { get; }
    public bool IsOverdue { get; }
    public string? RewardText { get; }
    public bool HasReward => !string.IsNullOrWhiteSpace(RewardText);
    public string? OverdueStepsText { get; }
    public bool HasOverdueSteps => !string.IsNullOrWhiteSpace(OverdueStepsText);
    public string StepsSummary { get; }
    public int StepPercent { get; }
    public int TimePercent { get; }
    public bool Behind { get; }

    [ObservableProperty] private bool _done;

    public GoalCardRowViewModel(
        GoalCardDto dto,
        Func<GoalCardRowViewModel, bool, Task> onToggle,
        CultureInfo culture)
    {
        _onToggle = onToggle;
        Id = dto.Id;
        Title = dto.Title;
        _done = dto.Status == GoalStatus.Done;
        StatusText = GoalsViewModel.StatusLabel(dto.Status);
        AreaText = GoalsViewModel.AreaFullLabel(dto.Area);

        var dmy = dto.Deadline.ToString("dd/MM/yyyy", culture);
        if (_done)
        {
            DeadlineText = dmy;
            IsOverdue = false;
        }
        else if (dto.DaysLeft > 0)
        {
            DeadlineText = $"{dmy} · còn {dto.DaysLeft} ngày";
            IsOverdue = false;
        }
        else if (dto.DaysLeft == 0)
        {
            DeadlineText = $"{dmy} · hôm nay";
            IsOverdue = false;
        }
        else
        {
            DeadlineText = $"{dmy} · quá hạn {Math.Abs(dto.DaysLeft)} ngày";
            IsOverdue = true;
        }

        RewardText = string.IsNullOrWhiteSpace(dto.Reward) ? null : $"🎁 {dto.Reward}";
        OverdueStepsText = dto.OverdueSteps > 0 ? $"{dto.OverdueSteps} bước quá hạn" : null;
        StepsSummary = $"{dto.StepsDone}/{dto.StepsTotal} bước";
        StepPercent = dto.StepPercent;
        TimePercent = dto.TimePercent;
        Behind = dto.Behind;
    }

    partial void OnDoneChanged(bool value) => _ = _onToggle(this, value);

#pragma warning disable MVVMTK0034 // Ghi thẳng field để hoàn tác khi API lỗi mà không gọi lại OnDoneChanged.
    public void Revert(bool value)
    {
        _done = value;
        OnPropertyChanged(nameof(Done));
    }
#pragma warning restore MVVMTK0034
}
