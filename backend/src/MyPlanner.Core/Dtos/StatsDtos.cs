using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Dtos;

public record StatsQuery(string Range, DateOnly Today);

public record StatsDto(
    string Range,
    DateOnly From,
    DateOnly To,
    DateOnly PreviousFrom,
    DateOnly PreviousTo,
    StatsHeroDto Hero,
    StatsKpisDto Kpis,
    StatsTrendDto Trend,
    IReadOnlyList<StatsHeatmapDayDto> Heatmap,
    IReadOnlyList<StatsWeekdayDto> WeekdayProductivity,
    IReadOnlyList<StatsHabitDto> HabitConsistency,
    StatsGoalsDto Goals);

public record StatsHeroDto(
    int CompletionPercent,
    int TasksDone,
    int TasksTotal,
    int DeltaPoints,
    int? BestWeekday,
    IReadOnlyList<StatsWeekPointDto> WeeklySparkline);

public record StatsKpisDto(
    int TasksDone,
    int? TasksDonePercentChange,
    int ActivityCurrentStreak,
    int ActivityLongestStreak,
    int HabitPercent,
    int HabitDeltaPoints);

public record StatsTrendDto(int AveragePercent, IReadOnlyList<StatsWeekPointDto> Points);

public record StatsWeekPointDto(
    string WeekKey,
    DateOnly Monday,
    int Done,
    int Total,
    int Percent);

public record StatsHeatmapDayDto(DateOnly Date, int Done, int Level);

public record StatsWeekdayDto(int Weekday, double AverageDone);

public record StatsHabitDto(
    Guid HabitId,
    string Title,
    int Percent,
    int DoneDays,
    int PossibleDays,
    int CurrentStreak,
    int LongestStreak);

public record StatsGoalsDto(
    int Total,
    int PercentDone,
    StatsGoalStatusDto ByStatus,
    IReadOnlyList<StatsGoalAreaDto> ByArea);

public record StatsGoalStatusDto(int NotStarted, int InProgress, int Done);

public record StatsGoalAreaDto(LifeArea Area, int Done, int Total);
