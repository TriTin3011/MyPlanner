using System.Globalization;
using MyPlanner.BLL.Dashboard;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Goals;
using MyPlanner.DAL.Habits;
using MyPlanner.DAL.Notes;
using MyPlanner.DAL.Tasks;

namespace MyPlanner.BLL.Tests;

public class DashboardServiceTests : IDisposable
{
    private static readonly DateOnly Today = new(2026, 11, 22);

    // Chuỗi nhận xét đi theo CurrentUICulture. Máy chạy test có thể là en-US,
    // nên mặc định ép "vi" cho mọi test; test đa ngôn ngữ tự đặt lại culture riêng.
    private readonly CultureInfo previousUiCulture = CultureInfo.CurrentUICulture;

    public DashboardServiceTests() => CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo("vi");

    public void Dispose() => CultureInfo.CurrentUICulture = previousUiCulture;

    [Fact]
    public async Task GetTodayAsync_calculates_summary_from_requested_date()
    {
        var tasks = Enumerable.Range(0, 10)
            .Select(i => Task(i, Today, done: i < 3))
            .ToList();
        var habits = Enumerable.Range(0, 6)
            .Select(i => Habit(i, active: true))
            .ToList();
        var logs = Enumerable.Range(0, 3)
            .Select(i => new HabitLogDto(habits[i].Id, Today))
            .ToList();
        var service = Service(new FakeTaskRepository(tasks), new FakeHabitRepository(habits, logs), new FakeNoteRepository());

        var result = await service.GetTodayAsync(Today, CancellationToken.None);

        Assert.Equal(Today, result.Date);
        Assert.Equal(3, result.TasksDone);
        Assert.Equal(10, result.TasksTotal);
        Assert.Equal(3, result.HabitsDone);
        Assert.Equal(6, result.HabitsTotal);
        Assert.Equal(38, result.Percent);
    }

    [Fact]
    public async Task GetTodayAsync_returns_daily_content()
    {
        var todayTask = Task(1, Today, done: false);
        var backlogTask = Task(2, Today.AddDays(-1), done: false);
        var completedOldTask = Task(3, Today.AddDays(-1), done: true);
        var activeHabit = Habit(1, active: true);
        var inactiveHabit = Habit(2, active: false);
        var note = new DayNoteDto(Today, "Ghi chú kiểm thử", DateTimeOffset.Parse("2026-11-22T09:00:00Z"));
        var service = Service(new FakeTaskRepository([todayTask, backlogTask, completedOldTask]), new FakeHabitRepository([activeHabit, inactiveHabit], [new HabitLogDto(activeHabit.Id, Today)]), new FakeNoteRepository(note));

        var result = await service.GetTodayAsync(Today, CancellationToken.None);

        Assert.Equal(todayTask, Assert.Single(result.Tasks));
        Assert.Equal(backlogTask, Assert.Single(result.Backlog));
        var habit = Assert.Single(result.Habits);
        Assert.Equal(activeHabit.Id, habit.Id);
        Assert.True(habit.Done);
        Assert.Equal(note, result.Note);
    }

    [Fact]
    public async Task GetDaysAsync_returns_one_row_per_day_with_percent_and_deadline_flag()
    {
        var from = Today.AddDays(-2);
        var service = new DashboardService(
            new FakeTaskRepository([Task(1, from, done: true), Task(2, from, done: false), Task(3, from, done: false), Task(4, Today, done: true)]),
            new FakeHabitRepository([], []),
            new FakeNoteRepository(),
            new FakeGoalRepository([Today.AddDays(-1)]));

        var days = await service.GetDaysAsync(from, Today, CancellationToken.None);

        Assert.Equal(3, days.Count);
        Assert.Equal(new DayProgressDto(from, 1, 3, 33, false), days[0]);
        Assert.Equal(new DayProgressDto(Today.AddDays(-1), 0, 0, 0, true), days[1]);
        Assert.Equal(new DayProgressDto(Today, 1, 1, 100, false), days[2]);
    }

    // Tuần 2026-W47: Thứ 2 16/11 → CN 22/11. Today = 22/11 (Chủ nhật), Thứ 4 18/11 làm tốt nhất.
    private static readonly DateOnly Monday = new(2026, 11, 16);

    [Fact]
    public async Task GetWeekAsync_calculates_stat_strip_comment_and_insights()
    {
        var weekTasks = new List<TaskDto>
        {
            Task(1, Monday, done: true),
            Task(2, Monday, done: false),             // tồn trong tuần
            Task(3, Monday.AddDays(2), done: true),
            Task(4, Monday.AddDays(2), done: true),
            Task(5, Today, done: false),              // hôm nay còn 1 việc
            Task(6, Today, done: true),
            Task(7, Monday.AddDays(7), done: false),  // tuần sau: không tính
        };
        // Tuần trước (9–15/11) xong 6 việc.
        weekTasks.AddRange(Enumerable.Range(0, 6).Select(i => Task(20 + i, Monday.AddDays(-7 + i), done: true)));
        var strong = Habit(1, active: true);
        var weak = Habit(2, active: true);
        var logs = Enumerable.Range(0, 7).Select(i => new HabitLogDto(strong.Id, Monday.AddDays(i)))
            .Append(new HabitLogDto(weak.Id, Monday))
            // Tuần trước: chỉ habit mạnh tick đủ 7 ngày → 7/14 = 50%.
            .Concat(Enumerable.Range(1, 7).Select(i => new HabitLogDto(strong.Id, Monday.AddDays(-i))))
            .ToList();
        var service = Service(new FakeTaskRepository(weekTasks), new FakeHabitRepository([strong, weak], logs), new FakeNoteRepository());

        var week = await service.GetWeekAsync(Monday, Today, CancellationToken.None);

        Assert.Equal("2026-W47", week.WeekKey);
        Assert.Equal(Today, week.To);
        Assert.Equal(4, week.TasksDone);
        Assert.Equal(6, week.TasksTotal);
        Assert.Equal("Khá tốt, giữ nhịp này nhé.", week.Comment); // 4/6 ≈ 0,67
        Assert.Equal(57, week.HabitPercent);                       // 8 / 14
        Assert.Equal(1, week.TodayRemaining);
        Assert.Equal(7, week.Days.Count);
        Assert.Equal(
        [
            "Xong ít hơn tuần trước 2 việc, thử chia nhỏ việc để dễ hoàn thành hơn.",
            "Thói quen tăng 7% so với tuần trước.",
            "Ngày hiệu quả nhất: Thứ 4 (2 việc xong).",
        ], week.Insights);
    }

    [Fact]
    public async Task GetWeekAsync_for_a_future_week_has_no_today_count_and_no_insights()
    {
        var nextMonday = Monday.AddDays(7);
        var service = Service(
            new FakeTaskRepository([Task(1, Today, done: false), Task(2, Today, done: false)]),
            new FakeHabitRepository([Habit(1, active: true)], []),
            new FakeNoteRepository());

        var week = await service.GetWeekAsync(nextMonday, Today, CancellationToken.None);

        Assert.Equal("2026-W48", week.WeekKey);
        Assert.Equal(0, week.TasksTotal);
        Assert.Equal("Tuần mới, lên kế hoạch thôi!", week.Comment);
        Assert.Equal(0, week.HabitPercent);
        Assert.Equal(0, week.TodayRemaining); // hôm nay (22/11) không thuộc tuần W48
        Assert.Empty(week.Insights);
    }

    [Theory]
    [InlineData("vi", "Tuần mới, lên kế hoạch thôi!")]
    [InlineData("en", "A new week—time to plan!")]
    public async Task GetWeekAsync_localizes_comment_from_current_ui_culture(string cultureName, string expected)
    {
        var previous = CultureInfo.CurrentUICulture;
        CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo(cultureName);
        try
        {
            var service = Service(
                new FakeTaskRepository([]),
                new FakeHabitRepository([], []),
                new FakeNoteRepository());

            var week = await service.GetWeekAsync(Monday, Today, CancellationToken.None);

            Assert.Equal(expected, week.Comment);
        }
        finally
        {
            CultureInfo.CurrentUICulture = previous;
        }
    }

    [Fact]
    public async Task GetWeeksAsync_returns_one_row_per_week_ending_at_the_given_week()
    {
        var service = Service(
            new FakeTaskRepository(
            [
                Task(1, Monday.AddDays(-14), done: true),  // W45
                Task(2, Monday.AddDays(-1), done: false),  // CN 15/11 của W46
                Task(3, Monday.AddDays(-7), done: true),   // T2 của W46
                Task(4, Today, done: true),                // W47
                Task(5, Monday.AddDays(7), done: true),    // W48: ngoài khoảng
            ]),
            new FakeHabitRepository([], []),
            new FakeNoteRepository());

        var weeks = await service.GetWeeksAsync(Monday, 3, CancellationToken.None);

        Assert.Equal(
        [
            new WeekProgressDto("2026-W45", Monday.AddDays(-14), 1, 1, 100),
            new WeekProgressDto("2026-W46", Monday.AddDays(-7), 1, 2, 50),
            new WeekProgressDto("2026-W47", Monday, 1, 1, 100),
        ], weeks);
    }

    // Tháng 11/2026, Today = 22/11. Habit 1 (từ 1/11) tick 1→20/11 (bỏ 21, 22): 20/22 ≈ 91%, chuỗi hiện tại 0.
    // Habit 2 (từ 15/11) tick 20, 21, 22: 3/8 ≈ 38%, chuỗi hiện tại 3. Có thêm log tháng 10 nối chuỗi của habit 1.
    [Fact]
    public async Task GetHabitMonthAsync_computes_rows_highlights_and_days()
    {
        var first = new DateOnly(2026, 11, 1);
        var h1 = Habit(1, active: true);
        var h2 = Habit(2, active: true) with { StartDate = new DateOnly(2026, 11, 15) };
        var inactive = Habit(3, active: false);
        var later = Habit(4, active: true) with { StartDate = new DateOnly(2026, 12, 5) };
        var logs = Enumerable.Range(0, 20).Select(i => new HabitLogDto(h1.Id, first.AddDays(i)))
            .Concat([new HabitLogDto(h1.Id, new DateOnly(2026, 10, 31)), new HabitLogDto(h1.Id, new DateOnly(2026, 10, 30))])
            .Concat(Enumerable.Range(19, 3).Select(i => new HabitLogDto(h2.Id, first.AddDays(i))))
            .Concat([new HabitLogDto(inactive.Id, Today)])
            .ToList();
        var service = Service(new FakeTaskRepository([]), new FakeHabitRepository([h1, h2, inactive, later], logs), new FakeNoteRepository());

        var result = await service.GetHabitMonthAsync(first, Today, CancellationToken.None);

        Assert.Equal("2026-11", result.Month);
        Assert.Equal(new DateOnly(2026, 11, 30), result.To);
        Assert.Equal([h1.Id, h2.Id], result.Habits.Select(r => r.Id));
        var r1 = result.Habits[0];
        Assert.Equal(91, r1.Percent);
        Assert.Equal(0, r1.CurrentStreak);
        Assert.Equal(22, r1.LongestStreak); // 30/10 → 20/11, tính cả lịch sử ngoài tháng
        Assert.Equal(20, r1.DoneDates.Count);
        var r2 = result.Habits[1];
        Assert.Equal(38, r2.Percent);
        Assert.Equal(3, r2.CurrentStreak);
        Assert.Equal(77, result.Percent); // (20 + 3) / (22 + 8) ô ≈ 76,7%
        Assert.Equal(new HabitHighlightDto(h1.Id, h1.Title, 22), result.LongestStreak);
        Assert.Equal(new HabitHighlightDto(h1.Id, h1.Title, 91), result.MostConsistent);
        Assert.Equal(30, result.Days.Count);
        Assert.Equal(new HabitDayCountDto(new DateOnly(2026, 11, 14), 1, 1, 100), result.Days[13]);
        Assert.Equal(new HabitDayCountDto(new DateOnly(2026, 11, 20), 2, 2, 100), result.Days[19]);
        Assert.Equal(new HabitDayCountDto(Today, 1, 2, 50), result.Days[21]);
        Assert.Equal(new HabitDayCountDto(new DateOnly(2026, 11, 23), null, null, null), result.Days[22]);
    }

    [Fact]
    public async Task GetHabitMonthAsync_without_habits_returns_empty_month()
    {
        var service = Service(new FakeTaskRepository([]), new FakeHabitRepository([], []), new FakeNoteRepository());

        var result = await service.GetHabitMonthAsync(new DateOnly(2026, 12, 1), Today, CancellationToken.None);

        Assert.Equal(0, result.Percent);
        Assert.Null(result.LongestStreak);
        Assert.Null(result.MostConsistent);
        Assert.Empty(result.Habits);
        Assert.All(result.Days, d => Assert.Null(d.Done));
    }

    private static DashboardService Service(FakeTaskRepository t, FakeHabitRepository h, FakeNoteRepository n) =>
        new(t, h, n, new FakeGoalRepository([]));

    private static TaskDto Task(int seed, DateOnly date, bool done) => new(
        GuidFrom(seed), $"Việc {seed}", date, null, done, done ? DateTimeOffset.Parse("2026-11-22T08:00:00Z") : null,
        [], [], null, seed, DateTimeOffset.Parse("2026-11-01T00:00:00Z"), DateTimeOffset.Parse("2026-11-01T00:00:00Z"));

    private static HabitDto Habit(int seed, bool active) => new(
        GuidFrom(seed + 100), $"Thói quen {seed}", seed, active, new DateOnly(2026, 11, 1),
        DateTimeOffset.Parse("2026-11-01T00:00:00Z"), null);

    private static Guid GuidFrom(int seed) => new(seed, 0, 0, new byte[8]);

    private sealed class FakeTaskRepository(List<TaskDto> tasks) : ITaskRepository
    {
        public Task<List<TaskDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
            System.Threading.Tasks.Task.FromResult(tasks.Where(t => t.Date >= from && t.Date <= to).ToList());
        public Task<List<TaskDto>> BacklogAsync(DateOnly today, CancellationToken ct) =>
            System.Threading.Tasks.Task.FromResult(tasks.Where(t => !t.Done && t.Date < today).ToList());
        public Task<TaskDto?> GetAsync(Guid id, CancellationToken ct) => throw new NotSupportedException();
        public Task<TaskItem?> FindAsync(Guid id, CancellationToken ct) => throw new NotSupportedException();
        public Task<List<TaskItem>> FindManyAsync(IReadOnlyCollection<Guid> ids, CancellationToken ct) => throw new NotSupportedException();
        public Task<List<TaskItem>> FindUndoneBeforeAsync(DateOnly today, CancellationToken ct) => throw new NotSupportedException();
        public Task<int> NextOrderAsync(DateOnly date, CancellationToken ct) => throw new NotSupportedException();
        public Task<HashSet<(Guid RecurringId, DateOnly Date)>> RecurringDatesAsync(DateOnly from, DateOnly to, CancellationToken ct) => throw new NotSupportedException();
        public Task<int> DeleteRangeAsync(DateOnly from, DateOnly to, CancellationToken ct) => throw new NotSupportedException();
        public void Add(TaskItem task) => throw new NotSupportedException();
        public void Remove(TaskItem task) => throw new NotSupportedException();
        public Task SaveChangesAsync(CancellationToken ct) => throw new NotSupportedException();
    }

    private sealed class FakeHabitRepository(List<HabitDto> habits, List<HabitLogDto> logs) : IHabitRepository
    {
        public Task<List<HabitDto>> ListAsync(bool includeInactive, CancellationToken ct) =>
            System.Threading.Tasks.Task.FromResult(habits.Where(h => includeInactive || h.Active).ToList());
        public Task<List<HabitLogDto>> LogsAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
            System.Threading.Tasks.Task.FromResult(logs.Where(l => l.Date >= from && l.Date <= to).ToList());
        public Task<HabitDto?> GetAsync(Guid id, CancellationToken ct) => throw new NotSupportedException();
        public Task<Habit?> FindAsync(Guid id, CancellationToken ct) => throw new NotSupportedException();
        public Task<List<Habit>> FindAllAsync(CancellationToken ct) => throw new NotSupportedException();
        public Task<int> NextOrderAsync(CancellationToken ct) => throw new NotSupportedException();
        public Task<List<HabitLogDto>> AllLogsAsync(CancellationToken ct) => throw new NotSupportedException();
        public Task<bool> HasLogAsync(Guid habitId, DateOnly date, CancellationToken ct) => throw new NotSupportedException();
        public void AddLog(HabitLog log) => throw new NotSupportedException();
        public Task<int> DeleteLogAsync(Guid habitId, DateOnly date, CancellationToken ct) => throw new NotSupportedException();
        public Task<int> DeleteLogsAsync(DateOnly from, DateOnly to, CancellationToken ct) => throw new NotSupportedException();
        public void Add(Habit habit) => throw new NotSupportedException();
        public void Remove(Habit habit) => throw new NotSupportedException();
        public Task SaveChangesAsync(CancellationToken ct) => throw new NotSupportedException();
    }

    private sealed class FakeNoteRepository(DayNoteDto? note = null) : INoteRepository
    {
        public Task<DayNoteDto?> GetDayAsync(DateOnly date, CancellationToken ct) =>
            System.Threading.Tasks.Task.FromResult(note?.Date == date ? note : null);
        public Task<WeekNoteDto?> GetWeekAsync(string weekKey, CancellationToken ct) => throw new NotSupportedException();
        public Task<DayNote?> FindDayAsync(DateOnly date, CancellationToken ct) => throw new NotSupportedException();
        public Task<WeekNote?> FindWeekAsync(string weekKey, CancellationToken ct) => throw new NotSupportedException();
        public Task<int> DeleteWeekAsync(string weekKey, DateOnly from, DateOnly to, CancellationToken ct) => throw new NotSupportedException();
        public void Add(DayNote note) => throw new NotSupportedException();
        public void Add(WeekNote note) => throw new NotSupportedException();
        public Task SaveChangesAsync(CancellationToken ct) => throw new NotSupportedException();
    }

    private sealed class FakeGoalRepository(List<DateOnly> deadlines) : IGoalRepository
    {
        public Task<HashSet<DateOnly>> DeadlineDatesAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
            System.Threading.Tasks.Task.FromResult(deadlines.Where(d => d >= from && d <= to).ToHashSet());
        public Task<List<GoalDto>> ListAsync(CancellationToken ct) => throw new NotSupportedException();
        public Task<GoalDto?> GetAsync(Guid id, CancellationToken ct) => throw new NotSupportedException();
        public Task<Goal?> FindAsync(Guid id, CancellationToken ct) => throw new NotSupportedException();
        public Task<List<(Guid GoalId, string GoalTitle, string Title, DateOnly Deadline, bool Done)>> StepDeadlinesAsync(
            DateOnly from, DateOnly to, CancellationToken ct) => throw new NotSupportedException();
        public Task<List<(Guid GoalId, string Title, DateOnly Deadline, bool Done)>> GoalDeadlinesAsync(
            DateOnly from, DateOnly to, CancellationToken ct) => throw new NotSupportedException();
        public void Add(Goal goal) => throw new NotSupportedException();
        public void Remove(Goal goal) => throw new NotSupportedException();
        public Task SaveChangesAsync(CancellationToken ct) => throw new NotSupportedException();
    }
}
