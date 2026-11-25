using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using Npgsql;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Focus;

public interface IFocusRepository
{
    Task<FocusSessionDto?> GetAsync(Guid id, CancellationToken ct);
    Task<List<FocusSessionDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct);
    Task<List<FocusSessionDto>> AllAsync(CancellationToken ct);

    // Global filter giấu dòng của tài khoản khác, nên "có tồn tại" ở đây cũng là "thuộc về mình".
    Task<bool> TaskExistsAsync(Guid id, CancellationToken ct);
    Task<bool> HabitExistsAsync(Guid id, CancellationToken ct);
    Task<bool> GoalExistsAsync(Guid id, CancellationToken ct);

    // Tên của các việc/thói quen/mục tiêu được gắn, để thẻ chậu hiện "Ôn SQL".
    Task<Dictionary<Guid, string>> LinkTitlesAsync(IReadOnlyCollection<Guid> ids, CancellationToken ct);

    // false khi Id đã có trong bảng (unique violation); lỗi DB khác vẫn ném ra.
    Task<bool> TryAddAsync(FocusSession session, CancellationToken ct);
}

public class FocusRepository(AppDbContext db) : IFocusRepository
{
    public Task<FocusSessionDto?> GetAsync(Guid id, CancellationToken ct) =>
        db.FocusSessions.AsNoTracking().Where(s => s.Id == id).Select(Projections.Focus).FirstOrDefaultAsync(ct);

    public Task<List<FocusSessionDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
        db.FocusSessions.AsNoTracking()
            .Where(s => s.Date >= from && s.Date <= to)
            .OrderBy(s => s.EndedAt)
            .Select(Projections.Focus)
            .ToListAsync(ct);

    // Bảng nhỏ (vài phiên mỗi ngày), đọc hết một lần rồi tính ở Core giống GoalBoard.
    public Task<List<FocusSessionDto>> AllAsync(CancellationToken ct) =>
        db.FocusSessions.AsNoTracking().OrderBy(s => s.EndedAt).Select(Projections.Focus).ToListAsync(ct);

    public Task<bool> TaskExistsAsync(Guid id, CancellationToken ct) => db.Tasks.AnyAsync(t => t.Id == id, ct);
    public Task<bool> HabitExistsAsync(Guid id, CancellationToken ct) => db.Habits.AnyAsync(h => h.Id == id, ct);
    public Task<bool> GoalExistsAsync(Guid id, CancellationToken ct) => db.Goals.AnyAsync(g => g.Id == id, ct);

    public async Task<Dictionary<Guid, string>> LinkTitlesAsync(IReadOnlyCollection<Guid> ids, CancellationToken ct)
    {
        var result = new Dictionary<Guid, string>();
        if (ids.Count == 0) return result;
        foreach (var x in await db.Tasks.AsNoTracking().Where(t => ids.Contains(t.Id)).Select(t => new { t.Id, t.Title }).ToListAsync(ct))
            result[x.Id] = x.Title;
        foreach (var x in await db.Habits.AsNoTracking().Where(h => ids.Contains(h.Id)).Select(h => new { h.Id, h.Title }).ToListAsync(ct))
            result[x.Id] = x.Title;
        foreach (var x in await db.Goals.AsNoTracking().Where(g => ids.Contains(g.Id)).Select(g => new { g.Id, g.Title }).ToListAsync(ct))
            result[x.Id] = x.Title;
        return result;
    }

    // Chỉ nuốt lỗi trùng khoá (hai request cùng Id chạy song song). Lỗi khác (sai kiểu, mất kết nối)
    // phải nổi lên thành 500 để thấy được, không được giả làm "bị trùng".
    public async Task<bool> TryAddAsync(FocusSession session, CancellationToken ct)
    {
        db.FocusSessions.Add(session);
        try
        {
            await db.SaveChangesAsync(ct);
            return true;
        }
        catch (DbUpdateException ex) when (ex.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation })
        {
            db.Entry(session).State = EntityState.Detached;
            return false;
        }
    }
}
