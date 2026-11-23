using System.Text.Json;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Identity;
using MyPlanner.BLL.Auth;
using MyPlanner.BLL.Data;
using MyPlanner.Core.Entities;
using MyPlanner.BLL.Dashboard;
using MyPlanner.BLL.Goals;
using MyPlanner.BLL.Habits;
using MyPlanner.BLL.Health;
using MyPlanner.BLL.Notes;
using MyPlanner.BLL.Stats;
using MyPlanner.BLL.Tasks;
using MyPlanner.DAL;

namespace MyPlanner.BLL;

// Điểm đăng ký DI của tầng BLL. Api chỉ gọi hàm này; BLL tự gọi xuống DAL.
public static class DependencyInjection
{
    public static IServiceCollection AddBusinessLogic(this IServiceCollection services, string connectionString)
    {
        services.AddDataAccess(connectionString);

        // Đồng hồ hệ thống. Service nhận TimeProvider thay vì gọi DateTimeOffset.UtcNow để test thay được bằng FakeTimeProvider.
        services.AddSingleton(TimeProvider.System);

        // Service scoped, cùng vòng đời với repository mà nó dùng.
        services.AddScoped<IHealthService, HealthService>();
        services.AddScoped<IDashboardService, DashboardService>();
        services.AddScoped<ITaskService, TaskService>();
        services.AddScoped<IRecurringService, RecurringService>();
        services.AddScoped<IHabitService, HabitService>();
        services.AddScoped<IGoalService, GoalService>();
        services.AddScoped<INoteService, NoteService>();
        services.AddScoped<IYearService, YearService>();
        services.AddScoped<IDataService, DataService>();
        services.AddScoped<ISeedService, SeedService>();
        services.AddScoped<IStatsService, StatsService>();

        // Đăng nhập: PasswordHasher và bộ ký JWT không giữ trạng thái theo request nên dùng singleton.
        services.AddSingleton<IPasswordHasher<AppUser>, PasswordHasher<AppUser>>();
        services.AddSingleton<ITokenIssuer, JwtTokenIssuer>();
        services.AddSingleton<IGoogleTokenVerifier, GoogleTokenVerifier>();
        services.AddScoped<IAuthService, AuthService>();

        // FluentValidation: quét assembly BLL, đăng ký mọi AbstractValidator<T>. ValidationFilter (Api) gọi chúng trước mỗi action.
        services.AddValidatorsFromAssembly(typeof(DependencyInjection).Assembly);
        // Key lỗi dạng camelCase ("title", không phải "Title") để khớp tên field JSON mà FE gửi.
        ValidatorOptions.Global.PropertyNameResolver = (_, member, _) =>
            member is null ? null : JsonNamingPolicy.CamelCase.ConvertName(member.Name);
        // Null means FluentValidation resolves built-in messages from CurrentUICulture for each request.
        ValidatorOptions.Global.LanguageManager.Culture = null;

        return services;
    }
}
