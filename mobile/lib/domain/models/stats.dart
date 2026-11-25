import 'package:freezed_annotation/freezed_annotation.dart';

import '../values/calendar_date.dart';
import '../values/week_key.dart';
import 'goal.dart';

part 'stats.freezed.dart';

/// Các khoảng backend chấp nhận (`StatsCalculator.IsSupportedRange`).
enum StatsRange {
  w4('4w'),
  w8('8w'),
  w12('12w'),
  m6('6m'),
  y1('1y');

  const StatsRange(this.code);
  final String code;
}

@freezed
abstract class StatsWeekPoint with _$StatsWeekPoint {
  const factory StatsWeekPoint({
    required WeekKey weekKey,
    required CalendarDate monday,
    required int done,
    required int total,
    required int percent,
  }) = _StatsWeekPoint;
}

@freezed
abstract class StatsHero with _$StatsHero {
  const factory StatsHero({
    required int completionPercent,
    required int tasksDone,
    required int tasksTotal,
    required int deltaPoints,
    /// 1 = Thứ 2 … 7 = Chủ nhật.
    int? bestWeekday,
    required List<StatsWeekPoint> weeklySparkline,
  }) = _StatsHero;
}

@freezed
abstract class StatsKpis with _$StatsKpis {
  const factory StatsKpis({
    required int tasksDone,
    int? tasksDonePercentChange,
    required int activityCurrentStreak,
    required int activityLongestStreak,
    required int habitPercent,
    required int habitDeltaPoints,
  }) = _StatsKpis;
}

@freezed
abstract class StatsHeatmapDay with _$StatsHeatmapDay {
  const factory StatsHeatmapDay({
    required CalendarDate date,
    required int done,
    /// 0–4, backend chia mức.
    required int level,
  }) = _StatsHeatmapDay;
}

@freezed
abstract class StatsWeekday with _$StatsWeekday {
  const factory StatsWeekday({
    required int weekday,
    required double averageDone,
  }) = _StatsWeekday;
}

@freezed
abstract class StatsHabit with _$StatsHabit {
  const factory StatsHabit({
    required String habitId,
    required String title,
    required int percent,
    required int doneDays,
    required int possibleDays,
    required int currentStreak,
    required int longestStreak,
  }) = _StatsHabit;
}

@freezed
abstract class StatsGoalArea with _$StatsGoalArea {
  const factory StatsGoalArea({
    required LifeArea area,
    required int done,
    required int total,
  }) = _StatsGoalArea;
}

@freezed
abstract class StatsGoals with _$StatsGoals {
  const factory StatsGoals({
    required int total,
    required int percentDone,
    required int notStarted,
    required int inProgress,
    required int done,
    required List<StatsGoalArea> byArea,
  }) = _StatsGoals;
}

@freezed
abstract class Stats with _$Stats {
  const factory Stats({
    required StatsRange range,
    required CalendarDate from,
    required CalendarDate to,
    required StatsHero hero,
    required StatsKpis kpis,
    required int trendAverage,
    required List<StatsWeekPoint> trend,
    required List<StatsHeatmapDay> heatmap,
    required List<StatsWeekday> weekdays,
    required List<StatsHabit> habits,
    required StatsGoals goals,
  }) = _Stats;
}
