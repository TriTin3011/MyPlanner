using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Tests;

public class FocusBoardTests
{
    private static readonly DateOnly Today = new(2026, 11, 24); // Thứ 3

    private static FocusSessionDto Session(
        DateOnly date, int minutes, FocusOutcome outcome = FocusOutcome.Completed, int hour = 9, Guid? taskId = null)
    {
        var end = new DateTimeOffset(date.ToDateTime(new TimeOnly(hour, 0)), TimeSpan.Zero);
        return new FocusSessionDto(Guid.NewGuid(), end.AddMinutes(-minutes), end, date, Math.Max(minutes, 5), minutes,
            outcome, PlantKind.Basil, PotColor.Terra, taskId, null, null);
    }

    [Fact]
    public void Empty_board_has_one_empty_shelf_and_only_starters_unlocked()
    {
        var board = FocusBoard.Build([], Today);

        Assert.Equal((0, 0, 0, 0, 0), (board.MinutesToday, board.MinutesThisWeek, board.MinutesTotal, board.PotCount, board.Streak));
        var shelf = Assert.Single(board.Shelves);
        Assert.Empty(shelf.Pots);
        Assert.Equal(["basil", "terra"], board.Unlocks.Where(u => u.Unlocked).Select(u => u.Key));
        Assert.Equal(2, board.Unlocks.Single(u => u.Key == "cream").HoursRemaining);
    }

    [Fact]
    public void Exactly_twelve_pots_fill_one_shelf_and_thirteenth_opens_next()
    {
        var twelve = Enumerable.Range(0, 12).Select(i => Session(Today.AddDays(-i), 25, hour: 8)).ToList();

        var full = FocusBoard.Build(twelve, Today);
        Assert.Single(full.Shelves);
        Assert.Equal(Enumerable.Range(0, 12), full.Shelves[0].Pots.Select(p => p.Slot));
        // Xếp theo EndedAt: chậu cũ nhất ở ô 0.
        Assert.Equal(Today.AddDays(-11), full.Shelves[0].Pots[0].Date);

        var more = FocusBoard.Build([.. twelve, Session(Today, 25, hour: 20)], Today);
        Assert.Equal(2, more.Shelves.Count);
        var pot = Assert.Single(more.Shelves[1].Pots);
        Assert.Equal(0, pot.Slot);
    }

    [Fact]
    public void Minutes_count_abandoned_but_pots_and_streak_do_not()
    {
        var sessions = new[]
        {
            Session(Today, 25),
            Session(Today, 10, FocusOutcome.Abandoned, hour: 10),
            Session(Today.AddDays(-1), 45),     // Thứ 2, cùng tuần
            Session(Today.AddDays(-2), 30),     // Chủ nhật tuần trước
            Session(Today.AddDays(-3), 20, FocusOutcome.Abandoned),
        };

        var board = FocusBoard.Build(sessions, Today);

        Assert.Equal(35, board.MinutesToday);
        Assert.Equal(80, board.MinutesThisWeek);
        Assert.Equal(130, board.MinutesTotal);
        Assert.Equal(3, board.PotCount);
        Assert.Equal(3, board.Streak);
    }

    [Fact]
    public void Streak_survives_until_today_has_a_session()
    {
        var sessions = new[] { Session(Today.AddDays(-1), 25, hour: 23), Session(Today.AddDays(-2), 25) };

        Assert.Equal(2, FocusBoard.Build(sessions, Today).Streak);
        Assert.Equal(0, FocusBoard.Build(sessions, Today.AddDays(1)).Streak);
    }

    [Fact]
    public void Unlocks_follow_completed_hours_only()
    {
        // 5 giờ completed + 10 giờ abandoned: mở hướng dương và chậu kem, chưa mở chậu xanh xám.
        var sessions = Enumerable.Range(0, 5).Select(i => Session(Today.AddDays(-i), 60))
            .Concat(Enumerable.Range(0, 10).Select(i => Session(Today.AddDays(-i), 60, FocusOutcome.Abandoned, hour: 15)))
            .ToList();

        var board = FocusBoard.Build(sessions, Today);

        Assert.Equal(5, board.CompletedHours);
        Assert.True(board.Unlocks.Single(u => u.Key == "sunflower").Unlocked);
        Assert.True(board.Unlocks.Single(u => u.Key == "cream").Unlocked);
        var sage = board.Unlocks.Single(u => u.Key == "sage");
        Assert.False(sage.Unlocked);
        Assert.Equal(5, sage.HoursRemaining);
        Assert.True(FocusBoard.IsUnlocked(PlantKind.Sunflower, 5));
        Assert.False(FocusBoard.IsUnlocked(PlantKind.Cactus, 19.99));
    }

    [Fact]
    public void Pot_shows_linked_title_when_known()
    {
        var taskId = Guid.NewGuid();
        var board = FocusBoard.Build([Session(Today, 25, taskId: taskId)], Today,
            new Dictionary<Guid, string> { [taskId] = "Ôn SQL" });

        Assert.Equal("Ôn SQL", board.Shelves[0].Pots[0].LinkTitle);
    }
}
