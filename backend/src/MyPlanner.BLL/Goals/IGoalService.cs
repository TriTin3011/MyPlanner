using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Goals;

public interface IGoalService
{
    Task<List<GoalDto>> ListAsync(CancellationToken ct);
    Task<GoalDto> GetAsync(Guid id, CancellationToken ct);
    Task<GoalDto> CreateAsync(SaveGoalRequest req, CancellationToken ct);
    Task<GoalDto> UpdateAsync(Guid id, SaveGoalRequest req, CancellationToken ct);
    Task DeleteAsync(Guid id, CancellationToken ct);
    Task<GoalDto> AddStepAsync(Guid goalId, SaveGoalStepRequest req, CancellationToken ct);
    Task<GoalDto> UpdateStepAsync(Guid goalId, Guid stepId, SaveGoalStepRequest req, CancellationToken ct);
    Task<GoalDto> DeleteStepAsync(Guid goalId, Guid stepId, CancellationToken ct);
    // Sắp lại bước theo thứ tự id client gửi (kéo thả trong Goal Drawer). Ids phải đúng bằng tập bước hiện có.
    Task<GoalDto> ReorderStepsAsync(Guid goalId, IReadOnlyList<Guid> ids, CancellationToken ct);
    // Read model màn Mục tiêu (SPEC §7), số liệu theo today của client.
    Task<GoalBoardDto> GetBoardAsync(DateOnly today, CancellationToken ct);
    // Dòng hạn (bước + mục tiêu) trong [from, to], "quá hạn" tính theo today của client.
    Task<List<DeadlineDto>> GetDeadlinesAsync(DateOnly from, DateOnly to, DateOnly today, CancellationToken ct);
}
