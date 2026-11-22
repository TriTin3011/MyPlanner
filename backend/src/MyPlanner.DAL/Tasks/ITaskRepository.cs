using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Tasks;

// Repository của aggregate Task (Task + Subtasks).
// Đọc: AsNoTracking + Select ra DTO (chỉ lấy cột cần, không bật change tracker).
// Ghi: trả entity đã track để service sửa, rồi SaveChangesAsync một lần.
public interface ITaskRepository
{
    Task<TaskDto?> GetAsync(Guid id, CancellationToken ct);
    Task<List<TaskDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct);
    Task<List<TaskDto>> BacklogAsync(DateOnly today, CancellationToken ct);

    Task<TaskItem?> FindAsync(Guid id, CancellationToken ct);
    Task<List<TaskItem>> FindManyAsync(IReadOnlyCollection<Guid> ids, CancellationToken ct);
    Task<List<TaskItem>> FindUndoneBeforeAsync(DateOnly today, CancellationToken ct);
    Task<int> NextOrderAsync(DateOnly date, CancellationToken ct);
    Task<HashSet<(Guid RecurringId, DateOnly Date)>> RecurringDatesAsync(DateOnly from, DateOnly to, CancellationToken ct);
    Task<int> DeleteRangeAsync(DateOnly from, DateOnly to, CancellationToken ct);

    void Add(TaskItem task);
    void Remove(TaskItem task);
    Task SaveChangesAsync(CancellationToken ct);
}
