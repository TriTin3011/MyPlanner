using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Notes;

public interface INoteService
{
    Task<DayNoteDto> GetDayAsync(DateOnly date, CancellationToken ct);
    Task<DayNoteDto> SaveDayAsync(DateOnly date, string content, CancellationToken ct);
    Task<WeekNoteDto> GetWeekAsync(string weekKey, CancellationToken ct);
    Task<WeekNoteDto> SaveWeekAsync(string weekKey, string content, CancellationToken ct);
}
