using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Dashboard;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api/dashboard")]
public class DashboardController(IDashboardService dashboard) : ControllerBase
{
    [HttpGet("today")]
    public Task<TodayDashboardDto> Today([FromQuery] DateOnly date, CancellationToken ct) =>
        dashboard.GetTodayAsync(date, ct);

    // GET /api/dashboard/days?from=2026-10-26&to=2026-12-06: biểu đồ tiến độ và lưới lịch dùng chung.
    [HttpGet("days")]
    public async Task<ActionResult<List<DayProgressDto>>> Days([FromQuery] DateOnly from, [FromQuery] DateOnly to, CancellationToken ct)
    {
        if (to < from || to.DayNumber - from.DayNumber > 400)
            return Problem(statusCode: 400, title: "Khoảng ngày không hợp lệ", detail: "Cần from ≤ to và tối đa 400 ngày.");
        return await dashboard.GetDaysAsync(from, to, ct);
    }

    // GET /api/dashboard/week?weekKey=2026-W47&today=2026-11-22: StatStrip, câu nhận xét, 7 ngày, phần "Xem thêm".
    [HttpGet("week")]
    public async Task<ActionResult<WeekDashboardDto>> Week([FromQuery] string weekKey, [FromQuery] DateOnly today, CancellationToken ct)
    {
        if (!WeekKeys.TryParse(weekKey, out var monday))
            return Problem(statusCode: 400, title: "weekKey không hợp lệ", detail: "Cần dạng ISO như 2026-W47.");
        return await dashboard.GetWeekAsync(monday, today, ct);
    }

    // GET /api/dashboard/weeks?to=2026-W47&count=12: biểu đồ "Tiến độ từng tuần", kết thúc ở tuần `to`.
    [HttpGet("weeks")]
    public async Task<ActionResult<List<WeekProgressDto>>> Weeks([FromQuery] string to, [FromQuery] int count, CancellationToken ct)
    {
        if (!WeekKeys.TryParse(to, out var lastMonday))
            return Problem(statusCode: 400, title: "weekKey không hợp lệ", detail: "Cần dạng ISO như 2026-W47.");
        if (count is < 1 or > 53)
            return Problem(statusCode: 400, title: "count không hợp lệ", detail: "Cần 1 ≤ count ≤ 53.");
        return await dashboard.GetWeeksAsync(lastMonday, count, ct);
    }

    // GET /api/dashboard/habits?month=2026-11&today=2026-11-22: StatStrip, bảng theo dõi và biểu đồ của trang Thói quen.
    [HttpGet("habits")]
    public async Task<ActionResult<HabitMonthDto>> Habits([FromQuery] string month, [FromQuery] DateOnly today, CancellationToken ct)
    {
        if (!DateOnly.TryParseExact($"{month}-01", "yyyy-MM-dd", out var firstOfMonth))
            return Problem(statusCode: 400, title: "month không hợp lệ", detail: "Cần dạng yyyy-MM như 2026-11.");
        return await dashboard.GetHabitMonthAsync(firstOfMonth, today, ct);
    }
}
