using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Notes;

public interface IYearRepository
{
    Task<YearMetaDto?> GetMetaAsync(int year, CancellationToken ct);
    Task<YearMeta?> FindMetaAsync(int year, CancellationToken ct);
    Task<List<YearPlanItemDto>> ItemsAsync(int year, CancellationToken ct);
    Task<YearPlanItemDto?> GetItemAsync(Guid id, CancellationToken ct);
    Task<YearPlanItem?> FindItemAsync(Guid id, CancellationToken ct);
    Task<List<YearPlanItem>> FindItemsAsync(IReadOnlyCollection<Guid> ids, CancellationToken ct);
    Task<int> NextOrderAsync(int year, int month, CancellationToken ct);
    void Add(YearMeta meta);
    void Add(YearPlanItem item);
    void Remove(YearPlanItem item);
    Task SaveChangesAsync(CancellationToken ct);
}
