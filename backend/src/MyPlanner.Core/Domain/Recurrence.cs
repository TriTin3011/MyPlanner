using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Domain;

// Quy tắc sinh việc lặp lại (SPEC §12.2), tách thành hàm thuần để test không cần DB.
public static class Recurrence
{
    // Chỉ sinh tối đa 7 ngày sau hôm nay để không tạo việc rác.
    public const int HorizonDays = 7;

    // Trả các ngày trong [from, to] mà rule cần có Task nhưng chưa có.
    // existingDates: các ngày đã có Task mang recurringId này (kể cả đã xong).
    public static IEnumerable<DateOnly> DatesToCreate(
        RecurringTask rule, DateOnly from, DateOnly to, DateOnly today, IReadOnlySet<DateOnly> existingDates)
    {
        if (!rule.Active) yield break;
        var last = Metrics.Min(to, today.AddDays(HorizonDays));
        for (var day = Metrics.Max(from, rule.StartDate); day <= last; day = day.AddDays(1))
        {
            if (!rule.Weekdays.Contains(WeekKeys.IsoWeekday(day))) continue;
            if (rule.SkippedDates.Contains(day)) continue;
            if (existingDates.Contains(day)) continue;
            yield return day;
        }
    }
}
