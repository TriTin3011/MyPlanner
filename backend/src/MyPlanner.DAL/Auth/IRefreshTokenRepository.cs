using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Auth;

public interface IRefreshTokenRepository
{
    Task<RefreshToken?> FindByHashAsync(string tokenHash, CancellationToken ct);
    Task AddAsync(RefreshToken token, CancellationToken ct);
    // Đánh dấu đã dùng một cách nguyên tử. Hai request cùng lúc thì chỉ một request nhận true.
    Task<bool> TryConsumeAsync(Guid id, DateTimeOffset now, CancellationToken ct);
    Task RevokeFamilyAsync(Guid familyId, DateTimeOffset now, CancellationToken ct);
    Task DeleteExpiredAsync(Guid userId, DateTimeOffset now, CancellationToken ct);
}
