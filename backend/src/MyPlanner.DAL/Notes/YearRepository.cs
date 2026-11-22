using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Notes;

public class YearRepository(AppDbContext db) : IYearRepository
{
    public Task<YearMetaDto?> GetMetaAsync(int year, CancellationToken ct) =>
        db.YearMeta.AsNoTracking().Where(y => y.Year == year)
            .Select(y => new YearMetaDto(y.Year, y.Keyword, y.Vision)).FirstOrDefaultAsync(ct);

    public Task<YearMeta?> FindMetaAsync(int year, CancellationToken ct) => db.YearMeta.FindAsync([year], ct).AsTask();

    public Task<List<YearPlanItemDto>> ItemsAsync(int year, CancellationToken ct) =>
        db.YearPlanItems.AsNoTracking().Where(i => i.Year == year)
            .OrderBy(i => i.Month).ThenBy(i => i.Order)
            .Select(Projections.YearItem).ToListAsync(ct);

    public Task<YearPlanItemDto?> GetItemAsync(Guid id, CancellationToken ct) =>
        db.YearPlanItems.AsNoTracking().Where(i => i.Id == id).Select(Projections.YearItem).FirstOrDefaultAsync(ct);

    public Task<YearPlanItem?> FindItemAsync(Guid id, CancellationToken ct) =>
        db.YearPlanItems.FirstOrDefaultAsync(i => i.Id == id, ct);

    public async Task<int> NextOrderAsync(int year, int month, CancellationToken ct) =>
        (await db.YearPlanItems.Where(i => i.Year == year && i.Month == month).MaxAsync(i => (int?)i.Order, ct) ?? -1) + 1;

    public void Add(YearMeta meta) => db.YearMeta.Add(meta);
    public void Add(YearPlanItem item) => db.YearPlanItems.Add(item);
    public void Remove(YearPlanItem item) => db.YearPlanItems.Remove(item);
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
