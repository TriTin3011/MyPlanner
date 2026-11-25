namespace MyPlanner.Core.Dtos;

// Toàn bộ dữ liệu của người dùng: dùng cho GET /export, POST /import và cho SeedService (SPEC §14.3).
// Version để sau này đổi cấu trúc vẫn đọc được file backup cũ.
public record BackupDto(
    int Version,
    DateTimeOffset ExportedAt,
    IReadOnlyList<TaskDto> Tasks,
    IReadOnlyList<RecurringTaskDto> Recurring,
    IReadOnlyList<HabitDto> Habits,
    IReadOnlyList<HabitLogDto> HabitLogs,
    IReadOnlyList<GoalDto> Goals,
    IReadOnlyList<DayNoteDto> DayNotes,
    IReadOnlyList<WeekNoteDto> WeekNotes,
    IReadOnlyList<YearMetaDto> Years,
    IReadOnlyList<YearPlanItemDto> YearItems,
    // Thêm ở version 2 cùng với lĩnh vực tự tạo. File version 1 không có trường này:
    // khi nhập, mục tiêu trỏ tới lĩnh vực không có trong file được đưa về lĩnh vực "Phát triển".
    IReadOnlyList<GoalAreaDto>? Areas = null)
{
    public const int CurrentVersion = 2;
}

public record ImportResultDto(int Tasks, int Habits, int HabitLogs, int Goals);

// Kết quả DELETE /api/weeks/{weekKey}: số dòng đã xoá mỗi loại.
public record WeekDeleteResultDto(int Tasks, int HabitLogs, int Notes);

// POST /api/dev/seed: dữ liệu mẫu xoay quanh ngày hôm nay của client.
public record SeedRequest(DateOnly Today);

// Kết quả các lệnh trả về số lượng (move-backlog-to-today, materialize).
public record CountDto(int Count);
