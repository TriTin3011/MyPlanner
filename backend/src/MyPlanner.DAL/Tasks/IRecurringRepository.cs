using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Tasks;

public interface IRecurringRepository
{
    Task<List<RecurringTaskDto>> ListAsync(CancellationToken ct);
    Task<RecurringTaskDto?> GetAsync(Guid id, CancellationToken ct);
    Task<List<RecurringTask>> ListActiveEntitiesAsync(CancellationToken ct);
    Task<RecurringTask?> FindAsync(Guid id, CancellationToken ct);
    void Add(RecurringTask rule);
    void Remove(RecurringTask rule);
    Task SaveChangesAsync(CancellationToken ct);
}
