using System.Linq.Expressions;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL;

// Map Entity → DTO viết tay, dạng Expression để EF dịch được sang SQL:
//   db.Tasks.Select(Projections.Task)  → SELECT đúng các cột DTO cần, kèm subquery bảng con.
// Bản đã Compile() dùng khi entity đã nằm trong bộ nhớ (ví dụ sau khi ghi).
// Thiếu một tham số constructor của record là lỗi biên dịch ngay, không phải lỗi lúc chạy.
public static class Projections
{
    public static readonly Expression<Func<TaskItem, TaskDto>> Task = t => new TaskDto(
        t.Id, t.Title, t.Date, t.OriginalDate, t.Done, t.DoneAt, t.Tags,
        t.Subtasks.OrderBy(s => s.Order).Select(s => new SubtaskDto(s.Id, s.Title, s.Done)).ToList(),
        t.RecurringId, t.Order, t.CreatedAt, t.UpdatedAt);

    public static readonly Expression<Func<RecurringTask, RecurringTaskDto>> Recurring = r => new RecurringTaskDto(
        r.Id, r.Title, r.Weekdays, r.Tags, r.Active, r.StartDate, r.SkippedDates, r.CreatedAt);

    public static readonly Expression<Func<Habit, HabitDto>> Habit = h => new HabitDto(
        h.Id, h.Title, h.Order, h.Active, h.StartDate, h.CreatedAt, h.ArchivedAt);

    public static readonly Expression<Func<Goal, GoalDto>> Goal = g => new GoalDto(
        g.Id, g.Title, g.AreaId, g.Status, g.StartDate, g.Deadline, g.Reward, g.Why,
        g.Steps.OrderBy(s => s.Order)
            .Select(s => new GoalStepDto(s.Id, s.Title, s.Deadline, s.Done, s.DoneAt, s.Order)).ToList(),
        g.CreatedAt, g.CompletedAt);

    public static readonly Expression<Func<YearPlanItem, YearPlanItemDto>> YearItem = i => new YearPlanItemDto(
        i.Id, i.Year, i.Month, i.Title, i.Done, i.Order);

    public static readonly Expression<Func<FocusSession, FocusSessionDto>> Focus = s => new FocusSessionDto(
        s.Id, s.StartedAt, s.EndedAt, s.Date, s.PlannedMinutes, s.ActualMinutes, s.Outcome, s.PlantKind, s.PotColor,
        s.TaskId, s.HabitId, s.GoalId);

    public static readonly Func<FocusSession, FocusSessionDto> ToFocusDto = Focus.Compile();
    public static readonly Func<TaskItem, TaskDto> ToTaskDto = Task.Compile();
    public static readonly Func<Goal, GoalDto> ToGoalDto = Goal.Compile();
}
