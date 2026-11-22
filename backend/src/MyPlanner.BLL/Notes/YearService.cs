using MyPlanner.BLL.Common;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Notes;

namespace MyPlanner.BLL.Notes;

public class YearService(IYearRepository years) : IYearService
{
    public async Task<YearMetaDto> GetMetaAsync(int year, CancellationToken ct) =>
        await years.GetMetaAsync(year, ct) ?? new YearMetaDto(year, "", "");

    public async Task<YearMetaDto> SaveMetaAsync(int year, SaveYearMetaRequest req, CancellationToken ct)
    {
        var meta = await years.FindMetaAsync(year, ct);
        if (meta is null) years.Add(meta = new YearMeta { Year = year });
        meta.Keyword = req.Keyword.Trim();
        meta.Vision = req.Vision.Trim();
        await years.SaveChangesAsync(ct);
        return new YearMetaDto(meta.Year, meta.Keyword, meta.Vision);
    }

    public Task<List<YearPlanItemDto>> ItemsAsync(int year, CancellationToken ct) => years.ItemsAsync(year, ct);

    public async Task<YearPlanItemDto> AddItemAsync(int year, CreateYearItemRequest req, CancellationToken ct)
    {
        var item = new YearPlanItem
        {
            Id = Guid.NewGuid(), Year = year, Month = req.Month, Title = req.Title.Trim(),
            Order = await years.NextOrderAsync(year, req.Month, ct),
        };
        years.Add(item);
        await years.SaveChangesAsync(ct);
        return (await years.GetItemAsync(item.Id, ct))!;
    }

    public async Task<YearPlanItemDto> UpdateItemAsync(Guid id, UpdateYearItemRequest req, CancellationToken ct)
    {
        var item = await years.FindItemAsync(id, ct) ?? throw AppException.NotFound("Mục kế hoạch năm");
        if (item.Month != req.Month) item.Order = await years.NextOrderAsync(item.Year, req.Month, ct);
        item.Month = req.Month;
        item.Title = req.Title.Trim();
        item.Done = req.Done;
        await years.SaveChangesAsync(ct);
        return (await years.GetItemAsync(id, ct))!;
    }

    public async Task DeleteItemAsync(Guid id, CancellationToken ct)
    {
        var item = await years.FindItemAsync(id, ct) ?? throw AppException.NotFound("Mục kế hoạch năm");
        years.Remove(item);
        await years.SaveChangesAsync(ct);
    }
}
