using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Tasks;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api/tasks")]
public class TasksController(ITaskService tasks) : ControllerBase
{
    // GET /api/tasks?from=2026-11-16&to=2026-11-22
    [HttpGet]
    public async Task<ActionResult<List<TaskDto>>> List([FromQuery] DateOnly from, [FromQuery] DateOnly to, CancellationToken ct)
    {
        if (to < from || to.DayNumber - from.DayNumber > 400)
            return Problem(statusCode: 400, title: "Khoảng ngày không hợp lệ", detail: "Cần from ≤ to và tối đa 400 ngày.");
        return await tasks.ListAsync(from, to, ct);
    }

    // Việc tồn: chưa xong và ngày < today (today do client gửi, giờ địa phương).
    [HttpGet("backlog")]
    public Task<List<TaskDto>> Backlog([FromQuery] DateOnly today, CancellationToken ct) => tasks.BacklogAsync(today, ct);

    [HttpPost]
    [ProducesResponseType<TaskDto>(StatusCodes.Status201Created)]
    public async Task<ActionResult<TaskDto>> Create(SaveTaskRequest req, CancellationToken ct)
    {
        var dto = await tasks.CreateAsync(req, ct);
        return Created($"/api/tasks/{dto.Id}", dto);
    }

    [HttpPut("{id:guid}")]
    public Task<TaskDto> Update(Guid id, SaveTaskRequest req, CancellationToken ct) => tasks.UpdateAsync(id, req, ct);

    [HttpPatch("{id:guid}/done")]
    public Task<TaskDto> SetDone(Guid id, SetDoneRequest req, CancellationToken ct) => tasks.SetDoneAsync(id, req.Done, ct);

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        await tasks.DeleteAsync(id, ct);
        return NoContent();
    }

    [HttpPost("move-backlog-to-today")]
    public async Task<ActionResult<CountDto>> MoveBacklogToToday(MoveBacklogRequest req, CancellationToken ct) =>
        new CountDto(await tasks.MoveBacklogToTodayAsync(req.Today, ct));

    [HttpPut("reorder")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Reorder(ReorderTasksRequest req, CancellationToken ct)
    {
        await tasks.ReorderAsync(req, ct);
        return NoContent();
    }
}
