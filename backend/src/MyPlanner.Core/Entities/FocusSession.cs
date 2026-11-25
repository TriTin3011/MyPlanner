namespace MyPlanner.Core.Entities;

// Một phiên tập trung = một chậu cây (SPEC §11A, §12.8).
// Bản ghi chỉ thêm: không có API sửa. Id do CLIENT tạo để gửi lại khi mất mạng không sinh dòng trùng.
public class FocusSession : IUserOwned
{
    public Guid UserId { get; set; }
    public Guid Id { get; set; }
    public DateTimeOffset StartedAt { get; set; }      // lúc xong đoạn mở đầu (đoạn trồng 20 giây không tính)
    public DateTimeOffset EndedAt { get; set; }
    public DateOnly Date { get; set; }                 // ngày địa phương của client lúc bắt đầu
    public int PlannedMinutes { get; set; }
    public int ActualMinutes { get; set; }
    public FocusOutcome Outcome { get; set; }
    public PlantKind PlantKind { get; set; }
    public PotColor PotColor { get; set; }

    // Liên kết tuỳ chọn, tối đa một trong ba. Xoá việc/thói quen/mục tiêu thì cột về null, chậu vẫn còn trên kệ.
    public Guid? TaskId { get; set; }
    public Guid? HabitId { get; set; }
    public Guid? GoalId { get; set; }
}
