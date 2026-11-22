using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Notes;

public class NoteRepository(AppDbContext db) : INoteRepository
{
    public Task<DayNoteDto?> GetDayAsync(DateOnly date, CancellationToken ct) =>
        db.DayNotes.AsNoTracking().Where(n => n.Date == date)
            .Select(n => new DayNoteDto(n.Date, n.Content, n.UpdatedAt)).FirstOrDefaultAsync(ct);

    public Task<WeekNoteDto?> GetWeekAsync(string weekKey, CancellationToken ct) =>
        db.WeekNotes.AsNoTracking().Where(n => n.WeekKey == weekKey)
            .Select(n => new WeekNoteDto(n.WeekKey, n.Content, n.UpdatedAt)).FirstOrDefaultAsync(ct);

    public Task<DayNote?> FindDayAsync(DateOnly date, CancellationToken ct) => db.DayNotes.FindAsync([date], ct).AsTask();
    public Task<WeekNote?> FindWeekAsync(string weekKey, CancellationToken ct) => db.WeekNotes.FindAsync([weekKey], ct).AsTask();

    public async Task<int> DeleteWeekAsync(string weekKey, DateOnly from, DateOnly to, CancellationToken ct) =>
        await db.WeekNotes.Where(n => n.WeekKey == weekKey).ExecuteDeleteAsync(ct)
        + await db.DayNotes.Where(n => n.Date >= from && n.Date <= to).ExecuteDeleteAsync(ct);

    public void Add(DayNote note) => db.DayNotes.Add(note);
    public void Add(WeekNote note) => db.WeekNotes.Add(note);
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
