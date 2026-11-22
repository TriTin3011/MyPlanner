using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Tasks;

public class TaskRepository(AppDbContext db) : ITaskRepository
{
    public Task<TaskDto?> GetAsync(Guid id, CancellationToken ct) =>
        db.Tasks.AsNoTracking().Where(t => t.Id == id).Select(Projections.Task).FirstOrDefaultAsync(ct);

    public Task<List<TaskDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
        db.Tasks.AsNoTracking()
            .Where(t => t.Date >= from && t.Date <= to)
            .OrderBy(t => t.Date).ThenBy(t => t.Order)
            .Select(Projections.Task)
            .ToListAsync(ct);

    public Task<List<TaskDto>> BacklogAsync(DateOnly today, CancellationToken ct) =>
        db.Tasks.AsNoTracking()
            .Where(t => !t.Done && t.Date < today)
            .OrderBy(t => t.Date).ThenBy(t => t.Order)
            .Select(Projections.Task)
            .ToListAsync(ct);

    public Task<TaskItem?> FindAsync(Guid id, CancellationToken ct) =>
        db.Tasks.Include(t => t.Subtasks).FirstOrDefaultAsync(t => t.Id == id, ct);

    public Task<List<TaskItem>> FindManyAsync(IReadOnlyCollection<Guid> ids, CancellationToken ct) =>
        db.Tasks.Where(t => ids.Contains(t.Id)).ToListAsync(ct);

    public Task<List<TaskItem>> FindUndoneBeforeAsync(DateOnly today, CancellationToken ct) =>
        db.Tasks.Where(t => !t.Done && t.Date < today).OrderBy(t => t.Date).ThenBy(t => t.Order).ToListAsync(ct);

    public async Task<int> NextOrderAsync(DateOnly date, CancellationToken ct) =>
        (await db.Tasks.Where(t => t.Date == date).MaxAsync(t => (int?)t.Order, ct) ?? -1) + 1;

    public async Task<HashSet<(Guid RecurringId, DateOnly Date)>> RecurringDatesAsync(
        DateOnly from, DateOnly to, CancellationToken ct)
    {
        var rows = await db.Tasks.AsNoTracking()
            .Where(t => t.RecurringId != null && t.Date >= from && t.Date <= to)
            .Select(t => new { RecurringId = t.RecurringId!.Value, t.Date })
            .ToListAsync(ct);
        return rows.Select(r => (r.RecurringId, r.Date)).ToHashSet();
    }

    // ExecuteDeleteAsync: một câu DELETE thẳng xuống DB, không tải entity lên bộ nhớ.
    public Task<int> DeleteRangeAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
        db.Tasks.Where(t => t.Date >= from && t.Date <= to).ExecuteDeleteAsync(ct);

    public void Add(TaskItem task) => db.Tasks.Add(task);
    public void Remove(TaskItem task) => db.Tasks.Remove(task);
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
