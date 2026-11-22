using System.Globalization;

namespace MyPlanner.Core.Domain;

// Tuần ISO 8601: bắt đầu Thứ 2, tuần 1 là tuần chứa ngày Thứ 5 đầu tiên của năm.
// weekKey dạng "2026-W47". Năm ISO có thể khác năm dương lịch (29/12/2025 thuộc 2026-W01).
public static class WeekKeys
{
    public static string ToKey(DateOnly date)
    {
        var dt = date.ToDateTime(TimeOnly.MinValue);
        return $"{ISOWeek.GetYear(dt)}-W{ISOWeek.GetWeekOfYear(dt):D2}";
    }

    public static bool TryParse(string? key, out DateOnly monday)
    {
        monday = default;
        if (key is null || key.Length < 7) return false;
        var parts = key.Split("-W");
        if (parts.Length != 2
            || !int.TryParse(parts[0], NumberStyles.None, CultureInfo.InvariantCulture, out var year)
            || !int.TryParse(parts[1], NumberStyles.None, CultureInfo.InvariantCulture, out var week)
            || year is < 1 or > 9998 || week < 1 || week > ISOWeek.GetWeeksInYear(year))
            return false;
        monday = DateOnly.FromDateTime(ISOWeek.ToDateTime(year, week, DayOfWeek.Monday));
        return true;
    }

    public static DateOnly MondayOf(DateOnly date) => date.AddDays(-(IsoWeekday(date) - 1));

    // 1 = Thứ 2 … 7 = Chủ nhật (DayOfWeek của .NET thì Sunday = 0).
    public static int IsoWeekday(DateOnly date) => date.DayOfWeek == DayOfWeek.Sunday ? 7 : (int)date.DayOfWeek;
}
