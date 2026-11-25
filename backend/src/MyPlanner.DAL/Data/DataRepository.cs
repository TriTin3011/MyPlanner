using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Goals;

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
        await db.YearPlanItems.AsNoTracking().OrderBy(i => i.Year).ThenBy(i => i.Month).ThenBy(i => i.Order).Select(Projections.YearItem).ToListAsync(ct),
        await db.GoalAreas.AsNoTracking().OrderBy(a => a.Order).ThenBy(a => a.CreatedAt)
            .Select(a => new GoalAreaDto(a.Id, a.Key, a.Name)).ToListAsync(ct));

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
        await db.GoalAreas.ExecuteDeleteAsync(ct);
        await db.DayNotes.ExecuteDeleteAsync(ct);
        await db.WeekNotes.ExecuteDeleteAsync(ct);
        await db.YearPlanItems.ExecuteDeleteAsync(ct);
        await db.YearMeta.ExecuteDeleteAsync(ct);

        // Id trong file sao lưu được cấp MỚI hết. Khoá chính là Id toàn cục (không kèm UserId), nên nếu hai tài khoản
        // cùng nhập một file, giữ Id cũ sẽ trùng khoá với dòng của người kia (dòng đó bị filter giấu, nhưng DB vẫn thấy).
        // Bảng tra cũ → mới giữ nguyên các liên kết: task → việc lặp lại, log → thói quen.
        var recurringIds = d.Recurring.ToDictionary(r => r.Id, _ => Guid.NewGuid());
        var habitIds = d.Habits.ToDictionary(h => h.Id, _ => Guid.NewGuid());
        Guid? NewRecurringId(Guid? old) => old is { } id && recurringIds.TryGetValue(id, out var n) ? n : null;

        // Map DTO → entity viết tay (chiều ngược của Projections).
        db.Tasks.AddRange(d.Tasks.Select(t =>
        {
            var taskId = Guid.NewGuid();
            return new TaskItem
            {
                Id = taskId, Title = t.Title, Date = t.Date, OriginalDate = t.OriginalDate, Done = t.Done, DoneAt = t.DoneAt,
                Tags = [.. t.Tags], RecurringId = NewRecurringId(t.RecurringId), Order = t.Order, CreatedAt = t.CreatedAt, UpdatedAt = t.UpdatedAt,
                Subtasks = t.Subtasks.Select((s, i) => new Subtask { Id = Guid.NewGuid(), TaskId = taskId, Title = s.Title, Done = s.Done, Order = i }).ToList(),
            };
        }));
        db.RecurringTasks.AddRange(d.Recurring.Select(r => new RecurringTask
        {
            Id = recurringIds[r.Id], Title = r.Title, Weekdays = [.. r.Weekdays], Tags = [.. r.Tags], Active = r.Active,
            StartDate = r.StartDate, SkippedDates = [.. r.SkippedDates], CreatedAt = r.CreatedAt,
        }));
        db.Habits.AddRange(d.Habits.Select(h => new Habit
        {
            Id = habitIds[h.Id], Title = h.Title, Order = h.Order, Active = h.Active, StartDate = h.StartDate,
            CreatedAt = h.CreatedAt, ArchivedAt = h.ArchivedAt,
        }));
        // Log trỏ tới thói quen không có trong file thì bỏ (trước đây FK cũng sẽ từ chối).
        db.HabitLogs.AddRange(d.HabitLogs
            .Where(l => habitIds.ContainsKey(l.HabitId))
            .Select(l => new HabitLog { HabitId = habitIds[l.HabitId], Date = l.Date }));
        // Lĩnh vực: luôn tạo lại đủ 8 lĩnh vực có sẵn, rồi thêm lĩnh vực riêng trong file (bỏ tên trùng, tối đa MaxCustom).
        var builtIns = GoalAreaRepository.BuiltIns(DateTimeOffset.UtcNow);
        var areaByKey = builtIns.ToDictionary(a => a.Key!.Value, a => a.Id);
        var areaIds = new Dictionary<Guid, Guid>();
        var customs = new List<GoalArea>();
        foreach (var a in d.Areas ?? [])
        {
            if (a.Key is { } key) { areaIds[a.Id] = areaByKey[key]; continue; }
            var name = a.Name?.Trim();
            if (string.IsNullOrEmpty(name) || name.Length > GoalAreaLimits.NameMaxLength) continue;
            var same = customs.FirstOrDefault(c => string.Equals(c.Name, name, StringComparison.OrdinalIgnoreCase));
            if (same is not null) { areaIds[a.Id] = same.Id; continue; }
            if (customs.Count >= GoalAreaLimits.MaxCustom) continue;
            var custom = new GoalArea
            {
                Id = Guid.NewGuid(), Name = name, Order = builtIns.Count + customs.Count, CreatedAt = DateTimeOffset.UtcNow,
            };
            customs.Add(custom);
            areaIds[a.Id] = custom.Id;
        }
        db.GoalAreas.AddRange(builtIns);
        db.GoalAreas.AddRange(customs);
        // File v1 chỉ có "area": "health"; file v2 có areaId. Không khớp được thì đưa về "Phát triển".
        Guid NewAreaId(GoalDto g) =>
            areaIds.TryGetValue(g.AreaId, out var n) ? n
            : g.LegacyArea is { } legacy ? areaByKey[legacy]
            : areaByKey[LifeArea.Growth];

        db.Goals.AddRange(d.Goals.Select(g =>
        {
            var goalId = Guid.NewGuid();
            return new Goal
            {
                Id = goalId, Title = g.Title, AreaId = NewAreaId(g), Status = g.Status, StartDate = g.StartDate, Deadline = g.Deadline,
                Reward = g.Reward, Why = g.Why, CreatedAt = g.CreatedAt, CompletedAt = g.CompletedAt,
                Steps = g.Steps.Select(s => new GoalStep
                {
                    Id = Guid.NewGuid(), GoalId = goalId, Title = s.Title, Deadline = s.Deadline, Done = s.Done, DoneAt = s.DoneAt, Order = s.Order,
                }).ToList(),
            };
        }));
        db.DayNotes.AddRange(d.DayNotes.Select(n => new DayNote { Date = n.Date, Content = n.Content, UpdatedAt = n.UpdatedAt ?? DateTimeOffset.UtcNow }));
        db.WeekNotes.AddRange(d.WeekNotes.Select(n => new WeekNote { WeekKey = n.WeekKey, Content = n.Content, UpdatedAt = n.UpdatedAt ?? DateTimeOffset.UtcNow }));
        db.YearMeta.AddRange(d.Years.Select(y => new YearMeta { Year = y.Year, Keyword = y.Keyword, Vision = y.Vision }));
        db.YearPlanItems.AddRange(d.YearItems.Select(i => new YearPlanItem
        {
            Id = Guid.NewGuid(), Year = i.Year, Month = i.Month, Title = i.Title, Done = i.Done, Order = i.Order,
        }));

        await db.SaveChangesAsync(ct);
        await tx.CommitAsync(ct);
        db.ChangeTracker.Clear();
    }
}
