using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Domain;

namespace MyPlanner.DAL.Stats;

public class StatsRepository(AppDbContext db) : IStatsRepository
{
    public Task<List<StatsTaskRow>> TasksAsync(DateOnly to, CancellationToken ct) =>
        db.Tasks.AsNoTracking()
            .Where(task => task.Date <= to)
            .Select(task => new StatsTaskRow(task.Date, task.Done))
            .ToListAsync(ct);

    public Task<List<StatsHabitRow>> HabitsAsync(CancellationToken ct) =>
        db.Habits.AsNoTracking()
            .Select(habit => new StatsHabitRow(
                habit.Id, habit.Title, habit.Order, habit.Active, habit.StartDate))
            .ToListAsync(ct);

    public Task<List<StatsHabitLogRow>> HabitLogsAsync(DateOnly to, CancellationToken ct) =>
        db.HabitLogs.AsNoTracking()
            .Where(log => log.Date <= to)
            .Select(log => new StatsHabitLogRow(log.HabitId, log.Date))
            .ToListAsync(ct);

    public Task<List<StatsGoalRow>> GoalsAsync(CancellationToken ct) =>
        db.Goals.AsNoTracking()
            .Select(goal => new StatsGoalRow(goal.Area, goal.Status))
            .ToListAsync(ct);

    public Task<List<StatsFocusRow>> FocusAsync(DateOnly to, CancellationToken ct) =>
        db.FocusSessions.AsNoTracking()
            .Where(s => s.Date <= to)
            .Select(s => new StatsFocusRow(s.Date, s.ActualMinutes, s.Outcome))
            .ToListAsync(ct);
}
