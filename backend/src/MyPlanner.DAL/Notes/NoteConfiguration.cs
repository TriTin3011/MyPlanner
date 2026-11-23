using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Notes;

public class DayNoteConfiguration : IEntityTypeConfiguration<DayNote>
{
    public void Configure(EntityTypeBuilder<DayNote> b)
    {
        b.ToTable("DayNotes");
        b.HasKey(n => new { n.UserId, n.Date }); // khoá tự nhiên: mỗi người mỗi ngày một ghi chú
    }
}

public class WeekNoteConfiguration : IEntityTypeConfiguration<WeekNote>
{
    public void Configure(EntityTypeBuilder<WeekNote> b)
    {
        b.ToTable("WeekNotes");
        b.HasKey(n => new { n.UserId, n.WeekKey });
        b.Property(n => n.WeekKey).HasMaxLength(8);
    }
}

public class YearMetaConfiguration : IEntityTypeConfiguration<YearMeta>
{
    public void Configure(EntityTypeBuilder<YearMeta> b)
    {
        b.ToTable("YearMeta");
        b.HasKey(y => new { y.UserId, y.Year });
        b.Property(y => y.Year).ValueGeneratedNever(); // khoá int nhưng không tự tăng: chính là số năm
        b.Property(y => y.Keyword).HasMaxLength(100);
    }
}

public class YearPlanItemConfiguration : IEntityTypeConfiguration<YearPlanItem>
{
    public void Configure(EntityTypeBuilder<YearPlanItem> b)
    {
        b.ToTable("YearPlanItems");
        b.Property(i => i.Title).HasMaxLength(300);
        b.HasIndex(i => new { i.UserId, i.Year, i.Month });
    }
}
