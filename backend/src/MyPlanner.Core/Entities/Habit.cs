namespace MyPlanner.Core.Entities;

// Thói quen (SPEC §12.3).
public class Habit : IUserOwned
{
    public Guid UserId { get; set; }
    public Guid Id { get; set; }
    public string Title { get; set; } = "";
    public int Order { get; set; }
    public bool Active { get; set; } = true;          // ẩn thay vì xoá để giữ lịch sử
    public DateOnly StartDate { get; set; }            // ngày (địa phương) bắt đầu theo dõi: không tính % trước ngày này
    public DateTimeOffset CreatedAt { get; set; }
    public DateTimeOffset? ArchivedAt { get; set; }
}

// Một lần tick: tồn tại dòng = đã làm. Khoá chính ghép (HabitId, Date).
public class HabitLog : IUserOwned
{
    public Guid UserId { get; set; }
    public Guid HabitId { get; set; }
    public DateOnly Date { get; set; }
}
