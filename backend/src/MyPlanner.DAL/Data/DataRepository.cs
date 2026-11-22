using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Data;

public class DataRepository(AppDbContext db) : IDataRepository
{
    public async Task<BackupDto> ExportAsync(DateTimeOffset now, CancellationToken ct) => new(
        BackupDto.CurrentVersion,
        now,
        await db.Tasks.AsNoTracking().OrderBy(t => t.Date).ThenBy(t => t.Order).Select(Projections.Task).ToListAsync(ct),
        await db.RecurringTasks.AsNoTracking().OrderBy(r => r.CreatedAt).Select(Projections.Recurring).ToListAsync(ct),
        await db.Habits.AsNoTracking().OrderBy(h => h.Order).Select(Projections.Habit).ToListAsync(ct),
        await db.HabitLogs.AsNoTracking().OrderBy(l => l.Date).Select(l => new HabitLogDto(l.HabitId, l.Date)).ToListAsync(ct),
        await db.Goals.AsNoTracking().OrderBy(g => g.CreatedAt).Select(Projections.Goal).ToListAsync(ct),
        await db.DayNotes.AsNoTracking().OrderBy(n => n.Date).Select(n => new DayNoteDto(n.Date, n.Content, n.UpdatedAt)).ToListAsync(ct),
        await db.WeekNotes.AsNoTracking().OrderBy(n => n.WeekKey).Select(n => new WeekNoteDto(n.WeekKey, n.Content, n.UpdatedAt)).ToListAsync(ct),
        await db.YearMeta.AsNoTracking().OrderBy(y => y.Year).Select(y => new YearMetaDto(y.Year, y.Keyword, y.Vision)).ToListAsync(ct),
        await db.YearPlanItems.AsNoTracking().OrderBy(i => i.Year).ThenBy(i => i.Month).ThenBy(i => i.Order).Select(Projections.YearItem).ToListAsync(ct));

    // Xoá sạch rồi ghi lại trong MỘT transaction: lỗi giữa chừng thì rollback, dữ liệu cũ còn nguyên.
    public async Task ReplaceAllAsync(BackupDto d, CancellationToken ct)
    {
        await using var tx = await db.Database.BeginTransactionAsync(ct);

        // Xoá con trước cha (FK). ExecuteDelete chạy SQL ngay, nằm trong transaction ở trên.
        await db.Subtasks.ExecuteDeleteAsync(ct);
        await db.Tasks.ExecuteDeleteAsync(ct);
        await db.RecurringTasks.ExecuteDeleteAsync(ct);
        await db.HabitLogs.ExecuteDeleteAsync(ct);
        await db.Habits.ExecuteDeleteAsync(ct);
        await db.GoalSteps.ExecuteDeleteAsync(ct);
        await db.Goals.ExecuteDeleteAsync(ct);
        await db.DayNotes.ExecuteDeleteAsync(ct);
        await db.WeekNotes.ExecuteDeleteAsync(ct);
        await db.YearPlanItems.ExecuteDeleteAsync(ct);
        await db.YearMeta.ExecuteDeleteAsync(ct);

        // Map DTO → entity viết tay (chiều ngược của Projections).
        db.Tasks.AddRange(d.Tasks.Select(t => new TaskItem
        {
            Id = t.Id, Title = t.Title, Date = t.Date, OriginalDate = t.OriginalDate, Done = t.Done, DoneAt = t.DoneAt,
            Tags = [.. t.Tags], RecurringId = t.RecurringId, Order = t.Order, CreatedAt = t.CreatedAt, UpdatedAt = t.UpdatedAt,
            Subtasks = t.Subtasks.Select((s, i) => new Subtask { Id = s.Id, TaskId = t.Id, Title = s.Title, Done = s.Done, Order = i }).ToList(),
        }));
        db.RecurringTasks.AddRange(d.Recurring.Select(r => new RecurringTask
        {
            Id = r.Id, Title = r.Title, Weekdays = [.. r.Weekdays], Tags = [.. r.Tags], Active = r.Active,
            StartDate = r.StartDate, SkippedDates = [.. r.SkippedDates], CreatedAt = r.CreatedAt,
        }));
        db.Habits.AddRange(d.Habits.Select(h => new Habit
        {
            Id = h.Id, Title = h.Title, Order = h.Order, Active = h.Active, StartDate = h.StartDate,
            CreatedAt = h.CreatedAt, ArchivedAt = h.ArchivedAt,
        }));
        db.HabitLogs.AddRange(d.HabitLogs.Select(l => new HabitLog { HabitId = l.HabitId, Date = l.Date }));
        db.Goals.AddRange(d.Goals.Select(g => new Goal
        {
            Id = g.Id, Title = g.Title, Area = g.Area, Status = g.Status, StartDate = g.StartDate, Deadline = g.Deadline,
            Reward = g.Reward, Why = g.Why, CreatedAt = g.CreatedAt, CompletedAt = g.CompletedAt,
            Steps = g.Steps.Select(s => new GoalStep
            {
                Id = s.Id, GoalId = g.Id, Title = s.Title, Deadline = s.Deadline, Done = s.Done, DoneAt = s.DoneAt, Order = s.Order,
            }).ToList(),
        }));
        db.DayNotes.AddRange(d.DayNotes.Select(n => new DayNote { Date = n.Date, Content = n.Content, UpdatedAt = n.UpdatedAt ?? DateTimeOffset.UtcNow }));
        db.WeekNotes.AddRange(d.WeekNotes.Select(n => new WeekNote { WeekKey = n.WeekKey, Content = n.Content, UpdatedAt = n.UpdatedAt ?? DateTimeOffset.UtcNow }));
        db.YearMeta.AddRange(d.Years.Select(y => new YearMeta { Year = y.Year, Keyword = y.Keyword, Vision = y.Vision }));
        db.YearPlanItems.AddRange(d.YearItems.Select(i => new YearPlanItem
        {
            Id = i.Id, Year = i.Year, Month = i.Month, Title = i.Title, Done = i.Done, Order = i.Order,
        }));

        await db.SaveChangesAsync(ct);
        await tx.CommitAsync(ct);
        db.ChangeTracker.Clear();
    }
}
