namespace MyPlanner.Core.Dtos;

// Read model cho màn Kế hoạch năm (SPEC §10, §13.8): một lần gọi đủ cho cả trang.
// CurrentMonth = tháng của `today` nếu `today` thuộc năm đang xem, ngược lại null (không card nào tự mở).
public record YearDashboardDto(
    int Year,
    string Keyword,
    string Vision,
    int Done,
    int Total,
    int Percent,
    int? CurrentMonth,
    List<YearMonthDto> Months);

// Một MonthCard: x/y, % thanh tiến độ, ⚑ k (= Deadlines.Count), các DeadlineRow và danh sách mục.
public record YearMonthDto(
    int Month,
    int Done,
    int Total,
    int Percent,
    List<DeadlineDto> Deadlines,
    List<YearPlanItemDto> Items);

// Kéo thả trong một tháng hoặc sang tháng khác: Ids là thứ tự mới của tháng đích.
public record ReorderYearItemsRequest(int Month, List<Guid> Ids);
