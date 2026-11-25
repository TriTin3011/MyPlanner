using MyPlanner.BLL.Goals;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Goals;

namespace MyPlanner.BLL.Tests;

// Dòng hạn của trang Tuần/Năm: ghép hạn bước + hạn mục tiêu, tính "quá hạn" theo today của client.
public class GoalServiceDeadlinesTests
{
    private static readonly DateOnly Today = new(2026, 11, 22);
    private static readonly Guid GoalA = Guid.NewGuid();
    private static readonly Guid GoalB = Guid.NewGuid();

    [Fact]
    public async Task Merges_step_and_goal_deadlines_sorted_by_date_with_steps_first()
    {
        var repo = new FakeGoalRepository(
            steps: [
                (GoalA, "Hoàn thành khóa Excel", "Đăng ký khóa học", new DateOnly(2026, 11, 19), false),
                (GoalA, "Hoàn thành khóa Excel", "Học bài 1", new DateOnly(2026, 11, 17), true),
            ],
            goals: [(GoalB, "Trả hết khoản vay", new DateOnly(2026, 11, 19), false)]);
        var service = new GoalService(repo, new FakeGoalAreaRepository(), TimeProvider.System);

        var result = await service.GetDeadlinesAsync(new(2026, 11, 16), new(2026, 11, 22), Today, CancellationToken.None);

        Assert.Equal(
            [("Học bài 1", DeadlineKind.Step), ("Đăng ký khóa học", DeadlineKind.Step), ("Trả hết khoản vay", DeadlineKind.Goal)],
            result.Select(d => (d.Title, d.Kind)).ToList());
        Assert.Equal("Hoàn thành khóa Excel", result[1].GoalTitle);
        Assert.Equal("Trả hết khoản vay", result[2].GoalTitle);
    }

    [Theory]
    [InlineData(2026, 11, 21, false, true)]   // hôm qua, chưa xong → quá hạn
    [InlineData(2026, 11, 22, false, false)]  // đúng hôm nay → chưa quá hạn
    [InlineData(2026, 11, 23, false, false)]  // ngày mai
    [InlineData(2026, 11, 21, true, false)]   // đã xong thì không bao giờ quá hạn
    public async Task Overdue_only_when_not_done_and_before_today(int y, int m, int d, bool done, bool expected)
    {
        var date = new DateOnly(y, m, d);
        var repo = new FakeGoalRepository(steps: [(GoalA, "Mục tiêu", "Bước", date, done)], goals: []);
        var service = new GoalService(repo, new FakeGoalAreaRepository(), TimeProvider.System);

        var result = await service.GetDeadlinesAsync(new(2026, 11, 16), new(2026, 11, 29), Today, CancellationToken.None);

        Assert.Equal(expected, Assert.Single(result).Overdue);
    }

    private sealed class FakeGoalRepository(
        List<(Guid GoalId, string GoalTitle, string Title, DateOnly Deadline, bool Done)> steps,
        List<(Guid GoalId, string Title, DateOnly Deadline, bool Done)> goals) : IGoalRepository
    {
        public Task<List<(Guid GoalId, string GoalTitle, string Title, DateOnly Deadline, bool Done)>> StepDeadlinesAsync(
            DateOnly from, DateOnly to, CancellationToken ct) =>
            System.Threading.Tasks.Task.FromResult(steps.Where(s => s.Deadline >= from && s.Deadline <= to).ToList());
        public Task<List<(Guid GoalId, string Title, DateOnly Deadline, bool Done)>> GoalDeadlinesAsync(
            DateOnly from, DateOnly to, CancellationToken ct) =>
            System.Threading.Tasks.Task.FromResult(goals.Where(g => g.Deadline >= from && g.Deadline <= to).ToList());
        public Task<HashSet<DateOnly>> DeadlineDatesAsync(DateOnly from, DateOnly to, CancellationToken ct) => throw new NotSupportedException();
        public Task<List<GoalDto>> ListAsync(CancellationToken ct) => throw new NotSupportedException();
        public Task<GoalDto?> GetAsync(Guid id, CancellationToken ct) => throw new NotSupportedException();
        public Task<Goal?> FindAsync(Guid id, CancellationToken ct) => throw new NotSupportedException();
        public void Add(Goal goal) => throw new NotSupportedException();
        public void Remove(Goal goal) => throw new NotSupportedException();
        public Task SaveChangesAsync(CancellationToken ct) => throw new NotSupportedException();
    }
}
