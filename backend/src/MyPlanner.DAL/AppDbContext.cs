using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Auth;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL;

// Một phiên làm việc với database: DbSet (bảng), change tracker, SaveChangesAsync (transaction).
// Đăng ký scoped: mỗi HTTP request một instance, nên mọi repository trong cùng request dùng chung một DbContext
// và một lần SaveChangesAsync lưu hết thay đổi của chúng trong một transaction (Unit of Work).
//
// Tách dữ liệu theo tài khoản (SPEC §12.0) nằm trọn ở đây, repository và service không phải nhớ:
//   - Đọc: global query filter thêm "WHERE UserId = @current" vào MỌI truy vấn trên bảng IUserOwned,
//     kể cả Include, Join, Any, Max, ExecuteDelete/ExecuteUpdate.
//   - Ghi: SaveChanges đóng dấu UserId cho dòng mới và chặn đổi chủ dòng cũ.
public class AppDbContext(DbContextOptions<AppDbContext> options, ICurrentUser currentUser) : DbContext(options)
{
    public DbSet<TaskItem> Tasks => Set<TaskItem>();
    public DbSet<Subtask> Subtasks => Set<Subtask>();
    public DbSet<RecurringTask> RecurringTasks => Set<RecurringTask>();
    public DbSet<Habit> Habits => Set<Habit>();
    public DbSet<HabitLog> HabitLogs => Set<HabitLog>();
    public DbSet<Goal> Goals => Set<Goal>();
    public DbSet<GoalStep> GoalSteps => Set<GoalStep>();
    public DbSet<GoalArea> GoalAreas => Set<GoalArea>();
    public DbSet<DayNote> DayNotes => Set<DayNote>();
    public DbSet<WeekNote> WeekNotes => Set<WeekNote>();
    public DbSet<YearMeta> YearMeta => Set<YearMeta>();
    public DbSet<YearPlanItem> YearPlanItems => Set<YearPlanItem>();
    public DbSet<AppUser> Users => Set<AppUser>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();

    // Filter tham chiếu thuộc tính của chính DbContext nên EF biến nó thành tham số SQL, đọc lại mỗi lần truy vấn.
    // (Nếu viết hằng số vào filter, model được cache một lần cho cả app và mọi người sẽ thấy dữ liệu của người đầu tiên.)
    // Không có người đăng nhập → Guid.Empty → không khớp dòng nào: thiếu xác thực thì thấy rỗng, không thấy hết.
    private Guid CurrentUserId => currentUser.UserId ?? Guid.Empty;

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

        ConfigureOwned<TaskItem>(modelBuilder);
        ConfigureOwned<Subtask>(modelBuilder);
        ConfigureOwned<RecurringTask>(modelBuilder);
        ConfigureOwned<Habit>(modelBuilder);
        ConfigureOwned<HabitLog>(modelBuilder);
        ConfigureOwned<Goal>(modelBuilder);
        ConfigureOwned<GoalStep>(modelBuilder);
        ConfigureOwned<GoalArea>(modelBuilder);
        ConfigureOwned<DayNote>(modelBuilder);
        ConfigureOwned<WeekNote>(modelBuilder);
        ConfigureOwned<YearMeta>(modelBuilder);
        ConfigureOwned<YearPlanItem>(modelBuilder);
    }

    private void ConfigureOwned<T>(ModelBuilder modelBuilder) where T : class, IUserOwned
    {
        var b = modelBuilder.Entity<T>();
        b.HasQueryFilter(e => e.UserId == CurrentUserId);
        // FK tới Users: không thể có dòng mồ côi; xoá tài khoản thì DB xoá hết dữ liệu của tài khoản đó.
        b.HasOne<AppUser>().WithMany().HasForeignKey(e => e.UserId).OnDelete(DeleteBehavior.Cascade);
    }

    public override int SaveChanges(bool acceptAllChangesOnSuccess)
    {
        StampOwner();
        return base.SaveChanges(acceptAllChangesOnSuccess);
    }

    public override Task<int> SaveChangesAsync(bool acceptAllChangesOnSuccess, CancellationToken cancellationToken = default)
    {
        StampOwner();
        return base.SaveChangesAsync(acceptAllChangesOnSuccess, cancellationToken);
    }

    private void StampOwner()
    {
        foreach (var entry in ChangeTracker.Entries<IUserOwned>())
        {
            if (entry.State == EntityState.Added)
            {
                // Ghi dữ liệu người dùng mà không có ai đăng nhập là lỗi lập trình, không âm thầm ghi vào Guid.Empty.
                var userId = currentUser.UserId
                    ?? throw new InvalidOperationException("Không ghi được dữ liệu người dùng khi chưa xác định tài khoản.");
                entry.Entity.UserId = userId;
            }
            else if (entry.State == EntityState.Modified && entry.Property(e => e.UserId).IsModified)
            {
                throw new InvalidOperationException("Không được đổi chủ sở hữu của dữ liệu.");
            }
        }
    }
}
