using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Tasks;

// Fluent API thay cho attribute trên entity: entity ở Core giữ sạch, không phụ thuộc EF.
public class TaskConfiguration : IEntityTypeConfiguration<TaskItem>
{
    public void Configure(EntityTypeBuilder<TaskItem> b)
    {
        b.ToTable("Tasks");
        b.Property(t => t.Title).HasMaxLength(500);
        // Mảng nhỏ → cột mảng native của Postgres (text[]); enum lưu dạng chữ cho dễ đọc khi xem DB.
        b.PrimitiveCollection(t => t.Tags).ElementType().HasConversion<string>();
        b.HasMany(t => t.Subtasks).WithOne().HasForeignKey(s => s.TaskId).OnDelete(DeleteBehavior.Cascade);
        // Index theo SPEC §14.1 (mở đầu bằng UserId vì mọi truy vấn đều có filter người dùng): lọc theo ngày, theo (ngày, đã xong) cho backlog/thống kê, theo việc lặp lại.
        b.HasIndex(t => new { t.UserId, t.Date });
        b.HasIndex(t => new { t.UserId, t.Date, t.Done });
        b.HasIndex(t => t.RecurringId);
    }
}

public class SubtaskConfiguration : IEntityTypeConfiguration<Subtask>
{
    public void Configure(EntityTypeBuilder<Subtask> b)
    {
        b.ToTable("Subtasks");
        b.Property(s => s.Title).HasMaxLength(500);
    }
}

public class RecurringTaskConfiguration : IEntityTypeConfiguration<RecurringTask>
{
    public void Configure(EntityTypeBuilder<RecurringTask> b)
    {
        b.ToTable("RecurringTasks");
        b.Property(r => r.Title).HasMaxLength(500);
        b.PrimitiveCollection(r => r.Tags).ElementType().HasConversion<string>();
        // Weekdays → integer[], SkippedDates → date[]: Npgsql map sẵn, không cần cấu hình thêm.
    }
}
