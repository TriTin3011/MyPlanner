using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Dtos;

// DTO là hình dạng JSON của API (SPEC §12). Dùng record: bất biến, so sánh theo giá trị, viết gọn.
// Entity không bao giờ đi ra ngoài API: đổi bảng không làm vỡ hợp đồng với web/WPF/Flutter.

public record SubtaskDto(Guid Id, string Title, bool Done);

public record TaskDto(
    Guid Id,
    string Title,
    DateOnly Date,
    DateOnly? OriginalDate,
    bool Done,
    DateTimeOffset? DoneAt,
    IReadOnlyList<TaskTag> Tags,
    IReadOnlyList<SubtaskDto> Subtasks,
    Guid? RecurringId,
    int Order,
    DateTimeOffset CreatedAt,
    DateTimeOffset UpdatedAt);

// Bước con gửi lên: Id null = bước mới.
public record SubtaskInput(Guid? Id, string Title, bool Done);

// Dùng chung cho POST /tasks và PUT /tasks/{id}.
public record SaveTaskRequest(string Title, DateOnly Date, List<TaskTag>? Tags, List<SubtaskInput>? Subtasks);

public record SetDoneRequest(bool Done);

// Kéo thả: đặt lại thứ tự (và ngày, khi kéo sang cột ngày khác) cho danh sách id theo đúng thứ tự gửi lên.
public record ReorderTasksRequest(DateOnly Date, List<Guid> Ids);

public record MoveBacklogRequest(DateOnly Today);

public record RecurringTaskDto(
    Guid Id,
    string Title,
    IReadOnlyList<int> Weekdays,
    IReadOnlyList<TaskTag> Tags,
    bool Active,
    DateOnly StartDate,
    IReadOnlyList<DateOnly> SkippedDates,
    DateTimeOffset CreatedAt);

public record SaveRecurringRequest(string Title, List<int> Weekdays, List<TaskTag>? Tags, bool Active, DateOnly StartDate);
