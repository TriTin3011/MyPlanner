using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Auth;

public interface IUserRepository
{
    // Trả entity được theo dõi (không AsNoTracking) vì service có thể cập nhật PasswordHash khi cần băm lại.
    Task<AppUser?> FindByUserNameAsync(string userName, CancellationToken ct);
    Task<AppUser?> FindByGoogleSubjectAsync(string subject, CancellationToken ct);
    Task<bool> AnyAsync(CancellationToken ct);
    void Add(AppUser user);

    // Thêm và lưu ngay. Trả false khi UserName hoặc GoogleSubject đã tồn tại (vi phạm index unique), kể cả khi hai request tranh nhau.
    Task<bool> TryAddAsync(AppUser user, CancellationToken ct);
    Task SaveChangesAsync(CancellationToken ct);
}
