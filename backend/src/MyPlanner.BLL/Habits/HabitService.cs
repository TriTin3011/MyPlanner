using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Habits;

namespace MyPlanner.BLL.Habits;

public class HabitService(IHabitRepository habits, TimeProvider clock) : IHabitService
{
    public Task<List<HabitDto>> ListAsync(bool includeInactive, CancellationToken ct) => habits.ListAsync(includeInactive, ct);

    public async Task<HabitDto> CreateAsync(SaveHabitRequest req, CancellationToken ct)
    {
        var now = clock.GetUtcNow();
        var habit = new Habit
        {
            Id = Guid.NewGuid(),
            Title = req.Title.Trim(),
            Order = await habits.NextOrderAsync(ct),
            Active = req.Active,
            StartDate = req.StartDate ?? DateOnly.FromDateTime(now.UtcDateTime),
            CreatedAt = now,
            ArchivedAt = req.Active ? null : now,
        };
        habits.Add(habit);
        await habits.SaveChangesAsync(ct);
        return (await habits.GetAsync(habit.Id, ct))!;
    }

    // Active = false là "lưu trữ": ẩn khỏi Hôm nay/bảng tháng nhưng giữ log cũ cho thống kê.
    public async Task<HabitDto> UpdateAsync(Guid id, SaveHabitRequest req, CancellationToken ct)
    {
        var habit = await habits.FindAsync(id, ct) ?? throw AppException.NotFound(Messages.Habit);
        habit.Title = req.Title.Trim();
        if (habit.Active != req.Active) habit.ArchivedAt = req.Active ? null : clock.GetUtcNow();
        habit.Active = req.Active;
        if (req.StartDate is { } start) habit.StartDate = start;
        await habits.SaveChangesAsync(ct);
        return (await habits.GetAsync(id, ct))!;
    }

    // Xoá hẳn (FK cascade xoá luôn log). Muốn giữ lịch sử thì dùng PUT active=false.
    public async Task DeleteAsync(Guid id, CancellationToken ct)
    {
        var habit = await habits.FindAsync(id, ct) ?? throw AppException.NotFound(Messages.Habit);
        habits.Remove(habit);
        await habits.SaveChangesAsync(ct);
    }

    public async Task ReorderAsync(IReadOnlyList<Guid> ids, CancellationToken ct)
    {
        var all = (await habits.FindAllAsync(ct)).ToDictionary(h => h.Id);
        if (ids.Any(id => !all.ContainsKey(id))) throw AppException.NotFound(Messages.SomeHabits);
        for (var i = 0; i < ids.Count; i++) all[ids[i]].Order = i;
        await habits.SaveChangesAsync(ct);
    }

    public Task<List<HabitLogDto>> LogsAsync(DateOnly from, DateOnly to, CancellationToken ct) => habits.LogsAsync(from, to, ct);

    // PUT idempotent: tick lại ngày đã tick không lỗi, không tạo trùng.
    public async Task TickAsync(Guid habitId, DateOnly date, CancellationToken ct)
    {
        // Server không biết múi giờ client; nơi sớm nhất thế giới là UTC+14 nên ngày lớn hơn mức đó chắc chắn là tương lai.
        var latestToday = DateOnly.FromDateTime(clock.GetUtcNow().AddHours(14).UtcDateTime);
        if (date > latestToday) throw AppException.BadRequest(Messages.FutureHabitLog);

        _ = await habits.FindAsync(habitId, ct) ?? throw AppException.NotFound(Messages.Habit);
        if (await habits.HasLogAsync(habitId, date, ct)) return;
        habits.AddLog(new HabitLog { HabitId = habitId, Date = date });
        await habits.SaveChangesAsync(ct);
    }

    // DELETE cũng idempotent: bỏ tick ngày chưa tick vẫn trả 204.
    public Task UntickAsync(Guid habitId, DateOnly date, CancellationToken ct) => habits.DeleteLogAsync(habitId, date, ct);
}
