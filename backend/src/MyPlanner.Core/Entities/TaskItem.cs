namespace MyPlanner.Core.Entities;

// Việc (SPEC §12.1). Đặt tên TaskItem để không trùng System.Threading.Tasks.Task.
// Entity là class có setter: EF Core cần tạo và gán giá trị khi đọc từ DB, change tracker theo dõi khi sửa.
public class TaskItem
{
    public Guid Id { get; set; }
    public string Title { get; set; } = "";
    public DateOnly Date { get; set; }               // ngày được lên lịch (giờ địa phương của người dùng)
    public DateOnly? OriginalDate { get; set; }      // ngày gốc nếu đã "chuyển vào hôm nay"
    public bool Done { get; set; }
    public DateTimeOffset? DoneAt { get; set; }
    public List<TaskTag> Tags { get; set; } = [];    // mảng nhỏ: lưu thành cột mảng của Postgres
    public List<Subtask> Subtasks { get; set; } = []; // bảng con 1-n
    public Guid? RecurringId { get; set; }           // sinh từ RecurringTask nào
    public int Order { get; set; }                   // thứ tự trong ngày
    public DateTimeOffset CreatedAt { get; set; }
    public DateTimeOffset UpdatedAt { get; set; }
}

public class Subtask
{
    public Guid Id { get; set; }
    public Guid TaskId { get; set; }
    public string Title { get; set; } = "";
    public bool Done { get; set; }
    public int Order { get; set; }
}

// Việc lặp lại (SPEC §12.2): khuôn để sinh TaskItem theo thứ trong tuần.
public class RecurringTask
{
    public Guid Id { get; set; }
    public string Title { get; set; } = "";
    public List<int> Weekdays { get; set; } = [];          // 1 = Thứ 2 … 7 = Chủ nhật
    public List<TaskTag> Tags { get; set; } = [];
    public bool Active { get; set; } = true;
    public DateOnly StartDate { get; set; }                 // không sinh việc trước ngày này
    public List<DateOnly> SkippedDates { get; set; } = [];  // ngày người dùng đã xoá: không sinh lại
    public DateTimeOffset CreatedAt { get; set; }
}
