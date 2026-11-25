using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Auth;

public class RefreshTokenRepository(AppDbContext db) : IRefreshTokenRepository
{
    // AsNoTracking: trạng thái đổi bằng ExecuteUpdate, bản đang theo dõi trong DbContext sẽ bị cũ nếu để tracking.
    public Task<RefreshToken?> FindByHashAsync(string tokenHash, CancellationToken ct) =>
        db.RefreshTokens.AsNoTracking().FirstOrDefaultAsync(t => t.TokenHash == tokenHash, ct);

    public async Task AddAsync(RefreshToken token, CancellationToken ct)
    {
        db.RefreshTokens.Add(token);
        await db.SaveChangesAsync(ct);
    }

    // Một câu UPDATE có điều kiện: database khoá dòng nên request đến sau thấy ConsumedAt đã có giá trị và cập nhật 0 dòng.
    public async Task<bool> TryConsumeAsync(Guid id, DateTimeOffset now, CancellationToken ct) =>
        await db.RefreshTokens
            .Where(t => t.Id == id && t.ConsumedAt == null && t.RevokedAt == null)
            .ExecuteUpdateAsync(s => s.SetProperty(t => t.ConsumedAt, now), ct) == 1;

    public Task RevokeFamilyAsync(Guid familyId, DateTimeOffset now, CancellationToken ct) =>
        db.RefreshTokens
            .Where(t => t.FamilyId == familyId && t.RevokedAt == null)
            .ExecuteUpdateAsync(s => s.SetProperty(t => t.RevokedAt, now), ct);

    public Task DeleteExpiredAsync(Guid userId, DateTimeOffset now, CancellationToken ct) =>
        db.RefreshTokens.Where(t => t.UserId == userId && t.ExpiresAt <= now).ExecuteDeleteAsync(ct);
}
