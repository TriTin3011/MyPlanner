using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Health;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

// Controller mỏng: nhận HTTP, gọi service (BLL), đổi kết quả thành status code.
[ApiController]
[Route("api/health")]
public class HealthController(IHealthService healthService) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType<HealthDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<HealthDto>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<ActionResult<HealthDto>> Get(CancellationToken ct)
    {
        var result = await healthService.GetAsync(ct);
        return result.Database ? Ok(result) : StatusCode(StatusCodes.Status503ServiceUnavailable, result);
    }
}
