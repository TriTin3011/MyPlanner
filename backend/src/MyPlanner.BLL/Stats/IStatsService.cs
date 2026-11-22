using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Stats;

public interface IStatsService
{
    Task<StatsDto> GetAsync(string range, DateOnly today, CancellationToken ct);
}
