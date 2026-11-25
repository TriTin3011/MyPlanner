// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_progress_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DayProgressDtoCWProxy {
  DayProgressDto date(String date);

  DayProgressDto tasksDone(int tasksDone);

  DayProgressDto tasksTotal(int tasksTotal);

  DayProgressDto percent(int percent);

  DayProgressDto hasDeadline(bool hasDeadline);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DayProgressDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DayProgressDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DayProgressDto call({
    String date,
    int tasksDone,
    int tasksTotal,
    int percent,
    bool hasDeadline,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDayProgressDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDayProgressDto.copyWith.fieldName(...)`
class _$DayProgressDtoCWProxyImpl implements _$DayProgressDtoCWProxy {
  const _$DayProgressDtoCWProxyImpl(this._value);

  final DayProgressDto _value;

  @override
  DayProgressDto date(String date) => this(date: date);

  @override
  DayProgressDto tasksDone(int tasksDone) => this(tasksDone: tasksDone);

  @override
  DayProgressDto tasksTotal(int tasksTotal) => this(tasksTotal: tasksTotal);

  @override
  DayProgressDto percent(int percent) => this(percent: percent);

  @override
  DayProgressDto hasDeadline(bool hasDeadline) =>
      this(hasDeadline: hasDeadline);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DayProgressDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DayProgressDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DayProgressDto call({
    Object? date = const $CopyWithPlaceholder(),
    Object? tasksDone = const $CopyWithPlaceholder(),
    Object? tasksTotal = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? hasDeadline = const $CopyWithPlaceholder(),
  }) {
    return DayProgressDto(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
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
      hasDeadline: hasDeadline == const $CopyWithPlaceholder()
          ? _value.hasDeadline
          // ignore: cast_nullable_to_non_nullable
          : hasDeadline as bool,
    );
  }
}

extension $DayProgressDtoCopyWith on DayProgressDto {
  /// Returns a callable class that can be used as follows: `instanceOfDayProgressDto.copyWith(...)` or like so:`instanceOfDayProgressDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DayProgressDtoCWProxy get copyWith => _$DayProgressDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayProgressDto _$DayProgressDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DayProgressDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'date',
          'tasksDone',
          'tasksTotal',
          'percent',
          'hasDeadline',
        ],
      );
      final val = DayProgressDto(
        date: $checkedConvert('date', (v) => v as String),
        tasksDone: $checkedConvert('tasksDone', (v) => (v as num).toInt()),
        tasksTotal: $checkedConvert('tasksTotal', (v) => (v as num).toInt()),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
        hasDeadline: $checkedConvert('hasDeadline', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$DayProgressDtoToJson(DayProgressDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'tasksDone': instance.tasksDone,
      'tasksTotal': instance.tasksTotal,
      'percent': instance.percent,
      'hasDeadline': instance.hasDeadline,
    };
