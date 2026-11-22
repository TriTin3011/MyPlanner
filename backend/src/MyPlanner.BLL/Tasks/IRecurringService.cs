using MyPlanner.BLL.Common;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Tasks;

namespace MyPlanner.BLL.Tasks;

public interface IRecurringService
{
    Task<List<RecurringTaskDto>> ListAsync(CancellationToken ct);
    Task<RecurringTaskDto> CreateAsync(SaveRecurringRequest req, CancellationToken ct);
    Task<RecurringTaskDto> UpdateAsync(Guid id, SaveRecurringRequest req, CancellationToken ct);
    Task DeleteAsync(Guid id, CancellationToken ct);
    Task<int> MaterializeAsync(DateOnly from, DateOnly to, DateOnly today, CancellationToken ct);
}
