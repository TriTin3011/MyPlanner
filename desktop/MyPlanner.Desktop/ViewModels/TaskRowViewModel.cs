using CommunityToolkit.Mvvm.ComponentModel;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Desktop.ViewModels;

// Một dòng việc trên màn hình. Bọc TaskDto (bất biến) thành object có thể bind hai chiều.
public partial class TaskRowViewModel(TaskDto task, Func<TaskRowViewModel, bool, Task> onToggle) : ObservableObject
{
    public Guid Id => task.Id;
    public string Title => task.Title;
    public int SubtaskCount => task.Subtasks.Count;
    public string Tags => string.Join(" · ", task.Tags.Select(t => t.ToString().ToLowerInvariant()));

    // [ObservableProperty] sinh property Done + PropertyChanged (source generator, không viết tay).
    [ObservableProperty]
    private bool _done = task.Done;

    // Người dùng tick checkbox → binding gán Done → gọi về TodayViewModel để PATCH lên API.
    partial void OnDoneChanged(bool value) => _ = onToggle(this, value);

    // Dùng khi API lỗi: trả checkbox về trạng thái cũ mà không gọi lại onToggle.
    public void Revert(bool value)
    {
#pragma warning disable MVVMTK0034 // cố ý ghi field để bỏ qua OnDoneChanged
        _done = value;
#pragma warning restore MVVMTK0034
        OnPropertyChanged(nameof(Done));
    }
}
