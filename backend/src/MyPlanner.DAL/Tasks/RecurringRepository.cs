using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Tasks;

public class RecurringRepository(AppDbContext db) : IRecurringRepository
{
    public Task<List<RecurringTaskDto>> ListAsync(CancellationToken ct) =>
        db.RecurringTasks.AsNoTracking().OrderBy(r => r.CreatedAt).Select(Projections.Recurring).ToListAsync(ct);

    public Task<RecurringTaskDto?> GetAsync(Guid id, CancellationToken ct) =>
        db.RecurringTasks.AsNoTracking().Where(r => r.Id == id).Select(Projections.Recurring).FirstOrDefaultAsync(ct);

    // Hàm Recurrence.DatesToCreate (Core) cần entity nên ở đây đọc entity, AsNoTracking vì chỉ đọc.
    public Task<List<RecurringTask>> ListActiveEntitiesAsync(CancellationToken ct) =>
        db.RecurringTasks.AsNoTracking().Where(r => r.Active).ToListAsync(ct);

    public Task<RecurringTask?> FindAsync(Guid id, CancellationToken ct) =>
        db.RecurringTasks.FirstOrDefaultAsync(r => r.Id == id, ct);

    public void Add(RecurringTask rule) => db.RecurringTasks.Add(rule);
    public void Remove(RecurringTask rule) => db.RecurringTasks.Remove(rule);
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
