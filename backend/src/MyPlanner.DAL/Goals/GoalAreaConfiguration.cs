using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Goals;

public class GoalAreaConfiguration : IEntityTypeConfiguration<GoalArea>
{
    public void Configure(EntityTypeBuilder<GoalArea> b)
    {
        b.ToTable("GoalAreas");
        b.Property(a => a.Key).HasConversion<string>().HasMaxLength(20);
        b.Property(a => a.Name).HasMaxLength(GoalAreaLimits.NameMaxLength);
        // Mỗi tài khoản có tối đa một dòng cho mỗi lĩnh vực có sẵn. Index lọc "Key IS NOT NULL" nên lĩnh vực tự thêm
        // (Key null) không bị ràng buộc. Nhờ index này, hai request đầu tiên chạy song song không tạo trùng bộ mặc định.
        b.HasIndex(a => new { a.UserId, a.Key }).IsUnique().HasFilter("\"Key\" IS NOT NULL");
        b.HasIndex(a => new { a.UserId, a.Order });
    }
}

public static class GoalAreaLimits
{
    public const int NameMaxLength = 40;
    public const int MaxCustom = 20;
}
