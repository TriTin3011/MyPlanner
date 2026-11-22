using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Notes;

// Ghi chú ngày/tuần: khoá tự nhiên nên "lưu" là upsert (có thì sửa, chưa có thì thêm).
public interface INoteRepository
{
    Task<DayNoteDto?> GetDayAsync(DateOnly date, CancellationToken ct);
    Task<WeekNoteDto?> GetWeekAsync(string weekKey, CancellationToken ct);
    Task<DayNote?> FindDayAsync(DateOnly date, CancellationToken ct);
    Task<WeekNote?> FindWeekAsync(string weekKey, CancellationToken ct);
    Task<int> DeleteWeekAsync(string weekKey, DateOnly from, DateOnly to, CancellationToken ct);
    void Add(DayNote note);
    void Add(WeekNote note);
    Task SaveChangesAsync(CancellationToken ct);
}
