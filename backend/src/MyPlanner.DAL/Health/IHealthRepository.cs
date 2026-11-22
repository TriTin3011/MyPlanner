namespace MyPlanner.DAL.Health;

// Hợp đồng truy cập dữ liệu cho việc kiểm tra kết nối database. BLL chỉ biết interface này.
public interface IHealthRepository
{
    Task<bool> CanConnectAsync(CancellationToken ct);
}
