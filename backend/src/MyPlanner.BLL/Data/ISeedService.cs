using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Data;

public interface ISeedService
{
    // Xoá dữ liệu hiện có và sinh dữ liệu mẫu quanh ngày "today" của client. Chỉ dùng ở môi trường Development.
    Task<ImportResultDto> SeedAsync(DateOnly today, CancellationToken ct);
}
