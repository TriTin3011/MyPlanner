namespace MyPlanner.Core.Entities;

// Ghi chú ngày (SPEC §12.5): khoá chính là chính ngày.
public class DayNote
{
    public DateOnly Date { get; set; }
    public string Content { get; set; } = "";
    public DateTimeOffset UpdatedAt { get; set; }
}

// Ghi chú tuần: khoá là weekKey ISO, ví dụ "2026-W47".
public class WeekNote
{
    public string WeekKey { get; set; } = "";
    public string Content { get; set; } = "";
    public DateTimeOffset UpdatedAt { get; set; }
}

// Kế hoạch năm (SPEC §12.6).
public class YearMeta
{
    public int Year { get; set; }
    public string Keyword { get; set; } = "";
    public string Vision { get; set; } = "";
}

public class YearPlanItem
{
    public Guid Id { get; set; }
    public int Year { get; set; }
    public int Month { get; set; }   // 1–12
    public string Title { get; set; } = "";
    public bool Done { get; set; }
    public int Order { get; set; }
}
