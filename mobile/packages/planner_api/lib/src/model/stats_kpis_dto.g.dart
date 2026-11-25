// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_kpis_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsKpisDtoCWProxy {
  StatsKpisDto tasksDone(int tasksDone);

  StatsKpisDto tasksDonePercentChange(int? tasksDonePercentChange);

  StatsKpisDto activityCurrentStreak(int activityCurrentStreak);

  StatsKpisDto activityLongestStreak(int activityLongestStreak);

  StatsKpisDto habitPercent(int habitPercent);

  StatsKpisDto habitDeltaPoints(int habitDeltaPoints);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsKpisDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsKpisDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsKpisDto call({
    int tasksDone,
    int? tasksDonePercentChange,
    int activityCurrentStreak,
    int activityLongestStreak,
    int habitPercent,
    int habitDeltaPoints,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsKpisDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsKpisDto.copyWith.fieldName(...)`
class _$StatsKpisDtoCWProxyImpl implements _$StatsKpisDtoCWProxy {
  const _$StatsKpisDtoCWProxyImpl(this._value);

  final StatsKpisDto _value;

  @override
  StatsKpisDto tasksDone(int tasksDone) => this(tasksDone: tasksDone);

  @override
  StatsKpisDto tasksDonePercentChange(int? tasksDonePercentChange) =>
      this(tasksDonePercentChange: tasksDonePercentChange);

  @override
  StatsKpisDto activityCurrentStreak(int activityCurrentStreak) =>
      this(activityCurrentStreak: activityCurrentStreak);

  @override
  StatsKpisDto activityLongestStreak(int activityLongestStreak) =>
      this(activityLongestStreak: activityLongestStreak);

  @override
  StatsKpisDto habitPercent(int habitPercent) =>
      this(habitPercent: habitPercent);

  @override
  StatsKpisDto habitDeltaPoints(int habitDeltaPoints) =>
      this(habitDeltaPoints: habitDeltaPoints);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsKpisDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsKpisDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsKpisDto call({
    Object? tasksDone = const $CopyWithPlaceholder(),
    Object? tasksDonePercentChange = const $CopyWithPlaceholder(),
    Object? activityCurrentStreak = const $CopyWithPlaceholder(),
    Object? activityLongestStreak = const $CopyWithPlaceholder(),
    Object? habitPercent = const $CopyWithPlaceholder(),
    Object? habitDeltaPoints = const $CopyWithPlaceholder(),
  }) {
    return StatsKpisDto(
      tasksDone: tasksDone == const $CopyWithPlaceholder()
          ? _value.tasksDone
          // ignore: cast_nullable_to_non_nullable
          : tasksDone as int,
      tasksDonePercentChange:
          tasksDonePercentChange == const $CopyWithPlaceholder()
          ? _value.tasksDonePercentChange
          // ignore: cast_nullable_to_non_nullable
          : tasksDonePercentChange as int?,
      activityCurrentStreak:
          activityCurrentStreak == const $CopyWithPlaceholder()
          ? _value.activityCurrentStreak
          // ignore: cast_nullable_to_non_nullable
          : activityCurrentStreak as int,
      activityLongestStreak:
          activityLongestStreak == const $CopyWithPlaceholder()
          ? _value.activityLongestStreak
          // ignore: cast_nullable_to_non_nullable
          : activityLongestStreak as int,
      habitPercent: habitPercent == const $CopyWithPlaceholder()
          ? _value.habitPercent
          // ignore: cast_nullable_to_non_nullable
          : habitPercent as int,
      habitDeltaPoints: habitDeltaPoints == const $CopyWithPlaceholder()
          ? _value.habitDeltaPoints
          // ignore: cast_nullable_to_non_nullable
          : habitDeltaPoints as int,
    );
  }
}

extension $StatsKpisDtoCopyWith on StatsKpisDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsKpisDto.copyWith(...)` or like so:`instanceOfStatsKpisDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsKpisDtoCWProxy get copyWith => _$StatsKpisDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsKpisDto _$StatsKpisDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsKpisDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'tasksDone',
          'tasksDonePercentChange',
          'activityCurrentStreak',
          'activityLongestStreak',
          'habitPercent',
          'habitDeltaPoints',
        ],
      );
      final val = StatsKpisDto(
        tasksDone: $checkedConvert('tasksDone', (v) => (v as num).toInt()),
        tasksDonePercentChange: $checkedConvert(
          'tasksDonePercentChange',
          (v) => (v as num?)?.toInt(),
        ),
        activityCurrentStreak: $checkedConvert(
          'activityCurrentStreak',
          (v) => (v as num).toInt(),
        ),
        activityLongestStreak: $checkedConvert(
          'activityLongestStreak',
          (v) => (v as num).toInt(),
        ),
        habitPercent: $checkedConvert(
          'habitPercent',
          (v) => (v as num).toInt(),
        ),
        habitDeltaPoints: $checkedConvert(
          'habitDeltaPoints',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StatsKpisDtoToJson(StatsKpisDto instance) =>
    <String, dynamic>{
      'tasksDone': instance.tasksDone,
      'tasksDonePercentChange': instance.tasksDonePercentChange,
      'activityCurrentStreak': instance.activityCurrentStreak,
      'activityLongestStreak': instance.activityLongestStreak,
      'habitPercent': instance.habitPercent,
      'habitDeltaPoints': instance.habitDeltaPoints,
    };
