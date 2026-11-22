using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Habits;

public class HabitConfiguration : IEntityTypeConfiguration<Habit>
{
    public void Configure(EntityTypeBuilder<Habit> b)
    {
        b.ToTable("Habits");
        b.Property(h => h.Title).HasMaxLength(200);
    }
}

public class HabitLogConfiguration : IEntityTypeConfiguration<HabitLog>
{
    public void Configure(EntityTypeBuilder<HabitLog> b)
    {
        b.ToTable("HabitLogs");
        // Khoá chính ghép: mỗi habit tick tối đa một lần mỗi ngày, DB tự chặn trùng.
        b.HasKey(l => new { l.HabitId, l.Date });
        b.HasIndex(l => l.Date);
        // Xoá habit thì xoá luôn lịch sử tick.
        b.HasOne<Habit>().WithMany().HasForeignKey(l => l.HabitId).OnDelete(DeleteBehavior.Cascade);
    }
}
