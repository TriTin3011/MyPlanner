using Microsoft.AspNetCore.Mvc;
using MyPlanner.BLL.Data;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api")]
public class DataController(IDataService data, ISeedService seed, IWebHostEnvironment env) : ControllerBase
{
    [HttpGet("export")]
    public Task<BackupDto> Export(CancellationToken ct) => data.ExportAsync(ct);

    // File backup có thể lớn hơn giới hạn mặc định 30MB của Kestrel ít khi; ở đây giữ mặc định.
    [HttpPost("import")]
    public Task<ImportResultDto> Import(BackupDto backup, CancellationToken ct) => data.ImportAsync(backup, ct);

    [HttpDelete("weeks/{weekKey}")]
    public Task<WeekDeleteResultDto> DeleteWeek(string weekKey, CancellationToken ct) => data.DeleteWeekAsync(weekKey, ct);

    // Chỉ chạy ở Development: endpoint này xoá sạch dữ liệu thật.
    [HttpPost("dev/seed")]
    public async Task<ActionResult<ImportResultDto>> Seed(SeedRequest req, CancellationToken ct)
    {
        if (!env.IsDevelopment()) return NotFound();
        return await seed.SeedAsync(req.Today, ct);
    }
}
