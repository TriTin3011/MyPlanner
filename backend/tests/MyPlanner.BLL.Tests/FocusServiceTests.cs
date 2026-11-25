using MyPlanner.BLL.Common;
using MyPlanner.BLL.Focus;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Focus;

namespace MyPlanner.BLL.Tests;

public class FocusServiceTests
{
    private static readonly DateOnly Today = new(2026, 11, 24);

    private static FocusSessionDto Request(
        Guid? id = null, int planned = 25, int actual = 25, PlantKind plant = PlantKind.Basil, PotColor pot = PotColor.Terra,
        Guid? taskId = null, Guid? habitId = null)
    {
        var end = new DateTimeOffset(2026, 11, 24, 9, 0, 0, TimeSpan.Zero);
        return new FocusSessionDto(id ?? Guid.NewGuid(), end.AddMinutes(-actual), end, Today, planned, actual,
            FocusOutcome.Completed, plant, pot, taskId, habitId, null);
    }

    [Fact]
    public async Task Save_creates_then_returns_same_session_when_resent()
    {
        var repo = new FakeFocusRepository();
        var service = new FocusService(repo);
        var req = Request();

        var first = await service.SaveAsync(req, CancellationToken.None);
        var second = await service.SaveAsync(req, CancellationToken.None);

        Assert.True(first.Created);
        Assert.False(second.Created);
        Assert.Single(repo.Sessions);
        Assert.Equal(first.Session, second.Session);
    }

    // Trình duyệt ở Việt Nam gửi "2026-11-24T16:00:00+07:00"; Npgsql từ chối ghi offset khác 0 vào timestamptz.
    [Fact]
    public async Task Save_stores_times_in_utc()
    {
        var repo = new FakeFocusRepository();
        var service = new FocusService(repo);
        var offset = TimeSpan.FromHours(7);
        var end = new DateTimeOffset(2026, 11, 24, 16, 0, 0, offset);
        var req = Request() with { StartedAt = end.AddMinutes(-25), EndedAt = end };

        await service.SaveAsync(req, CancellationToken.None);

        var saved = Assert.Single(repo.Sessions);
        Assert.Equal(TimeSpan.Zero, saved.StartedAt.Offset);
        Assert.Equal(TimeSpan.Zero, saved.EndedAt.Offset);
        Assert.Equal(end, saved.EndedAt); // cùng một thời điểm, chỉ đổi cách biểu diễn
    }

    [Fact]
    public async Task Save_rejects_locked_plant()
    {
        var service = new FocusService(new FakeFocusRepository());

        var error = await Assert.ThrowsAsync<AppException>(() =>
            service.SaveAsync(Request(plant: PlantKind.Sunflower), CancellationToken.None));

        Assert.Equal(400, error.StatusCode);
    }

    [Fact]
    public async Task Save_accepts_unlocked_pot_after_enough_hours()
    {
        var repo = new FakeFocusRepository();
        var service = new FocusService(repo);
        for (var i = 0; i < 2; i++) await service.SaveAsync(Request(planned: 60, actual: 60), CancellationToken.None);

        var result = await service.SaveAsync(Request(pot: PotColor.Cream), CancellationToken.None);

        Assert.True(result.Created);
    }

    [Fact]
    public async Task Save_returns_404_for_task_of_another_account()
    {
        var service = new FocusService(new FakeFocusRepository());

        var error = await Assert.ThrowsAsync<AppException>(() =>
            service.SaveAsync(Request(taskId: Guid.NewGuid()), CancellationToken.None));

        Assert.Equal(404, error.StatusCode);
    }

    [Fact]
    public void Validator_rejects_bad_shapes()
    {
        var validator = new FocusSessionValidator();

        Assert.False(validator.Validate(Request(planned: 3, actual: 3)).IsValid);
        Assert.False(validator.Validate(Request(planned: 25, actual: 30)).IsValid);
        Assert.False(validator.Validate(Request(taskId: Guid.NewGuid(), habitId: Guid.NewGuid())).IsValid);
        Assert.False(validator.Validate(Request() with { EndedAt = Request().StartedAt.AddMinutes(-1) }).IsValid);
        Assert.True(validator.Validate(Request(planned: 25, actual: 12)).IsValid);
    }

    private sealed class FakeFocusRepository : IFocusRepository
    {
        public List<FocusSession> Sessions { get; } = [];
        private readonly List<FocusSession> _pending = [];

        private static FocusSessionDto ToDto(FocusSession s) => new(s.Id, s.StartedAt, s.EndedAt, s.Date, s.PlannedMinutes,
            s.ActualMinutes, s.Outcome, s.PlantKind, s.PotColor, s.TaskId, s.HabitId, s.GoalId);

        public Task<FocusSessionDto?> GetAsync(Guid id, CancellationToken ct) =>
            Task.FromResult(Sessions.Where(s => s.Id == id).Select(ToDto).FirstOrDefault());

        public Task<List<FocusSessionDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
            Task.FromResult(Sessions.Where(s => s.Date >= from && s.Date <= to).Select(ToDto).ToList());

        public Task<List<FocusSessionDto>> AllAsync(CancellationToken ct) => Task.FromResult(Sessions.Select(ToDto).ToList());

        public Task<bool> TaskExistsAsync(Guid id, CancellationToken ct) => Task.FromResult(false);
        public Task<bool> HabitExistsAsync(Guid id, CancellationToken ct) => Task.FromResult(false);
        public Task<bool> GoalExistsAsync(Guid id, CancellationToken ct) => Task.FromResult(false);

        public Task<Dictionary<Guid, string>> LinkTitlesAsync(IReadOnlyCollection<Guid> ids, CancellationToken ct) =>
            Task.FromResult(new Dictionary<Guid, string>());

        public Task<bool> TryAddAsync(FocusSession session, CancellationToken ct)
        {
            if (Sessions.Any(s => s.Id == session.Id)) return Task.FromResult(false);
            Sessions.Add(session);
            return Task.FromResult(true);
        }
    }
}
