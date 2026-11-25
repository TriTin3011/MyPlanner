using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Tests;

// GoalBoard.Build: số trên GoalCard, chip/radar và thứ tự thẻ (SPEC §7.4, §13.3–13.4).
public class GoalBoardTests
{
    private static readonly DateOnly Today = new(2026, 11, 22);

    // 8 lĩnh vực có sẵn theo thứ tự enum + một lĩnh vực tự tạo ở cuối.
    private static readonly List<GoalAreaDto> Areas =
    [
        .. Enum.GetValues<LifeArea>().Select(k => new GoalAreaDto(Guid.NewGuid(), k, null)),
        new GoalAreaDto(Guid.NewGuid(), null, "Tình nguyện"),
    ];

    private static Guid AreaOf(LifeArea key) => Areas.Single(a => a.Key == key).Id;
    private static Guid Custom => Areas[^1].Id;

    private static GoalDto Goal(
        string title, Guid area, GoalStatus status, DateOnly start, DateOnly deadline, params (bool done, DateOnly? deadline)[] steps) =>
        new(Guid.NewGuid(), title, area, status, start, deadline, null, null,
            steps.Select((s, i) => new GoalStepDto(Guid.NewGuid(), $"b{i}", s.deadline, s.done, null, i)).ToList(),
            DateTimeOffset.UnixEpoch, null);

    [Fact]
    public void Card_computes_progress_time_overdue_and_behind()
    {
        // 100 ngày, đã trôi 60 ngày → Thời gian 60%; 1/4 bước → Tiến độ 25%; chênh 35 điểm > 10 → chậm.
        var g = Goal("A", AreaOf(LifeArea.Learning), GoalStatus.InProgress, Today.AddDays(-60), Today.AddDays(40),
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
        var g = Goal("Xong", AreaOf(LifeArea.Hobby), GoalStatus.Done, Today.AddDays(-10), Today.AddDays(-1));
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
            Goal("Xong", AreaOf(LifeArea.Health), GoalStatus.Done, Today.AddDays(-5), Today.AddDays(1)),
            Goal("Xa", AreaOf(LifeArea.Health), GoalStatus.InProgress, Today, Today.AddDays(90), (true, null), (false, null)),
            Goal("Gần", AreaOf(LifeArea.Finance), GoalStatus.NotStarted, Today, Today.AddDays(10)),
            Goal("Riêng", Custom, GoalStatus.Done, Today.AddDays(-5), Today.AddDays(200)),
        };

        var board = GoalBoard.Build(goals, Areas, Today);

        Assert.Equal((2, 4, 50), (board.Done, board.Total, board.Percent));
        Assert.Equal(["Gần", "Xa", "Xong", "Riêng"], board.Goals.Select(c => c.Title));
        // Đủ mọi lĩnh vực của tài khoản theo thứ tự, kể cả lĩnh vực chưa có mục tiêu và lĩnh vực tự tạo.
        Assert.Equal(Areas.Select(a => a.Id), board.Areas.Select(a => a.Id));
        Assert.Equal(("Tình nguyện", 1, 100), (board.Areas[^1].Name, board.Areas[^1].Count, board.Areas[^1].Percent));
        var health = board.Areas.Single(a => a.Key == LifeArea.Health);
        Assert.Equal((2, 75), (health.Count, health.Percent));   // (1 + 0,5) / 2
        Assert.Equal(0, board.Areas.Single(a => a.Key == LifeArea.Career).Percent);
    }
}
