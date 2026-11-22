using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Goals;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api/goals")]
public class GoalsController(IGoalService goals) : ControllerBase
{
    [HttpGet]
    public Task<List<GoalDto>> List(CancellationToken ct) => goals.ListAsync(ct);

    [HttpGet("{id:guid}")]
    public Task<GoalDto> Get(Guid id, CancellationToken ct) => goals.GetAsync(id, ct);

    [HttpPost]
    [ProducesResponseType<GoalDto>(StatusCodes.Status201Created)]
    public async Task<ActionResult<GoalDto>> Create(SaveGoalRequest req, CancellationToken ct)
    {
        var dto = await goals.CreateAsync(req, ct);
        return Created($"/api/goals/{dto.Id}", dto);
    }

    [HttpPut("{id:guid}")]
    public Task<GoalDto> Update(Guid id, SaveGoalRequest req, CancellationToken ct) => goals.UpdateAsync(id, req, ct);

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        await goals.DeleteAsync(id, ct);
        return NoContent();
    }

    // Bước là phần con của Goal (aggregate): mọi thao tác trả về cả Goal đã cập nhật.
    [HttpPost("{id:guid}/steps")]
    public Task<GoalDto> AddStep(Guid id, SaveGoalStepRequest req, CancellationToken ct) => goals.AddStepAsync(id, req, ct);

    [HttpPut("{id:guid}/steps/{stepId:guid}")]
    public Task<GoalDto> UpdateStep(Guid id, Guid stepId, SaveGoalStepRequest req, CancellationToken ct) =>
        goals.UpdateStepAsync(id, stepId, req, ct);

    // Kéo thả bước trong Goal Drawer. Khai báo trước route "{stepId:guid}" cũng không sao: "reorder" không phải guid nên không trùng.
    [HttpPut("{id:guid}/steps/reorder")]
    public Task<GoalDto> ReorderSteps(Guid id, ReorderRequest req, CancellationToken ct) =>
        goals.ReorderStepsAsync(id, req.Ids, ct);

    // GET /api/dashboard/goals?today=2026-11-22: vòng %, chip, radar và mọi số trên GoalCard (SPEC §7, §13.3–13.4).
    [HttpGet("/api/dashboard/goals")]
    public Task<GoalBoardDto> Board([FromQuery] DateOnly today, CancellationToken ct) => goals.GetBoardAsync(today, ct);

    [HttpDelete("{id:guid}/steps/{stepId:guid}")]
    public Task<GoalDto> DeleteStep(Guid id, Guid stepId, CancellationToken ct) => goals.DeleteStepAsync(id, stepId, ct);

    // GET /api/deadlines?from=2026-11-16&to=2026-11-22&today=2026-11-22: DeadlineRow của trang Tuần và Năm.
    // Route bắt đầu bằng "/" nên bỏ qua tiền tố "api/goals" của controller.
    [HttpGet("/api/deadlines")]
    public async Task<ActionResult<List<DeadlineDto>>> Deadlines(
        [FromQuery] DateOnly from, [FromQuery] DateOnly to, [FromQuery] DateOnly today, CancellationToken ct)
    {
        if (to < from || to.DayNumber - from.DayNumber > 400)
            return Problem(statusCode: 400, title: "Khoảng ngày không hợp lệ", detail: "Cần from ≤ to và tối đa 400 ngày.");
        return await goals.GetDeadlinesAsync(from, to, today, ct);
    }
}
