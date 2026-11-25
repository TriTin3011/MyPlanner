import 'package:freezed_annotation/freezed_annotation.dart';

import '../values/calendar_date.dart';

part 'habit.freezed.dart';

@freezed
abstract class HabitHighlight with _$HabitHighlight {
  const factory HabitHighlight({
    required String habitId,
    required String title,
    required int value,
  }) = _HabitHighlight;
}

/// Một dòng của lưới thói quen trong tháng.
@freezed
abstract class HabitRow with _$HabitRow {
  const factory HabitRow({
    required String id,
    required String title,
    required int order,
    required CalendarDate startDate,
    required int percent,
    required int currentStreak,
    required int longestStreak,
    required Set<CalendarDate> doneDates,
  }) = _HabitRow;
}

/// Số thói quen đã làm trong một ngày. Ngày tương lai: `percent == null`.
@freezed
abstract class HabitDayCount with _$HabitDayCount {
  const factory HabitDayCount({
    required CalendarDate date,
    int? done,
    int? total,
    int? percent,
  }) = _HabitDayCount;
}

@freezed
abstract class HabitMonth with _$HabitMonth {
  const factory HabitMonth({
    /// `YYYY-MM`.
    required String month,
    required CalendarDate from,
    required CalendarDate to,
    required int percent,
    HabitHighlight? longestStreak,
    HabitHighlight? mostConsistent,
    required List<HabitRow> habits,
    required List<HabitDayCount> days,
  }) = _HabitMonth;
}
