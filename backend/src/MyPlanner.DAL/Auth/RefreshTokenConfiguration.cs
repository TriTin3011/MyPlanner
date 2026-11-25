using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Auth;

public class RefreshTokenConfiguration : IEntityTypeConfiguration<RefreshToken>
{
    public void Configure(EntityTypeBuilder<RefreshToken> b)
    {
        b.ToTable("RefreshTokens");
        b.Property(t => t.TokenHash).HasMaxLength(64); // SHA-256 dạng hex
        b.HasIndex(t => t.TokenHash).IsUnique();
        b.HasIndex(t => t.FamilyId);                   // thu hồi cả họ
        b.HasIndex(t => new { t.UserId, t.ExpiresAt }); // dọn token hết hạn của một tài khoản
        // Xoá tài khoản thì mọi phiên của tài khoản đó biến mất theo.
        b.HasOne<AppUser>().WithMany().HasForeignKey(t => t.UserId).OnDelete(DeleteBehavior.Cascade);
    }
}
