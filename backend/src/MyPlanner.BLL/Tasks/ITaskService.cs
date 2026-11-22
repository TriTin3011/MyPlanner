using MyPlanner.BLL.Common;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Tasks;

namespace MyPlanner.BLL.Tasks;

public interface ITaskService
{
    Task<List<TaskDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct);
    Task<List<TaskDto>> BacklogAsync(DateOnly today, CancellationToken ct);
    Task<TaskDto> CreateAsync(SaveTaskRequest req, CancellationToken ct);
    Task<TaskDto> UpdateAsync(Guid id, SaveTaskRequest req, CancellationToken ct);
    Task<TaskDto> SetDoneAsync(Guid id, bool done, CancellationToken ct);
    Task DeleteAsync(Guid id, CancellationToken ct);
    Task<int> MoveBacklogToTodayAsync(DateOnly today, CancellationToken ct);
    Task ReorderAsync(ReorderTasksRequest req, CancellationToken ct);
}
