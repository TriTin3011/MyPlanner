using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Auth;

public interface IUserRepository
{
    // Trả entity được theo dõi (không AsNoTracking) vì service có thể cập nhật PasswordHash khi cần băm lại.
    Task<AppUser?> FindByUserNameAsync(string userName, CancellationToken ct);
    Task<bool> AnyAsync(CancellationToken ct);
    void Add(AppUser user);
    Task SaveChangesAsync(CancellationToken ct);
}
