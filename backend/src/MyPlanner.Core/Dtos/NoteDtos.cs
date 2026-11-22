namespace MyPlanner.Core.Dtos;

public record DayNoteDto(DateOnly Date, string Content, DateTimeOffset? UpdatedAt);

public record WeekNoteDto(string WeekKey, string Content, DateTimeOffset? UpdatedAt);

public record SaveNoteRequest(string Content);

public record YearMetaDto(int Year, string Keyword, string Vision);

public record SaveYearMetaRequest(string Keyword, string Vision);

public record YearPlanItemDto(Guid Id, int Year, int Month, string Title, bool Done, int Order);

public record CreateYearItemRequest(int Month, string Title);

public record UpdateYearItemRequest(int Month, string Title, bool Done);
