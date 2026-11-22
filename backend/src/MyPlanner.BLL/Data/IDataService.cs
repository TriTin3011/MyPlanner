using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Data;

public interface IDataService
{
    Task<BackupDto> ExportAsync(CancellationToken ct);
    Task<ImportResultDto> ImportAsync(BackupDto data, CancellationToken ct);
    Task<WeekDeleteResultDto> DeleteWeekAsync(string weekKey, CancellationToken ct);
}
