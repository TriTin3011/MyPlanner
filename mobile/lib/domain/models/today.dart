import 'package:freezed_annotation/freezed_annotation.dart';

import '../values/calendar_date.dart';
import 'task.dart';

part 'today.freezed.dart';

@freezed
abstract class TodayHabit with _$TodayHabit {
  const factory TodayHabit({
    required String id,
    required String title,
    required bool done,
  }) = _TodayHabit;
}

/// Màn Hôm nay. `percent` và các con số đếm do backend tính.
@freezed
abstract class TodayDashboard with _$TodayDashboard {
  const factory TodayDashboard({
    required CalendarDate date,
    required int percent,
    required int tasksDone,
    required int tasksTotal,
    required int habitsDone,
    required int habitsTotal,
    required List<Task> tasks,
    required List<Task> backlog,
    required List<TodayHabit> habits,
    @Default('') String note,
  }) = _TodayDashboard;
}
