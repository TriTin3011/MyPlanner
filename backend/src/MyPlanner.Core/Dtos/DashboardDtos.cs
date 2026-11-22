namespace MyPlanner.Core.Dtos;

public record TodayHabitDto(Guid Id, string Title, int Order, bool Done);

public record TodayDashboardDto(
    DateOnly Date,
    int Percent,
    int TasksDone,
    int TasksTotal,
    int HabitsDone,
    int HabitsTotal,
    IReadOnlyList<TaskDto> Tasks,
    IReadOnlyList<TaskDto> Backlog,
    IReadOnlyList<TodayHabitDto> Habits,
    DayNoteDto? Note);

// Số liệu một ngày cho biểu đồ "Tiến độ gần đây" và ô lịch "Lên kế hoạch" (SPEC §6.2, §6.6).
// HasDeadline: ngày đó là hạn của một mục tiêu hoặc một bước (cờ ⚑ trên lịch).
public record DayProgressDto(DateOnly Date, int TasksDone, int TasksTotal, int Percent, bool HasDeadline);

// Số liệu trang Kế hoạch tuần (SPEC §9.1, §13.6). Danh sách task từng ngày lấy riêng qua GET /tasks?from=&to=.
// Insights: các câu "Xem thêm" so với tuần trước, BE ghép sẵn để mọi client hiện giống nhau.
public record WeekDashboardDto(
    string WeekKey,
    DateOnly From,
    DateOnly To,
    int TasksDone,
    int TasksTotal,
    int HabitPercent,
    int TodayRemaining,
    string Comment,
    IReadOnlyList<DayProgressDto> Days,
    IReadOnlyList<string> Insights);

// Một tuần trên biểu đồ "Tiến độ từng tuần" (chế độ 12 tuần, SPEC §9.2).
public record WeekProgressDto(string WeekKey, DateOnly Monday, int TasksDone, int TasksTotal, int Percent);

// Số liệu trang Theo dõi thói quen cho một tháng (SPEC §8, §13.5). Month dạng "2026-11".
// Percent: ô đã tick / ô tick được của cả tháng, tính tới hôm nay. Hai ô nổi bật null khi chưa có habit nào.
public record HabitMonthDto(
    string Month,
    DateOnly From,
    DateOnly To,
    int Percent,
    HabitHighlightDto? LongestStreak,
    HabitHighlightDto? MostConsistent,
    IReadOnlyList<HabitMonthRowDto> Habits,
    IReadOnlyList<HabitDayCountDto> Days);

// Value: số ngày (chuỗi dài nhất) hoặc % (đều đặn nhất), tuỳ ô.
public record HabitHighlightDto(Guid HabitId, string Title, int Value);

// Một dòng của "Bảng theo dõi". DoneDates: các ngày đã tick trong tháng (FE tô ô).
// LongestStreak tính trên toàn bộ lịch sử tới hôm nay, Percent chỉ trong tháng.
public record HabitMonthRowDto(
    Guid Id,
    string Title,
    int Order,
    DateOnly StartDate,
    int Percent,
    int CurrentStreak,
    int LongestStreak,
    IReadOnlyList<DateOnly> DoneDates);

// Một điểm trên biểu đồ "Mức hoàn thành theo ngày". Ngày sau hôm nay: Done, Total, Percent là null (biểu đồ để trống).
public record HabitDayCountDto(DateOnly Date, int? Done, int? Total, int? Percent);
