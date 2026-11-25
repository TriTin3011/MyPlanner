using MyPlanner.BLL.Common;
using MyPlanner.BLL.Goals;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Goals;

namespace MyPlanner.BLL.Tests;

// Luật của lĩnh vực mục tiêu: lĩnh vực có sẵn không xoá được, đang có mục tiêu thì chặn xoá, tên không trùng, có giới hạn.
public class GoalAreaServiceTests
{
    private static GoalAreaService Service(FakeGoalAreaRepository repo) => new(repo, TimeProvider.System);

    [Fact]
    public async Task Create_trims_name_and_orders_after_existing_areas()
    {
        var repo = new FakeGoalAreaRepository();

        var dto = await Service(repo).CreateAsync(new CreateGoalAreaRequest("  Tình nguyện  "), CancellationToken.None);

        Assert.Equal(("Tình nguyện", (LifeArea?)null), (dto.Name, dto.Key));
        Assert.Equal(8, repo.Areas.Single(a => a.Id == dto.Id).Order);
    }

    [Theory]
    [InlineData("tình nguyện")]   // trùng lĩnh vực riêng, khác hoa thường
    [InlineData("sức khỏe")]      // trùng nhãn lĩnh vực có sẵn
    [InlineData("Health")]
    public async Task Create_rejects_duplicate_name_with_409(string name)
    {
        var repo = new FakeGoalAreaRepository();
        repo.AddCustom("Tình nguyện");

        var ex = await Assert.ThrowsAsync<AppException>(() => Service(repo).CreateAsync(new(name), CancellationToken.None));

        Assert.Equal(409, ex.StatusCode);
    }

    [Fact]
    public async Task Create_rejects_when_custom_limit_reached()
    {
        var repo = new FakeGoalAreaRepository();
        for (var i = 0; i < GoalAreaLimits.MaxCustom; i++) repo.AddCustom($"Mục {i}");

        var ex = await Assert.ThrowsAsync<AppException>(() => Service(repo).CreateAsync(new("Thêm nữa"), CancellationToken.None));

        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task Delete_built_in_area_is_rejected()
    {
        var repo = new FakeGoalAreaRepository();

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Service(repo).DeleteAsync(repo.Areas[0].Id, CancellationToken.None));

        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task Delete_area_in_use_is_blocked_with_409()
    {
        var repo = new FakeGoalAreaRepository();
        var area = repo.AddCustom("Tình nguyện");
        repo.InUse.Add(area.Id);

        var ex = await Assert.ThrowsAsync<AppException>(() => Service(repo).DeleteAsync(area.Id, CancellationToken.None));

        Assert.Equal(409, ex.StatusCode);
        Assert.Contains(repo.Areas, a => a.Id == area.Id);
    }

    [Fact]
    public async Task Delete_unused_custom_area_removes_it()
    {
        var repo = new FakeGoalAreaRepository();
        var area = repo.AddCustom("Tình nguyện");

        await Service(repo).DeleteAsync(area.Id, CancellationToken.None);

        Assert.DoesNotContain(repo.Areas, a => a.Id == area.Id);
    }

    [Fact]
    public async Task Delete_unknown_area_is_404()
    {
        var ex = await Assert.ThrowsAsync<AppException>(
            () => Service(new FakeGoalAreaRepository()).DeleteAsync(Guid.NewGuid(), CancellationToken.None));

        Assert.Equal(404, ex.StatusCode);
    }
}

// Kho lĩnh vực trong bộ nhớ: sẵn 8 lĩnh vực có sẵn như sau lần đọc đầu tiên.
internal sealed class FakeGoalAreaRepository : IGoalAreaRepository
{
    public List<GoalArea> Areas { get; } = GoalAreaRepository.BuiltIns(DateTimeOffset.UnixEpoch);
    public HashSet<Guid> InUse { get; } = [];

    public GoalArea AddCustom(string name)
    {
        var area = new GoalArea { Id = Guid.NewGuid(), Name = name, Order = Areas.Count, CreatedAt = DateTimeOffset.UnixEpoch };
        Areas.Add(area);
        return area;
    }

    public Task<List<GoalAreaDto>> ListAsync(CancellationToken ct) =>
        Task.FromResult(Areas.OrderBy(a => a.Order).Select(a => new GoalAreaDto(a.Id, a.Key, a.Name)).ToList());
    public Task<GoalArea?> FindAsync(Guid id, CancellationToken ct) => Task.FromResult(Areas.FirstOrDefault(a => a.Id == id));
    public Task<bool> ExistsAsync(Guid id, CancellationToken ct) => Task.FromResult(Areas.Any(a => a.Id == id));
    public Task<bool> InUseAsync(Guid id, CancellationToken ct) => Task.FromResult(InUse.Contains(id));
    public Task<List<string>> CustomNamesAsync(CancellationToken ct) =>
        Task.FromResult(Areas.Where(a => a.Key is null).Select(a => a.Name!).ToList());
    public Task<int> NextOrderAsync(CancellationToken ct) => Task.FromResult(Areas.Max(a => a.Order) + 1);
    public void Add(GoalArea area) => Areas.Add(area);
    public void Remove(GoalArea area) => Areas.Remove(area);
    public Task SaveChangesAsync(CancellationToken ct) => Task.CompletedTask;
}
