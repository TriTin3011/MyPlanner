using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Habits;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api/habits")]
public class HabitsController(IHabitService habits) : ControllerBase
{
    // includeInactive=true để màn Thói quen hiện cả thói quen đã lưu trữ.
    [HttpGet]
    public Task<List<HabitDto>> List([FromQuery] bool includeInactive, CancellationToken ct) => habits.ListAsync(includeInactive, ct);

    [HttpPost]
    [ProducesResponseType<HabitDto>(StatusCodes.Status201Created)]
    public async Task<ActionResult<HabitDto>> Create(SaveHabitRequest req, CancellationToken ct)
    {
        var dto = await habits.CreateAsync(req, ct);
        return Created($"/api/habits/{dto.Id}", dto);
    }

    [HttpPut("{id:guid}")]
    public Task<HabitDto> Update(Guid id, SaveHabitRequest req, CancellationToken ct) => habits.UpdateAsync(id, req, ct);

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        await habits.DeleteAsync(id, ct);
        return NoContent();
    }

    [HttpPut("reorder")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Reorder(ReorderRequest req, CancellationToken ct)
    {
        await habits.ReorderAsync(req.Ids, ct);
        return NoContent();
    }
}
