using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.DAL.Stats;

namespace MyPlanner.BLL.Stats;

public class StatsService(IStatsRepository stats) : IStatsService
{
    public async Task<StatsDto> GetAsync(string range, DateOnly today, CancellationToken ct)
    {
        // DbContext không chạy đồng thời nhiều truy vấn; đọc tuần tự, mỗi bảng đúng một lần.
        var tasks = await stats.TasksAsync(today, ct);
        var habits = await stats.HabitsAsync(ct);
        var logs = await stats.HabitLogsAsync(today, ct);
        var goals = await stats.GoalsAsync(ct);
        return StatsCalculator.Build(range, today, tasks, habits, logs, goals);
    }
}
