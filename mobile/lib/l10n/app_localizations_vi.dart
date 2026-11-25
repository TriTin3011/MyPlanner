// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Mầm';

  @override
  String get navToday => 'Hôm nay';

  @override
  String get navGoals => 'Mục tiêu';

  @override
  String get navHabits => 'Thói quen';

  @override
  String get navWeek => 'Tuần';

  @override
  String get navYear => 'Năm';

  @override
  String get navStats => 'Thống kê';

  @override
  String get navMore => 'Thêm';

  @override
  String get themeLabel => 'Bộ màu';

  @override
  String get themeForest => 'Rừng xanh';

  @override
  String get themeOcean => 'Biển đêm';

  @override
  String get themeSunset => 'Hoàng hôn';

  @override
  String get themeLavender => 'Oải hương';

  @override
  String get themeNight => 'Đêm';

  @override
  String get languageLabel => 'Ngôn ngữ';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get authTitle => 'Đăng nhập';

  @override
  String get authSubtitle => 'Kế hoạch của bạn đang chờ ở đây.';

  @override
  String get authUserName => 'Tên đăng nhập';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authShowPassword => 'Hiện mật khẩu';

  @override
  String get authHidePassword => 'Ẩn mật khẩu';

  @override
  String get authSubmit => 'Đăng nhập';

  @override
  String get authLogout => 'Đăng xuất';

  @override
  String get authAccount => 'Tài khoản';

  @override
  String get authProfile => 'Hồ sơ';

  @override
  String get authDisplayName => 'Tên hiển thị';

  @override
  String get authDisplayNameHint =>
      'Để trống để dùng lại tên đăng nhập. Tối đa 50 ký tự.';

  @override
  String authLoginName(String name) {
    return 'Tên đăng nhập: $name';
  }

  @override
  String get authRegisterTitle => 'Tạo tài khoản';

  @override
  String get authRegisterSubtitle => 'Bắt đầu gieo kế hoạch của riêng bạn.';

  @override
  String get authRegisterSubmit => 'Tạo tài khoản';

  @override
  String get authUserNameHint =>
      '3–64 ký tự: chữ không dấu, số, dấu chấm, gạch ngang, gạch dưới.';

  @override
  String authPasswordHint(int count) {
    return 'Ít nhất $count ký tự.';
  }

  @override
  String get authNoAccount => 'Chưa có tài khoản?';

  @override
  String get authGoToRegister => 'Đăng ký';

  @override
  String get authHaveAccount => 'Đã có tài khoản?';

  @override
  String get authGoToLogin => 'Đăng nhập';

  @override
  String get authOr => 'hoặc';

  @override
  String get authGoogleContinue => 'Đăng nhập bằng Google';

  @override
  String get authGoogleUnavailable => 'Bản này chưa cấu hình đăng nhập Google.';

  @override
  String get authSessionExpired =>
      'Phiên đăng nhập đã hết hạn, hãy đăng nhập lại.';

  @override
  String get authAddPhoto => 'Thêm ảnh';

  @override
  String get authChangePhoto => 'Đổi ảnh';

  @override
  String get authRemovePhoto => 'Xoá ảnh';

  @override
  String get authTakePhoto => 'Chụp ảnh';

  @override
  String get authPhotoHint => 'JPG, PNG hoặc WebP, tối đa 5 MB';

  @override
  String get authPhotoTooLarge => 'Ảnh tối đa 5 MB.';

  @override
  String get errorNetwork =>
      'Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại.';

  @override
  String get errorUnknown => 'Có lỗi xảy ra. Thử lại sau nhé.';

  @override
  String errorTooMany(int seconds) {
    return 'Bạn thử quá nhiều lần. Đợi $seconds giây rồi thử lại.';
  }

  @override
  String get retry => 'Thử lại';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Huỷ';

  @override
  String get delete => 'Xoá';

  @override
  String get add => 'Thêm';

  @override
  String get edit => 'Sửa';

  @override
  String get close => 'Đóng';

  @override
  String get done => 'Xong';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get saved => 'Đã lưu';

  @override
  String get saving => 'Đang lưu…';

  @override
  String get chartLine => 'Đường';

  @override
  String get chartBar => 'Cột';

  @override
  String get chartTable => 'Bảng';

  @override
  String todayGreeting(String name) {
    return 'Chào $name!';
  }

  @override
  String todayProgress(int done, int total, int habitsDone, int habitsTotal) {
    return '$done/$total việc · $habitsDone/$habitsTotal thói quen';
  }

  @override
  String get todayTasks => 'Việc hôm nay';

  @override
  String get todayTasksEmpty =>
      'Chưa có việc nào. Thêm một việc nhỏ để bắt đầu nhé.';

  @override
  String get todayAddTask => 'Thêm việc';

  @override
  String get todayTaskHint => 'Việc cần làm…';

  @override
  String get todayHabits => 'Thói quen';

  @override
  String get todayHabitsEmpty => 'Chưa có thói quen. Thêm ở tab Thói quen.';

  @override
  String get todayNote => 'Ghi chú';

  @override
  String get todayNoteHint => 'Viết vài dòng cho hôm nay…';

  @override
  String get todayBacklog => 'Việc còn tồn';

  @override
  String get todayBacklogMove => 'Chuyển hết sang hôm nay';

  @override
  String todayBacklogMoved(int count) {
    return 'Đã chuyển $count việc sang hôm nay';
  }

  @override
  String get todayCalendar => 'Lên kế hoạch';

  @override
  String get todayCalendarMonth => 'Tháng';

  @override
  String get todayCalendarWeek => 'Tuần';

  @override
  String get todayRecent => 'Tiến độ gần đây';

  @override
  String get todayRecurring => 'Việc lặp lại';

  @override
  String get tagUrgent => 'Gấp';

  @override
  String get tagImportant => 'Quan trọng';

  @override
  String get taskEdit => 'Sửa việc';

  @override
  String get taskTitle => 'Tên việc';

  @override
  String get taskDate => 'Ngày';

  @override
  String get taskTags => 'Nhãn';

  @override
  String get taskSubtasks => 'Việc con';

  @override
  String get taskAddSubtask => 'Thêm việc con';

  @override
  String get taskMoveDate => 'Chọn ngày khác';

  @override
  String get taskMoveToday => 'Chuyển sang hôm nay';

  @override
  String get taskDelete => 'Xoá việc';

  @override
  String get taskDeleted => 'Đã xoá việc';

  @override
  String taskLate(String date) {
    return 'Từ $date';
  }

  @override
  String dayTasksTitle(String date) {
    return 'Việc ngày $date';
  }

  @override
  String get reorderHint => 'Giữ và kéo để sắp xếp';

  @override
  String get recurringTitle => 'Việc lặp lại';

  @override
  String get recurringEmpty => 'Chưa có việc lặp lại.';

  @override
  String get recurringAdd => 'Thêm việc lặp lại';

  @override
  String get recurringWeekdays => 'Lặp vào';

  @override
  String get recurringActive => 'Đang bật';

  @override
  String get recurringStart => 'Bắt đầu từ';

  @override
  String get recurringEveryday => 'Mỗi ngày';

  @override
  String get weekdayShort1 => 'T2';

  @override
  String get weekdayShort2 => 'T3';

  @override
  String get weekdayShort3 => 'T4';

  @override
  String get weekdayShort4 => 'T5';

  @override
  String get weekdayShort5 => 'T6';

  @override
  String get weekdayShort6 => 'T7';

  @override
  String get weekdayShort7 => 'CN';

  @override
  String get weekTitle => 'Kế hoạch tuần';

  @override
  String weekRange(int week, String from, String to) {
    return 'Tuần $week · $from – $to';
  }

  @override
  String get weekTasksDone => 'Việc xong';

  @override
  String get weekHabitPercent => 'Thói quen';

  @override
  String get weekTodayRemaining => 'Còn hôm nay';

  @override
  String get weekProgress => 'Tiến độ';

  @override
  String get weekRange1 => '1 tuần';

  @override
  String get weekRange4 => '4 tuần';

  @override
  String get weekRange12 => '12 tuần';

  @override
  String get weekNote => 'Ghi chú tuần';

  @override
  String get weekNoteHint => 'Điều quan trọng nhất tuần này…';

  @override
  String get weekDeadlines => 'Hạn trong tuần';

  @override
  String get weekThis => 'Tuần này';

  @override
  String get weekPrev => 'Tuần trước';

  @override
  String get weekNext => 'Tuần sau';

  @override
  String get weekClear => 'Xoá dữ liệu tuần đang xem';

  @override
  String weekClearConfirm(String week) {
    return 'Xoá toàn bộ việc, dấu thói quen và ghi chú của tuần $week? Không hoàn tác được.';
  }

  @override
  String weekCleared(int tasks, int logs) {
    return 'Đã xoá $tasks việc, $logs dấu thói quen';
  }

  @override
  String get habitsTitle => 'Theo dõi thói quen';

  @override
  String get habitsMonthPercent => 'Hoàn thành tháng';

  @override
  String get habitsLongestStreak => 'Chuỗi dài nhất';

  @override
  String get habitsMostConsistent => 'Đều đặn nhất';

  @override
  String get habitsDaily => 'Mức hoàn thành theo ngày';

  @override
  String get habitsAdd => 'Thêm thói quen';

  @override
  String get habitsName => 'Tên thói quen';

  @override
  String get habitsEmpty => 'Chưa có thói quen. Thêm thói quen đầu tiên nhé.';

  @override
  String habitsDeleteConfirm(String name) {
    return 'Xoá thói quen \"$name\" và toàn bộ dấu tick?';
  }

  @override
  String habitsStreak(int count) {
    return 'Chuỗi $count ngày';
  }

  @override
  String daysCount(int count) {
    return '$count ngày';
  }

  @override
  String get goalsTitle => 'Mục tiêu & tầm nhìn';

  @override
  String get goalsAll => 'Tất cả';

  @override
  String goalsDone(int done, int total) {
    return '$done/$total mục tiêu hoàn thành';
  }

  @override
  String get goalsAdd => 'Thêm mục tiêu';

  @override
  String get goalsEmpty => 'Chưa có mục tiêu ở nhóm này.';

  @override
  String get goalsArea => 'Lĩnh vực';

  @override
  String get goalsStatus => 'Trạng thái';

  @override
  String get goalsStart => 'Bắt đầu';

  @override
  String get goalsDeadline => 'Hạn';

  @override
  String get goalsReward => 'Phần thưởng';

  @override
  String get goalsWhy => 'Vì sao quan trọng';

  @override
  String get goalsSteps => 'Các bước';

  @override
  String get goalsAddStep => 'Thêm bước';

  @override
  String get goalsStepDeadline => 'Hạn bước';

  @override
  String goalsDaysLeft(int count) {
    return 'Còn $count ngày';
  }

  @override
  String goalsOverdue(int count) {
    return 'Quá hạn $count ngày';
  }

  @override
  String get goalsBehind => 'Chậm kế hoạch';

  @override
  String goalsStepsProgress(int done, int total) {
    return '$done/$total bước';
  }

  @override
  String goalsDeleteConfirm(String name) {
    return 'Xoá mục tiêu \"$name\"?';
  }

  @override
  String get goalsRadar => 'Cân bằng các lĩnh vực';

  @override
  String get statusNotStarted => 'Chưa bắt đầu';

  @override
  String get statusInProgress => 'Đang làm';

  @override
  String get statusDone => 'Hoàn thành';

  @override
  String get areaHealth => 'Sức khoẻ';

  @override
  String get areaFinance => 'Tài chính';

  @override
  String get areaCareer => 'Sự nghiệp';

  @override
  String get areaGrowth => 'Phát triển bản thân';

  @override
  String get areaRelationship => 'Các mối quan hệ';

  @override
  String get areaLearning => 'Học tập';

  @override
  String get areaFamily => 'Gia đình';

  @override
  String get areaHobby => 'Sở thích';

  @override
  String get yearTitle => 'Kế hoạch năm';

  @override
  String get yearKeyword => 'Từ khoá của năm';

  @override
  String get yearKeywordHint => 'Một từ dẫn đường cho cả năm';

  @override
  String get yearVision => 'Tầm nhìn';

  @override
  String get yearVisionHint => 'Cuối năm nay bạn muốn mình ra sao?';

  @override
  String yearDone(int done, int total) {
    return '$done/$total việc trong năm';
  }

  @override
  String yearMonth(int month) {
    return 'Tháng $month';
  }

  @override
  String get yearAddItem => 'Thêm việc cho tháng';

  @override
  String get yearMonthEmpty => 'Chưa có việc.';

  @override
  String get yearDeadlines => 'Hạn';

  @override
  String get statsTitle => 'Thống kê';

  @override
  String get statsRange4w => '4 tuần';

  @override
  String get statsRange8w => '8 tuần';

  @override
  String get statsRange12w => '12 tuần';

  @override
  String get statsRange6m => '6 tháng';

  @override
  String get statsRange1y => '1 năm';

  @override
  String get statsCompletion => 'Tỉ lệ hoàn thành';

  @override
  String statsDelta(String delta) {
    return '$delta điểm so với kỳ trước';
  }

  @override
  String statsBestWeekday(String day) {
    return 'Ngày làm tốt nhất: $day';
  }

  @override
  String get statsTasksDone => 'Việc đã xong';

  @override
  String get statsActivityStreak => 'Chuỗi ngày hoạt động';

  @override
  String statsLongest(int count) {
    return 'dài nhất $count';
  }

  @override
  String get statsHabit => 'Thói quen';

  @override
  String get statsTrend => 'Xu hướng theo tuần';

  @override
  String get statsHeatmap => 'Lịch hoạt động';

  @override
  String get statsWeekday => 'Theo thứ trong tuần';

  @override
  String get statsHabits => 'Độ đều của thói quen';

  @override
  String get statsGoals => 'Mục tiêu';

  @override
  String statsAverage(int percent) {
    return 'Trung bình $percent%';
  }

  @override
  String get statsEmpty => 'Chưa có dữ liệu trong khoảng này.';

  @override
  String get habitsThisMonth => 'Tháng này';

  @override
  String get habitsRename => 'Đổi tên';

  @override
  String get moveUp => 'Chuyển lên';

  @override
  String get moveDown => 'Chuyển xuống';

  @override
  String get goalsName => 'Tên mục tiêu';

  @override
  String get goalsClearDeadline => 'Bỏ hạn';

  @override
  String get goalsDeadlineBeforeStart => 'Hạn phải sau ngày bắt đầu.';

  @override
  String get yearThisYear => 'Năm nay';

  @override
  String get yearProgress => 'Tiến độ theo tháng';

  @override
  String get yearCurrentMonth => 'Tháng này';
}
