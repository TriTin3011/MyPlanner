using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Tasks;

namespace MyPlanner.BLL.Tasks;

public class RecurringService(IRecurringRepository rules, ITaskRepository tasks, TimeProvider clock) : IRecurringService
{
    public Task<List<RecurringTaskDto>> ListAsync(CancellationToken ct) => rules.ListAsync(ct);

    public async Task<RecurringTaskDto> CreateAsync(SaveRecurringRequest req, CancellationToken ct)
    {
        var rule = new RecurringTask
        {
            Id = Guid.NewGuid(),
            Title = req.Title.Trim(),
            Weekdays = req.Weekdays.Distinct().Order().ToList(),
            Tags = req.Tags?.Distinct().ToList() ?? [],
            Active = req.Active,
            StartDate = req.StartDate,
            CreatedAt = clock.GetUtcNow(),
        };
        rules.Add(rule);
        await rules.SaveChangesAsync(ct);
        return (await rules.GetAsync(rule.Id, ct))!;
    }

    public async Task<RecurringTaskDto> UpdateAsync(Guid id, SaveRecurringRequest req, CancellationToken ct)
    {
        var rule = await rules.FindAsync(id, ct) ?? throw AppException.NotFound(Messages.RecurringTask);
        rule.Title = req.Title.Trim();
        rule.Weekdays = req.Weekdays.Distinct().Order().ToList();
        rule.Tags = req.Tags?.Distinct().ToList() ?? [];
        rule.Active = req.Active;
        rule.StartDate = req.StartDate;
        await rules.SaveChangesAsync(ct);
        return (await rules.GetAsync(id, ct))!;
    }

    // Xoá khuôn: các Task đã sinh vẫn giữ (là lịch sử), chỉ không sinh thêm.
    public async Task DeleteAsync(Guid id, CancellationToken ct)
    {
        var rule = await rules.FindAsync(id, ct) ?? throw AppException.NotFound(Messages.RecurringTask);
        rules.Remove(rule);
        await rules.SaveChangesAsync(ct);
    }

    // Sinh Task cho các ngày trong [from, to] (không quá today + 7). Gọi qua POST, không gắn vào GET (SPEC §14.2).
    // Idempotent: gọi nhiều lần không sinh trùng vì bỏ qua (recurringId, date) đã có.
    public async Task<int> MaterializeAsync(DateOnly from, DateOnly to, DateOnly today, CancellationToken ct)
    {
        var active = await rules.ListActiveEntitiesAsync(ct);
        if (active.Count == 0) return 0;

        var existing = await tasks.RecurringDatesAsync(from, to, ct);
        var now = clock.GetUtcNow();
        var created = 0;
        var nextOrder = new Dictionary<DateOnly, int>();

        foreach (var rule in active)
        {
            var have = existing.Where(e => e.RecurringId == rule.Id).Select(e => e.Date).ToHashSet();
            foreach (var date in Recurrence.DatesToCreate(rule, from, to, today, have))
            {
                if (!nextOrder.TryGetValue(date, out var order)) order = await tasks.NextOrderAsync(date, ct);
                nextOrder[date] = order + 1;
                tasks.Add(new TaskItem
                {
                    Id = Guid.NewGuid(), Title = rule.Title, Date = date, Tags = [.. rule.Tags],
                    RecurringId = rule.Id, Order = order, CreatedAt = now, UpdatedAt = now,
                });
                created++;
            }
        }

        if (created > 0) await tasks.SaveChangesAsync(ct);
        return created;
    }
}
