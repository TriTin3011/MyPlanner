using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Auth;

public class AppUserConfiguration : IEntityTypeConfiguration<AppUser>
{
    public void Configure(EntityTypeBuilder<AppUser> b)
    {
        b.ToTable("Users");
        b.Property(u => u.UserName).HasMaxLength(64);
        b.Property(u => u.PasswordHash).HasMaxLength(512);
        // Không cho hai tài khoản trùng tên; cũng là index cho truy vấn đăng nhập.
        b.HasIndex(u => u.UserName).IsUnique();
        // Một tài khoản Google chỉ gắn với một user. Postgres coi các NULL là khác nhau nên tài khoản mật khẩu không bị ảnh hưởng.
        b.Property(u => u.GoogleSubject).HasMaxLength(255);
        b.HasIndex(u => u.GoogleSubject).IsUnique();
    }
}
