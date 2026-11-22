using System.Globalization;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Desktop.Api;

// Typed client: tầng "gọi API" của app desktop, tương đương api/*.ts + axios ở web.
// Nhận HttpClient đã cấu hình BaseAddress từ DI (IHttpClientFactory quản lý vòng đời handler).
// Trả về đúng DTO của MyPlanner.Core, nên không có model trùng lặp phải đồng bộ tay.
public sealed class PlannerApiClient(HttpClient http)
{
    // Giống cấu hình JSON của API: camelCase + enum dạng chuỗi ("urgent", "important").
    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web)
    {
        Converters = { new JsonStringEnumConverter() },
    };

    public async Task<TodayDashboardDto> GetTodayAsync(DateOnly date, CancellationToken ct = default)
    {
        // "Hôm nay" do client gửi theo giờ địa phương, không lấy đồng hồ server (CLAUDE.md).
        var url = $"api/dashboard/today?date={Iso(date)}";
        var dto = await http.GetFromJsonAsync<TodayDashboardDto>(url, Json, ct);
        return dto ?? throw new InvalidOperationException("API trả về rỗng.");
    }

    public async Task SetDoneAsync(Guid taskId, bool done, CancellationToken ct = default)
    {
        using var res = await http.PatchAsJsonAsync($"api/tasks/{taskId}/done", new SetDoneRequest(done), Json, ct);
        res.EnsureSuccessStatusCode();
    }

    private static string Iso(DateOnly d) => d.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
}
