using MyPlanner.Core.Domain;

namespace MyPlanner.BLL.Localization;

internal sealed class LocalizedWeekTextSource : IWeekTextSource
{
    public static LocalizedWeekTextSource Instance { get; } = new();

    private LocalizedWeekTextSource() { }

    public string NewWeekComment => Messages.NewWeekComment;
    public string NoTasksDoneComment => Messages.NoTasksDoneComment;
    public string SlowWeekComment => Messages.SlowWeekComment;
    public string FindingRhythmComment => Messages.FindingRhythmComment;
    public string GoodWeekComment => Messages.GoodWeekComment;
    public string ExcellentWeekComment => Messages.ExcellentWeekComment;
    public string FewerTasks(int count) => Messages.FewerTasks(count);
    public string MoreTasks(int count) => Messages.MoreTasks(count);
    public string SameTasks => Messages.SameTasks;
    public string HabitDecrease(int percent) => Messages.HabitDecrease(percent);
    public string HabitIncrease(int percent) => Messages.HabitIncrease(percent);
    public string BestDay(DateOnly date, int tasksDone) => Messages.BestDay(date, tasksDone);
    public string NoHabitTicks => Messages.NoHabitTicks;
}
