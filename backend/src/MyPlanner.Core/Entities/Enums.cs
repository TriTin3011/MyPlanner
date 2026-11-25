using System.Text.Json.Serialization;

namespace MyPlanner.Core.Entities;

// Enum nằm ở Core vì cả entity (DB) và DTO (JSON) cùng dùng.
// JsonStringEnumMemberName: JSON ghi "urgent", "not_started" đúng như SPEC §12 thay vì số 0, 1.
// Đặt converter ngay trên enum (không cấu hình ở Program.cs) để WPF/Flutter đọc Core cũng ra cùng chuỗi.

[JsonConverter(typeof(JsonStringEnumConverter<TaskTag>))]
public enum TaskTag
{
    [JsonStringEnumMemberName("urgent")] Urgent,
    [JsonStringEnumMemberName("important")] Important,
}

[JsonConverter(typeof(JsonStringEnumConverter<LifeArea>))]
public enum LifeArea
{
    [JsonStringEnumMemberName("health")] Health,
    [JsonStringEnumMemberName("finance")] Finance,
    [JsonStringEnumMemberName("career")] Career,
    [JsonStringEnumMemberName("growth")] Growth,
    [JsonStringEnumMemberName("relationship")] Relationship,
    [JsonStringEnumMemberName("learning")] Learning,
    [JsonStringEnumMemberName("family")] Family,
    [JsonStringEnumMemberName("hobby")] Hobby,
}

// Tập trung (SPEC §12.8). Thêm loại cây hoặc màu chậu mới thì thêm ngưỡng mở khoá ở FocusBoard (§13.9).
[JsonConverter(typeof(JsonStringEnumConverter<FocusOutcome>))]
public enum FocusOutcome
{
    [JsonStringEnumMemberName("completed")] Completed,
    [JsonStringEnumMemberName("abandoned")] Abandoned,
}

[JsonConverter(typeof(JsonStringEnumConverter<PlantKind>))]
public enum PlantKind
{
    [JsonStringEnumMemberName("basil")] Basil,
    [JsonStringEnumMemberName("sunflower")] Sunflower,
    [JsonStringEnumMemberName("cactus")] Cactus,
}

[JsonConverter(typeof(JsonStringEnumConverter<PotColor>))]
public enum PotColor
{
    [JsonStringEnumMemberName("terra")] Terra,
    [JsonStringEnumMemberName("cream")] Cream,
    [JsonStringEnumMemberName("sage")] Sage,
    [JsonStringEnumMemberName("blue")] Blue,
}

[JsonConverter(typeof(JsonStringEnumConverter<GoalStatus>))]
public enum GoalStatus
{
    [JsonStringEnumMemberName("not_started")] NotStarted,
    [JsonStringEnumMemberName("in_progress")] InProgress,
    [JsonStringEnumMemberName("done")] Done,
}
