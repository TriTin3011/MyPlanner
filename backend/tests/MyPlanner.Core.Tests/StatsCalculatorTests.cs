using MyPlanner.Core.Domain;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Tests;

public class StatsCalculatorTests
{
    private static readonly DateOnly Today = new(2026, 11, 22); // Chủ nhật

    [Fact]
    public void Build_returns_complete_empty_shape()
    {
        var result = Build();

        Assert.Equal(new DateOnly(2026, 10, 26), result.From);
        Assert.Equal(Today, result.To);
        Assert.Equal(new DateOnly(2026, 9, 28), result.PreviousFrom);
        Assert.Equal(new DateOnly(2026, 10, 25), result.PreviousTo);
        Assert.Equal(0, result.Hero.CompletionPercent);
        Assert.Null(result.Hero.BestWeekday);
        Assert.Equal(4, result.Hero.WeeklySparkline.Count);
        Assert.Equal(("2026-W44", new DateOnly(2026, 10, 26)),
            (result.Hero.WeeklySparkline[0].WeekKey, result.Hero.WeeklySparkline[0].Monday));
        Assert.Equal(28, result.Heatmap.Count);
        Assert.All(result.Heatmap, day => Assert.Equal((0, 0), (day.Done, day.Level)));
        Assert.Equal(7, result.WeekdayProductivity.Count);
        Assert.Null(result.Kpis.TasksDonePercentChange);
        Assert.Empty(result.HabitConsistency);
        Assert.Equal(0, result.Goals.Total);
    }

    [Fact]
    public void Build_uses_fixed_heatmap_levels()
    {
        var tasks = Enumerable.Range(0, 7)
            .SelectMany(offset => Enumerable.Range(0, offset + 1)
                .Select(_ => new StatsTaskRow(Today.AddDays(offset - 6), true)))
            .ToList();

        var levels = Build(tasks: tasks).Heatmap
            .Where(day => day.Date >= Today.AddDays(-6))
            .Select(day => day.Level)
            .ToList();

        Assert.Equal([1, 1, 2, 2, 3, 3, 4], levels);
    }

    [Fact]
    public void Build_divides_weekday_done_by_occurrences_in_range()
    {
        var tasks = new List<StatsTaskRow>
        {
            new(new DateOnly(2026, 10, 26), true),
            new(new DateOnly(2026, 11, 2), true),
            new(new DateOnly(2026, 11, 22), true),
            new(new DateOnly(2026, 11, 22), true),
        };

        var weekdays = Build(tasks: tasks).WeekdayProductivity;

        Assert.Equal(0.5, weekdays.Single(x => x.Weekday == 1).AverageDone);
        Assert.Equal(0.5, weekdays.Single(x => x.Weekday == 7).AverageDone);
        Assert.Equal(1, Build(tasks: tasks).Hero.BestWeekday);
    }

    [Fact]
    public void Build_computes_strict_activity_streak_and_reuses_habit_streak_rules()
    {
        var habitId = Guid.NewGuid();
        var tasks = new List<StatsTaskRow>
        {
            new(Today.AddDays(-10), true),
            new(Today.AddDays(-9), true),
            new(Today.AddDays(-2), true),
        };
        var habits = new List<StatsHabitRow>
        {
            new(habitId, "Đọc sách", 0, true, Today.AddDays(-20)),
        };
        var logs = new List<StatsHabitLogRow>
        {
            new(habitId, Today.AddDays(-8)),
            new(habitId, Today.AddDays(-1)),
        };

        var result = Build(tasks, habits, logs);

        Assert.Equal(0, result.Kpis.ActivityCurrentStreak);
        Assert.Equal(3, result.Kpis.ActivityLongestStreak);
        var habit = Assert.Single(result.HabitConsistency);
        Assert.Equal(1, habit.CurrentStreak);
        Assert.Equal(1, habit.LongestStreak);
    }

    [Fact]
    public void Build_computes_task_and_habit_deltas_against_equal_previous_period()
    {
        var habitId = Guid.NewGuid();
        var tasks = new List<StatsTaskRow>
        {
            new(new DateOnly(2026, 10, 1), true),
            new(new DateOnly(2026, 10, 2), false),
            new(new DateOnly(2026, 11, 1), true),
            new(new DateOnly(2026, 11, 2), true),
            new(new DateOnly(2026, 11, 3), true),
            new(new DateOnly(2026, 11, 4), false),
        };
        var habits = new List<StatsHabitRow>
        {
            new(habitId, "Đi bộ", 0, true, new DateOnly(2026, 9, 1)),
        };
        var logs = Enumerable.Range(0, 14)
            .Select(i => new StatsHabitLogRow(habitId, new DateOnly(2026, 10, 26).AddDays(i)))
            .Concat(Enumerable.Range(0, 7)
                .Select(i => new StatsHabitLogRow(habitId, new DateOnly(2026, 9, 28).AddDays(i))))
            .ToList();

        var result = Build(tasks, habits, logs);

        Assert.Equal(75, result.Hero.CompletionPercent);
        Assert.Equal(25, result.Hero.DeltaPoints);
        Assert.Equal(3, result.Kpis.TasksDone);
        Assert.Equal(200, result.Kpis.TasksDonePercentChange);
        Assert.Equal(50, result.Kpis.HabitPercent);
        Assert.Equal(25, result.Kpis.HabitDeltaPoints);
        Assert.Equal(result.Hero.CompletionPercent, result.Trend.AveragePercent);
    }

    [Fact]
    public void Build_summarizes_goal_statuses_and_life_areas()
    {
        var goals = new List<StatsGoalRow>
        {
            new(Health.Id, GoalStatus.Done),
            new(Health.Id, GoalStatus.InProgress),
            new(Finance.Id, GoalStatus.NotStarted),
        };

        var summary = Build(goals: goals, areas: [Health, Career, Finance]).Goals;

        Assert.Equal(3, summary.Total);
        Assert.Equal(33, summary.PercentDone);
        Assert.Equal((1, 1, 1),
            (summary.ByStatus.NotStarted, summary.ByStatus.InProgress, summary.ByStatus.Done));
        Assert.Collection(summary.ByArea,
            health => Assert.Equal((LifeArea.Health, 1, 2), (health.Key, health.Done, health.Total)),
            finance => Assert.Equal((LifeArea.Finance, 0, 1), (finance.Key, finance.Done, finance.Total)));
    }

    [Theory]
    [InlineData("12w", "2026-08-31", "2026-06-08")]
    [InlineData("6m", "2026-05-23", "2025-11-20")]
    [InlineData("1y", "2025-11-23", "2024-11-23")]
    public void Build_uses_calendar_ranges_and_equal_previous_day_counts(
        string range,
        string expectedFrom,
        string expectedPreviousFrom)
    {
        var result = StatsCalculator.Build(range, Today, [], [], [], [], []);

        Assert.Equal(DateOnly.Parse(expectedFrom), result.From);
        Assert.Equal(DateOnly.Parse(expectedPreviousFrom), result.PreviousFrom);
        Assert.Equal(
            result.To.DayNumber - result.From.DayNumber,
            result.PreviousTo.DayNumber - result.PreviousFrom.DayNumber);
    }

    [Fact]
    public void Build_attributes_unknown_range_error_to_range()
    {
        var error = Assert.Throws<ArgumentOutOfRangeException>(
            () => StatsCalculator.Build("2w", Today, [], [], [], [], []));

        Assert.Equal("range", error.ParamName);
    }

    private static readonly MyPlanner.Core.Dtos.GoalAreaDto Health = new(Guid.NewGuid(), LifeArea.Health, null);
    private static readonly MyPlanner.Core.Dtos.GoalAreaDto Career = new(Guid.NewGuid(), LifeArea.Career, null);
    private static readonly MyPlanner.Core.Dtos.GoalAreaDto Finance = new(Guid.NewGuid(), LifeArea.Finance, null);

    private static MyPlanner.Core.Dtos.StatsDto Build(
        IReadOnlyList<StatsTaskRow>? tasks = null,
        IReadOnlyList<StatsHabitRow>? habits = null,
        IReadOnlyList<StatsHabitLogRow>? logs = null,
        IReadOnlyList<StatsGoalRow>? goals = null,
        IReadOnlyList<MyPlanner.Core.Dtos.GoalAreaDto>? areas = null) =>
        StatsCalculator.Build(
            "4w",
            Today,
            tasks ?? [],
            habits ?? [],
            logs ?? [],
            goals ?? [],
            areas ?? []);
}
