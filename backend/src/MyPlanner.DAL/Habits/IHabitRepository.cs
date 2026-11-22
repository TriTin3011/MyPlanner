using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Habits;

public interface IHabitRepository
{
    Task<List<HabitDto>> ListAsync(bool includeInactive, CancellationToken ct);
    Task<HabitDto?> GetAsync(Guid id, CancellationToken ct);
    Task<Habit?> FindAsync(Guid id, CancellationToken ct);
    Task<List<Habit>> FindAllAsync(CancellationToken ct);
    Task<int> NextOrderAsync(CancellationToken ct);

    Task<List<HabitLogDto>> LogsAsync(DateOnly from, DateOnly to, CancellationToken ct);
    Task<List<HabitLogDto>> AllLogsAsync(CancellationToken ct);
    Task<bool> HasLogAsync(Guid habitId, DateOnly date, CancellationToken ct);
    void AddLog(HabitLog log);
    Task<int> DeleteLogAsync(Guid habitId, DateOnly date, CancellationToken ct);
    Task<int> DeleteLogsAsync(DateOnly from, DateOnly to, CancellationToken ct);

    void Add(Habit habit);
    void Remove(Habit habit);
    Task SaveChangesAsync(CancellationToken ct);
}
