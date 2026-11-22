using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Dashboard;

public interface IDashboardService
{
    Task<TodayDashboardDto> GetTodayAsync(DateOnly date, CancellationToken ct);
    Task<List<DayProgressDto>> GetDaysAsync(DateOnly from, DateOnly to, CancellationToken ct);
    Task<WeekDashboardDto> GetWeekAsync(DateOnly monday, DateOnly today, CancellationToken ct);
    Task<List<WeekProgressDto>> GetWeeksAsync(DateOnly lastMonday, int count, CancellationToken ct);
    Task<HabitMonthDto> GetHabitMonthAsync(DateOnly firstOfMonth, DateOnly today, CancellationToken ct);
}
