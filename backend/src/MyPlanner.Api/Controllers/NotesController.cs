using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Notes;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

// PUT = upsert: ghi chú định danh bằng ngày/tuần (khoá tự nhiên), không cần POST tạo trước.
[ApiController]
[Route("api/notes")]
public class NotesController(INoteService notes) : ControllerBase
{
    [HttpGet("day/{date}")]
    public Task<DayNoteDto> GetDay(DateOnly date, CancellationToken ct) => notes.GetDayAsync(date, ct);

    [HttpPut("day/{date}")]
    public Task<DayNoteDto> SaveDay(DateOnly date, SaveNoteRequest req, CancellationToken ct) => notes.SaveDayAsync(date, req.Content, ct);

    [HttpGet("week/{weekKey}")]
    public Task<WeekNoteDto> GetWeek(string weekKey, CancellationToken ct) => notes.GetWeekAsync(weekKey, ct);

    [HttpPut("week/{weekKey}")]
    public Task<WeekNoteDto> SaveWeek(string weekKey, SaveNoteRequest req, CancellationToken ct) => notes.SaveWeekAsync(weekKey, req.Content, ct);
}
