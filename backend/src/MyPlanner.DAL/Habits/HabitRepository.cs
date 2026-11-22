using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Habits;

public class HabitRepository(AppDbContext db) : IHabitRepository
{
    public Task<List<HabitDto>> ListAsync(bool includeInactive, CancellationToken ct) =>
        db.Habits.AsNoTracking()
            .Where(h => includeInactive || h.Active)
            .OrderBy(h => h.Order).ThenBy(h => h.CreatedAt)
            .Select(Projections.Habit)
            .ToListAsync(ct);

    public Task<HabitDto?> GetAsync(Guid id, CancellationToken ct) =>
        db.Habits.AsNoTracking().Where(h => h.Id == id).Select(Projections.Habit).FirstOrDefaultAsync(ct);

    public Task<Habit?> FindAsync(Guid id, CancellationToken ct) => db.Habits.FirstOrDefaultAsync(h => h.Id == id, ct);

    public Task<List<Habit>> FindAllAsync(CancellationToken ct) => db.Habits.ToListAsync(ct);

    public async Task<int> NextOrderAsync(CancellationToken ct) =>
        (await db.Habits.MaxAsync(h => (int?)h.Order, ct) ?? -1) + 1;

    public Task<List<HabitLogDto>> LogsAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
        db.HabitLogs.AsNoTracking()
            .Where(l => l.Date >= from && l.Date <= to)
            .OrderBy(l => l.Date)
            .Select(l => new HabitLogDto(l.HabitId, l.Date))
            .ToListAsync(ct);

    public Task<List<HabitLogDto>> AllLogsAsync(CancellationToken ct) =>
        db.HabitLogs.AsNoTracking().OrderBy(l => l.Date).Select(l => new HabitLogDto(l.HabitId, l.Date)).ToListAsync(ct);

    public Task<bool> HasLogAsync(Guid habitId, DateOnly date, CancellationToken ct) =>
        db.HabitLogs.AnyAsync(l => l.HabitId == habitId && l.Date == date, ct);

    public void AddLog(HabitLog log) => db.HabitLogs.Add(log);

    public Task<int> DeleteLogAsync(Guid habitId, DateOnly date, CancellationToken ct) =>
        db.HabitLogs.Where(l => l.HabitId == habitId && l.Date == date).ExecuteDeleteAsync(ct);

    public Task<int> DeleteLogsAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
        db.HabitLogs.Where(l => l.Date >= from && l.Date <= to).ExecuteDeleteAsync(ct);

    public void Add(Habit habit) => db.Habits.Add(habit);
    public void Remove(Habit habit) => db.Habits.Remove(habit);
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
