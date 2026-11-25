using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Focus;

public class FocusSessionConfiguration : IEntityTypeConfiguration<FocusSession>
{
    public void Configure(EntityTypeBuilder<FocusSession> b)
    {
        b.ToTable("FocusSessions");
        // Enum lưu dạng chuỗi: đọc DB thấy "basil" thay vì 0, và thêm giá trị mới vào giữa enum không làm sai dữ liệu cũ.
        b.Property(s => s.Outcome).HasConversion<string>().HasMaxLength(20);
        b.Property(s => s.PlantKind).HasConversion<string>().HasMaxLength(20);
        b.Property(s => s.PotColor).HasConversion<string>().HasMaxLength(20);

        // Liên kết tuỳ chọn: SET NULL thay vì CASCADE, xoá việc không được xoá mất chậu cây trên kệ.
        b.HasOne<TaskItem>().WithMany().HasForeignKey(s => s.TaskId).OnDelete(DeleteBehavior.SetNull);
        b.HasOne<Habit>().WithMany().HasForeignKey(s => s.HabitId).OnDelete(DeleteBehavior.SetNull);
        b.HasOne<Goal>().WithMany().HasForeignKey(s => s.GoalId).OnDelete(DeleteBehavior.SetNull);

        b.HasIndex(s => new { s.UserId, s.Date });     // dải số "hôm nay / tuần này", GET ?from=&to=
        b.HasIndex(s => new { s.UserId, s.EndedAt });  // xếp chậu lên kệ theo thứ tự hoàn thành
    }
}
