using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Dtos;

// Một phiên tập trung (SPEC §12.8). Dùng cho cả body POST /focus/sessions, kết quả GET và file sao lưu.
// Id do client tạo: gửi lại cùng Id thì server trả bản đã lưu, không thêm dòng mới (idempotent).
public record FocusSessionDto(
    Guid Id,
    DateTimeOffset StartedAt,
    DateTimeOffset EndedAt,
    DateOnly Date,
    int PlannedMinutes,
    int ActualMinutes,
    FocusOutcome Outcome,
    PlantKind PlantKind,
    PotColor PotColor,
    Guid? TaskId,
    Guid? HabitId,
    Guid? GoalId);

// GET /dashboard/focus (SPEC §13.9): mọi con số của tab Tập trung, tính ở Core (FocusBoard).
public record FocusBoardDto(
    int MinutesToday,
    int MinutesThisWeek,
    int MinutesTotal,
    int PotCount,
    int Streak,
    double CompletedHours,
    IReadOnlyList<FocusShelfDto> Shelves,
    IReadOnlyList<FocusUnlockDto> Unlocks);

// Một kệ 12 ô (3 + 4 + 5). Ô trống không có trong danh sách: FE vẽ ô trống từ vị trí còn thiếu.
public record FocusShelfDto(int Index, IReadOnlyList<FocusPotDto> Pots);

// Slot 0..11 tính từ tầng trên cùng, trái sang phải.
public record FocusPotDto(
    Guid Id,
    int Slot,
    PlantKind PlantKind,
    PotColor PotColor,
    int Minutes,
    DateOnly Date,
    DateTimeOffset EndedAt,
    string? LinkTitle);

// Kind = "plant" | "pot"; Key = giá trị enum dạng chuỗi ("sunflower", "cream").
public record FocusUnlockDto(string Kind, string Key, double ThresholdHours, bool Unlocked, double HoursRemaining);
