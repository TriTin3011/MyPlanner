using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Domain;

public record StatsTaskRow(DateOnly Date, bool Done);
public record StatsHabitRow(Guid Id, string Title, int Order, bool Active, DateOnly StartDate);
public record StatsHabitLogRow(Guid HabitId, DateOnly Date);
public record StatsGoalRow(LifeArea Area, GoalStatus Status);
public record StatsFocusRow(DateOnly Date, int Minutes, FocusOutcome Outcome);
public readonly record struct StatsPeriod(
    DateOnly From,
    DateOnly To,
    DateOnly PreviousFrom,
    DateOnly PreviousTo);

// Toàn bộ phép tính thống kê là hàm thuần, không đọc DB hay đồng hồ server.
public static class StatsCalculator
{
    public static StatsDto Build(
        string range,
        DateOnly today,
        IReadOnlyList<StatsTaskRow> tasks,
        IReadOnlyList<StatsHabitRow> habits,
        IReadOnlyList<StatsHabitLogRow> habitLogs,
        IReadOnlyList<StatsGoalRow> goals,
        IReadOnlyList<StatsFocusRow>? focus = null)
    {
        if (!IsSupportedRange(range))
            throw new ArgumentOutOfRangeException(nameof(range));
        if (!TryGetPeriod(range, today, out var period))
            throw new ArgumentOutOfRangeException(nameof(today));
        var (from, to, previousFrom, previousTo) = period;

        var currentTasks = tasks.Where(t => t.Date >= from && t.Date <= to).ToList();
        var previousTasks = tasks.Where(t => t.Date >= previousFrom && t.Date <= previousTo).ToList();
        var tasksDone = currentTasks.Count(t => t.Done);
        var previousTasksDone = previousTasks.Count(t => t.Done);
        var completionPercent = Metrics.Percent(tasksDone, currentTasks.Count);
        var previousCompletionPercent = Metrics.Percent(previousTasksDone, previousTasks.Count);

        var weekdayProductivity = BuildWeekdays(from, to, currentTasks);
        var bestWeekday = weekdayProductivity
            .Where(x => x.AverageDone > 0)
            .OrderByDescending(x => x.AverageDone)
            .ThenBy(x => x.Weekday)
            .Select(x => (int?)x.Weekday)
            .FirstOrDefault();
        var weeks = BuildWeeks(from, to, currentTasks);
        var heatmap = BuildHeatmap(from, to, currentTasks);

        var activeHabits = habits.Where(h => h.Active && h.StartDate <= today).ToList();
        var activeIds = activeHabits.Select(h => h.Id).ToHashSet();
        var validLogs = habitLogs
            .Where(l => activeIds.Contains(l.HabitId) && l.Date <= today)
            .Distinct()
            .ToList();
        var currentHabitLogs = CountHabitLogs(validLogs, activeHabits, from, to);
        var previousHabitLogs = CountHabitLogs(validLogs, activeHabits, previousFrom, previousTo);
        var starts = activeHabits.Select(h => h.StartDate).ToList();
        var habitPercent = Metrics.HabitPercent(starts, currentHabitLogs, from, to, today);
        var previousHabitPercent = Metrics.HabitPercent(starts, previousHabitLogs, previousFrom, previousTo, today);

        var activityDates = tasks.Where(t => t.Done && t.Date <= today).Select(t => t.Date)
            .Concat(habitLogs.Where(l => l.Date <= today).Select(l => l.Date))
            .ToHashSet();
        var habitConsistency = BuildHabitConsistency(from, to, today, activeHabits, validLogs);
        var goalSummary = BuildGoals(goals);

        return new StatsDto(
            range, from, to, previousFrom, previousTo,
            new StatsHeroDto(
                completionPercent,
                tasksDone,
                currentTasks.Count,
                completionPercent - previousCompletionPercent,
                bestWeekday,
                weeks),
            new StatsKpisDto(
                tasksDone,
                previousTasksDone == 0
                    ? null
                    : Metrics.Percent((double)(tasksDone - previousTasksDone) / previousTasksDone),
                StrictCurrentStreak(activityDates, today),
                Metrics.LongestStreak(activityDates),
                habitPercent,
                habitPercent - previousHabitPercent),
            new StatsTrendDto(completionPercent, weeks),
            heatmap,
            weekdayProductivity,
            habitConsistency,
            goalSummary,
            BuildFocus(period, focus ?? []));
    }

    private static StatsFocusDto BuildFocus(StatsPeriod period, IReadOnlyList<StatsFocusRow> sessions)
    {
        var current = sessions.Where(s => s.Date >= period.From && s.Date <= period.To).ToList();
        var minutes = current.Sum(s => s.Minutes);
        var previous = sessions.Where(s => s.Date >= period.PreviousFrom && s.Date <= period.PreviousTo).Sum(s => s.Minutes);

        var byMonday = current.GroupBy(s => WeekKeys.MondayOf(s.Date)).ToDictionary(g => g.Key, g => g.Sum(s => s.Minutes));
        var weeks = new List<StatsFocusWeekDto>();
        for (var monday = WeekKeys.MondayOf(period.From); monday <= WeekKeys.MondayOf(period.To); monday = monday.AddDays(7))
            weeks.Add(new StatsFocusWeekDto(WeekKeys.ToKey(monday), monday, byMonday.GetValueOrDefault(monday)));

        return new StatsFocusDto(
            minutes,
            previous == 0 ? null : Metrics.Percent((double)(minutes - previous) / previous),
            current.Count(s => s.Outcome == FocusOutcome.Completed),
            weeks);
    }

    public static bool IsSupportedRange(string? range) => range is "4w" or "8w" or "12w" or "6m" or "1y";

    public static bool TryGetPeriod(string range, DateOnly today, out StatsPeriod period)
    {
        try
        {
            var from = range switch
            {
                "4w" => today.AddDays(-27),
                "8w" => today.AddDays(-55),
                "12w" => today.AddDays(-83),
                "6m" => today.AddMonths(-6).AddDays(1),
                "1y" => today.AddYears(-1).AddDays(1),
                _ => throw new ArgumentOutOfRangeException(nameof(range)),
            };
            var dayCount = Metrics.DaysBetweenInclusive(from, today);
            var previousTo = from.AddDays(-1);
            var previousFrom = previousTo.AddDays(-(dayCount - 1));
            period = new StatsPeriod(from, today, previousFrom, previousTo);
            return true;
        }
        catch (ArgumentOutOfRangeException)
        {
            period = default;
            return false;
        }
    }

    private static List<StatsWeekPointDto> BuildWeeks(
        DateOnly from,
        DateOnly to,
        IReadOnlyList<StatsTaskRow> tasks)
    {
        var byMonday = tasks.GroupBy(t => WeekKeys.MondayOf(t.Date))
            .ToDictionary(g => g.Key, g => (Done: g.Count(t => t.Done), Total: g.Count()));
        var firstMonday = WeekKeys.MondayOf(from);
        var lastMonday = WeekKeys.MondayOf(to);
        var result = new List<StatsWeekPointDto>();
        for (var monday = firstMonday; monday <= lastMonday; monday = monday.AddDays(7))
        {
            var (done, total) = byMonday.GetValueOrDefault(monday);
            result.Add(new StatsWeekPointDto(
                WeekKeys.ToKey(monday), monday, done, total, Metrics.Percent(done, total)));
        }
        return result;
    }

    private static List<StatsHeatmapDayDto> BuildHeatmap(
        DateOnly from,
        DateOnly to,
        IReadOnlyList<StatsTaskRow> tasks)
    {
        var doneByDate = tasks.Where(t => t.Done)
            .GroupBy(t => t.Date)
            .ToDictionary(g => g.Key, g => g.Count());
        var result = new List<StatsHeatmapDayDto>(Metrics.DaysBetweenInclusive(from, to));
        for (var date = from; date <= to; date = date.AddDays(1))
        {
            var done = doneByDate.GetValueOrDefault(date);
            result.Add(new StatsHeatmapDayDto(date, done, Metrics.HeatLevel(done)));
        }
        return result;
    }

    private static List<StatsWeekdayDto> BuildWeekdays(
        DateOnly from,
        DateOnly to,
        IReadOnlyList<StatsTaskRow> tasks)
    {
        var occurrences = Enumerable.Range(1, 7).ToDictionary(day => day, _ => 0);
        for (var date = from; date <= to; date = date.AddDays(1))
            occurrences[WeekKeys.IsoWeekday(date)]++;

        var done = tasks.Where(t => t.Done)
            .GroupBy(t => WeekKeys.IsoWeekday(t.Date))
            .ToDictionary(g => g.Key, g => g.Count());
        return Enumerable.Range(1, 7)
            .Select(day => new StatsWeekdayDto(day, (double)done.GetValueOrDefault(day) / occurrences[day]))
            .ToList();
    }

    private static int CountHabitLogs(
        IReadOnlyList<StatsHabitLogRow> logs,
        IReadOnlyList<StatsHabitRow> habits,
        DateOnly from,
        DateOnly to)
    {
        var starts = habits.ToDictionary(h => h.Id, h => h.StartDate);
        return logs.Count(l => l.Date >= from && l.Date <= to && l.Date >= starts[l.HabitId]);
    }

    private static List<StatsHabitDto> BuildHabitConsistency(
        DateOnly from,
        DateOnly to,
        DateOnly today,
        IReadOnlyList<StatsHabitRow> habits,
        IReadOnlyList<StatsHabitLogRow> logs)
    {
        var datesByHabit = logs.GroupBy(l => l.HabitId)
            .ToDictionary(g => g.Key, g => g.Select(l => l.Date).ToHashSet());
        return habits.Select(h =>
            {
                var dates = datesByHabit.GetValueOrDefault(h.Id) ?? [];
                var doneDays = dates.Count(d => d >= Metrics.Max(from, h.StartDate) && d <= to);
                var possibleDays = Metrics.DaysBetweenInclusive(Metrics.Max(from, h.StartDate), Metrics.Min(to, today));
                return new
                {
                    h.Order,
                    Dto = new StatsHabitDto(
                        h.Id,
                        h.Title,
                        Metrics.Percent(doneDays, possibleDays),
                        doneDays,
                        possibleDays,
                        Metrics.CurrentStreak(dates, today),
                        Metrics.LongestStreak(dates)),
                };
            })
            .OrderByDescending(x => x.Dto.Percent)
            .ThenBy(x => x.Order)
            .ThenBy(x => x.Dto.Title, StringComparer.Ordinal)
            .Select(x => x.Dto)
            .ToList();
    }

    private static StatsGoalsDto BuildGoals(IReadOnlyList<StatsGoalRow> goals)
    {
        var done = goals.Count(g => g.Status == GoalStatus.Done);
        var byArea = goals.GroupBy(g => g.Area)
            .OrderBy(g => g.Key)
            .Select(g => new StatsGoalAreaDto(g.Key, g.Count(x => x.Status == GoalStatus.Done), g.Count()))
            .ToList();
        return new StatsGoalsDto(
            goals.Count,
            Metrics.Percent(done, goals.Count),
            new StatsGoalStatusDto(
                goals.Count(g => g.Status == GoalStatus.NotStarted),
                goals.Count(g => g.Status == GoalStatus.InProgress),
                done),
            byArea);
    }

    private static int StrictCurrentStreak(IReadOnlySet<DateOnly> dates, DateOnly today)
    {
        var streak = 0;
        for (var date = today; dates.Contains(date); date = date.AddDays(-1))
            streak++;
        return streak;
    }
}
