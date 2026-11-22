namespace MyPlanner.Core.Domain;

// Dashboard prose belongs to the presentation culture, not the domain calculation.
// Core receives this source from BLL so it remains free of localization resources and framework dependencies.
public interface IWeekTextSource
{
    string NewWeekComment { get; }
    string NoTasksDoneComment { get; }
    string SlowWeekComment { get; }
    string FindingRhythmComment { get; }
    string GoodWeekComment { get; }
    string ExcellentWeekComment { get; }
    string FewerTasks(int count);
    string MoreTasks(int count);
    string SameTasks { get; }
    string HabitDecrease(int percent);
    string HabitIncrease(int percent);
    string BestDay(DateOnly date, int tasksDone);
    string NoHabitTicks { get; }
}
