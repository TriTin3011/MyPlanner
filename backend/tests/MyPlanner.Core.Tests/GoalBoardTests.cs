using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Tests;

// GoalBoard.Build: số trên GoalCard, chip/radar và thứ tự thẻ (SPEC §7.4, §13.3–13.4).
public class GoalBoardTests
{
    private static readonly DateOnly Today = new(2026, 11, 22);

    private static GoalDto Goal(
        string title, LifeArea area, GoalStatus status, DateOnly start, DateOnly deadline, params (bool done, DateOnly? deadline)[] steps) =>
        new(Guid.NewGuid(), title, area, status, start, deadline, null, null,
            steps.Select((s, i) => new GoalStepDto(Guid.NewGuid(), $"b{i}", s.deadline, s.done, null, i)).ToList(),
            DateTimeOffset.UnixEpoch, null);

    [Fact]
    public void Card_computes_progress_time_overdue_and_behind()
    {
        // 100 ngày, đã trôi 60 ngày → Thời gian 60%; 1/4 bước → Tiến độ 25%; chênh 35 điểm > 10 → chậm.
        var g = Goal("A", LifeArea.Learning, GoalStatus.InProgress, Today.AddDays(-60), Today.AddDays(40),
            (true, null), (false, Today.AddDays(-1)), (false, Today), (false, null));

        var card = GoalBoard.Card(g, Today);

        Assert.Equal(25, card.StepPercent);
        Assert.Equal(60, card.TimePercent);
        Assert.Equal(40, card.DaysLeft);
        Assert.Equal(1, card.OverdueSteps);   // hạn hôm nay chưa tính là quá hạn
        Assert.Equal((1, 4), (card.StepsDone, card.StepsTotal));
        Assert.True(card.Behind);
    }

    [Fact]
    public void Done_goal_is_never_behind_and_counts_full_without_steps()
    {
        var g = Goal("Xong", LifeArea.Hobby, GoalStatus.Done, Today.AddDays(-10), Today.AddDays(-1));
        var card = GoalBoard.Card(g, Today);
        Assert.Equal(100, card.StepPercent);
        Assert.Equal(-1, card.DaysLeft);
        Assert.False(card.Behind);
    }

    [Fact]
    public void Build_summarises_areas_and_sorts_cards()
    {
        var goals = new[]
        {
            Goal("Xong", LifeArea.Health, GoalStatus.Done, Today.AddDays(-5), Today.AddDays(1)),
            Goal("Xa", LifeArea.Health, GoalStatus.InProgress, Today, Today.AddDays(90), (true, null), (false, null)),
            Goal("Gần", LifeArea.Finance, GoalStatus.NotStarted, Today, Today.AddDays(10)),
        };

        var board = GoalBoard.Build(goals, Today);

        Assert.Equal((1, 3, 33), (board.Done, board.Total, board.Percent));
        Assert.Equal(["Gần", "Xa", "Xong"], board.Goals.Select(c => c.Title));
        Assert.Equal(8, board.Areas.Count);
        var health = board.Areas.Single(a => a.Area == LifeArea.Health);
        Assert.Equal((2, 75), (health.Count, health.Percent));   // (1 + 0,5) / 2
        Assert.Equal(0, board.Areas.Single(a => a.Area == LifeArea.Career).Percent);
    }
}
