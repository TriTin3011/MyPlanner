using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Habits;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

// Log là tài nguyên định danh bằng (habitId, date): PUT = tick, DELETE = bỏ tick. Cả hai idempotent,
// nên FE bấm nhanh hai lần hay mạng gửi lại cũng không sinh dữ liệu sai.
[ApiController]
[Route("api/habit-logs")]
public class HabitLogsController(IHabitService habits) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<List<HabitLogDto>>> List([FromQuery] DateOnly from, [FromQuery] DateOnly to, CancellationToken ct)
    {
        if (to < from || to.DayNumber - from.DayNumber > 400)
            return Problem(statusCode: 400, title: "Khoảng ngày không hợp lệ", detail: "Cần from ≤ to và tối đa 400 ngày.");
        return await habits.LogsAsync(from, to, ct);
    }

    [HttpPut("{habitId:guid}/{date}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Tick(Guid habitId, DateOnly date, CancellationToken ct)
    {
        await habits.TickAsync(habitId, date, ct);
        return NoContent();
    }

    [HttpDelete("{habitId:guid}/{date}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Untick(Guid habitId, DateOnly date, CancellationToken ct)
    {
        await habits.UntickAsync(habitId, date, ct);
        return NoContent();
    }
}
