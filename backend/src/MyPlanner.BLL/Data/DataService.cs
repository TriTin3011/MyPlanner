using MyPlanner.BLL.Common;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.DAL.Data;
using MyPlanner.DAL.Habits;
using MyPlanner.DAL.Notes;
using MyPlanner.DAL.Tasks;

namespace MyPlanner.BLL.Data;

// Thao tác trên nhiều aggregate cùng lúc (sao lưu, xoá dữ liệu một tuần) gom vào một service riêng,
// để TaskService/HabitService không phải biết nhau.
public class DataService(
    IDataRepository data,
    ITaskRepository tasks,
    IHabitRepository habits,
    INoteRepository notes,
    TimeProvider clock) : IDataService
{
    public Task<BackupDto> ExportAsync(CancellationToken ct) => data.ExportAsync(clock.GetUtcNow(), ct);

    // Import = thay toàn bộ (không gộp): đơn giản, dễ đoán; FE phải hỏi xác nhận trước khi gọi.
    public async Task<ImportResultDto> ImportAsync(BackupDto backup, CancellationToken ct)
    {
        if (backup.Version > BackupDto.CurrentVersion)
            throw AppException.BadRequest($"File sao lưu phiên bản {backup.Version} mới hơn ứng dụng (hỗ trợ tới {BackupDto.CurrentVersion}).");
        if (backup.Version < 1) throw AppException.BadRequest("File sao lưu không hợp lệ (thiếu version).");

        var habitIds = backup.Habits.Select(h => h.Id).ToHashSet();
        if (backup.HabitLogs.Any(l => !habitIds.Contains(l.HabitId)))
            throw AppException.BadRequest("Có log thói quen trỏ tới thói quen không tồn tại trong file.");

        await data.ReplaceAllAsync(backup, ct);
        return new ImportResultDto(backup.Tasks.Count, backup.Habits.Count, backup.HabitLogs.Count, backup.Goals.Count);
    }

    // SPEC §9: "Xoá dữ liệu tuần" xoá task, log thói quen và ghi chú trong 7 ngày của tuần đó; giữ nguyên thói quen, mục tiêu.
    public async Task<WeekDeleteResultDto> DeleteWeekAsync(string weekKey, CancellationToken ct)
    {
        if (!WeekKeys.TryParse(weekKey, out var monday)) throw AppException.BadRequest($"weekKey không hợp lệ: '{weekKey}'.");
        var sunday = monday.AddDays(6);
        var t = await tasks.DeleteRangeAsync(monday, sunday, ct);
        var h = await habits.DeleteLogsAsync(monday, sunday, ct);
        var n = await notes.DeleteWeekAsync(weekKey, monday, sunday, ct);
        return new WeekDeleteResultDto(t, h, n);
    }
}
