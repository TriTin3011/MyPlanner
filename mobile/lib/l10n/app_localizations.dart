import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'Mầm'**
  String get appName;

  /// No description provided for @navToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get navToday;

  /// No description provided for @navGoals.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get navGoals;

  /// No description provided for @navHabits.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen'**
  String get navHabits;

  /// No description provided for @navWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần'**
  String get navWeek;

  /// No description provided for @navYear.
  ///
  /// In vi, this message translates to:
  /// **'Năm'**
  String get navYear;

  /// No description provided for @navStats.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get navStats;

  /// No description provided for @navMore.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get navMore;

  /// No description provided for @themeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bộ màu'**
  String get themeLabel;

  /// No description provided for @themeForest.
  ///
  /// In vi, this message translates to:
  /// **'Rừng xanh'**
  String get themeForest;

  /// No description provided for @themeOcean.
  ///
  /// In vi, this message translates to:
  /// **'Biển đêm'**
  String get themeOcean;

  /// No description provided for @themeSunset.
  ///
  /// In vi, this message translates to:
  /// **'Hoàng hôn'**
  String get themeSunset;

  /// No description provided for @themeLavender.
  ///
  /// In vi, this message translates to:
  /// **'Oải hương'**
  String get themeLavender;

  /// No description provided for @themeNight.
  ///
  /// In vi, this message translates to:
  /// **'Đêm'**
  String get themeNight;

  /// No description provided for @languageLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get languageLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @authTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get authTitle;

  /// No description provided for @authSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch của bạn đang chờ ở đây.'**
  String get authSubtitle;

  /// No description provided for @authUserName.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập'**
  String get authUserName;

  /// No description provided for @authPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get authPassword;

  /// No description provided for @authShowPassword.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get authHidePassword;

  /// No description provided for @authSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get authSubmit;

  /// No description provided for @authLogout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get authLogout;

  /// No description provided for @authAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get authAccount;

  /// No description provided for @authProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get authProfile;

  /// No description provided for @authDisplayName.
  ///
  /// In vi, this message translates to:
  /// **'Tên hiển thị'**
  String get authDisplayName;

  /// No description provided for @authDisplayNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Để trống để dùng lại tên đăng nhập. Tối đa 50 ký tự.'**
  String get authDisplayNameHint;

  /// No description provided for @authLoginName.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập: {name}'**
  String authLoginName(String name);

  /// No description provided for @authRegisterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu gieo kế hoạch của riêng bạn.'**
  String get authRegisterSubtitle;

  /// No description provided for @authRegisterSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get authRegisterSubmit;

  /// No description provided for @authUserNameHint.
  ///
  /// In vi, this message translates to:
  /// **'3–64 ký tự: chữ không dấu, số, dấu chấm, gạch ngang, gạch dưới.'**
  String get authUserNameHint;

  /// No description provided for @authPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất {count} ký tự.'**
  String authPasswordHint(int count);

  /// No description provided for @authNoAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get authNoAccount;

  /// No description provided for @authGoToRegister.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get authGoToRegister;

  /// No description provided for @authHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get authHaveAccount;

  /// No description provided for @authGoToLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get authGoToLogin;

  /// No description provided for @authOr.
  ///
  /// In vi, this message translates to:
  /// **'hoặc'**
  String get authOr;

  /// No description provided for @authGoogleContinue.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng Google'**
  String get authGoogleContinue;

  /// No description provided for @authGoogleUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Bản này chưa cấu hình đăng nhập Google.'**
  String get authGoogleUnavailable;

  /// No description provided for @authSessionExpired.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập đã hết hạn, hãy đăng nhập lại.'**
  String get authSessionExpired;

  /// No description provided for @authAddPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ảnh'**
  String get authAddPhoto;

  /// No description provided for @authChangePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh'**
  String get authChangePhoto;

  /// No description provided for @authRemovePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Xoá ảnh'**
  String get authRemovePhoto;

  /// No description provided for @authTakePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get authTakePhoto;

  /// No description provided for @authPhotoHint.
  ///
  /// In vi, this message translates to:
  /// **'JPG, PNG hoặc WebP, tối đa 5 MB'**
  String get authPhotoHint;

  /// No description provided for @authPhotoTooLarge.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh tối đa 5 MB.'**
  String get authPhotoTooLarge;

  /// No description provided for @errorNetwork.
  ///
  /// In vi, this message translates to:
  /// **'Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại.'**
  String get errorNetwork;

  /// No description provided for @errorUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra. Thử lại sau nhé.'**
  String get errorUnknown;

  /// No description provided for @errorTooMany.
  ///
  /// In vi, this message translates to:
  /// **'Bạn thử quá nhiều lần. Đợi {seconds} giây rồi thử lại.'**
  String errorTooMany(int seconds);

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @done.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get done;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @saved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get saved;

  /// No description provided for @saving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu…'**
  String get saving;

  /// No description provided for @chartLine.
  ///
  /// In vi, this message translates to:
  /// **'Đường'**
  String get chartLine;

  /// No description provided for @chartBar.
  ///
  /// In vi, this message translates to:
  /// **'Cột'**
  String get chartBar;

  /// No description provided for @chartTable.
  ///
  /// In vi, this message translates to:
  /// **'Bảng'**
  String get chartTable;

  /// No description provided for @todayGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào {name}!'**
  String todayGreeting(String name);

  /// No description provided for @todayProgress.
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} việc · {habitsDone}/{habitsTotal} thói quen'**
  String todayProgress(int done, int total, int habitsDone, int habitsTotal);

  /// No description provided for @todayTasks.
  ///
  /// In vi, this message translates to:
  /// **'Việc hôm nay'**
  String get todayTasks;

  /// No description provided for @todayTasksEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có việc nào. Thêm một việc nhỏ để bắt đầu nhé.'**
  String get todayTasksEmpty;

  /// No description provided for @todayAddTask.
  ///
  /// In vi, this message translates to:
  /// **'Thêm việc'**
  String get todayAddTask;

  /// No description provided for @todayTaskHint.
  ///
  /// In vi, this message translates to:
  /// **'Việc cần làm…'**
  String get todayTaskHint;

  /// No description provided for @todayHabits.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen'**
  String get todayHabits;

  /// No description provided for @todayHabitsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thói quen. Thêm ở tab Thói quen.'**
  String get todayHabitsEmpty;

  /// No description provided for @todayNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get todayNote;

  /// No description provided for @todayNoteHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết vài dòng cho hôm nay…'**
  String get todayNoteHint;

  /// No description provided for @todayBacklog.
  ///
  /// In vi, this message translates to:
  /// **'Việc còn tồn'**
  String get todayBacklog;

  /// No description provided for @todayBacklogMove.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển hết sang hôm nay'**
  String get todayBacklogMove;

  /// No description provided for @todayBacklogMoved.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển {count} việc sang hôm nay'**
  String todayBacklogMoved(int count);

  /// No description provided for @todayCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Lên kế hoạch'**
  String get todayCalendar;

  /// No description provided for @todayCalendarMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get todayCalendarMonth;

  /// No description provided for @todayCalendarWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần'**
  String get todayCalendarWeek;

  /// No description provided for @todayRecent.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ gần đây'**
  String get todayRecent;

  /// No description provided for @todayRecurring.
  ///
  /// In vi, this message translates to:
  /// **'Việc lặp lại'**
  String get todayRecurring;

  /// No description provided for @tagUrgent.
  ///
  /// In vi, this message translates to:
  /// **'Gấp'**
  String get tagUrgent;

  /// No description provided for @tagImportant.
  ///
  /// In vi, this message translates to:
  /// **'Quan trọng'**
  String get tagImportant;

  /// No description provided for @taskEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa việc'**
  String get taskEdit;

  /// No description provided for @taskTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tên việc'**
  String get taskTitle;

  /// No description provided for @taskDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get taskDate;

  /// No description provided for @taskTags.
  ///
  /// In vi, this message translates to:
  /// **'Nhãn'**
  String get taskTags;

  /// No description provided for @taskSubtasks.
  ///
  /// In vi, this message translates to:
  /// **'Việc con'**
  String get taskSubtasks;

  /// No description provided for @taskAddSubtask.
  ///
  /// In vi, this message translates to:
  /// **'Thêm việc con'**
  String get taskAddSubtask;

  /// No description provided for @taskMoveDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày khác'**
  String get taskMoveDate;

  /// No description provided for @taskMoveToday.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển sang hôm nay'**
  String get taskMoveToday;

  /// No description provided for @taskDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xoá việc'**
  String get taskDelete;

  /// No description provided for @taskDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá việc'**
  String get taskDeleted;

  /// No description provided for @taskLate.
  ///
  /// In vi, this message translates to:
  /// **'Từ {date}'**
  String taskLate(String date);

  /// No description provided for @dayTasksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Việc ngày {date}'**
  String dayTasksTitle(String date);

  /// No description provided for @reorderHint.
  ///
  /// In vi, this message translates to:
  /// **'Giữ và kéo để sắp xếp'**
  String get reorderHint;

  /// No description provided for @recurringTitle.
  ///
  /// In vi, this message translates to:
  /// **'Việc lặp lại'**
  String get recurringTitle;

  /// No description provided for @recurringEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có việc lặp lại.'**
  String get recurringEmpty;

  /// No description provided for @recurringAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm việc lặp lại'**
  String get recurringAdd;

  /// No description provided for @recurringWeekdays.
  ///
  /// In vi, this message translates to:
  /// **'Lặp vào'**
  String get recurringWeekdays;

  /// No description provided for @recurringActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật'**
  String get recurringActive;

  /// No description provided for @recurringStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu từ'**
  String get recurringStart;

  /// No description provided for @recurringEveryday.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi ngày'**
  String get recurringEveryday;

  /// No description provided for @weekdayShort1.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get weekdayShort1;

  /// No description provided for @weekdayShort2.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get weekdayShort2;

  /// No description provided for @weekdayShort3.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get weekdayShort3;

  /// No description provided for @weekdayShort4.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get weekdayShort4;

  /// No description provided for @weekdayShort5.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get weekdayShort5;

  /// No description provided for @weekdayShort6.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get weekdayShort6;

  /// No description provided for @weekdayShort7.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get weekdayShort7;

  /// No description provided for @weekTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch tuần'**
  String get weekTitle;

  /// No description provided for @weekRange.
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week} · {from} – {to}'**
  String weekRange(int week, String from, String to);

  /// No description provided for @weekTasksDone.
  ///
  /// In vi, this message translates to:
  /// **'Việc xong'**
  String get weekTasksDone;

  /// No description provided for @weekHabitPercent.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen'**
  String get weekHabitPercent;

  /// No description provided for @weekTodayRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn hôm nay'**
  String get weekTodayRemaining;

  /// No description provided for @weekProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get weekProgress;

  /// No description provided for @weekRange1.
  ///
  /// In vi, this message translates to:
  /// **'1 tuần'**
  String get weekRange1;

  /// No description provided for @weekRange4.
  ///
  /// In vi, this message translates to:
  /// **'4 tuần'**
  String get weekRange4;

  /// No description provided for @weekRange12.
  ///
  /// In vi, this message translates to:
  /// **'12 tuần'**
  String get weekRange12;

  /// No description provided for @weekNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú tuần'**
  String get weekNote;

  /// No description provided for @weekNoteHint.
  ///
  /// In vi, this message translates to:
  /// **'Điều quan trọng nhất tuần này…'**
  String get weekNoteHint;

  /// No description provided for @weekDeadlines.
  ///
  /// In vi, this message translates to:
  /// **'Hạn trong tuần'**
  String get weekDeadlines;

  /// No description provided for @weekThis.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get weekThis;

  /// No description provided for @weekPrev.
  ///
  /// In vi, this message translates to:
  /// **'Tuần trước'**
  String get weekPrev;

  /// No description provided for @weekNext.
  ///
  /// In vi, this message translates to:
  /// **'Tuần sau'**
  String get weekNext;

  /// No description provided for @weekClear.
  ///
  /// In vi, this message translates to:
  /// **'Xoá dữ liệu tuần đang xem'**
  String get weekClear;

  /// No description provided for @weekClearConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xoá toàn bộ việc, dấu thói quen và ghi chú của tuần {week}? Không hoàn tác được.'**
  String weekClearConfirm(String week);

  /// No description provided for @weekCleared.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá {tasks} việc, {logs} dấu thói quen'**
  String weekCleared(int tasks, int logs);

  /// No description provided for @habitsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi thói quen'**
  String get habitsTitle;

  /// No description provided for @habitsMonthPercent.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành tháng'**
  String get habitsMonthPercent;

  /// No description provided for @habitsLongestStreak.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi dài nhất'**
  String get habitsLongestStreak;

  /// No description provided for @habitsMostConsistent.
  ///
  /// In vi, this message translates to:
  /// **'Đều đặn nhất'**
  String get habitsMostConsistent;

  /// No description provided for @habitsDaily.
  ///
  /// In vi, this message translates to:
  /// **'Mức hoàn thành theo ngày'**
  String get habitsDaily;

  /// No description provided for @habitsAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thói quen'**
  String get habitsAdd;

  /// No description provided for @habitsName.
  ///
  /// In vi, this message translates to:
  /// **'Tên thói quen'**
  String get habitsName;

  /// No description provided for @habitsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thói quen. Thêm thói quen đầu tiên nhé.'**
  String get habitsEmpty;

  /// No description provided for @habitsDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xoá thói quen \"{name}\" và toàn bộ dấu tick?'**
  String habitsDeleteConfirm(String name);

  /// No description provided for @habitsStreak.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi {count} ngày'**
  String habitsStreak(int count);

  /// No description provided for @daysCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày'**
  String daysCount(int count);

  /// No description provided for @goalsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu & tầm nhìn'**
  String get goalsTitle;

  /// No description provided for @goalsAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get goalsAll;

  /// No description provided for @goalsDone.
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} mục tiêu hoàn thành'**
  String goalsDone(int done, int total);

  /// No description provided for @goalsAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm mục tiêu'**
  String get goalsAdd;

  /// No description provided for @goalsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có mục tiêu ở nhóm này.'**
  String get goalsEmpty;

  /// No description provided for @goalsArea.
  ///
  /// In vi, this message translates to:
  /// **'Lĩnh vực'**
  String get goalsArea;

  /// No description provided for @goalsStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get goalsStatus;

  /// No description provided for @goalsStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get goalsStart;

  /// No description provided for @goalsDeadline.
  ///
  /// In vi, this message translates to:
  /// **'Hạn'**
  String get goalsDeadline;

  /// No description provided for @goalsReward.
  ///
  /// In vi, this message translates to:
  /// **'Phần thưởng'**
  String get goalsReward;

  /// No description provided for @goalsWhy.
  ///
  /// In vi, this message translates to:
  /// **'Vì sao quan trọng'**
  String get goalsWhy;

  /// No description provided for @goalsSteps.
  ///
  /// In vi, this message translates to:
  /// **'Các bước'**
  String get goalsSteps;

  /// No description provided for @goalsAddStep.
  ///
  /// In vi, this message translates to:
  /// **'Thêm bước'**
  String get goalsAddStep;

  /// No description provided for @goalsStepDeadline.
  ///
  /// In vi, this message translates to:
  /// **'Hạn bước'**
  String get goalsStepDeadline;

  /// No description provided for @goalsDaysLeft.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} ngày'**
  String goalsDaysLeft(int count);

  /// No description provided for @goalsOverdue.
  ///
  /// In vi, this message translates to:
  /// **'Quá hạn {count} ngày'**
  String goalsOverdue(int count);

  /// No description provided for @goalsBehind.
  ///
  /// In vi, this message translates to:
  /// **'Chậm kế hoạch'**
  String get goalsBehind;

  /// No description provided for @goalsStepsProgress.
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} bước'**
  String goalsStepsProgress(int done, int total);

  /// No description provided for @goalsDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xoá mục tiêu \"{name}\"?'**
  String goalsDeleteConfirm(String name);

  /// No description provided for @goalsRadar.
  ///
  /// In vi, this message translates to:
  /// **'Cân bằng các lĩnh vực'**
  String get goalsRadar;

  /// No description provided for @statusNotStarted.
  ///
  /// In vi, this message translates to:
  /// **'Chưa bắt đầu'**
  String get statusNotStarted;

  /// No description provided for @statusInProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đang làm'**
  String get statusInProgress;

  /// No description provided for @statusDone.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get statusDone;

  /// No description provided for @areaHealth.
  ///
  /// In vi, this message translates to:
  /// **'Sức khoẻ'**
  String get areaHealth;

  /// No description provided for @areaFinance.
  ///
  /// In vi, this message translates to:
  /// **'Tài chính'**
  String get areaFinance;

  /// No description provided for @areaCareer.
  ///
  /// In vi, this message translates to:
  /// **'Sự nghiệp'**
  String get areaCareer;

  /// No description provided for @areaGrowth.
  ///
  /// In vi, this message translates to:
  /// **'Phát triển bản thân'**
  String get areaGrowth;

  /// No description provided for @areaRelationship.
  ///
  /// In vi, this message translates to:
  /// **'Các mối quan hệ'**
  String get areaRelationship;

  /// No description provided for @areaLearning.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get areaLearning;

  /// No description provided for @areaFamily.
  ///
  /// In vi, this message translates to:
  /// **'Gia đình'**
  String get areaFamily;

  /// No description provided for @areaHobby.
  ///
  /// In vi, this message translates to:
  /// **'Sở thích'**
  String get areaHobby;

  /// No description provided for @yearTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch năm'**
  String get yearTitle;

  /// No description provided for @yearKeyword.
  ///
  /// In vi, this message translates to:
  /// **'Từ khoá của năm'**
  String get yearKeyword;

  /// No description provided for @yearKeywordHint.
  ///
  /// In vi, this message translates to:
  /// **'Một từ dẫn đường cho cả năm'**
  String get yearKeywordHint;

  /// No description provided for @yearVision.
  ///
  /// In vi, this message translates to:
  /// **'Tầm nhìn'**
  String get yearVision;

  /// No description provided for @yearVisionHint.
  ///
  /// In vi, this message translates to:
  /// **'Cuối năm nay bạn muốn mình ra sao?'**
  String get yearVisionHint;

  /// No description provided for @yearDone.
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} việc trong năm'**
  String yearDone(int done, int total);

  /// No description provided for @yearMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}'**
  String yearMonth(int month);

  /// No description provided for @yearAddItem.
  ///
  /// In vi, this message translates to:
  /// **'Thêm việc cho tháng'**
  String get yearAddItem;

  /// No description provided for @yearMonthEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có việc.'**
  String get yearMonthEmpty;

  /// No description provided for @yearDeadlines.
  ///
  /// In vi, this message translates to:
  /// **'Hạn'**
  String get yearDeadlines;

  /// No description provided for @statsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get statsTitle;

  /// No description provided for @statsRange4w.
  ///
  /// In vi, this message translates to:
  /// **'4 tuần'**
  String get statsRange4w;

  /// No description provided for @statsRange8w.
  ///
  /// In vi, this message translates to:
  /// **'8 tuần'**
  String get statsRange8w;

  /// No description provided for @statsRange12w.
  ///
  /// In vi, this message translates to:
  /// **'12 tuần'**
  String get statsRange12w;

  /// No description provided for @statsRange6m.
  ///
  /// In vi, this message translates to:
  /// **'6 tháng'**
  String get statsRange6m;

  /// No description provided for @statsRange1y.
  ///
  /// In vi, this message translates to:
  /// **'1 năm'**
  String get statsRange1y;

  /// No description provided for @statsCompletion.
  ///
  /// In vi, this message translates to:
  /// **'Tỉ lệ hoàn thành'**
  String get statsCompletion;

  /// No description provided for @statsDelta.
  ///
  /// In vi, this message translates to:
  /// **'{delta} điểm so với kỳ trước'**
  String statsDelta(String delta);

  /// No description provided for @statsBestWeekday.
  ///
  /// In vi, this message translates to:
  /// **'Ngày làm tốt nhất: {day}'**
  String statsBestWeekday(String day);

  /// No description provided for @statsTasksDone.
  ///
  /// In vi, this message translates to:
  /// **'Việc đã xong'**
  String get statsTasksDone;

  /// No description provided for @statsActivityStreak.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi ngày hoạt động'**
  String get statsActivityStreak;

  /// No description provided for @statsLongest.
  ///
  /// In vi, this message translates to:
  /// **'dài nhất {count}'**
  String statsLongest(int count);

  /// No description provided for @statsHabit.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen'**
  String get statsHabit;

  /// No description provided for @statsTrend.
  ///
  /// In vi, this message translates to:
  /// **'Xu hướng theo tuần'**
  String get statsTrend;

  /// No description provided for @statsHeatmap.
  ///
  /// In vi, this message translates to:
  /// **'Lịch hoạt động'**
  String get statsHeatmap;

  /// No description provided for @statsWeekday.
  ///
  /// In vi, this message translates to:
  /// **'Theo thứ trong tuần'**
  String get statsWeekday;

  /// No description provided for @statsHabits.
  ///
  /// In vi, this message translates to:
  /// **'Độ đều của thói quen'**
  String get statsHabits;

  /// No description provided for @statsGoals.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get statsGoals;

  /// No description provided for @statsAverage.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình {percent}%'**
  String statsAverage(int percent);

  /// No description provided for @statsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu trong khoảng này.'**
  String get statsEmpty;

  /// No description provided for @habitsThisMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng này'**
  String get habitsThisMonth;

  /// No description provided for @habitsRename.
  ///
  /// In vi, this message translates to:
  /// **'Đổi tên'**
  String get habitsRename;

  /// No description provided for @moveUp.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển lên'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển xuống'**
  String get moveDown;

  /// No description provided for @goalsName.
  ///
  /// In vi, this message translates to:
  /// **'Tên mục tiêu'**
  String get goalsName;

  /// No description provided for @goalsClearDeadline.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ hạn'**
  String get goalsClearDeadline;

  /// No description provided for @goalsDeadlineBeforeStart.
  ///
  /// In vi, this message translates to:
  /// **'Hạn phải sau ngày bắt đầu.'**
  String get goalsDeadlineBeforeStart;

  /// No description provided for @yearThisYear.
  ///
  /// In vi, this message translates to:
  /// **'Năm nay'**
  String get yearThisYear;

  /// No description provided for @yearProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ theo tháng'**
  String get yearProgress;

  /// No description provided for @yearCurrentMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng này'**
  String get yearCurrentMonth;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
