import 'package:freezed_annotation/freezed_annotation.dart';

import '../values/calendar_date.dart';
import '../values/week_key.dart';
import 'task.dart';

part 'week.freezed.dart';

@freezed
abstract class WeekDashboard with _$WeekDashboard {
  const factory WeekDashboard({
    required WeekKey weekKey,
    required CalendarDate from,
    required CalendarDate to,
    required int tasksDone,
    required int tasksTotal,
    required int habitPercent,
    required int todayRemaining,
    required String comment,
    required List<DayProgress> days,
    @Default([]) List<String> insights,
  }) = _WeekDashboard;
}

/// Một điểm của biểu đồ 12 tuần (`dashboard/weeks`).
@freezed
abstract class WeekProgress with _$WeekProgress {
  const factory WeekProgress({
    required WeekKey weekKey,
    required CalendarDate monday,
    required int tasksDone,
    required int tasksTotal,
    required int percent,
  }) = _WeekProgress;
}

enum DeadlineKind { step, goal }

/// Hạn của bước hoặc mục tiêu, hiện ở Tuần, lịch Hôm nay và Năm.
@freezed
abstract class Deadline with _$Deadline {
  const factory Deadline({
    required CalendarDate date,
    required DeadlineKind kind,
    required String goalId,
    required String goalTitle,
    required String title,
    required bool done,
    required bool overdue,
  }) = _Deadline;
}

@freezed
abstract class WeekDeleteResult with _$WeekDeleteResult {
  const factory WeekDeleteResult({
    required int tasks,
    required int habitLogs,
    required int notes,
  }) = _WeekDeleteResult;
}
