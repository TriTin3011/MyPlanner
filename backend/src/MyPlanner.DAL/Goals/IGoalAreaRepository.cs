using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Goals;

// Lĩnh vực mục tiêu của tài khoản đang đăng nhập (query filter của AppDbContext đã lọc theo UserId).
public interface IGoalAreaRepository
{
    // Toàn bộ lĩnh vực theo thứ tự hiển thị. Lần đọc đầu tiên của một tài khoản sẽ tạo 8 lĩnh vực có sẵn.
    Task<List<GoalAreaDto>> ListAsync(CancellationToken ct);
    Task<GoalArea?> FindAsync(Guid id, CancellationToken ct);
    Task<bool> ExistsAsync(Guid id, CancellationToken ct);
    Task<bool> InUseAsync(Guid id, CancellationToken ct);
    Task<List<string>> CustomNamesAsync(CancellationToken ct);
    Task<int> NextOrderAsync(CancellationToken ct);
    void Add(GoalArea area);
    void Remove(GoalArea area);
    Task SaveChangesAsync(CancellationToken ct);
}
