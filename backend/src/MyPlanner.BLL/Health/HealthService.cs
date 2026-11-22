using MyPlanner.Core.Dtos;
using MyPlanner.DAL.Health;

namespace MyPlanner.BLL.Health;

// Nghiệp vụ: hỏi DAL database có sống không, rồi quyết định trạng thái "ok"/"degraded".
public class HealthService(IHealthRepository healthRepository) : IHealthService
{
    public async Task<HealthDto> GetAsync(CancellationToken ct)
    {
        var database = await healthRepository.CanConnectAsync(ct);
        return new HealthDto(database ? "ok" : "degraded", database);
    }
}
