using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Habits;

public interface IHabitService
{
    Task<List<HabitDto>> ListAsync(bool includeInactive, CancellationToken ct);
    Task<HabitDto> CreateAsync(SaveHabitRequest req, CancellationToken ct);
    Task<HabitDto> UpdateAsync(Guid id, SaveHabitRequest req, CancellationToken ct);
    Task DeleteAsync(Guid id, CancellationToken ct);
    Task ReorderAsync(IReadOnlyList<Guid> ids, CancellationToken ct);

    Task<List<HabitLogDto>> LogsAsync(DateOnly from, DateOnly to, CancellationToken ct);
    Task TickAsync(Guid habitId, DateOnly date, CancellationToken ct);
    Task UntickAsync(Guid habitId, DateOnly date, CancellationToken ct);
}
