namespace MyPlanner.DAL.Health;

// Cài đặt bằng EF Core. Chỉ DAL được chạm vào AppDbContext.
public class HealthRepository(AppDbContext db) : IHealthRepository
{
    // Mở kết nối thử; trả false (không ném lỗi) khi Postgres tắt.
    public Task<bool> CanConnectAsync(CancellationToken ct) => db.Database.CanConnectAsync(ct);
}
