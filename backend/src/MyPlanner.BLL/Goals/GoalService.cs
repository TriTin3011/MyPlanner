using MyPlanner.BLL.Common;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Goals;

namespace MyPlanner.BLL.Goals;

// Mọi thao tác trên bước đều đi qua Goal (aggregate root), rồi trả lại cả Goal để FE cập nhật thẻ một lần.
public class GoalService(IGoalRepository goals, TimeProvider clock) : IGoalService
{
    public Task<List<GoalDto>> ListAsync(CancellationToken ct) => goals.ListAsync(ct);

    public async Task<GoalDto> GetAsync(Guid id, CancellationToken ct) =>
        await goals.GetAsync(id, ct) ?? throw AppException.NotFound("Mục tiêu");

    public async Task<GoalDto> CreateAsync(SaveGoalRequest req, CancellationToken ct)
    {
        var now = clock.GetUtcNow();
        var goal = new Goal { Id = Guid.NewGuid(), CreatedAt = now };
        Apply(goal, req, now);
        goals.Add(goal);
        await goals.SaveChangesAsync(ct);
        return await GetAsync(goal.Id, ct);
    }

    public async Task<GoalDto> UpdateAsync(Guid id, SaveGoalRequest req, CancellationToken ct)
    {
        var goal = await goals.FindAsync(id, ct) ?? throw AppException.NotFound("Mục tiêu");
        Apply(goal, req, clock.GetUtcNow());
        await goals.SaveChangesAsync(ct);
        return await GetAsync(id, ct);
    }

    public async Task DeleteAsync(Guid id, CancellationToken ct)
    {
        var goal = await goals.FindAsync(id, ct) ?? throw AppException.NotFound("Mục tiêu");
        goals.Remove(goal);
        await goals.SaveChangesAsync(ct);
    }

    public async Task<GoalDto> AddStepAsync(Guid goalId, SaveGoalStepRequest req, CancellationToken ct)
    {
        var goal = await goals.FindAsync(goalId, ct) ?? throw AppException.NotFound("Mục tiêu");
        var now = clock.GetUtcNow();
        goal.Steps.Add(new GoalStep
        {
            Id = Guid.NewGuid(), GoalId = goalId, Title = req.Title.Trim(), Deadline = req.Deadline,
            Done = req.Done, DoneAt = req.Done ? now : null,
            Order = goal.Steps.Count == 0 ? 0 : goal.Steps.Max(s => s.Order) + 1,
        });
        PromoteStatus(goal);
        await goals.SaveChangesAsync(ct);
        return await GetAsync(goalId, ct);
    }

    public async Task<GoalDto> UpdateStepAsync(Guid goalId, Guid stepId, SaveGoalStepRequest req, CancellationToken ct)
    {
        var goal = await goals.FindAsync(goalId, ct) ?? throw AppException.NotFound("Mục tiêu");
        var step = goal.Steps.FirstOrDefault(s => s.Id == stepId) ?? throw AppException.NotFound("Bước");
        step.Title = req.Title.Trim();
        step.Deadline = req.Deadline;
        if (step.Done != req.Done) step.DoneAt = req.Done ? clock.GetUtcNow() : null;
        step.Done = req.Done;
        PromoteStatus(goal);
        await goals.SaveChangesAsync(ct);
        return await GetAsync(goalId, ct);
    }

    public async Task<GoalDto> DeleteStepAsync(Guid goalId, Guid stepId, CancellationToken ct)
    {
        var goal = await goals.FindAsync(goalId, ct) ?? throw AppException.NotFound("Mục tiêu");
        var step = goal.Steps.FirstOrDefault(s => s.Id == stepId) ?? throw AppException.NotFound("Bước");
        goal.Steps.Remove(step); // bỏ khỏi navigation collection: EF xoá dòng con (orphan, FK bắt buộc)
        await goals.SaveChangesAsync(ct);
        return await GetAsync(goalId, ct);
    }

    public async Task<GoalDto> ReorderStepsAsync(Guid goalId, IReadOnlyList<Guid> ids, CancellationToken ct)
    {
        var goal = await goals.FindAsync(goalId, ct) ?? throw AppException.NotFound("Mục tiêu");
        // Bắt buộc gửi đủ và đúng tập bước: tránh trường hợp client cũ (thiếu bước vừa thêm) làm lệch thứ tự.
        if (ids.Count != goal.Steps.Count || !goal.Steps.Select(s => s.Id).ToHashSet().SetEquals(ids))
            throw AppException.BadRequest("Danh sách bước không khớp với mục tiêu.");
        var position = ids.Select((id, i) => (id, i)).ToDictionary(x => x.id, x => x.i);
        foreach (var step in goal.Steps) step.Order = position[step.Id];
        await goals.SaveChangesAsync(ct);
        return await GetAsync(goalId, ct);
    }

    public async Task<GoalBoardDto> GetBoardAsync(DateOnly today, CancellationToken ct) =>
        GoalBoard.Build(await goals.ListAsync(ct), today);

    // Ghép hạn bước và hạn mục tiêu thành một danh sách, sắp theo ngày rồi đặt hạn mục tiêu sau hạn bước.
    public async Task<List<DeadlineDto>> GetDeadlinesAsync(DateOnly from, DateOnly to, DateOnly today, CancellationToken ct)
    {
        var steps = await goals.StepDeadlinesAsync(from, to, ct);
        var goalRows = await goals.GoalDeadlinesAsync(from, to, ct);

        return steps
            .Select(s => new DeadlineDto(s.Deadline, DeadlineKind.Step, s.GoalId, s.GoalTitle, s.Title, s.Done,
                IsOverdue(s.Deadline, s.Done, today)))
            .Concat(goalRows.Select(g => new DeadlineDto(g.Deadline, DeadlineKind.Goal, g.GoalId, g.Title, g.Title, g.Done,
                IsOverdue(g.Deadline, g.Done, today))))
            .OrderBy(d => d.Date)
            .ThenBy(d => d.Kind)
            .ToList();
    }

    // SPEC §13.4: quá hạn = chưa xong và hạn đã qua (hạn đúng hôm nay thì chưa quá).
    private static bool IsOverdue(DateOnly deadline, bool done, DateOnly today) => !done && deadline < today;

    private static void Apply(Goal goal, SaveGoalRequest req, DateTimeOffset now)
    {
        goal.Title = req.Title.Trim();
        goal.Area = req.Area;
        goal.StartDate = req.StartDate;
        goal.Deadline = req.Deadline;
        goal.Reward = string.IsNullOrWhiteSpace(req.Reward) ? null : req.Reward.Trim();
        goal.Why = string.IsNullOrWhiteSpace(req.Why) ? null : req.Why.Trim();
        if (goal.Status != GoalStatus.Done && req.Status == GoalStatus.Done) goal.CompletedAt = now;
        if (req.Status != GoalStatus.Done) goal.CompletedAt = null;
        goal.Status = req.Status;
    }

    // SPEC §12.4: có bước đầu tiên xong thì tự chuyển "chưa bắt đầu" → "đang làm".
    private static void PromoteStatus(Goal goal)
    {
        if (goal.Status == GoalStatus.NotStarted && goal.Steps.Any(s => s.Done)) goal.Status = GoalStatus.InProgress;
    }
}
