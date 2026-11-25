using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Goals;

public class GoalRepository(AppDbContext db) : IGoalRepository
{
    public Task<List<GoalDto>> ListAsync(CancellationToken ct) =>
        db.Goals.AsNoTracking().OrderBy(g => g.Deadline).ThenBy(g => g.CreatedAt).Select(Projections.Goal).ToListAsync(ct);

    public Task<GoalDto?> GetAsync(Guid id, CancellationToken ct) =>
        db.Goals.AsNoTracking().Where(g => g.Id == id).Select(Projections.Goal).FirstOrDefaultAsync(ct);

    public Task<Goal?> FindAsync(Guid id, CancellationToken ct) =>
        db.Goals.Include(g => g.Steps).FirstOrDefaultAsync(g => g.Id == id, ct);

    // Hạn của các bước trong khoảng: dùng cho lịch Hôm nay, Tuần và ⚑ của Năm.
    public async Task<List<(Guid GoalId, string GoalTitle, string Title, DateOnly Deadline, bool Done)>>
        StepDeadlinesAsync(DateOnly from, DateOnly to, CancellationToken ct)
    {
        var rows = await db.GoalSteps.AsNoTracking()
            .Where(s => s.Deadline.HasValue && s.Deadline.Value >= from && s.Deadline.Value <= to)
            .Join(db.Goals.AsNoTracking(), s => s.GoalId, g => g.Id,
                (s, g) => new { g.Id, GoalTitle = g.Title, s.Title, Deadline = s.Deadline!.Value, s.Done })
            .OrderBy(r => r.Deadline)
            .ToListAsync(ct);
        return rows.Select(r => (r.Id, r.GoalTitle, r.Title, r.Deadline, r.Done)).ToList();
    }

    // Hạn của chính mục tiêu trong khoảng (Done = mục tiêu đã hoàn thành).
    public async Task<List<(Guid GoalId, string Title, DateOnly Deadline, bool Done)>> GoalDeadlinesAsync(
        DateOnly from, DateOnly to, CancellationToken ct)
    {
        var rows = await db.Goals.AsNoTracking()
            .Where(g => g.Deadline >= from && g.Deadline <= to)
            .OrderBy(g => g.Deadline)
            .Select(g => new { g.Id, g.Title, g.Deadline, Done = g.Status == GoalStatus.Done })
            .ToListAsync(ct);
        return rows.Select(r => (r.Id, r.Title, r.Deadline, r.Done)).ToList();
    }

    // Các ngày là hạn của mục tiêu hoặc của bước trong khoảng: chỉ lấy cột ngày, gộp bằng UNION ở DB.
    public async Task<HashSet<DateOnly>> DeadlineDatesAsync(DateOnly from, DateOnly to, CancellationToken ct)
    {
        var goalDates = db.Goals.AsNoTracking()
            .Where(g => g.Deadline >= from && g.Deadline <= to)
            .Select(g => g.Deadline);
        var stepDates = db.GoalSteps.AsNoTracking()
            .Where(s => s.Deadline.HasValue && s.Deadline.Value >= from && s.Deadline.Value <= to)
            .Select(s => s.Deadline!.Value);
        return (await goalDates.Union(stepDates).ToListAsync(ct)).ToHashSet();
    }

    public void Add(Goal goal) => db.Goals.Add(goal);
    public void Remove(Goal goal) => db.Goals.Remove(goal);
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
