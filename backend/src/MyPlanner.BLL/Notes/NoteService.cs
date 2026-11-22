using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Notes;

namespace MyPlanner.BLL.Notes;

// Ghi chú chưa có thì GET trả về ghi chú rỗng (không 404): FE luôn có một ô để gõ.
public class NoteService(INoteRepository notes, TimeProvider clock) : INoteService
{
    public async Task<DayNoteDto> GetDayAsync(DateOnly date, CancellationToken ct) =>
        await notes.GetDayAsync(date, ct) ?? new DayNoteDto(date, "", null);

    public async Task<DayNoteDto> SaveDayAsync(DateOnly date, string content, CancellationToken ct)
    {
        var note = await notes.FindDayAsync(date, ct);
        if (note is null) notes.Add(note = new DayNote { Date = date });
        note.Content = content;
        note.UpdatedAt = clock.GetUtcNow();
        await notes.SaveChangesAsync(ct);
        return new DayNoteDto(note.Date, note.Content, note.UpdatedAt);
    }

    public async Task<WeekNoteDto> GetWeekAsync(string weekKey, CancellationToken ct)
    {
        EnsureWeekKey(weekKey);
        return await notes.GetWeekAsync(weekKey, ct) ?? new WeekNoteDto(weekKey, "", null);
    }

    public async Task<WeekNoteDto> SaveWeekAsync(string weekKey, string content, CancellationToken ct)
    {
        EnsureWeekKey(weekKey);
        var note = await notes.FindWeekAsync(weekKey, ct);
        if (note is null) notes.Add(note = new WeekNote { WeekKey = weekKey });
        note.Content = content;
        note.UpdatedAt = clock.GetUtcNow();
        await notes.SaveChangesAsync(ct);
        return new WeekNoteDto(note.WeekKey, note.Content, note.UpdatedAt);
    }

    private static void EnsureWeekKey(string weekKey)
    {
        if (!WeekKeys.TryParse(weekKey, out _)) throw AppException.BadRequest(Messages.InvalidWeekKeyWithFormat(weekKey));
    }
}
