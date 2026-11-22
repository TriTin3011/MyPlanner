using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Stats;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api/stats")]
public class StatsController(IStatsService stats) : ControllerBase
{
    [HttpGet]
    public Task<StatsDto> Get([FromQuery] StatsQuery query, CancellationToken ct) =>
        stats.GetAsync(query.Range, query.Today, ct);
}
