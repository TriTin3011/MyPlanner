using MyPlanner.Core.Domain;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Tests;

// Test các công thức SPEC §13 bằng đúng ví dụ trong SPEC (khớp với ảnh mẫu).
public class MetricsTests
{
    private static DateOnly D(string s) => DateOnly.Parse(s);
    private static readonly IWeekTextSource WeekText = new VietnameseWeekTextSource();

    [Fact]
    public void TodayPercent_matches_spec_example() =>
        Assert.Equal(38, Metrics.TodayPercent(tasksTotal: 10, tasksDone: 3, habitsTotal: 6, habitsDone: 3));

    [Fact]
    public void Percent_is_zero_when_denominator_is_zero() => Assert.Equal(0, Metrics.Percent(0, 0));

    [Theory]
    [InlineData(2, 12, 17)]
    [InlineData(41, 52, 79)]
    [InlineData(1, 8, 13)] // 12,5 → 13 (không làm tròn về số chẵn)
    public void Percent_rounds_half_away_from_zero(int num, int den, int expected) =>
        Assert.Equal(expected, Metrics.Percent(num, den));

    [Theory]
    [InlineData(0.00, 0.47, true)]
    [InlineData(0.50, 1.00, true)]
    [InlineData(0.40, 0.29, false)]
    public void IsBehind_matches_spec_examples(double step, double time, bool expected) =>
        Assert.Equal(expected, Metrics.IsBehind(GoalStatus.InProgress, time, step));

    [Fact]
    public void IsBehind_is_false_for_done_goal() => Assert.False(Metrics.IsBehind(GoalStatus.Done, 1, 0));

    [Fact]
    public void StepProgress_without_steps_uses_status()
    {
        Assert.Equal(1, Metrics.StepProgress(0, 0, GoalStatus.Done));
        Assert.Equal(0, Metrics.StepProgress(0, 0, GoalStatus.InProgress));
        Assert.Equal(0.5, Metrics.StepProgress(4, 2, GoalStatus.InProgress));
    }

    [Fact]
    public void TimeProgress_is_clamped()
    {
        Assert.Equal(0, Metrics.TimeProgress(D("2026-01-10"), D("2026-01-20"), D("2026-01-01")));
        Assert.Equal(0.5, Metrics.TimeProgress(D("2026-01-10"), D("2026-01-20"), D("2026-01-15")));
        Assert.Equal(1, Metrics.TimeProgress(D("2026-01-10"), D("2026-01-20"), D("2026-02-01")));
    }

    [Fact]
    public void DaysLeft_is_negative_when_overdue() =>
        Assert.Equal(-3, Metrics.DaysLeft(D("2026-11-19"), D("2026-11-22")));

    [Fact]
    public void CurrentStreak_starts_from_yesterday_when_today_not_ticked()
    {
        var days = new HashSet<DateOnly> { D("2026-11-19"), D("2026-11-20"), D("2026-11-21") };
        Assert.Equal(3, Metrics.CurrentStreak(days, D("2026-11-22")));
        days.Add(D("2026-11-22"));
        Assert.Equal(4, Metrics.CurrentStreak(days, D("2026-11-22")));
    }

    [Fact]
    public void CurrentStreak_breaks_on_gap()
    {
        var days = new HashSet<DateOnly> { D("2026-11-18"), D("2026-11-21") };
        Assert.Equal(1, Metrics.CurrentStreak(days, D("2026-11-22")));
        Assert.Equal(0, Metrics.CurrentStreak(days, D("2026-11-24")));
    }

    [Fact]
    public void LongestStreak_finds_longest_run_ignoring_order_and_duplicates()
    {
        var days = new[] { D("2026-11-05"), D("2026-11-01"), D("2026-11-02"), D("2026-11-03"), D("2026-11-02"), D("2026-11-06") };
        Assert.Equal(3, Metrics.LongestStreak(days));
        Assert.Equal(0, Metrics.LongestStreak([]));
    }

    [Fact]
    public void HabitPercent_ignores_days_before_habit_start_and_after_today()
    {
        // Tuần 16–22/11, hôm nay 20/11. Habit A có từ trước (5 ngày tính được), habit B bắt đầu 19/11 (2 ngày).
        var starts = new[] { D("2026-01-01"), D("2026-11-19") };
        Assert.Equal(Metrics.Percent(5, 7), Metrics.HabitPercent(starts, 5, D("2026-11-16"), D("2026-11-22"), D("2026-11-20")));
    }

    [Theory]
    [InlineData(0, 0, "Tuần mới, lên kế hoạch thôi!")]
    [InlineData(2, 10, "Tuần hơi chậm, chọn 3 việc quan trọng nhất trước nhé.")]
    [InlineData(4, 10, "Đang vào nhịp, cố thêm chút nữa.")]
    [InlineData(7, 10, "Khá tốt, giữ nhịp này nhé.")]
    [InlineData(8, 10, "Tuần tuyệt vời! Bạn hoàn thành phần lớn kế hoạch.")]
    [InlineData(0, 3, "Chưa xong việc nào. Tuần sau hãy bắt đầu từ 1–2 việc nhỏ.")]
    public void WeekComment_by_ratio(int done, int total, string expected) =>
        Assert.Equal(expected, Metrics.WeekComment(done, total, WeekText));

    [Fact]
    public void WeekInsights_compares_with_previous_week_like_the_reference()
    {
        // Số liệu thật của bản demo: 24 việc xong (tuần trước 34), thói quen 55% (tuần trước 81%), Thứ 2 xong 6 việc.
        var lines = Metrics.WeekInsights(24, 34, habitCells: 42, habitLogs: 23, habitPercent: 55, prevHabitPercent: 81,
            bestDay: D("2026-11-16"), bestDayDone: 6, text: WeekText);

        Assert.Equal(
        [
            "Xong ít hơn tuần trước 10 việc, thử chia nhỏ việc để dễ hoàn thành hơn.",
            "Thói quen giảm 26% so với tuần trước, hãy tích đều hơn.",
            "Ngày hiệu quả nhất: Thứ 2 (6 việc xong).",
        ], lines);
    }

    [Fact]
    public void WeekInsights_after_clearing_the_week_reports_no_habit_ticks_and_no_best_day()
    {
        var lines = Metrics.WeekInsights(0, 34, habitCells: 42, habitLogs: 0, habitPercent: 0, prevHabitPercent: 81,
            bestDay: null, bestDayDone: 0, text: WeekText);

        Assert.Equal(
        [
            "Xong ít hơn tuần trước 34 việc, thử chia nhỏ việc để dễ hoàn thành hơn.",
            "Thói quen giảm 81% so với tuần trước, hãy tích đều hơn.",
            "Chưa tích thói quen nào trong tuần này.",
        ], lines);
    }

    [Fact]
    public void WeekInsights_for_a_future_week_skips_habit_lines()
    {
        var lines = Metrics.WeekInsights(0, 0, habitCells: 0, habitLogs: 0, habitPercent: 0, prevHabitPercent: 0,
            bestDay: null, bestDayDone: 0, text: WeekText);
        Assert.Empty(lines);
    }

    [Theory]
    [InlineData(0, 0)]
    [InlineData(1, 1)]
    [InlineData(2, 1)]
    [InlineData(3, 2)]
    [InlineData(6, 3)]
    [InlineData(7, 4)]
    [InlineData(20, 4)]
    public void HeatLevel_has_five_levels(int done, int level) => Assert.Equal(level, Metrics.HeatLevel(done));

    private sealed class VietnameseWeekTextSource : IWeekTextSource
    {
        public string NewWeekComment => "Tuần mới, lên kế hoạch thôi!";
        public string NoTasksDoneComment => "Chưa xong việc nào. Tuần sau hãy bắt đầu từ 1–2 việc nhỏ.";
        public string SlowWeekComment => "Tuần hơi chậm, chọn 3 việc quan trọng nhất trước nhé.";
        public string FindingRhythmComment => "Đang vào nhịp, cố thêm chút nữa.";
        public string GoodWeekComment => "Khá tốt, giữ nhịp này nhé.";
        public string ExcellentWeekComment => "Tuần tuyệt vời! Bạn hoàn thành phần lớn kế hoạch.";
        public string FewerTasks(int count) => $"Xong ít hơn tuần trước {count} việc, thử chia nhỏ việc để dễ hoàn thành hơn.";
        public string MoreTasks(int count) => $"Xong nhiều hơn tuần trước {count} việc, đang tiến bộ.";
        public string SameTasks => "Số việc xong bằng tuần trước, giữ nhịp nhé.";
        public string HabitDecrease(int percent) => $"Thói quen giảm {percent}% so với tuần trước, hãy tích đều hơn.";
        public string HabitIncrease(int percent) => $"Thói quen tăng {percent}% so với tuần trước.";
        public string BestDay(DateOnly date, int tasksDone) =>
            $"Ngày hiệu quả nhất: {DayName(date)} ({tasksDone} việc xong).";
        public string NoHabitTicks => "Chưa tích thói quen nào trong tuần này.";

        private static string DayName(DateOnly date) => date.DayOfWeek switch
        {
            DayOfWeek.Sunday => "Chủ nhật",
            var day => $"Thứ {(int)day + 1}",
        };
    }
}

public class WeekKeysTests
{
    [Theory]
    [InlineData("2026-11-22", "2026-W47")] // Chủ nhật vẫn thuộc tuần bắt đầu Thứ 2 16/11
    [InlineData("2026-11-16", "2026-W47")]
    [InlineData("2025-12-29", "2026-W01")] // năm ISO khác năm dương lịch
    [InlineData("2027-01-01", "2026-W53")]
    public void ToKey_uses_iso_week(string date, string key) => Assert.Equal(key, WeekKeys.ToKey(DateOnly.Parse(date)));

    [Fact]
    public void TryParse_returns_monday()
    {
        Assert.True(WeekKeys.TryParse("2026-W47", out var monday));
        Assert.Equal(new DateOnly(2026, 11, 16), monday);
        Assert.False(WeekKeys.TryParse("2026-W60", out _));
        Assert.False(WeekKeys.TryParse("abc", out _));
    }

    [Fact]
    public void IsoWeekday_sunday_is_7() => Assert.Equal(7, WeekKeys.IsoWeekday(new DateOnly(2026, 11, 22)));
}

public class RecurrenceTests
{
    private static readonly DateOnly Today = new(2026, 11, 18); // Thứ 4

    private static RecurringTask Rule(params int[] weekdays) => new()
    {
        Title = "Tập thể dục",
        Weekdays = [.. weekdays],
        StartDate = new DateOnly(2026, 1, 1),
    };

    [Fact]
    public void Creates_only_matching_weekdays()
    {
        var dates = Recurrence.DatesToCreate(Rule(1, 3), new(2026, 11, 16), new(2026, 11, 22), Today, new HashSet<DateOnly>()).ToList();
        Assert.Equal([new DateOnly(2026, 11, 16), new DateOnly(2026, 11, 18)], dates);
    }

    [Fact]
    public void Skips_existing_and_skipped_dates()
    {
        var rule = Rule(1, 2, 3);
        rule.SkippedDates.Add(new(2026, 11, 17));
        var existing = new HashSet<DateOnly> { new(2026, 11, 16) };
        var dates = Recurrence.DatesToCreate(rule, new(2026, 11, 16), new(2026, 11, 22), Today, existing).ToList();
        Assert.Equal([new DateOnly(2026, 11, 18)], dates);
    }

    [Fact]
    public void Does_not_go_beyond_horizon_or_before_start_or_when_inactive()
    {
        var all = Rule(1, 2, 3, 4, 5, 6, 7);
        var dates = Recurrence.DatesToCreate(all, Today, Today.AddDays(30), Today, new HashSet<DateOnly>()).ToList();
        Assert.Equal(Recurrence.HorizonDays + 1, dates.Count);

        all.StartDate = Today.AddDays(2);
        Assert.Equal(Today.AddDays(2), Recurrence.DatesToCreate(all, Today, Today.AddDays(3), Today, new HashSet<DateOnly>()).First());

        all.Active = false;
        Assert.Empty(Recurrence.DatesToCreate(all, Today, Today.AddDays(3), Today, new HashSet<DateOnly>()));
    }
}
