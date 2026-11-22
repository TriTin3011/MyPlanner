using MyPlanner.Core.Dtos;

namespace MyPlanner.Core.Domain;

// Hàm thuần dựng YearDashboardDto (SPEC §13.8). Không đụng DB, không đọc đồng hồ: dễ unit test,
// và WPF/Flutter nhận đúng cùng con số vì chỉ BE gọi hàm này.
public static class YearBoard
{
    public static YearDashboardDto Build(
        int year,
        YearMetaDto? meta,
        IReadOnlyList<YearPlanItemDto> items,
        IReadOnlyList<DeadlineDto> deadlines,
        DateOnly today)
    {
        var months = Enumerable.Range(1, 12).Select(m =>
        {
            var monthItems = items.Where(i => i.Year == year && i.Month == m).OrderBy(i => i.Order).ToList();
            var done = monthItems.Count(i => i.Done);
            var monthDeadlines = deadlines
                .Where(d => d.Date.Year == year && d.Date.Month == m)
                .OrderBy(d => d.Date).ThenBy(d => d.Kind)
                .ToList();
            return new YearMonthDto(m, done, monthItems.Count, Metrics.Percent(done, monthItems.Count), monthDeadlines, monthItems);
        }).ToList();

        var totalDone = months.Sum(m => m.Done);
        var total = months.Sum(m => m.Total);
        return new YearDashboardDto(
            year,
            meta?.Keyword ?? "",
            meta?.Vision ?? "",
            totalDone,
            total,
            Metrics.Percent(totalDone, total),
            today.Year == year ? today.Month : null,
            months);
    }

    // Ghép hạn bước và hạn mục tiêu thành DeadlineRow, dùng chung cho /deadlines và /dashboard/year.
    // SPEC §13.4: quá hạn = chưa xong và hạn đã qua (hạn đúng hôm nay thì chưa quá).
    public static List<DeadlineDto> Deadlines(
        IEnumerable<(Guid GoalId, string GoalTitle, string Title, DateOnly Deadline, bool Done)> steps,
        IEnumerable<(Guid GoalId, string Title, DateOnly Deadline, bool Done)> goals,
        DateOnly today) =>
        steps
            .Select(s => new DeadlineDto(s.Deadline, DeadlineKind.Step, s.GoalId, s.GoalTitle, s.Title, s.Done,
                IsOverdue(s.Deadline, s.Done, today)))
            .Concat(goals.Select(g => new DeadlineDto(g.Deadline, DeadlineKind.Goal, g.GoalId, g.Title, g.Title, g.Done,
                IsOverdue(g.Deadline, g.Done, today))))
            .OrderBy(d => d.Date)
            .ThenBy(d => d.Kind)
            .ToList();

    public static bool IsOverdue(DateOnly deadline, bool done, DateOnly today) => !done && deadline < today;
}
