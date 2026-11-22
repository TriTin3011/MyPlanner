using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Notes;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api")]
public class YearsController(IYearService years) : ControllerBase
{
    [HttpGet("years/{year:int:range(2000,2100)}")]
    public Task<YearMetaDto> GetMeta(int year, CancellationToken ct) => years.GetMetaAsync(year, ct);

    [HttpPut("years/{year:int:range(2000,2100)}")]
    public Task<YearMetaDto> SaveMeta(int year, SaveYearMetaRequest req, CancellationToken ct) => years.SaveMetaAsync(year, req, ct);

    [HttpGet("years/{year:int:range(2000,2100)}/items")]
    public Task<List<YearPlanItemDto>> Items(int year, CancellationToken ct) => years.ItemsAsync(year, ct);

    [HttpPost("years/{year:int:range(2000,2100)}/items")]
    [ProducesResponseType<YearPlanItemDto>(StatusCodes.Status201Created)]
    public async Task<ActionResult<YearPlanItemDto>> AddItem(int year, CreateYearItemRequest req, CancellationToken ct)
    {
        var dto = await years.AddItemAsync(year, req, ct);
        return Created($"/api/year-items/{dto.Id}", dto);
    }

    // GET /api/dashboard/year?year=2026&today=2026-11-22: cả trang Kế hoạch năm trong một lần gọi (SPEC §10, §13.8).
    [HttpGet("dashboard/year")]
    public async Task<ActionResult<YearDashboardDto>> Board([FromQuery] int year, [FromQuery] DateOnly today, CancellationToken ct)
    {
        if (year is < 2000 or > 2100)
            return Problem(statusCode: 400, title: "year không hợp lệ", detail: "Cần 2000 ≤ year ≤ 2100.");
        return await years.GetBoardAsync(year, today, ct);
    }

    [HttpPut("years/{year:int:range(2000,2100)}/items/reorder")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> ReorderItems(int year, ReorderYearItemsRequest req, CancellationToken ct)
    {
        await years.ReorderItemsAsync(year, req, ct);
        return NoContent();
    }

    [HttpPut("year-items/{id:guid}")]
    public Task<YearPlanItemDto> UpdateItem(Guid id, UpdateYearItemRequest req, CancellationToken ct) => years.UpdateItemAsync(id, req, ct);

    [HttpDelete("year-items/{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteItem(Guid id, CancellationToken ct)
    {
        await years.DeleteItemAsync(id, ct);
        return NoContent();
    }
}
