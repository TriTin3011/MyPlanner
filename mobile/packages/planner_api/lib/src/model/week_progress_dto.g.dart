// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_progress_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WeekProgressDtoCWProxy {
  WeekProgressDto weekKey(String weekKey);

  WeekProgressDto monday(String monday);

  WeekProgressDto tasksDone(int tasksDone);

  WeekProgressDto tasksTotal(int tasksTotal);

  WeekProgressDto percent(int percent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeekProgressDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeekProgressDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WeekProgressDto call({
    String weekKey,
    String monday,
    int tasksDone,
    int tasksTotal,
    int percent,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWeekProgressDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWeekProgressDto.copyWith.fieldName(...)`
class _$WeekProgressDtoCWProxyImpl implements _$WeekProgressDtoCWProxy {
  const _$WeekProgressDtoCWProxyImpl(this._value);

  final WeekProgressDto _value;

  @override
  WeekProgressDto weekKey(String weekKey) => this(weekKey: weekKey);

  @override
  WeekProgressDto monday(String monday) => this(monday: monday);

  @override
  WeekProgressDto tasksDone(int tasksDone) => this(tasksDone: tasksDone);

  @override
  WeekProgressDto tasksTotal(int tasksTotal) => this(tasksTotal: tasksTotal);

  @override
  WeekProgressDto percent(int percent) => this(percent: percent);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeekProgressDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeekProgressDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WeekProgressDto call({
    Object? weekKey = const $CopyWithPlaceholder(),
    Object? monday = const $CopyWithPlaceholder(),
    Object? tasksDone = const $CopyWithPlaceholder(),
    Object? tasksTotal = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
  }) {
    return WeekProgressDto(
      weekKey: weekKey == const $CopyWithPlaceholder()
          ? _value.weekKey
          // ignore: cast_nullable_to_non_nullable
          : weekKey as String,
      monday: monday == const $CopyWithPlaceholder()
          ? _value.monday
          // ignore: cast_nullable_to_non_nullable
          : monday as String,
      tasksDone: tasksDone == const $CopyWithPlaceholder()
          ? _value.tasksDone
          // ignore: cast_nullable_to_non_nullable
          : tasksDone as int,
      tasksTotal: tasksTotal == const $CopyWithPlaceholder()
          ? _value.tasksTotal
          // ignore: cast_nullable_to_non_nullable
          : tasksTotal as int,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
    );
  }
}

extension $WeekProgressDtoCopyWith on WeekProgressDto {
  /// Returns a callable class that can be used as follows: `instanceOfWeekProgressDto.copyWith(...)` or like so:`instanceOfWeekProgressDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WeekProgressDtoCWProxy get copyWith => _$WeekProgressDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekProgressDto _$WeekProgressDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeekProgressDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'weekKey',
          'monday',
          'tasksDone',
          'tasksTotal',
          'percent',
        ],
      );
      final val = WeekProgressDto(
        weekKey: $checkedConvert('weekKey', (v) => v as String),
        monday: $checkedConvert('monday', (v) => v as String),
        tasksDone: $checkedConvert('tasksDone', (v) => (v as num).toInt()),
        tasksTotal: $checkedConvert('tasksTotal', (v) => (v as num).toInt()),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$WeekProgressDtoToJson(WeekProgressDto instance) =>
    <String, dynamic>{
      'weekKey': instance.weekKey,
      'monday': instance.monday,
      'tasksDone': instance.tasksDone,
      'tasksTotal': instance.tasksTotal,
      'percent': instance.percent,
    };
