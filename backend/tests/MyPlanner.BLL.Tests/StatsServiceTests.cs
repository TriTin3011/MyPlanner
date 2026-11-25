using MyPlanner.BLL.Stats;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.DAL.Stats;

namespace MyPlanner.BLL.Tests;

public class StatsServiceTests
{
    private static readonly DateOnly Today = new(2026, 11, 22);

    [Fact]
    public async Task GetAsync_reads_each_table_once_and_builds_requested_range()
    {
        var repository = new FakeStatsRepository();
        var service = new StatsService(repository, new FakeGoalAreaRepository());

        var result = await service.GetAsync("8w", Today, CancellationToken.None);

        Assert.Equal(new DateOnly(2026, 9, 28), result.From);
        Assert.Equal(Today, result.To);
        Assert.Equal((1, 1, 1, 1),
            (repository.TaskReads, repository.HabitReads, repository.LogReads, repository.GoalReads));
        Assert.Equal(Today, repository.To);
    }

    [Theory]
    [InlineData("4w")]
    [InlineData("8w")]
    [InlineData("12w")]
    [InlineData("6m")]
    [InlineData("1y")]
    public void Validator_accepts_supported_ranges(string range)
    {
        var result = new StatsQueryValidator().Validate(new StatsQuery(range, Today));

        Assert.True(result.IsValid);
    }

    [Fact]
    public void Validator_rejects_unknown_range_and_missing_today()
    {
        var result = new StatsQueryValidator().Validate(new StatsQuery("2w", default));

        Assert.Contains(result.Errors, error => error.PropertyName == "Range");
        Assert.Contains(result.Errors, error => error.PropertyName == "Today");
    }

    [Fact]
    public void Validator_rejects_date_that_cannot_fit_equal_previous_period()
    {
        var result = new StatsQueryValidator().Validate(new StatsQuery("1y", new DateOnly(2, 1, 1)));

        Assert.Contains(result.Errors, error => error.PropertyName == "Today");
    }

    private sealed class FakeStatsRepository : IStatsRepository
    {
        public int TaskReads { get; private set; }
        public int HabitReads { get; private set; }
        public int LogReads { get; private set; }
        public int GoalReads { get; private set; }
        public DateOnly To { get; private set; }

        public Task<List<StatsTaskRow>> TasksAsync(DateOnly to, CancellationToken ct)
        {
            TaskReads++;
            To = to;
            return Task.FromResult(new List<StatsTaskRow>());
        }

        public Task<List<StatsHabitRow>> HabitsAsync(CancellationToken ct)
        {
            HabitReads++;
            return Task.FromResult(new List<StatsHabitRow>());
        }

        public Task<List<StatsHabitLogRow>> HabitLogsAsync(DateOnly to, CancellationToken ct)
        {
            LogReads++;
            To = to;
            return Task.FromResult(new List<StatsHabitLogRow>());
        }

        public Task<List<StatsGoalRow>> GoalsAsync(CancellationToken ct)
        {
            GoalReads++;
            return Task.FromResult(new List<StatsGoalRow>());
        }

        public Task<List<StatsFocusRow>> FocusAsync(DateOnly to, CancellationToken ct) =>
            Task.FromResult(new List<StatsFocusRow>());
    }
}
