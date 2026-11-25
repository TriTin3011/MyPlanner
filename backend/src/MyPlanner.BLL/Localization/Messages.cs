using System.Globalization;

namespace MyPlanner.BLL.Localization;

// Strongly typed message catalog. RequestLocalization sets CurrentUICulture from Accept-Language.
// Unsupported cultures fall back to Vietnamese, matching the API default.
public static class Messages
{
    private static bool IsEnglish =>
        string.Equals(CultureInfo.CurrentUICulture.TwoLetterISOLanguageName, "en", StringComparison.OrdinalIgnoreCase);

    private static string Text(string vietnamese, string english) => IsEnglish ? english : vietnamese;

    private static string Format(string vietnamese, string english, params object?[] args) =>
        string.Format(CultureInfo.CurrentUICulture, Text(vietnamese, english), args);

    public static string TaskTitleRequired => Text("Tên việc không được trống.", "Task title is required.");
    public static string SubtaskTitleRequired => Text("Tên bước con không được trống.", "Subtask title is required.");
    public static string MaximumSubtasks => Text("Tối đa 50 bước con.", "A task can have at most 50 subtasks.");
    public static string DuplicateIds => Text("Danh sách id bị trùng.", "The ID list contains duplicates.");
    public static string RecurringWeekdayRequired => Text("Chọn ít nhất một thứ trong tuần.", "Select at least one weekday.");
    public static string RecurringWeekdayRange => Text("Thứ phải từ 1 (Thứ 2) đến 7 (Chủ nhật).", "Weekday must be from 1 (Monday) to 7 (Sunday).");
    public static string MaterializeDateOrder => Text("'to' phải sau hoặc bằng 'from'.", "'to' must be on or after 'from'.");
    public static string MaterializeMaximumRange => Text("Khoảng tối đa 62 ngày.", "The range cannot exceed 62 days.");
    public static string GoalTitleRequired => Text("Tên mục tiêu không được trống.", "Goal title is required.");
    public static string GoalDeadlineOrder => Text("Hạn chót phải sau ngày bắt đầu.", "The deadline must be on or after the start date.");
    public static string GoalStepTitleRequired => Text("Tên bước không được trống.", "Step title is required.");
    public static string HabitTitleRequired => Text("Tên thói quen không được trống.", "Habit title is required.");
    public static string StatsRangeInvalid => Text("range phải là 4w, 8w, 12w, 6m hoặc 1y.", "range must be 4w, 8w, 12w, 6m, or 1y.");
    public static string StatsTodayRequired => Text("today là bắt buộc.", "today is required.");
    public static string StatsTodayTooEarly => Text("today quá sớm để tính kỳ so sánh.", "today is too early to calculate the comparison period.");

    public static string FocusPlannedRange => Text("Thời lượng phải từ 5 đến 180 phút.", "Duration must be between 5 and 180 minutes.");
    public static string FocusActualRange => Text("Số phút thực tế phải từ 0 tới số phút đã đặt.", "Actual minutes must be between 0 and the planned minutes.");
    public static string FocusTimeOrder => Text("Giờ kết thúc phải sau giờ bắt đầu.", "The end time must be after the start time.");
    public static string FocusOneLink => Text("Chỉ gắn được một việc, một thói quen hoặc một mục tiêu.", "A session can link to only one task, habit or goal.");
    public static string FocusIdRequired => Text("Thiếu id phiên.", "Session id is required.");
    public static string FocusLocked(string key, double hoursRemaining) => Format(
        "'{0}' chưa mở khoá, còn {1:0.#} giờ tập trung.",
        "'{0}' is still locked; {1:0.#} more focus hours needed.",
        key, hoursRemaining);
    public static string FocusRangeInvalid => Text("Cần from ≤ to và tối đa 400 ngày.", "from must be on or before to, at most 400 days apart.");
    public static string FocusSession => Text("Phiên tập trung", "Focus session");

    public static string NotFoundTitle => Text("Không tìm thấy", "Not found");
    public static string BadRequestTitle => Text("Yêu cầu không hợp lệ", "Invalid request");
    public static string UnauthorizedTitle => Text("Chưa đăng nhập", "Unauthorized");
    // Cố ý không nói sai tên hay sai mật khẩu: nói rõ sẽ giúp kẻ dò biết tên đăng nhập nào có thật.
    public static string InvalidCredentials => Text("Sai tên đăng nhập hoặc mật khẩu.", "Incorrect username or password.");
    public static string TooManyLoginAttempts => Text("Đăng nhập sai quá nhiều lần, thử lại sau một phút.", "Too many login attempts. Try again in a minute.");
    public static string UserNameRequired => Text("Tên đăng nhập không được trống.", "Username is required.");
    public static string PasswordRequired => Text("Mật khẩu không được trống.", "Password is required.");
    public static string ConflictTitle => Text("Bị trùng", "Conflict");
    public static string UserNameTaken => Text("Tên đăng nhập này đã có người dùng.", "This username is already taken.");
    public static string ServiceUnavailableTitle => Text("Dịch vụ tạm thời không khả dụng", "Service temporarily unavailable");
    public static string StorageUnavailable => Text("Chưa lưu được ảnh vì kho lưu trữ đang không hoạt động.", "The photo could not be saved because storage is unavailable.");
    public static string AvatarInvalid => Text("Chỉ nhận ảnh JPG, PNG hoặc WebP hợp lệ.", "Only valid JPG, PNG or WebP images are accepted.");
    public static string AvatarTooLarge => Text("Ảnh tối đa 5 MB.", "Images can be at most 5 MB.");
    public static string TooManyUploads => Text("Bạn đổi ảnh quá nhiều lần, hãy thử lại sau.", "Too many photo changes. Please try again later.");
    public static string UserNameFormat => Text(
        "Tên đăng nhập dài 3–64 ký tự, chỉ gồm chữ không dấu, số, dấu chấm, gạch ngang hoặc gạch dưới.",
        "Username must be 3–64 characters: letters a–z, digits, dot, hyphen or underscore.");
    public static string DisplayNameInvalid => Text("Tên hiển thị tối đa 50 ký tự và không chứa ký tự điều khiển.", "Display name must be at most 50 characters with no control characters.");
    public static string PasswordTooShort => Text("Mật khẩu phải dài ít nhất 8 ký tự.", "Password must be at least 8 characters.");
    public static string InvalidGoogleToken => Text("Không xác thực được tài khoản Google.", "Could not verify your Google account.");
    public static string InvalidRefreshToken => Text("Phiên đăng nhập đã hết hạn, hãy đăng nhập lại.", "Your session has expired. Please sign in again.");
    public static string TooManyRefreshes => Text("Quá nhiều yêu cầu gia hạn phiên, thử lại sau một phút.", "Too many session requests. Try again in a minute.");
    public static string TooManyRegistrations => Text("Tạo tài khoản quá nhiều lần, thử lại sau.", "Too many sign-ups. Try again later.");
    public static string NotFoundDetail(string item) => Format("{0} không tồn tại.", "{0} was not found.", item);

    public static string Task => Text("Việc", "Task");
    public static string SomeTasks => Text("Một số việc", "Some tasks");
    public static string RecurringTask => Text("Việc lặp lại", "Recurring task");
    public static string Habit => Text("Thói quen", "Habit");
    public static string SomeHabits => Text("Một số thói quen", "Some habits");
    public static string Goal => Text("Mục tiêu", "Goal");
    public static string GoalStep => Text("Bước", "Goal step");
    public static string GoalArea => Text("Lĩnh vực", "Life area");
    public static string YearItem => Text("Mục kế hoạch năm", "Year plan item");
    public static string SomeYearItems => Text("Một số mục kế hoạch năm", "Some year plan items");

    public static string FutureHabitLog => Text(
        "Không thể tick thói quen cho ngày trong tương lai.",
        "A habit cannot be checked off for a future date.");

    public static string BackupVersionTooNew(int version, int supportedVersion) => Format(
        "File sao lưu phiên bản {0} mới hơn ứng dụng (hỗ trợ tới {1}).",
        "Backup version {0} is newer than this application (supported through {1}).",
        version, supportedVersion);

    public static string BackupVersionMissing => Text(
        "File sao lưu không hợp lệ (thiếu version).",
        "The backup file is invalid (version is missing).");

    public static string BackupHabitMissing => Text(
        "Có log thói quen trỏ tới thói quen không tồn tại trong file.",
        "A habit log refers to a habit that does not exist in the backup file.");

    public static string InvalidWeekKey(string weekKey) => Format(
        "weekKey không hợp lệ: '{0}'.",
        "Invalid weekKey: '{0}'.",
        weekKey);

    public static string InvalidWeekKeyWithFormat(string weekKey) => Format(
        "weekKey không hợp lệ: '{0}' (dạng 2026-W47).",
        "Invalid weekKey: '{0}' (expected format: 2026-W47).",
        weekKey);

    public static string GoalStepListMismatch => Text(
        "Danh sách bước không khớp với mục tiêu.",
        "The step list does not match the goal.");

    public static string GoalAreaNotFound => Text(
        "Lĩnh vực đã chọn không tồn tại, hãy chọn lại.",
        "The selected life area does not exist. Please choose another one.");

    public static string GoalAreaNameRequired => Text("Hãy nhập tên lĩnh vực.", "Enter a name for the life area.");

    public static string GoalAreaNameTooLong(int max) => Format(
        "Tên lĩnh vực tối đa {0} ký tự.",
        "A life area name can have at most {0} characters.",
        max);

    public static string GoalAreaDuplicate => Text(
        "Đã có lĩnh vực trùng tên.",
        "A life area with this name already exists.");

    public static string GoalAreaLimit(int max) => Format(
        "Chỉ tạo được tối đa {0} lĩnh vực riêng.",
        "You can create at most {0} custom life areas.",
        max);

    public static string GoalAreaBuiltIn => Text(
        "Không xoá được lĩnh vực có sẵn.",
        "Built-in life areas cannot be deleted.");

    public static string GoalAreaInUse => Text(
        "Lĩnh vực này còn mục tiêu, hãy chuyển hoặc xoá các mục tiêu đó trước.",
        "This life area still has goals. Move or delete them first.");

    public static string NewWeekComment => Text("Tuần mới, lên kế hoạch thôi!", "A new week—time to plan!");
    public static string NoTasksDoneComment => Text(
        "Chưa xong việc nào. Tuần sau hãy bắt đầu từ 1–2 việc nhỏ.",
        "No tasks finished yet. Next week, start with 1–2 small tasks.");
    public static string SlowWeekComment => Text(
        "Tuần hơi chậm, chọn 3 việc quan trọng nhất trước nhé.",
        "A slow week. Pick the 3 most important tasks first.");
    public static string FindingRhythmComment => Text(
        "Đang vào nhịp, cố thêm chút nữa.",
        "You are finding your rhythm. Keep going.");
    public static string GoodWeekComment => Text("Khá tốt, giữ nhịp này nhé.", "Good progress. Keep this rhythm.");
    public static string ExcellentWeekComment => Text(
        "Tuần tuyệt vời! Bạn hoàn thành phần lớn kế hoạch.",
        "Excellent week! You completed most of your plan.");

    public static string FewerTasks(int count) => Format(
        "Xong ít hơn tuần trước {0} việc, thử chia nhỏ việc để dễ hoàn thành hơn.",
        "You finished {0} fewer tasks than last week. Try breaking tasks into smaller steps.",
        count);
    public static string MoreTasks(int count) => Format(
        "Xong nhiều hơn tuần trước {0} việc, đang tiến bộ.",
        "You finished {0} more tasks than last week. You are making progress.",
        count);
    public static string SameTasks => Text(
        "Số việc xong bằng tuần trước, giữ nhịp nhé.",
        "You finished the same number of tasks as last week. Keep the rhythm.");
    public static string HabitDecrease(int percent) => Format(
        "Thói quen giảm {0}% so với tuần trước, hãy tích đều hơn.",
        "Habit completion decreased by {0}% from last week. Aim for more consistency.",
        percent);
    public static string HabitIncrease(int percent) => Format(
        "Thói quen tăng {0}% so với tuần trước.",
        "Habit completion increased by {0}% from last week.",
        percent);
    public static string BestDay(DateOnly date, int tasksDone) => Format(
        "Ngày hiệu quả nhất: {0} ({1} việc xong).",
        "Most productive day: {0} ({1} tasks finished).",
        DayName(date), tasksDone);
    public static string NoHabitTicks => Text(
        "Chưa tích thói quen nào trong tuần này.",
        "No habits were checked off this week.");

    private static string DayName(DateOnly date) => IsEnglish
        ? date.ToString("dddd", CultureInfo.GetCultureInfo("en"))
        : date.DayOfWeek switch
        {
            DayOfWeek.Sunday => "Chủ nhật",
            var day => $"Thứ {(int)day + 1}",
        };
}
