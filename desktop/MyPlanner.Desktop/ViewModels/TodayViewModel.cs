using System.Collections.ObjectModel;
using System.Globalization;
using System.Net.Http;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using MyPlanner.Desktop.Api;

namespace MyPlanner.Desktop.ViewModels;

// ViewModel của màn "Hôm nay" (SPEC §6). Giữ trạng thái màn hình, không biết gì về XAML.
// View → (binding/command) → ViewModel → PlannerApiClient → HTTP → API.
// Mọi con số (Percent, TasksDone…) lấy nguyên từ backend, desktop không tự tính.
public partial class TodayViewModel(PlannerApiClient api) : ObservableObject, IPageViewModel
{
    public string PageTitle => "Hôm nay";
    public Task ActivateAsync() => LoadCommand.ExecuteAsync(null);

    private static readonly CultureInfo Vi = new("vi-VN");

    public ObservableCollection<TaskRowViewModel> Tasks { get; } = [];

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(DateLabel))]
    private DateOnly _date = DateOnly.FromDateTime(DateTime.Now);

    [ObservableProperty] private int _percent;
    [ObservableProperty] private string _summary = "";
    [ObservableProperty] private string? _error;
    [ObservableProperty] private bool _isBusy;

    public string DateLabel => Date.ToDateTime(TimeOnly.MinValue).ToString("dddd, d/M/yyyy", Vi);

    // [RelayCommand] sinh LoadCommand (IAsyncRelayCommand): tự chặn bấm lặp khi đang chạy.
    [RelayCommand]
    private async Task LoadAsync()
    {
        IsBusy = true;
        Error = null;
        try
        {
            var dto = await api.GetTodayAsync(Date);
            Percent = dto.Percent;
            Summary = $"{dto.TasksDone}/{dto.TasksTotal} việc · {dto.HabitsDone}/{dto.HabitsTotal} thói quen";
            Tasks.Clear();
            foreach (var t in dto.Tasks)
                Tasks.Add(new TaskRowViewModel(t, ToggleAsync));
        }
        catch (HttpRequestException ex) when (ex.StatusCode == System.Net.HttpStatusCode.Unauthorized)
        {
            // BearerTokenHandler đã xoá token và đưa app về màn đăng nhập; không cần báo thêm.
        }
        catch (HttpRequestException ex)
        {
            Error = $"Không gọi được API: {ex.Message}";
        }
        finally
        {
            IsBusy = false;
        }
    }

    [RelayCommand]
    private Task PreviousDayAsync() { Date = Date.AddDays(-1); return LoadAsync(); }

    [RelayCommand]
    private Task NextDayAsync() { Date = Date.AddDays(1); return LoadAsync(); }

    [RelayCommand]
    private Task TodayAsync() { Date = DateOnly.FromDateTime(DateTime.Now); return LoadAsync(); }

    // Optimistic: checkbox đã đổi trên UI; gọi API, lỗi thì trả lại. Xong thì tải lại để lấy % mới từ BE.
    private async Task ToggleAsync(TaskRowViewModel row, bool done)
    {
        try
        {
            await api.SetDoneAsync(row.Id, done);
            await LoadAsync();
        }
        catch (HttpRequestException ex)
        {
            row.Revert(!done);
            Error = $"Không lưu được: {ex.Message}";
        }
    }
}
