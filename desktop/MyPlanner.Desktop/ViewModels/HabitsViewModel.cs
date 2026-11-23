using System.Collections.ObjectModel;
using System.Globalization;
using System.Net.Http;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using MyPlanner.Desktop.Api;

namespace MyPlanner.Desktop.ViewModels;

// Màn "Theo dõi thói quen" (SPEC §8) bản desktop: lưới thói quen × ngày trong tháng, tick từng ô.
// Mọi % và chuỗi ngày lấy từ GET /api/dashboard/habits; tick xong tải lại để lấy số mới từ BE.
public partial class HabitsViewModel(PlannerApiClient api) : ObservableObject, IPageViewModel
{
    private static readonly CultureInfo Vi = new("vi-VN");

    public string PageTitle => "Thói quen";

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(MonthLabel))]
    private DateOnly _month = FirstOfMonth(DateOnly.FromDateTime(DateTime.Now));

    [ObservableProperty] private int _percent;
    [ObservableProperty] private string _longestStreak = "—";
    [ObservableProperty] private string _mostConsistent = "—";
    [ObservableProperty] private string? _error;
    [ObservableProperty] private bool _isBusy;

    public ObservableCollection<HabitRowViewModel> Rows { get; } = [];

    // Tiêu đề cột: số ngày trong tháng.
    public ObservableCollection<string> DayHeaders { get; } = [];

    public string MonthLabel => Month.ToString("'Tháng' M/yyyy", Vi);

    public Task ActivateAsync() => LoadCommand.ExecuteAsync(null);

    [RelayCommand]
    private async Task LoadAsync()
    {
        IsBusy = true;
        Error = null;
        try
        {
            var today = DateOnly.FromDateTime(DateTime.Now);
            var dto = await api.GetHabitMonthAsync(Month.ToString("yyyy-MM", CultureInfo.InvariantCulture), today);
            Percent = dto.Percent;
            LongestStreak = dto.LongestStreak is { } ls ? $"{ls.Title} · {ls.Value} ngày" : "—";
            MostConsistent = dto.MostConsistent is { } mc ? $"{mc.Title} · {mc.Value}%" : "—";

            DayHeaders.Clear();
            for (var d = dto.From; d <= dto.To; d = d.AddDays(1)) DayHeaders.Add(d.Day.ToString(CultureInfo.InvariantCulture));

            Rows.Clear();
            foreach (var h in dto.Habits.OrderBy(h => h.Order))
            {
                var done = h.DoneDates.ToHashSet();
                var cells = new List<HabitCellViewModel>();
                for (var d = dto.From; d <= dto.To; d = d.AddDays(1))
                {
                    // Ô khoá: ngày tương lai hoặc trước ngày bắt đầu thói quen (giống web).
                    var enabled = d <= today && d >= h.StartDate;
                    cells.Add(new HabitCellViewModel(h.Id, d, done.Contains(d), enabled, ToggleAsync)
                    {
                        Label = $"{h.Title}, {d.ToString("d/M", Vi)}",
                    });
                }
                Rows.Add(new HabitRowViewModel(h.Title, h.Percent, h.CurrentStreak, cells));
            }
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

    // Optimistic như màn Hôm nay: ô đã đổi trên UI, gọi API; lỗi thì trả lại.
    private async Task ToggleAsync(HabitCellViewModel cell, bool done)
    {
        try
        {
            await api.SetHabitDoneAsync(cell.HabitId, cell.Date, done);
            await LoadAsync();
        }
        catch (HttpRequestException ex)
        {
            cell.Revert(!done);
            Error = $"Không lưu được: {ex.Message}";
        }
    }

    [RelayCommand]
    private Task PreviousMonthAsync() { Month = Month.AddMonths(-1); return LoadAsync(); }

    [RelayCommand]
    private Task NextMonthAsync() { Month = Month.AddMonths(1); return LoadAsync(); }

    private static DateOnly FirstOfMonth(DateOnly d) => new(d.Year, d.Month, 1);
}

public sealed record HabitRowViewModel(string Title, int Percent, int CurrentStreak, IReadOnlyList<HabitCellViewModel> Cells);

public partial class HabitCellViewModel(Guid habitId, DateOnly date, bool done, bool isEnabled,
    Func<HabitCellViewModel, bool, Task> onToggle) : ObservableObject
{
    public Guid HabitId { get; } = habitId;
    public DateOnly Date { get; } = date;
    public bool IsEnabled { get; } = isEnabled;
    public string Label { get; init; } = "";

    [ObservableProperty] private bool _done = done;

    partial void OnDoneChanged(bool value) => _ = onToggle(this, value);

#pragma warning disable MVVMTK0034 // Ghi thẳng field để trả lại giá trị mà không gọi lại API.
    public void Revert(bool value)
    {
        _done = value;
        OnPropertyChanged(nameof(Done));
    }
#pragma warning restore MVVMTK0034
}
