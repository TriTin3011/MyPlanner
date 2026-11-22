using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Data;

// Sao lưu / khôi phục toàn bộ dữ liệu (SPEC §14.3). Dùng chung cho GET /export, POST /import và SeedService.
public interface IDataRepository
{
    Task<BackupDto> ExportAsync(DateTimeOffset now, CancellationToken ct);
    Task ReplaceAllAsync(BackupDto data, CancellationToken ct);
}
