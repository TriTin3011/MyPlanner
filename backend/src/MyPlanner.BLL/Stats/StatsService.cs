using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.DAL.Goals;
using MyPlanner.DAL.Stats;

namespace MyPlanner.BLL.Stats;

public class StatsService(IStatsRepository stats, IGoalAreaRepository areas) : IStatsService
{
    public async Task<StatsDto> GetAsync(string range, DateOnly today, CancellationToken ct)
    {
        // DbContext không chạy đồng thời nhiều truy vấn; đọc tuần tự, mỗi bảng đúng một lần.
        var tasks = await stats.TasksAsync(today, ct);
        var habits = await stats.HabitsAsync(ct);
        var logs = await stats.HabitLogsAsync(today, ct);
        var goals = await stats.GoalsAsync(ct);
        var focus = await stats.FocusAsync(today, ct);
        var areaList = await areas.ListAsync(ct);
        return StatsCalculator.Build(range, today, tasks, habits, logs, goals, areaList, focus);
    }
}
