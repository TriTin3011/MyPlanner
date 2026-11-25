using System.Text.Json.Serialization;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Dtos;

public record GoalStepDto(Guid Id, string Title, DateOnly? Deadline, bool Done, DateTimeOffset? DoneAt, int Order);

// Lĩnh vực: có sẵn thì Key khác null (client tự dịch tên), tự thêm thì Key null và Name là tên người dùng gõ.
public record GoalAreaDto(Guid Id, LifeArea? Key, string? Name);

public record CreateGoalAreaRequest(string Name);

public record GoalDto(
    Guid Id,
    string Title,
    Guid AreaId,
    GoalStatus Status,
    DateOnly StartDate,
    DateOnly Deadline,
    string? Reward,
    string? Why,
    IReadOnlyList<GoalStepDto> Steps,
    DateTimeOffset CreatedAt,
    DateTimeOffset? CompletedAt)
{
    // Chỉ để đọc file sao lưu version 1 (khi đó mục tiêu lưu "area": "health" thay vì areaId). API không trả trường này.
    [JsonPropertyName("area")]
    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public LifeArea? LegacyArea { get; init; }
}

public record SaveGoalRequest(
    string Title,
    Guid AreaId,
    GoalStatus Status,
    DateOnly StartDate,
    DateOnly Deadline,
    string? Reward,
    string? Why);

public record SaveGoalStepRequest(string Title, DateOnly? Deadline, bool Done);

// Loại dòng hạn: hạn của một bước, hoặc hạn của cả mục tiêu.
[JsonConverter(typeof(JsonStringEnumConverter<DeadlineKind>))]
public enum DeadlineKind
{
    [JsonStringEnumMemberName("step")] Step,
    [JsonStringEnumMemberName("goal")] Goal,
}

// Một DeadlineRow (SPEC §5): "⚑ Hạn bước: <Title> · <GoalTitle> · quá hạn". Với hạn mục tiêu, Title = GoalTitle.
// Overdue do BE tính theo `today` client gửi (chưa xong và Date < today), FE chỉ hiện chữ "quá hạn".
public record DeadlineDto(
    DateOnly Date,
    DeadlineKind Kind,
    Guid GoalId,
    string GoalTitle,
    string Title,
    bool Done,
    bool Overdue);
