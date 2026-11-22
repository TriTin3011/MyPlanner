using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Domain;

// Mọi công thức của SPEC §13 ở dạng hàm static thuần: không đụng DB, không đọc đồng hồ.
// "Hôm nay" luôn là tham số, nên test được với ngày cố định và web/WPF ra cùng con số.
public static class Metrics
{
    // Làm tròn kiểu "37,5% ≈ 38%" (MidpointRounding.AwayFromZero; mặc định của .NET là làm tròn về số chẵn: 37,5 → 38 nhưng 36,5 → 36).
    public static int Percent(int numerator, int denominator) =>
        denominator <= 0 ? 0 : (int)Math.Round(100.0 * numerator / denominator, MidpointRounding.AwayFromZero);

    public static int Percent(double ratio) => (int)Math.Round(100.0 * ratio, MidpointRounding.AwayFromZero);

    // §13.1: % vòng tròn = (việc xong + thói quen xong) / (tổng việc + tổng thói quen đang theo dõi).
    public static int TodayPercent(int tasksTotal, int tasksDone, int habitsTotal, int habitsDone) =>
        Percent(tasksDone + habitsDone, tasksTotal + habitsTotal);

    // §13.3
    public static double StepProgress(int stepCount, int doneSteps, GoalStatus status) =>
        stepCount > 0 ? (double)doneSteps / stepCount : status == GoalStatus.Done ? 1 : 0;

    public static double TimeProgress(DateOnly start, DateOnly deadline, DateOnly today)
    {
        var total = deadline.DayNumber - start.DayNumber;
        if (total <= 0) return today >= deadline ? 1 : 0;
        return Math.Clamp((double)(today.DayNumber - start.DayNumber) / total, 0, 1);
    }

    public static int DaysLeft(DateOnly deadline, DateOnly today) => deadline.DayNumber - today.DayNumber;

    // §13.4: chậm kế hoạch khi % thời gian vượt % tiến độ hơn 10 điểm.
    public static bool IsBehind(GoalStatus status, double timeProgress, double stepProgress) =>
        status != GoalStatus.Done && timeProgress - stepProgress > 0.10;

    // §13.5: % thói quen trong [from, to]. Mẫu số chỉ tính những ngày habit đã tồn tại và không vượt quá hôm nay.
    public static int HabitPercent(IEnumerable<DateOnly> habitStartDates, int logCount, DateOnly from, DateOnly to, DateOnly today)
    {
        return Percent(logCount, HabitCells(habitStartDates, from, to, today));
    }

    public static int DaysBetweenInclusive(DateOnly a, DateOnly b) => b < a ? 0 : b.DayNumber - a.DayNumber + 1;

    // §13.5: chuỗi hiện tại. Hôm nay chưa tick thì chưa tính là đứt chuỗi: bắt đầu đếm từ hôm qua.
    public static int CurrentStreak(IReadOnlySet<DateOnly> doneDates, DateOnly today)
    {
        var day = doneDates.Contains(today) ? today : today.AddDays(-1);
        var streak = 0;
        while (doneDates.Contains(day))
        {
            streak++;
            day = day.AddDays(-1);
        }
        return streak;
    }

    public static int LongestStreak(IEnumerable<DateOnly> doneDates)
    {
        int longest = 0, current = 0;
        DateOnly? previous = null;
        foreach (var day in doneDates.Distinct().Order())
        {
            current = previous is { } p && p.AddDays(1) == day ? current + 1 : 1;
            longest = Math.Max(longest, current);
            previous = day;
        }
        return longest;
    }

    // §13.6: câu nhận xét của tuần.
    public static string WeekComment(int done, int total, IWeekTextSource text)
    {
        if (total == 0) return text.NewWeekComment;
        if (done == 0) return text.NoTasksDoneComment;
        var r = (double)done / total;
        return r switch
        {
            < 0.3 => text.SlowWeekComment,
            < 0.5 => text.FindingRhythmComment,
            < 0.8 => text.GoodWeekComment,
            _ => text.ExcellentWeekComment,
        };
    }

    // §13.6: các câu "Xem thêm" so với tuần trước. habitCells = số ô thói quen tick được của tuần này (0 = chưa tới tuần đó / không có habit).
    public static List<string> WeekInsights(
        int done, int prevDone,
        int habitCells, int habitLogs, int habitPercent, int prevHabitPercent,
        DateOnly? bestDay, int bestDayDone,
        IWeekTextSource text)
    {
        var lines = new List<string>();

        var d = done - prevDone;
        if (d < 0) lines.Add(text.FewerTasks(-d));
        else if (d > 0) lines.Add(text.MoreTasks(d));
        else if (done > 0) lines.Add(text.SameTasks);

        if (habitCells > 0)
        {
            var h = habitPercent - prevHabitPercent;
            if (h < 0) lines.Add(text.HabitDecrease(-h));
            else if (h > 0) lines.Add(text.HabitIncrease(h));
        }

        if (bestDay is { } best && bestDayDone > 0)
            lines.Add(text.BestDay(best, bestDayDone));

        if (habitCells > 0 && habitLogs == 0)
            lines.Add(text.NoHabitTicks);

        return lines;
    }

    // Số ô thói quen tick được trong [from, to], không vượt hôm nay (mẫu số của HabitPercent).
    public static int HabitCells(IEnumerable<DateOnly> habitStartDates, DateOnly from, DateOnly to, DateOnly today) =>
        habitStartDates.Sum(start => DaysBetweenInclusive(Max(from, start), Min(to, today)));

    // §13.7: 5 mức màu heatmap theo số việc xong trong ngày.
    public static int HeatLevel(int doneCount) => doneCount switch
    {
        <= 0 => 0,
        <= 2 => 1,
        <= 4 => 2,
        <= 6 => 3,
        _ => 4,
    };

    public static DateOnly Max(DateOnly a, DateOnly b) => a > b ? a : b;
    public static DateOnly Min(DateOnly a, DateOnly b) => a < b ? a : b;
}
