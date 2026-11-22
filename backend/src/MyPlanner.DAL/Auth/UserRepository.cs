using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Auth;

public class UserRepository(AppDbContext db) : IUserRepository
{
    // UserName lưu dạng chữ thường (service chuẩn hoá trước khi gọi), nên so sánh bằng là đủ và dùng được index unique.
    public Task<AppUser?> FindByUserNameAsync(string userName, CancellationToken ct) =>
        db.Users.FirstOrDefaultAsync(u => u.UserName == userName, ct);

    public Task<bool> AnyAsync(CancellationToken ct) => db.Users.AnyAsync(ct);

    public void Add(AppUser user) => db.Users.Add(user);
    public Task SaveChangesAsync(CancellationToken ct) => db.SaveChangesAsync(ct);
}
