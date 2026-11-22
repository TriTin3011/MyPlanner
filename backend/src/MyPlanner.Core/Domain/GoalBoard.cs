using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Domain;

// Dựng GoalBoardDto từ danh sách GoalDto và "hôm nay" của client. Hàm thuần: không DB, không đồng hồ, nên test bằng xUnit.
public static class GoalBoard
{
    public static GoalBoardDto Build(IReadOnlyList<GoalDto> goals, DateOnly today)
    {
        var cards = goals
            .Select(g => Card(g, today))
            .OrderBy(c => c.Status == GoalStatus.Done)   // chưa xong trước (false < true)
            .ThenBy(c => c.Deadline)
            .ThenBy(c => c.Title, StringComparer.CurrentCulture)
            .ToList();

        // Radar dùng stepProgress dạng double rồi mới làm tròn, tránh sai số khi trung bình các số đã làm tròn.
        var areas = Enum.GetValues<LifeArea>()
            .Select(area =>
            {
                var inArea = goals.Where(g => g.Area == area).ToList();
                var avg = inArea.Count == 0 ? 0 : inArea.Average(Progress);
                return new AreaSummaryDto(area, inArea.Count, Metrics.Percent(avg));
            })
            .ToList();

        var done = goals.Count(g => g.Status == GoalStatus.Done);
        return new GoalBoardDto(done, goals.Count, Metrics.Percent(done, goals.Count), areas, cards);
    }

    public static GoalCardDto Card(GoalDto g, DateOnly today)
    {
        var stepsDone = g.Steps.Count(s => s.Done);
        var step = Progress(g);
        var time = Metrics.TimeProgress(g.StartDate, g.Deadline, today);
        var overdueSteps = g.Steps.Count(s => !s.Done && s.Deadline is { } d && d < today);

        return new GoalCardDto(
            g.Id, g.Title, g.Area, g.Status, g.StartDate, g.Deadline, g.Reward,
            Metrics.DaysLeft(g.Deadline, today),
            stepsDone, g.Steps.Count, overdueSteps,
            Metrics.Percent(step), Metrics.Percent(time),
            Metrics.IsBehind(g.Status, time, step));
    }

    private static double Progress(GoalDto g) =>
        Metrics.StepProgress(g.Steps.Count, g.Steps.Count(s => s.Done), g.Status);
}
