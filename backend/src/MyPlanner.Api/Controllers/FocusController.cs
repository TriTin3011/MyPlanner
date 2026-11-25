using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Focus;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api")]
public class FocusController(IFocusService focus) : ControllerBase
{
    // POST /api/focus/sessions: 201 khi tạo mới, 200 khi Id đã có (gửi lại từ hàng đợi offline).
    [HttpPost("focus/sessions")]
    [ProducesResponseType<FocusSessionDto>(StatusCodes.Status201Created)]
    [ProducesResponseType<FocusSessionDto>(StatusCodes.Status200OK)]
    public async Task<ActionResult<FocusSessionDto>> Save(FocusSessionDto req, CancellationToken ct)
    {
        var (session, created) = await focus.SaveAsync(req, ct);
        return created ? Created($"/api/focus/sessions/{session.Id}", session) : Ok(session);
    }

    // GET /api/focus/sessions?from=2026-11-01&to=2026-11-30
    [HttpGet("focus/sessions")]
    public async Task<ActionResult<List<FocusSessionDto>>> List([FromQuery] DateOnly from, [FromQuery] DateOnly to, CancellationToken ct)
    {
        if (to < from || to.DayNumber - from.DayNumber > 400)
            return Problem(statusCode: 400, title: Messages.BadRequestTitle, detail: Messages.FocusRangeInvalid);
        return await focus.ListAsync(from, to, ct);
    }

    // GET /api/dashboard/focus?today=2026-11-24: dải số, kệ và mở khoá (SPEC §13.9).
    [HttpGet("dashboard/focus")]
    public Task<FocusBoardDto> Board([FromQuery] DateOnly today, CancellationToken ct) => focus.GetBoardAsync(today, ct);
}
