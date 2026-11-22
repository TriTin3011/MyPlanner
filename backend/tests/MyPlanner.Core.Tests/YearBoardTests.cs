using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Core.Tests;

// YearBoard (SPEC §10, §13.8): x/y từng tháng, tổng năm, ⚑ k và tháng hiện tại.
public class YearBoardTests
{
    private static readonly DateOnly Today = new(2026, 11, 22);

    private static YearPlanItemDto Item(int month, bool done, int order = 0, int year = 2026) =>
        new(Guid.NewGuid(), year, month, $"m{month}", done, order);

    [Fact]
    public void Months_and_year_totals_follow_spec_example()
    {
        // 41/52 = 79% như ảnh tham chiếu: 11 tháng xong hết 4/4, tháng 11 xong 0/8.
        var items = new List<YearPlanItemDto>();
        for (var m = 1; m <= 10; m++)
            for (var k = 0; k < 4; k++) items.Add(Item(m, true, k));
        items.Add(Item(12, true));
        items.Add(Item(12, false, 1));
        for (var k = 0; k < 10; k++) items.Add(Item(11, false, k));

        var board = YearBoard.Build(2026, new YearMetaDto(2026, "Bứt phá", "v"), items, [], Today);

        Assert.Equal((41, 52, 79), (board.Done, board.Total, board.Percent));
        Assert.Equal("Bứt phá", board.Keyword);
        Assert.Equal(12, board.Months.Count);
        Assert.Equal((0, 10, 0), (board.Months[10].Done, board.Months[10].Total, board.Months[10].Percent));
        Assert.Equal((1, 2, 50), (board.Months[11].Done, board.Months[11].Total, board.Months[11].Percent));
    }

    [Fact]
    public void Items_are_ordered_and_empty_year_is_zero()
    {
        var a = Item(3, false, 2);
        var b = Item(3, false, 0);
        var board = YearBoard.Build(2026, null, [a, b], [], Today);

        Assert.Equal([b.Id, a.Id], board.Months[2].Items.Select(i => i.Id));
        Assert.Equal("", board.Keyword);

        var empty = YearBoard.Build(2026, null, [], [], Today);
        Assert.Equal((0, 0, 0), (empty.Done, empty.Total, empty.Percent));
    }

    [Fact]
    public void Deadlines_go_to_their_month_and_current_month_only_in_same_year()
    {
        var goalId = Guid.NewGuid();
        var deadlines = YearBoard.Deadlines(
            [(goalId, "Trả nợ", "Bước 1", new DateOnly(2026, 11, 17), false)],
            [(goalId, "Trả nợ", new DateOnly(2026, 11, 12), false), (goalId, "Trả nợ", new DateOnly(2027, 1, 5), false)],
            Today);

        var board = YearBoard.Build(2026, null, [], deadlines, Today);

        Assert.Equal(11, board.CurrentMonth);
        var nov = board.Months[10].Deadlines;
        Assert.Equal(2, nov.Count);                      // ⚑ 2: hạn 2027 không lọt vào năm 2026
        Assert.Equal(new DateOnly(2026, 11, 12), nov[0].Date);
        Assert.All(nov, d => Assert.True(d.Overdue));

        Assert.Null(YearBoard.Build(2025, null, [], [], Today).CurrentMonth);
    }

    [Fact]
    public void Deadline_today_is_not_overdue_and_done_never_is()
    {
        Assert.False(YearBoard.IsOverdue(Today, done: false, Today));
        Assert.True(YearBoard.IsOverdue(Today.AddDays(-1), done: false, Today));
        Assert.False(YearBoard.IsOverdue(Today.AddDays(-1), done: true, Today));
    }
}
