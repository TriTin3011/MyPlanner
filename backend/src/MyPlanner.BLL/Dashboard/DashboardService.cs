using MyPlanner.Core.Dtos;
using MyPlanner.Core.Domain;
using MyPlanner.BLL.Localization;
using MyPlanner.DAL.Goals;
using MyPlanner.DAL.Habits;
using MyPlanner.DAL.Notes;
using MyPlanner.DAL.Tasks;

namespace MyPlanner.BLL.Dashboard;

public class DashboardService(
    ITaskRepository tasks,
    IHabitRepository habits,
    INoteRepository notes,
    IGoalRepository goals) : IDashboardService
{
    public async Task<TodayDashboardDto> GetTodayAsync(DateOnly date, CancellationToken ct)
    {
        var todayTasks = await tasks.ListAsync(date, date, ct);
        var activeHabits = (await habits.ListAsync(includeInactive: false, ct))
            .Where(h => h.StartDate <= date)
            .ToList();
        var doneHabitIds = (await habits.LogsAsync(date, date, ct))
            .Select(l => l.HabitId)
            .ToHashSet();

        var tasksDone = todayTasks.Count(t => t.Done);
        var habitsDone = activeHabits.Count(h => doneHabitIds.Contains(h.Id));
        var percent = Metrics.TodayPercent(todayTasks.Count, tasksDone, activeHabits.Count, habitsDone);
        var backlog = await tasks.BacklogAsync(date, ct);
        var note = await notes.GetDayAsync(date, ct);
        var todayHabits = activeHabits
            .Select(h => new TodayHabitDto(h.Id, h.Title, h.Order, doneHabitIds.Contains(h.Id)))
            .ToList();

        return new TodayDashboardDto(
            date, percent, tasksDone, todayTasks.Count, habitsDone, activeHabits.Count,
            todayTasks, backlog, todayHabits, note);
    }

    // Một dòng cho mỗi ngày trong [from, to], kể cả ngày không có việc (0/0), để FE vẽ thẳng không phải lấp chỗ trống.
    public async Task<List<DayProgressDto>> GetDaysAsync(DateOnly from, DateOnly to, CancellationToken ct)
    {
        var byDate = (await tasks.ListAsync(from, to, ct))
            .GroupBy(t => t.Date)
            .ToDictionary(g => g.Key, g => (Done: g.Count(t => t.Done), Total: g.Count()));
        var deadlines = await goals.DeadlineDatesAsync(from, to, ct);

        var days = new List<DayProgressDto>(Metrics.DaysBetweenInclusive(from, to));
        for (var d = from; d <= to; d = d.AddDays(1))
        {
            var (done, total) = byDate.GetValueOrDefault(d);
            days.Add(new DayProgressDto(d, done, total, Metrics.Percent(done, total), deadlines.Contains(d)));
        }
        return days;
    }

    // SPEC §9.1 + §13.6. monday là Thứ 2 của tuần đang xem; today là "hôm nay" của client (có thể nằm ngoài tuần).
    public async Task<WeekDashboardDto> GetWeekAsync(DateOnly monday, DateOnly today, CancellationToken ct)
    {
        var sunday = monday.AddDays(6);
        var prevMonday = monday.AddDays(-7);
        var days = await GetDaysAsync(monday, sunday, ct);

        // Đọc một lần cả tuần trước lẫn tuần này rồi chia trong bộ nhớ: 1 truy vấn thay vì 2.
        var twoWeeks = await tasks.ListAsync(prevMonday, sunday, ct);
        var weekTasks = twoWeeks.Where(t => t.Date >= monday).ToList();
        var done = weekTasks.Count(t => t.Done);
        var prevDone = twoWeeks.Count(t => t.Date < monday && t.Done);

        // HÔM NAY chỉ có nghĩa khi tuần đang xem chứa hôm nay (giống bản tham chiếu).
        var todayRemaining = today >= monday && today <= sunday
            ? weekTasks.Count(t => t.Date == today && !t.Done)
            : 0;

        // Thói quen: chỉ habit đang theo dõi; log tính tới hôm nay (ô tương lai chưa thể tick).
        var activeHabits = (await habits.ListAsync(includeInactive: false, ct)).ToList();
        var activeIds = activeHabits.Select(h => h.Id).ToHashSet();
        var starts = activeHabits.Select(h => h.StartDate).ToList();
        var logs = (await habits.LogsAsync(prevMonday, sunday, ct))
            .Where(l => activeIds.Contains(l.HabitId) && l.Date <= today)
            .ToList();
        var habitLogs = logs.Count(l => l.Date >= monday);
        var habitCells = Metrics.HabitCells(starts, monday, sunday, today);
        var habitPercent = Metrics.Percent(habitLogs, habitCells);
        var prevHabitPercent = Metrics.HabitPercent(starts, logs.Count - habitLogs, prevMonday, monday.AddDays(-1), today);

        var best = days.Where(d => d.TasksDone > 0)
            .OrderByDescending(d => d.TasksDone)
            .ThenBy(d => d.Date)
            .FirstOrDefault();

        return new WeekDashboardDto(
            WeekKeys.ToKey(monday), monday, sunday,
            done, weekTasks.Count, habitPercent,
            TodayRemaining: todayRemaining,
            Comment: Metrics.WeekComment(done, weekTasks.Count, LocalizedWeekTextSource.Instance),
            Days: days,
            Insights: Metrics.WeekInsights(done, prevDone, habitCells, habitLogs, habitPercent, prevHabitPercent,
                best?.Date, best?.TasksDone ?? 0, LocalizedWeekTextSource.Instance));
    }

    // SPEC §9.2 chế độ 12 tuần: count tuần liên tiếp, tuần cuối bắt đầu ở lastMonday. Một truy vấn rồi gộp theo tuần.
    public async Task<List<WeekProgressDto>> GetWeeksAsync(DateOnly lastMonday, int count, CancellationToken ct)
    {
        var firstMonday = lastMonday.AddDays(-7 * (count - 1));
        var byWeek = (await tasks.ListAsync(firstMonday, lastMonday.AddDays(6), ct))
            .GroupBy(t => (t.Date.DayNumber - firstMonday.DayNumber) / 7)
            .ToDictionary(g => g.Key, g => (Done: g.Count(t => t.Done), Total: g.Count()));

        var weeks = new List<WeekProgressDto>(count);
        for (var i = 0; i < count; i++)
        {
            var monday = firstMonday.AddDays(7 * i);
            var (done, total) = byWeek.GetValueOrDefault(i);
            weeks.Add(new WeekProgressDto(WeekKeys.ToKey(monday), monday, done, total, Metrics.Percent(done, total)));
        }
        return weeks;
    }

    // SPEC §8 + §13.5. firstOfMonth là ngày 1 của tháng đang xem; today của client quyết định ô nào đã "qua".
    public async Task<HabitMonthDto> GetHabitMonthAsync(DateOnly firstOfMonth, DateOnly today, CancellationToken ct)
    {
        var from = firstOfMonth;
        var to = from.AddMonths(1).AddDays(-1);

        // Chỉ habit đang theo dõi và đã tồn tại trước cuối tháng (tháng cũ không hiện habit tạo sau này).
        var rows = (await habits.ListAsync(includeInactive: false, ct))
            .Where(h => h.StartDate <= to)
            .OrderBy(h => h.Order)
            .ToList();
        if (rows.Count == 0)
            return new HabitMonthDto(MonthKey(from), from, to, 0, null, null, [], EmptyDays(from, to, today));

        // Chuỗi dài nhất tính trên toàn bộ lịch sử (kể cả log trước StartDate nếu người dùng đã sửa ngày bắt đầu).
        // Một truy vấn cho cả hai việc (streak + tháng), rồi chia trong bộ nhớ. Bảng log nhỏ (≤ vài nghìn dòng/năm).
        var ids = rows.Select(h => h.Id).ToHashSet();
        var logs = (await habits.LogsAsync(DateOnly.MinValue, Metrics.Max(to, today), ct))
            .Where(l => ids.Contains(l.HabitId) && l.Date <= today)
            .ToList();
        var datesByHabit = logs
            .GroupBy(l => l.HabitId)
            .ToDictionary(g => g.Key, g => g.Select(l => l.Date).ToHashSet());

        var habitRows = rows.Select(h =>
        {
            var dates = datesByHabit.GetValueOrDefault(h.Id) ?? [];
            var inMonth = dates.Where(d => d >= from && d <= to).Order().ToList();
            return new HabitMonthRowDto(
                h.Id, h.Title, h.Order, h.StartDate,
                Percent: Metrics.HabitPercent([h.StartDate], inMonth.Count, from, to, today),
                CurrentStreak: Metrics.CurrentStreak(dates, today),
                LongestStreak: Metrics.LongestStreak(dates),
                DoneDates: inMonth);
        }).ToList();

        var monthLogs = habitRows.Sum(r => r.DoneDates.Count);
        var starts = rows.Select(h => h.StartDate).ToList();
        var percent = Metrics.HabitPercent(starts, monthLogs, from, to, today);

        // Hoà thì lấy habit đứng trên (Order nhỏ hơn), để mọi client chọn cùng một habit.
        var longest = habitRows.Where(r => r.LongestStreak > 0)
            .OrderByDescending(r => r.LongestStreak).ThenBy(r => r.Order).FirstOrDefault();
        var consistent = habitRows.Where(r => Metrics.HabitCells([r.StartDate], from, to, today) > 0)
            .OrderByDescending(r => r.Percent).ThenBy(r => r.Order).FirstOrDefault();

        var doneByDate = logs.Where(l => l.Date >= from && l.Date <= to)
            .GroupBy(l => l.Date)
            .ToDictionary(g => g.Key, g => g.Count());
        var days = new List<HabitDayCountDto>(Metrics.DaysBetweenInclusive(from, to));
        for (var d = from; d <= to; d = d.AddDays(1))
        {
            if (d > today)
            {
                days.Add(new HabitDayCountDto(d, null, null, null));
                continue;
            }
            var done = doneByDate.GetValueOrDefault(d);
            var total = rows.Count(h => h.StartDate <= d);
            days.Add(new HabitDayCountDto(d, done, total, Metrics.Percent(done, total)));
        }

        return new HabitMonthDto(
            MonthKey(from), from, to, percent,
            longest is null ? null : new HabitHighlightDto(longest.Id, longest.Title, longest.LongestStreak),
            consistent is null ? null : new HabitHighlightDto(consistent.Id, consistent.Title, consistent.Percent),
            habitRows, days);
    }

    private static string MonthKey(DateOnly firstOfMonth) => $"{firstOfMonth.Year:D4}-{firstOfMonth.Month:D2}";

    private static List<HabitDayCountDto> EmptyDays(DateOnly from, DateOnly to, DateOnly today)
    {
        var days = new List<HabitDayCountDto>();
        for (var d = from; d <= to; d = d.AddDays(1))
            days.Add(d > today ? new HabitDayCountDto(d, null, null, null) : new HabitDayCountDto(d, 0, 0, 0));
        return days;
    }
}
