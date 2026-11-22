using MyPlanner.Core.Domain;

namespace MyPlanner.DAL.Stats;

public interface IStatsRepository
{
    Task<List<StatsTaskRow>> TasksAsync(DateOnly to, CancellationToken ct);
    Task<List<StatsHabitRow>> HabitsAsync(CancellationToken ct);
    Task<List<StatsHabitLogRow>> HabitLogsAsync(DateOnly to, CancellationToken ct);
    Task<List<StatsGoalRow>> GoalsAsync(CancellationToken ct);
}
