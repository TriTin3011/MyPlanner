namespace MyPlanner.Core.Dtos;

public record HabitDto(Guid Id, string Title, int Order, bool Active, DateOnly StartDate, DateTimeOffset CreatedAt, DateTimeOffset? ArchivedAt);

// StartDate null = hôm nay theo đồng hồ server (client nên gửi ngày địa phương).
public record SaveHabitRequest(string Title, bool Active = true, DateOnly? StartDate = null);

public record ReorderRequest(List<Guid> Ids);

public record HabitLogDto(Guid HabitId, DateOnly Date);
