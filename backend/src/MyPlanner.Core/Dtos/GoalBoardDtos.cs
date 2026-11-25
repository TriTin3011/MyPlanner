using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Dtos;

// Read model của màn Mục tiêu (SPEC §7): mọi con số trên GoalCard, vòng %, chip và radar đều tính sẵn ở BE.
// FE chỉ hiển thị, nên web, WPF và Flutter ra cùng một "Đang chậm hơn kế hoạch".

// Một GoalCard. Phần trăm là số nguyên 0–100.
public record GoalCardDto(
    Guid Id,
    string Title,
    Guid AreaId,
    GoalStatus Status,
    DateOnly StartDate,
    DateOnly Deadline,
    string? Reward,
    int DaysLeft,        // âm = quá hạn |DaysLeft| ngày
    int StepsDone,
    int StepsTotal,
    int OverdueSteps,    // bước chưa xong mà hạn < today
    int StepPercent,     // thanh "Tiến độ"
    int TimePercent,     // thanh "Thời gian"
    bool Behind);        // dòng "Đang chậm hơn kế hoạch" (§13.4)

// Một chip / một trục radar. Percent = trung bình stepProgress các mục tiêu của lĩnh vực, 0 nếu không có mục tiêu.
public record AreaSummaryDto(Guid Id, LifeArea? Key, string? Name, int Count, int Percent);

// GET /api/dashboard/goals?today=. Areas là mọi lĩnh vực của tài khoản (8 có sẵn + tự thêm) theo thứ tự hiển thị; Goals đã sắp: chưa xong theo hạn gần nhất, đã xong ở cuối.
public record GoalBoardDto(
    int Done,
    int Total,
    int Percent,
    IReadOnlyList<AreaSummaryDto> Areas,
    IReadOnlyList<GoalCardDto> Goals);
