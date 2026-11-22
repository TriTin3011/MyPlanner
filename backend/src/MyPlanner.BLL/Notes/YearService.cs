using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Goals;
using MyPlanner.DAL.Notes;

namespace MyPlanner.BLL.Notes;

public class YearService(IYearRepository years, IGoalRepository goals) : IYearService
{
    // SPEC §10 + §13.8. Ba truy vấn (meta, mục, hạn) rồi YearBoard.Build gom trong bộ nhớ.
    public async Task<YearDashboardDto> GetBoardAsync(int year, DateOnly today, CancellationToken ct)
    {
        var meta = await years.GetMetaAsync(year, ct);
        var items = await years.ItemsAsync(year, ct);
        var from = new DateOnly(year, 1, 1);
        var to = new DateOnly(year, 12, 31);
        var steps = await goals.StepDeadlinesAsync(from, to, ct);
        var goalRows = await goals.GoalDeadlinesAsync(from, to, ct);
        var deadlines = YearBoard.Deadlines(steps.Select(s => (s.GoalId, s.GoalTitle, s.Title, s.Deadline, s.Done)), goalRows, today);
        return YearBoard.Build(year, meta, items, deadlines, today);
    }

    // Ids là thứ tự mới của tháng đích; mục kéo từ tháng khác sang được đổi Month luôn (giống task kéo giữa các ngày).
    public async Task ReorderItemsAsync(int year, ReorderYearItemsRequest req, CancellationToken ct)
    {
        var found = await years.FindItemsAsync(req.Ids, ct);
        if (found.Count != req.Ids.Count || found.Any(i => i.Year != year))
            throw AppException.NotFound(Messages.SomeYearItems);

        var byId = found.ToDictionary(i => i.Id);
        for (var i = 0; i < req.Ids.Count; i++)
        {
            var item = byId[req.Ids[i]];
            item.Month = req.Month;
            item.Order = i;
        }
        await years.SaveChangesAsync(ct);
    }

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
        var item = await years.FindItemAsync(id, ct) ?? throw AppException.NotFound(Messages.YearItem);
        if (item.Month != req.Month) item.Order = await years.NextOrderAsync(item.Year, req.Month, ct);
        item.Month = req.Month;
        item.Title = req.Title.Trim();
        item.Done = req.Done;
        await years.SaveChangesAsync(ct);
        return (await years.GetItemAsync(id, ct))!;
    }

    public async Task DeleteItemAsync(Guid id, CancellationToken ct)
    {
        var item = await years.FindItemAsync(id, ct) ?? throw AppException.NotFound(Messages.YearItem);
        years.Remove(item);
        await years.SaveChangesAsync(ct);
    }
}
