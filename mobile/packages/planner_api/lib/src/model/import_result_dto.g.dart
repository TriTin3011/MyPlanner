// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ImportResultDtoCWProxy {
  ImportResultDto tasks(int tasks);

  ImportResultDto habits(int habits);

  ImportResultDto habitLogs(int habitLogs);

  ImportResultDto goals(int goals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ImportResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ImportResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ImportResultDto call({int tasks, int habits, int habitLogs, int goals});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfImportResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfImportResultDto.copyWith.fieldName(...)`
class _$ImportResultDtoCWProxyImpl implements _$ImportResultDtoCWProxy {
  const _$ImportResultDtoCWProxyImpl(this._value);

  final ImportResultDto _value;

  @override
  ImportResultDto tasks(int tasks) => this(tasks: tasks);

  @override
  ImportResultDto habits(int habits) => this(habits: habits);

  @override
  ImportResultDto habitLogs(int habitLogs) => this(habitLogs: habitLogs);

  @override
  ImportResultDto goals(int goals) => this(goals: goals);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ImportResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ImportResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ImportResultDto call({
    Object? tasks = const $CopyWithPlaceholder(),
    Object? habits = const $CopyWithPlaceholder(),
    Object? habitLogs = const $CopyWithPlaceholder(),
    Object? goals = const $CopyWithPlaceholder(),
  }) {
    return ImportResultDto(
      tasks: tasks == const $CopyWithPlaceholder()
          ? _value.tasks
          // ignore: cast_nullable_to_non_nullable
          : tasks as int,
      habits: habits == const $CopyWithPlaceholder()
          ? _value.habits
          // ignore: cast_nullable_to_non_nullable
          : habits as int,
      habitLogs: habitLogs == const $CopyWithPlaceholder()
          ? _value.habitLogs
          // ignore: cast_nullable_to_non_nullable
          : habitLogs as int,
      goals: goals == const $CopyWithPlaceholder()
          ? _value.goals
          // ignore: cast_nullable_to_non_nullable
          : goals as int,
    );
  }
}

extension $ImportResultDtoCopyWith on ImportResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfImportResultDto.copyWith(...)` or like so:`instanceOfImportResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ImportResultDtoCWProxy get copyWith => _$ImportResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportResultDto _$ImportResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ImportResultDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['tasks', 'habits', 'habitLogs', 'goals'],
      );
      final val = ImportResultDto(
        tasks: $checkedConvert('tasks', (v) => (v as num).toInt()),
        habits: $checkedConvert('habits', (v) => (v as num).toInt()),
        habitLogs: $checkedConvert('habitLogs', (v) => (v as num).toInt()),
        goals: $checkedConvert('goals', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$ImportResultDtoToJson(ImportResultDto instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
      'habits': instance.habits,
      'habitLogs': instance.habitLogs,
      'goals': instance.goals,
    };
