// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_dashboard_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WeekDashboardDtoCWProxy {
  WeekDashboardDto weekKey(String weekKey);

  WeekDashboardDto from(String from);

  WeekDashboardDto to(String to);

  WeekDashboardDto tasksDone(int tasksDone);

  WeekDashboardDto tasksTotal(int tasksTotal);

  WeekDashboardDto habitPercent(int habitPercent);

  WeekDashboardDto todayRemaining(int todayRemaining);

  WeekDashboardDto comment(String comment);

  WeekDashboardDto days(List<DayProgressDto> days);

  WeekDashboardDto insights(List<String> insights);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeekDashboardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeekDashboardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WeekDashboardDto call({
    String weekKey,
    String from,
    String to,
    int tasksDone,
    int tasksTotal,
    int habitPercent,
    int todayRemaining,
    String comment,
    List<DayProgressDto> days,
    List<String> insights,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWeekDashboardDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWeekDashboardDto.copyWith.fieldName(...)`
class _$WeekDashboardDtoCWProxyImpl implements _$WeekDashboardDtoCWProxy {
  const _$WeekDashboardDtoCWProxyImpl(this._value);

  final WeekDashboardDto _value;

  @override
  WeekDashboardDto weekKey(String weekKey) => this(weekKey: weekKey);

  @override
  WeekDashboardDto from(String from) => this(from: from);

  @override
  WeekDashboardDto to(String to) => this(to: to);

  @override
  WeekDashboardDto tasksDone(int tasksDone) => this(tasksDone: tasksDone);

  @override
  WeekDashboardDto tasksTotal(int tasksTotal) => this(tasksTotal: tasksTotal);

  @override
  WeekDashboardDto habitPercent(int habitPercent) =>
      this(habitPercent: habitPercent);

  @override
  WeekDashboardDto todayRemaining(int todayRemaining) =>
      this(todayRemaining: todayRemaining);

  @override
  WeekDashboardDto comment(String comment) => this(comment: comment);

  @override
  WeekDashboardDto days(List<DayProgressDto> days) => this(days: days);

  @override
  WeekDashboardDto insights(List<String> insights) => this(insights: insights);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeekDashboardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeekDashboardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WeekDashboardDto call({
    Object? weekKey = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? tasksDone = const $CopyWithPlaceholder(),
    Object? tasksTotal = const $CopyWithPlaceholder(),
    Object? habitPercent = const $CopyWithPlaceholder(),
    Object? todayRemaining = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? days = const $CopyWithPlaceholder(),
    Object? insights = const $CopyWithPlaceholder(),
  }) {
    return WeekDashboardDto(
      weekKey: weekKey == const $CopyWithPlaceholder()
          ? _value.weekKey
          // ignore: cast_nullable_to_non_nullable
          : weekKey as String,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String,
      tasksDone: tasksDone == const $CopyWithPlaceholder()
          ? _value.tasksDone
          // ignore: cast_nullable_to_non_nullable
          : tasksDone as int,
      tasksTotal: tasksTotal == const $CopyWithPlaceholder()
          ? _value.tasksTotal
          // ignore: cast_nullable_to_non_nullable
          : tasksTotal as int,
      habitPercent: habitPercent == const $CopyWithPlaceholder()
          ? _value.habitPercent
          // ignore: cast_nullable_to_non_nullable
          : habitPercent as int,
      todayRemaining: todayRemaining == const $CopyWithPlaceholder()
          ? _value.todayRemaining
          // ignore: cast_nullable_to_non_nullable
          : todayRemaining as int,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String,
      days: days == const $CopyWithPlaceholder()
          ? _value.days
          // ignore: cast_nullable_to_non_nullable
          : days as List<DayProgressDto>,
      insights: insights == const $CopyWithPlaceholder()
          ? _value.insights
          // ignore: cast_nullable_to_non_nullable
          : insights as List<String>,
    );
  }
}

extension $WeekDashboardDtoCopyWith on WeekDashboardDto {
  /// Returns a callable class that can be used as follows: `instanceOfWeekDashboardDto.copyWith(...)` or like so:`instanceOfWeekDashboardDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WeekDashboardDtoCWProxy get copyWith => _$WeekDashboardDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekDashboardDto _$WeekDashboardDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeekDashboardDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'weekKey',
          'from',
          'to',
          'tasksDone',
          'tasksTotal',
          'habitPercent',
          'todayRemaining',
          'comment',
          'days',
          'insights',
        ],
      );
      final val = WeekDashboardDto(
        weekKey: $checkedConvert('weekKey', (v) => v as String),
        from: $checkedConvert('from', (v) => v as String),
        to: $checkedConvert('to', (v) => v as String),
        tasksDone: $checkedConvert('tasksDone', (v) => (v as num).toInt()),
        tasksTotal: $checkedConvert('tasksTotal', (v) => (v as num).toInt()),
        habitPercent: $checkedConvert(
          'habitPercent',
          (v) => (v as num).toInt(),
        ),
        todayRemaining: $checkedConvert(
          'todayRemaining',
          (v) => (v as num).toInt(),
        ),
        comment: $checkedConvert('comment', (v) => v as String),
        days: $checkedConvert(
          'days',
          (v) => (v as List<dynamic>)
              .map((e) => DayProgressDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        insights: $checkedConvert(
          'insights',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WeekDashboardDtoToJson(WeekDashboardDto instance) =>
    <String, dynamic>{
      'weekKey': instance.weekKey,
      'from': instance.from,
      'to': instance.to,
      'tasksDone': instance.tasksDone,
      'tasksTotal': instance.tasksTotal,
      'habitPercent': instance.habitPercent,
      'todayRemaining': instance.todayRemaining,
      'comment': instance.comment,
      'days': instance.days.map((e) => e.toJson()).toList(),
      'insights': instance.insights,
    };
