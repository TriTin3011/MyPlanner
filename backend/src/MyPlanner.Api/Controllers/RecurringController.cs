using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Tasks;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api/recurring")]
public class RecurringController(IRecurringService recurring) : ControllerBase
{
    [HttpGet]
    public Task<List<RecurringTaskDto>> List(CancellationToken ct) => recurring.ListAsync(ct);

    [HttpPost]
    [ProducesResponseType<RecurringTaskDto>(StatusCodes.Status201Created)]
    public async Task<ActionResult<RecurringTaskDto>> Create(SaveRecurringRequest req, CancellationToken ct)
    {
        var dto = await recurring.CreateAsync(req, ct);
        return Created($"/api/recurring/{dto.Id}", dto);
    }

    [HttpPut("{id:guid}")]
    public Task<RecurringTaskDto> Update(Guid id, SaveRecurringRequest req, CancellationToken ct) => recurring.UpdateAsync(id, req, ct);

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        await recurring.DeleteAsync(id, ct);
        return NoContent();
    }

    // Sinh task từ quy tắc lặp cho khoảng [from, to]. Là POST vì có ghi dữ liệu (GET phải không có tác dụng phụ).
    // Idempotent: gọi lại nhiều lần không sinh trùng. FE gọi trước khi đọc /tasks của tuần đang xem.
    [HttpPost("materialize")]
    public async Task<ActionResult<CountDto>> Materialize(MaterializeRequest req, CancellationToken ct) =>
        new CountDto(await recurring.MaterializeAsync(req.From, req.To, req.Today, ct));
}
