using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.Core.Domain;

// SPEC §13.9: mọi con số của tab Tập trung. Hàm thuần, không đụng DB, để web, WPF và Flutter ra cùng số.
public static class FocusBoard
{
    // Kệ 3 tầng: 3 + 4 + 5 chậu.
    public const int ShelfCapacity = 12;

    // Ngưỡng mở khoá theo tổng GIỜ của phiên completed. Thứ tự bảng = thứ tự hiện ở FE.
    public static readonly IReadOnlyList<(PlantKind Plant, double Hours)> PlantThresholds =
    [
        (PlantKind.Basil, 0),
        (PlantKind.Sunflower, 5),
        (PlantKind.Cactus, 20),
    ];

    public static readonly IReadOnlyList<(PotColor Pot, double Hours)> PotThresholds =
    [
        (PotColor.Terra, 0),
        (PotColor.Cream, 2),
        (PotColor.Sage, 10),
        (PotColor.Blue, 40),
    ];

    public static double CompletedHours(IEnumerable<FocusSessionDto> sessions) =>
        sessions.Where(s => s.Outcome == FocusOutcome.Completed).Sum(s => s.ActualMinutes) / 60.0;

    public static bool IsUnlocked(PlantKind plant, double completedHours) =>
        completedHours >= PlantThresholds.First(t => t.Plant == plant).Hours;

    public static bool IsUnlocked(PotColor pot, double completedHours) =>
        completedHours >= PotThresholds.First(t => t.Pot == pot).Hours;

    // titles: Id của việc/thói quen/mục tiêu → tên, để thẻ chậu hiện "Ôn SQL". Thiếu thì LinkTitle = null.
    public static FocusBoardDto Build(
        IReadOnlyList<FocusSessionDto> sessions, DateOnly today, IReadOnlyDictionary<Guid, string>? titles = null)
    {
        var monday = today.AddDays(-(((int)today.DayOfWeek + 6) % 7));
        var minutesToday = sessions.Where(s => s.Date == today).Sum(s => s.ActualMinutes);
        var minutesWeek = sessions.Where(s => s.Date >= monday && s.Date <= today).Sum(s => s.ActualMinutes);
        var minutesTotal = sessions.Sum(s => s.ActualMinutes);

        // Hoà EndedAt thì so Id để mọi client xếp cùng một thứ tự.
        var completed = sessions.Where(s => s.Outcome == FocusOutcome.Completed)
            .OrderBy(s => s.EndedAt).ThenBy(s => s.Id)
            .ToList();
        var hours = CompletedHours(completed);

        var shelfCount = Math.Max(1, (completed.Count + ShelfCapacity - 1) / ShelfCapacity);
        var shelves = Enumerable.Range(0, shelfCount)
            .Select(i => new FocusShelfDto(i, completed
                .Skip(i * ShelfCapacity).Take(ShelfCapacity)
                .Select((s, slot) => new FocusPotDto(
                    s.Id, slot, s.PlantKind, s.PotColor, s.ActualMinutes, s.Date, s.EndedAt, TitleOf(s, titles)))
                .ToList()))
            .ToList();

        var streak = Metrics.CurrentStreak(completed.Select(s => s.Date).ToHashSet(), today);

        var unlocks = PlantThresholds.Select(t => Unlock("plant", PlantKey(t.Plant), t.Hours, hours))
            .Concat(PotThresholds.Select(t => Unlock("pot", PotKey(t.Pot), t.Hours, hours)))
            .ToList();

        return new FocusBoardDto(
            minutesToday, minutesWeek, minutesTotal, completed.Count, streak,
            Math.Round(hours, 2), shelves, unlocks);
    }

    public static string PlantKey(PlantKind plant) => plant switch
    {
        PlantKind.Basil => "basil",
        PlantKind.Sunflower => "sunflower",
        PlantKind.Cactus => "cactus",
        _ => throw new ArgumentOutOfRangeException(nameof(plant)),
    };

    public static string PotKey(PotColor pot) => pot switch
    {
        PotColor.Terra => "terra",
        PotColor.Cream => "cream",
        PotColor.Sage => "sage",
        PotColor.Blue => "blue",
        _ => throw new ArgumentOutOfRangeException(nameof(pot)),
    };

    private static FocusUnlockDto Unlock(string kind, string key, double threshold, double hours) =>
        new(kind, key, threshold, hours >= threshold, Math.Round(Math.Max(0, threshold - hours), 2));

    private static string? TitleOf(FocusSessionDto s, IReadOnlyDictionary<Guid, string>? titles)
    {
        if (titles is null) return null;
        var id = s.TaskId ?? s.HabitId ?? s.GoalId;
        return id is { } key && titles.TryGetValue(key, out var title) ? title : null;
    }
}
