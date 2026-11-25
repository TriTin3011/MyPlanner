using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Goals;

public class GoalAreaRepository(AppDbContext db) : IGoalAreaRepository
{
    // 8 lĩnh vực có sẵn, Order theo thứ tự enum. Dùng chung cho lần đọc đầu tiên và cho Import/Seed.
    public static List<GoalArea> BuiltIns(DateTimeOffset now) =>
        Enum.GetValues<LifeArea>()
            .Select((key, i) => new GoalArea { Id = Guid.NewGuid(), Key = key, Order = i, CreatedAt = now })
            .ToList();

    public async Task<List<GoalAreaDto>> ListAsync(CancellationToken ct)
    {
        var areas = await QueryAsync(ct);
        // Lĩnh vực có sẵn không xoá được, nên "không có dòng nào có Key" nghĩa là tài khoản chưa được tạo bộ mặc định.
        if (areas.Any(a => a.Key is not null)) return areas;

        db.GoalAreas.AddRange(BuiltIns(DateTimeOffset.UtcNow));
        try
        {
            await db.SaveChangesAsync(ct);
        }
        catch (Exception ex) when (ex is DbUpdateException || ex.InnerException is DbUpdateException)
        {
            // Request khác của cùng tài khoản đang tạo cùng lúc (trang Mục tiêu gọi song song goal-areas và dashboard/goals):
            // unique index UserId+Key chặn bản trùng, hoặc Postgres chọn bên mình làm nạn nhân deadlock (40P01),
            // khi đó EF bọc DbUpdateException trong InvalidOperationException "transient failure".
            // Cả hai trường hợp: bỏ bản của mình, đọc lại bản bên kia đã lưu.
            db.ChangeTracker.Clear();
        }
        return await QueryAsync(ct);
    }

    private Task<List<GoalAreaDto>> QueryAsync(CancellationToken ct) =>
        db.GoalAreas.AsNoTracking()
            .OrderBy(a => a.Order).ThenBy(a => a.CreatedAt)
            .Select(a => new GoalAreaDto(a.Id, a.Key, a.Name))
            .ToListAsync(ct);

    public Task<GoalArea?> FindAsync(Guid id, CancellationToken ct) =>
        db.GoalAreas.FirstOrDefaultAsync(a => a.Id == id, ct);

    public Task<bool> ExistsAsync(Guid id, CancellationToken ct) =>
        db.GoalAreas.AnyAsync(a => a.Id == id, ct);

    public Task<bool> InUseAsync(Guid id, CancellationToken ct) =>
        db.Goals.AnyAsync(g => g.AreaId == id, ct);

    public Task<List<string>> CustomNamesAsync(CancellationToken ct) =>
        db.GoalAreas.AsNoTracking().Where(a => a.Key == null).Select(a => a.Name!).ToListAsync(ct);

    public async Task<int> NextOrderAsync(CancellationToken ct) =>
        (await db.GoalAreas.MaxAsync(a => (int?)a.Order, ct) ?? -1) + 1;

    public void Add(GoalArea area) => db.GoalAreas.Add(area);
    public void Remove(GoalArea area) => db.GoalAreas.Remove(area);
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
