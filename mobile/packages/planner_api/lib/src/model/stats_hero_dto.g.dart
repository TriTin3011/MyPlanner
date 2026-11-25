// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_hero_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatsHeroDtoCWProxy {
  StatsHeroDto completionPercent(int completionPercent);

  StatsHeroDto tasksDone(int tasksDone);

  StatsHeroDto tasksTotal(int tasksTotal);

  StatsHeroDto deltaPoints(int deltaPoints);

  StatsHeroDto bestWeekday(int? bestWeekday);

  StatsHeroDto weeklySparkline(List<StatsWeekPointDto> weeklySparkline);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsHeroDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsHeroDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsHeroDto call({
    int completionPercent,
    int tasksDone,
    int tasksTotal,
    int deltaPoints,
    int? bestWeekday,
    List<StatsWeekPointDto> weeklySparkline,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStatsHeroDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStatsHeroDto.copyWith.fieldName(...)`
class _$StatsHeroDtoCWProxyImpl implements _$StatsHeroDtoCWProxy {
  const _$StatsHeroDtoCWProxyImpl(this._value);

  final StatsHeroDto _value;

  @override
  StatsHeroDto completionPercent(int completionPercent) =>
      this(completionPercent: completionPercent);

  @override
  StatsHeroDto tasksDone(int tasksDone) => this(tasksDone: tasksDone);

  @override
  StatsHeroDto tasksTotal(int tasksTotal) => this(tasksTotal: tasksTotal);

  @override
  StatsHeroDto deltaPoints(int deltaPoints) => this(deltaPoints: deltaPoints);

  @override
  StatsHeroDto bestWeekday(int? bestWeekday) => this(bestWeekday: bestWeekday);

  @override
  StatsHeroDto weeklySparkline(List<StatsWeekPointDto> weeklySparkline) =>
      this(weeklySparkline: weeklySparkline);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StatsHeroDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StatsHeroDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StatsHeroDto call({
    Object? completionPercent = const $CopyWithPlaceholder(),
    Object? tasksDone = const $CopyWithPlaceholder(),
    Object? tasksTotal = const $CopyWithPlaceholder(),
    Object? deltaPoints = const $CopyWithPlaceholder(),
    Object? bestWeekday = const $CopyWithPlaceholder(),
    Object? weeklySparkline = const $CopyWithPlaceholder(),
  }) {
    return StatsHeroDto(
      completionPercent: completionPercent == const $CopyWithPlaceholder()
          ? _value.completionPercent
          // ignore: cast_nullable_to_non_nullable
          : completionPercent as int,
      tasksDone: tasksDone == const $CopyWithPlaceholder()
          ? _value.tasksDone
          // ignore: cast_nullable_to_non_nullable
          : tasksDone as int,
      tasksTotal: tasksTotal == const $CopyWithPlaceholder()
          ? _value.tasksTotal
          // ignore: cast_nullable_to_non_nullable
          : tasksTotal as int,
      deltaPoints: deltaPoints == const $CopyWithPlaceholder()
          ? _value.deltaPoints
          // ignore: cast_nullable_to_non_nullable
          : deltaPoints as int,
      bestWeekday: bestWeekday == const $CopyWithPlaceholder()
          ? _value.bestWeekday
          // ignore: cast_nullable_to_non_nullable
          : bestWeekday as int?,
      weeklySparkline: weeklySparkline == const $CopyWithPlaceholder()
          ? _value.weeklySparkline
          // ignore: cast_nullable_to_non_nullable
          : weeklySparkline as List<StatsWeekPointDto>,
    );
  }
}

extension $StatsHeroDtoCopyWith on StatsHeroDto {
  /// Returns a callable class that can be used as follows: `instanceOfStatsHeroDto.copyWith(...)` or like so:`instanceOfStatsHeroDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatsHeroDtoCWProxy get copyWith => _$StatsHeroDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsHeroDto _$StatsHeroDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StatsHeroDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'completionPercent',
          'tasksDone',
          'tasksTotal',
          'deltaPoints',
          'bestWeekday',
          'weeklySparkline',
        ],
      );
      final val = StatsHeroDto(
        completionPercent: $checkedConvert(
          'completionPercent',
          (v) => (v as num).toInt(),
        ),
        tasksDone: $checkedConvert('tasksDone', (v) => (v as num).toInt()),
        tasksTotal: $checkedConvert('tasksTotal', (v) => (v as num).toInt()),
        deltaPoints: $checkedConvert('deltaPoints', (v) => (v as num).toInt()),
        bestWeekday: $checkedConvert(
          'bestWeekday',
          (v) => (v as num?)?.toInt(),
        ),
        weeklySparkline: $checkedConvert(
          'weeklySparkline',
          (v) => (v as List<dynamic>)
              .map((e) => StatsWeekPointDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StatsHeroDtoToJson(
  StatsHeroDto instance,
) => <String, dynamic>{
  'completionPercent': instance.completionPercent,
  'tasksDone': instance.tasksDone,
  'tasksTotal': instance.tasksTotal,
  'deltaPoints': instance.deltaPoints,
  'bestWeekday': instance.bestWeekday,
  'weeklySparkline': instance.weeklySparkline.map((e) => e.toJson()).toList(),
};
