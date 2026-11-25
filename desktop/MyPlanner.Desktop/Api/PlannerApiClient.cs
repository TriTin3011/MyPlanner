using System.Globalization;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

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

    // Sai tài khoản → API trả 401 ProblemDetails; trả null để ViewModel hiện thông báo thay vì ném lỗi.
    public async Task<LoginResponse?> LoginAsync(string userName, string password, CancellationToken ct = default)
    {
        using var res = await http.PostAsJsonAsync("api/auth/login", new LoginRequest(userName, password), Json, ct);
        if (res.StatusCode == System.Net.HttpStatusCode.Unauthorized) return null;
        res.EnsureSuccessStatusCode();
        return await res.Content.ReadFromJsonAsync<LoginResponse>(Json, ct);
    }

    // Kiểm tra token đã lưu còn dùng được không (gọi khi mở app).
    public Task<CurrentUserDto?> MeAsync(CancellationToken ct = default) =>
        http.GetFromJsonAsync<CurrentUserDto>("api/auth/me", Json, ct);

    public async Task<TodayDashboardDto> GetTodayAsync(DateOnly date, CancellationToken ct = default)
    {
        // "Hôm nay" do client gửi theo giờ địa phương, không lấy đồng hồ server (SPEC §1).
        var url = $"api/dashboard/today?date={Iso(date)}";
        var dto = await http.GetFromJsonAsync<TodayDashboardDto>(url, Json, ct);
        return dto ?? throw new InvalidOperationException("API trả về rỗng.");
    }

    public async Task SetDoneAsync(Guid taskId, bool done, CancellationToken ct = default)
    {
        using var res = await http.PatchAsJsonAsync($"api/tasks/{taskId}/done", new SetDoneRequest(done), Json, ct);
        res.EnsureSuccessStatusCode();
    }

    // Màn Tuần (SPEC §9): weekKey dạng "2026-W47"; today để BE tính "còn lại hôm nay".
    public async Task<WeekDashboardDto> GetWeekAsync(string weekKey, DateOnly today, CancellationToken ct = default)
    {
        var dto = await http.GetFromJsonAsync<WeekDashboardDto>(
            $"api/dashboard/week?weekKey={Uri.EscapeDataString(weekKey)}&today={Iso(today)}", Json, ct);
        return dto ?? throw new InvalidOperationException("API trả về rỗng.");
    }

    // Màn Thói quen (SPEC §8): month dạng "2026-11". Ngày tương lai trả null.
    public async Task<HabitMonthDto> GetHabitMonthAsync(string month, DateOnly today, CancellationToken ct = default)
    {
        var dto = await http.GetFromJsonAsync<HabitMonthDto>($"api/dashboard/habits?month={month}&today={Iso(today)}", Json, ct);
        return dto ?? throw new InvalidOperationException("API trả về rỗng.");
    }

    // PUT = tick, DELETE = bỏ tick (idempotent, khoá là habitId + ngày).
    public async Task SetHabitDoneAsync(Guid habitId, DateOnly date, bool done, CancellationToken ct = default)
    {
        var url = $"api/habit-logs/{habitId}/{Iso(date)}";
        using var res = done ? await http.PutAsync(url, null, ct) : await http.DeleteAsync(url, ct);
        res.EnsureSuccessStatusCode();
    }

    // Màn Mục tiêu (SPEC §7): mọi chỉ số %, bước quá hạn và cờ Behind đều tính sẵn ở BE.
    public async Task<GoalBoardDto> GetGoalBoardAsync(DateOnly today, CancellationToken ct = default)
    {
        var dto = await http.GetFromJsonAsync<GoalBoardDto>($"api/dashboard/goals?today={Iso(today)}", Json, ct);
        return dto ?? throw new InvalidOperationException("API trả về rỗng.");
    }

    // Tick hoàn thành trên GoalCard: đọc bản đầy đủ rồi gửi PUT giữ nguyên các trường, đổi Status (giống web).
    public async Task SetGoalDoneAsync(Guid goalId, bool done, CancellationToken ct = default)
    {
        var goal = await http.GetFromJsonAsync<GoalDto>($"api/goals/{goalId}", Json, ct)
            ?? throw new InvalidOperationException("Không tìm thấy mục tiêu.");
        var nextStatus = done
            ? GoalStatus.Done
            : goal.Steps.Any(s => s.Done) ? GoalStatus.InProgress : GoalStatus.NotStarted;
        var req = new SaveGoalRequest(goal.Title, goal.AreaId, nextStatus, goal.StartDate, goal.Deadline, goal.Reward, goal.Why);
        using var res = await http.PutAsJsonAsync($"api/goals/{goalId}", req, Json, ct);
        res.EnsureSuccessStatusCode();
    }

    // Màn Kế hoạch năm (SPEC §10): cả trang trong một lần gọi GET /api/dashboard/year.
    public async Task<YearDashboardDto> GetYearBoardAsync(int year, DateOnly today, CancellationToken ct = default)
    {
        var dto = await http.GetFromJsonAsync<YearDashboardDto>($"api/dashboard/year?year={year}&today={Iso(today)}", Json, ct);
        return dto ?? throw new InvalidOperationException("API trả về rỗng.");
    }

    public async Task SaveYearMetaAsync(int year, SaveYearMetaRequest req, CancellationToken ct = default)
    {
        using var res = await http.PutAsJsonAsync($"api/years/{year}", req, Json, ct);
        res.EnsureSuccessStatusCode();
    }

    public async Task AddYearItemAsync(int year, CreateYearItemRequest req, CancellationToken ct = default)
    {
        using var res = await http.PostAsJsonAsync($"api/years/{year}/items", req, Json, ct);
        res.EnsureSuccessStatusCode();
    }

    public async Task UpdateYearItemAsync(Guid itemId, UpdateYearItemRequest req, CancellationToken ct = default)
    {
        using var res = await http.PutAsJsonAsync($"api/year-items/{itemId}", req, Json, ct);
        res.EnsureSuccessStatusCode();
    }

    // Màn Thống kê (SPEC §11): range là 4w, 8w, 12w, 6m hoặc 1y; mọi số liệu do BE tính.
    public async Task<StatsDto> GetStatsAsync(string range, DateOnly today, CancellationToken ct = default)
    {
        var dto = await http.GetFromJsonAsync<StatsDto>(
            $"api/stats?range={Uri.EscapeDataString(range)}&today={Iso(today)}", Json, ct);
        return dto ?? throw new InvalidOperationException("API trả về rỗng.");
    }

    private static string Iso(DateOnly d) => d.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
}
