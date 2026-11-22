using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Notes;

public interface IYearService
{
    Task<YearMetaDto> GetMetaAsync(int year, CancellationToken ct);
    Task<YearMetaDto> SaveMetaAsync(int year, SaveYearMetaRequest req, CancellationToken ct);
    Task<List<YearPlanItemDto>> ItemsAsync(int year, CancellationToken ct);
    Task<YearPlanItemDto> AddItemAsync(int year, CreateYearItemRequest req, CancellationToken ct);
    Task<YearPlanItemDto> UpdateItemAsync(Guid id, UpdateYearItemRequest req, CancellationToken ct);
    Task DeleteItemAsync(Guid id, CancellationToken ct);
    Task ReorderItemsAsync(int year, ReorderYearItemsRequest req, CancellationToken ct);
    Task<YearDashboardDto> GetBoardAsync(int year, DateOnly today, CancellationToken ct);
}
