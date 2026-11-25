using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Goals;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

// Lĩnh vực mục tiêu: 8 lĩnh vực có sẵn + lĩnh vực người dùng tự tạo.
[ApiController]
[Route("api/goal-areas")]
public class GoalAreasController(IGoalAreaService areas) : ControllerBase
{
    [HttpGet]
    public Task<List<GoalAreaDto>> List(CancellationToken ct) => areas.ListAsync(ct);

    [HttpPost]
    [ProducesResponseType<GoalAreaDto>(StatusCodes.Status201Created)]
    public async Task<ActionResult<GoalAreaDto>> Create(CreateGoalAreaRequest req, CancellationToken ct)
    {
        var dto = await areas.CreateAsync(req, ct);
        return Created($"/api/goal-areas/{dto.Id}", dto);
    }

    // 409 khi lĩnh vực còn mục tiêu, 400 khi là lĩnh vực có sẵn.
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        await areas.DeleteAsync(id, ct);
        return NoContent();
    }
}
