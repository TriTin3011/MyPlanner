using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Data;

namespace MyPlanner.BLL.Data;

// Sinh dữ liệu mẫu đủ dày để mọi màn hình có cái để vẽ: ~8 tuần task, 6 thói quen, 12 mục tiêu, ghi chú, kế hoạch năm.
// Dựng sẵn một BackupDto rồi tái dùng ReplaceAllAsync (cùng đường với Import): không viết thêm code ghi DB.
// Random có seed cố định → chạy lại ra cùng dữ liệu, dễ so sánh khi debug.
public class SeedService(IDataRepository data, TimeProvider clock) : ISeedService
{
    private static readonly string[] TaskTitles =
    [
        "Đọc 20 trang sách", "Ôn từ vựng tiếng Anh", "Viết báo cáo tuần", "Họp nhóm dự án", "Dọn bàn làm việc",
        "Gọi điện cho bố mẹ", "Làm bài tập LeetCode", "Chạy bộ 5km", "Lên thực đơn tuần", "Trả lời email",
        "Đi chợ", "Xem lại ngân sách", "Học một bài React", "Sửa bug đăng nhập", "Viết blog",
        "Tưới cây", "Đặt lịch khám răng", "Chuẩn bị slide thuyết trình", "Đọc tài liệu EF Core", "Thiền 10 phút",
    ];

    private static readonly string[] HabitTitles =
        ["Dậy trước 6h", "Uống đủ 2 lít nước", "Tập thể dục", "Đọc sách 30 phút", "Học tiếng Anh", "Không dùng điện thoại sau 23h"];

    private static readonly (string Title, LifeArea Area, string Why)[] GoalSeeds =
    [
        ("Chạy được 10km liên tục", LifeArea.Health, "Khoẻ hơn, bớt mệt khi làm việc"),
        ("Giảm 4kg", LifeArea.Health, "Tự tin hơn"),
        ("Tiết kiệm 50 triệu", LifeArea.Finance, "Quỹ dự phòng 6 tháng"),
        ("Đầu tư định kỳ mỗi tháng", LifeArea.Finance, "Tiền làm việc thay mình"),
        ("Lên vị trí Senior Developer", LifeArea.Career, "Thu nhập và trách nhiệm lớn hơn"),
        ("Làm xong dự án MyPlanner", LifeArea.Career, "Có sản phẩm thật để đi phỏng vấn"),
        ("Đọc 24 cuốn sách", LifeArea.Growth, "Mở rộng góc nhìn"),
        ("Duy trì viết nhật ký", LifeArea.Growth, "Hiểu bản thân hơn"),
        ("Đạt IELTS 7.0", LifeArea.Learning, "Mở cơ hội làm việc nước ngoài"),
        ("Học xong khoá System Design", LifeArea.Learning, "Thiết kế hệ thống tự tin hơn"),
        ("Đưa bố mẹ đi du lịch", LifeArea.Family, "Bố mẹ ngày càng lớn tuổi"),
        ("Học chơi guitar 10 bài", LifeArea.Hobby, "Thư giãn sau giờ làm"),
    ];

    public async Task<ImportResultDto> SeedAsync(DateOnly today, CancellationToken ct)
    {
        var rnd = new Random(2026);
        var now = clock.GetUtcNow();
        var thisMonday = WeekKeys.MondayOf(today);
        var from = thisMonday.AddDays(-7 * 7); // 7 tuần trước + tuần này = 8 tuần
        var to = thisMonday.AddDays(6);

        // Việc lặp lại: tạo quy tắc; task tương ứng sẽ do materialize sinh khi FE mở màn hình.
        var recurring = new List<RecurringTaskDto>
        {
            new(Guid.NewGuid(), "Tổng kết tuần", [7], [TaskTag.Important], true, from, [], now),
            new(Guid.NewGuid(), "Tập gym", [1, 3, 5], [], true, from, [], now),
        };

        var tasks = new List<TaskDto>();
        for (var d = from; d <= to; d = d.AddDays(1))
        {
            var count = rnd.Next(5, 11);
            for (var i = 0; i < count; i++)
            {
                var past = d < today;
                // Quá khứ: ~75% xong; hôm nay: ~30%; tương lai: chưa xong.
                var done = past ? rnd.NextDouble() < 0.75 : d == today && rnd.NextDouble() < 0.3;
                var tags = new List<TaskTag>();
                if (rnd.NextDouble() < 0.2) tags.Add(TaskTag.Urgent);
                if (rnd.NextDouble() < 0.3) tags.Add(TaskTag.Important);
                var subtasks = rnd.NextDouble() < 0.25
                    ? Enumerable.Range(1, rnd.Next(2, 4)).Select(k => new SubtaskDto(Guid.NewGuid(), $"Bước {k}", done || rnd.NextDouble() < 0.4)).ToList()
                    : [];
                var created = new DateTimeOffset(d.ToDateTime(new TimeOnly(7, 0)), TimeSpan.Zero);
                tasks.Add(new TaskDto(
                    Guid.NewGuid(), TaskTitles[rnd.Next(TaskTitles.Length)], d, null, done,
                    done ? created.AddHours(rnd.Next(1, 14)) : null, tags, subtasks, null, i, created, created));
            }
        }

        var habits = HabitTitles.Select((t, i) => new HabitDto(
            Guid.NewGuid(), t, i, true, from, new DateTimeOffset(from.ToDateTime(TimeOnly.MinValue), TimeSpan.Zero), null)).ToList();
        var logs = new List<HabitLogDto>();
        foreach (var (h, i) in habits.Select((h, i) => (h, i)))
        {
            var rate = 0.9 - i * 0.1; // thói quen đầu đều đặn hơn → thống kê có chênh lệch để xem
            for (var d = from; d <= today; d = d.AddDays(1))
                if (rnd.NextDouble() < rate) logs.Add(new HabitLogDto(h.Id, d));
        }

        // Lĩnh vực: 8 có sẵn + một lĩnh vực tự tạo để màn Mục tiêu có ví dụ chip riêng. Id ở đây chỉ là tạm,
        // ReplaceAllAsync cấp Id mới và giữ liên kết mục tiêu → lĩnh vực.
        var areas = Enum.GetValues<LifeArea>().Select(k => new GoalAreaDto(Guid.NewGuid(), k, null)).ToList();
        var volunteer = new GoalAreaDto(Guid.NewGuid(), null, "Tình nguyện");
        areas.Add(volunteer);
        var areaIdOf = areas.Where(a => a.Key is not null).ToDictionary(a => a.Key!.Value, a => a.Id);
        var goalSeeds = GoalSeeds.Select(g => (g.Title, AreaId: areaIdOf[g.Area], g.Why))
            .Append((Title: "Tham gia 3 chuyến tình nguyện", AreaId: volunteer.Id, Why: "Sống có ích cho cộng đồng"))
            .ToList();

        var goals = goalSeeds.Select((g, i) =>
        {
            var start = today.AddDays(-rnd.Next(10, 120));
            var deadline = today.AddDays(rnd.Next(-10, 300));
            var stepCount = rnd.Next(2, 6);
            var status = i % 5 == 4 ? GoalStatus.Done : i % 3 == 0 ? GoalStatus.NotStarted : GoalStatus.InProgress;
            var steps = Enumerable.Range(0, stepCount).Select(k =>
            {
                var stepDone = status == GoalStatus.Done || (status == GoalStatus.InProgress && k < stepCount / 2 + 1);
                return new GoalStepDto(Guid.NewGuid(), $"Bước {k + 1}: {g.Title.ToLowerInvariant()}",
                    start.AddDays((k + 1) * 14), stepDone, stepDone ? now.AddDays(-rnd.Next(1, 30)) : null, k);
            }).ToList();
            return new GoalDto(Guid.NewGuid(), g.Title, g.AreaId, status, start, deadline,
                i % 2 == 0 ? "Một bữa ăn ngon" : null, g.Why, steps,
                new DateTimeOffset(start.ToDateTime(TimeOnly.MinValue), TimeSpan.Zero),
                status == GoalStatus.Done ? now.AddDays(-rnd.Next(1, 20)) : null);
        }).ToList();

        var dayNotes = Enumerable.Range(0, 5)
            .Select(k => new DayNoteDto(today.AddDays(-k * 3), "Hôm nay làm việc khá tập trung. Cần ngủ sớm hơn.", now)).ToList();
        var weekNotes = new List<WeekNoteDto> { new(WeekKeys.ToKey(today), "Tuần này ưu tiên hoàn thành giai đoạn 1.", now) };
        var years = new List<YearMetaDto> { new(today.Year, "Kỷ luật", "Một năm khoẻ mạnh, học được nhiều và có sản phẩm của riêng mình.") };
        var yearItems = Enumerable.Range(1, 12).SelectMany(m => Enumerable.Range(0, rnd.Next(1, 4)).Select(k =>
            new YearPlanItemDto(Guid.NewGuid(), today.Year, m, $"Kế hoạch tháng {m} #{k + 1}", m < today.Month && rnd.NextDouble() < 0.7, k))).ToList();

        var backup = new BackupDto(BackupDto.CurrentVersion, now, tasks, recurring, habits, logs, goals, dayNotes, weekNotes, years, yearItems, areas);
        await data.ReplaceAllAsync(backup, ct);
        return new ImportResultDto(tasks.Count, habits.Count, logs.Count, goals.Count);
    }
}
