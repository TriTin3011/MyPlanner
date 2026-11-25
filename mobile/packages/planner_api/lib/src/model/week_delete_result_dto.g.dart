// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_delete_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WeekDeleteResultDtoCWProxy {
  WeekDeleteResultDto tasks(int tasks);

  WeekDeleteResultDto habitLogs(int habitLogs);

  WeekDeleteResultDto notes(int notes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeekDeleteResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeekDeleteResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WeekDeleteResultDto call({int tasks, int habitLogs, int notes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWeekDeleteResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWeekDeleteResultDto.copyWith.fieldName(...)`
class _$WeekDeleteResultDtoCWProxyImpl implements _$WeekDeleteResultDtoCWProxy {
  const _$WeekDeleteResultDtoCWProxyImpl(this._value);

  final WeekDeleteResultDto _value;

  @override
  WeekDeleteResultDto tasks(int tasks) => this(tasks: tasks);

  @override
  WeekDeleteResultDto habitLogs(int habitLogs) => this(habitLogs: habitLogs);

  @override
  WeekDeleteResultDto notes(int notes) => this(notes: notes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WeekDeleteResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WeekDeleteResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WeekDeleteResultDto call({
    Object? tasks = const $CopyWithPlaceholder(),
    Object? habitLogs = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
  }) {
    return WeekDeleteResultDto(
      tasks: tasks == const $CopyWithPlaceholder()
          ? _value.tasks
          // ignore: cast_nullable_to_non_nullable
          : tasks as int,
      habitLogs: habitLogs == const $CopyWithPlaceholder()
          ? _value.habitLogs
          // ignore: cast_nullable_to_non_nullable
          : habitLogs as int,
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as int,
    );
  }
}

extension $WeekDeleteResultDtoCopyWith on WeekDeleteResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfWeekDeleteResultDto.copyWith(...)` or like so:`instanceOfWeekDeleteResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WeekDeleteResultDtoCWProxy get copyWith =>
      _$WeekDeleteResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekDeleteResultDto _$WeekDeleteResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeekDeleteResultDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['tasks', 'habitLogs', 'notes']);
      final val = WeekDeleteResultDto(
        tasks: $checkedConvert('tasks', (v) => (v as num).toInt()),
        habitLogs: $checkedConvert('habitLogs', (v) => (v as num).toInt()),
        notes: $checkedConvert('notes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$WeekDeleteResultDtoToJson(
  WeekDeleteResultDto instance,
) => <String, dynamic>{
  'tasks': instance.tasks,
  'habitLogs': instance.habitLogs,
  'notes': instance.notes,
};
