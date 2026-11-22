using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using MyPlanner.DAL.Data;
using MyPlanner.DAL.Goals;
using MyPlanner.DAL.Habits;
using MyPlanner.DAL.Health;
using MyPlanner.DAL.Notes;
using MyPlanner.DAL.Stats;
using MyPlanner.DAL.Tasks;

namespace MyPlanner.DAL;

// Điểm đăng ký DI của tầng DAL. BLL gọi hàm này; Api không biết DAL có gì bên trong.
public static class DependencyInjection
{
    public static IServiceCollection AddDataAccess(this IServiceCollection services, string connectionString)
    {
        // AppDbContext scoped: mỗi HTTP request một instance.
        services.AddDbContext<AppDbContext>(options => options.UseNpgsql(connectionString));

        // Repository scoped, cùng vòng đời với AppDbContext mà nó dùng.
        services.AddScoped<IHealthRepository, HealthRepository>();
        services.AddScoped<ITaskRepository, TaskRepository>();
        services.AddScoped<IRecurringRepository, RecurringRepository>();
        services.AddScoped<IHabitRepository, HabitRepository>();
        services.AddScoped<IGoalRepository, GoalRepository>();
        services.AddScoped<INoteRepository, NoteRepository>();
        services.AddScoped<IYearRepository, YearRepository>();
        services.AddScoped<IDataRepository, DataRepository>();
        services.AddScoped<IStatsRepository, StatsRepository>();

        return services;
    }
}
