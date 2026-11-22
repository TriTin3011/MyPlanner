using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Health;

// Hợp đồng nghiệp vụ mà controller gọi. Controller chỉ biết interface này.
public interface IHealthService
{
    Task<HealthDto> GetAsync(CancellationToken ct);
}
