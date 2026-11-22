using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL;

// Một phiên làm việc với database: DbSet (bảng), change tracker, SaveChangesAsync (transaction).
// Đăng ký scoped: mỗi HTTP request một instance, nên mọi repository trong cùng request dùng chung một DbContext
// và một lần SaveChangesAsync lưu hết thay đổi của chúng trong một transaction (Unit of Work).
public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<TaskItem> Tasks => Set<TaskItem>();
    public DbSet<Subtask> Subtasks => Set<Subtask>();
    public DbSet<RecurringTask> RecurringTasks => Set<RecurringTask>();
    public DbSet<Habit> Habits => Set<Habit>();
    public DbSet<HabitLog> HabitLogs => Set<HabitLog>();
    public DbSet<Goal> Goals => Set<Goal>();
    public DbSet<GoalStep> GoalSteps => Set<GoalStep>();
    public DbSet<DayNote> DayNotes => Set<DayNote>();
    public DbSet<WeekNote> WeekNotes => Set<WeekNote>();
    public DbSet<YearMeta> YearMeta => Set<YearMeta>();
    public DbSet<YearPlanItem> YearPlanItems => Set<YearPlanItem>();
    public DbSet<AppUser> Users => Set<AppUser>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Mỗi entity cấu hình trong thư mục tính năng, ví dụ Tasks/TaskConfiguration.cs (IEntityTypeConfiguration<T>).
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);

        // Id Guid luôn do service gán (Guid.NewGuid()), không để DB/EF sinh. Nếu không khai báo, EF coi khoá Guid là
        // "store-generated": entity con có Id sẵn được thêm qua navigation (goal.Steps.Add) bị hiểu là dòng đã tồn tại
        // → sinh UPDATE thay vì INSERT → DbUpdateConcurrencyException "affected 0 rows".
        foreach (var entity in modelBuilder.Model.GetEntityTypes())
        {
            var id = entity.FindProperty("Id");
            if (id is not null && id.ClrType == typeof(Guid) && entity.FindPrimaryKey()?.Properties.SequenceEqual([id]) == true)
                id.ValueGenerated = Microsoft.EntityFrameworkCore.Metadata.ValueGenerated.Never;
        }
    }
}
