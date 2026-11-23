using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Entities;
using Npgsql;

namespace MyPlanner.DAL.Auth;

public class UserRepository(AppDbContext db) : IUserRepository
{
    // UserName lưu dạng chữ thường (service chuẩn hoá trước khi gọi), nên so sánh bằng là đủ và dùng được index unique.
    public Task<AppUser?> FindByUserNameAsync(string userName, CancellationToken ct) =>
        db.Users.FirstOrDefaultAsync(u => u.UserName == userName, ct);

    public Task<AppUser?> FindByGoogleSubjectAsync(string subject, CancellationToken ct) =>
        db.Users.FirstOrDefaultAsync(u => u.GoogleSubject == subject, ct);

    public Task<AppUser?> FindByIdAsync(Guid id, CancellationToken ct) =>
        db.Users.FirstOrDefaultAsync(u => u.Id == id, ct);

    public Task<bool> AnyAsync(CancellationToken ct) => db.Users.AnyAsync(ct);

    public void Add(AppUser user) => db.Users.Add(user);

    public async Task<bool> TryAddAsync(AppUser user, CancellationToken ct)
    {
        db.Users.Add(user);
        try
        {
            await db.SaveChangesAsync(ct);
            return true;
        }
        catch (DbUpdateException ex) when (ex.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation })
        {
            db.Entry(user).State = EntityState.Detached; // bỏ entity hỏng khỏi change tracker để DbContext còn dùng được
            return false;
        }
    }
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
