// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BackupDtoCWProxy {
  BackupDto version(int version);

  BackupDto exportedAt(DateTime exportedAt);

  BackupDto tasks(List<TaskDto> tasks);

  BackupDto recurring(List<RecurringTaskDto> recurring);

  BackupDto habits(List<HabitDto> habits);

  BackupDto habitLogs(List<HabitLogDto> habitLogs);

  BackupDto goals(List<GoalDto> goals);

  BackupDto dayNotes(List<DayNoteDto> dayNotes);

  BackupDto weekNotes(List<WeekNoteDto> weekNotes);

  BackupDto years(List<YearMetaDto> years);

  BackupDto yearItems(List<YearPlanItemDto> yearItems);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BackupDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BackupDto(...).copyWith(id: 12, name: "My name")
  /// ````
  BackupDto call({
    int version,
    DateTime exportedAt,
    List<TaskDto> tasks,
    List<RecurringTaskDto> recurring,
    List<HabitDto> habits,
    List<HabitLogDto> habitLogs,
    List<GoalDto> goals,
    List<DayNoteDto> dayNotes,
    List<WeekNoteDto> weekNotes,
    List<YearMetaDto> years,
    List<YearPlanItemDto> yearItems,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBackupDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBackupDto.copyWith.fieldName(...)`
class _$BackupDtoCWProxyImpl implements _$BackupDtoCWProxy {
  const _$BackupDtoCWProxyImpl(this._value);

  final BackupDto _value;

  @override
  BackupDto version(int version) => this(version: version);

  @override
  BackupDto exportedAt(DateTime exportedAt) => this(exportedAt: exportedAt);

  @override
  BackupDto tasks(List<TaskDto> tasks) => this(tasks: tasks);

  @override
  BackupDto recurring(List<RecurringTaskDto> recurring) =>
      this(recurring: recurring);

  @override
  BackupDto habits(List<HabitDto> habits) => this(habits: habits);

  @override
  BackupDto habitLogs(List<HabitLogDto> habitLogs) =>
      this(habitLogs: habitLogs);

  @override
  BackupDto goals(List<GoalDto> goals) => this(goals: goals);

  @override
  BackupDto dayNotes(List<DayNoteDto> dayNotes) => this(dayNotes: dayNotes);

  @override
  BackupDto weekNotes(List<WeekNoteDto> weekNotes) =>
      this(weekNotes: weekNotes);

  @override
  BackupDto years(List<YearMetaDto> years) => this(years: years);

  @override
  BackupDto yearItems(List<YearPlanItemDto> yearItems) =>
      this(yearItems: yearItems);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BackupDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BackupDto(...).copyWith(id: 12, name: "My name")
  /// ````
  BackupDto call({
    Object? version = const $CopyWithPlaceholder(),
    Object? exportedAt = const $CopyWithPlaceholder(),
    Object? tasks = const $CopyWithPlaceholder(),
    Object? recurring = const $CopyWithPlaceholder(),
    Object? habits = const $CopyWithPlaceholder(),
    Object? habitLogs = const $CopyWithPlaceholder(),
    Object? goals = const $CopyWithPlaceholder(),
    Object? dayNotes = const $CopyWithPlaceholder(),
    Object? weekNotes = const $CopyWithPlaceholder(),
    Object? years = const $CopyWithPlaceholder(),
    Object? yearItems = const $CopyWithPlaceholder(),
  }) {
    return BackupDto(
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
      exportedAt: exportedAt == const $CopyWithPlaceholder()
          ? _value.exportedAt
          // ignore: cast_nullable_to_non_nullable
          : exportedAt as DateTime,
      tasks: tasks == const $CopyWithPlaceholder()
          ? _value.tasks
          // ignore: cast_nullable_to_non_nullable
          : tasks as List<TaskDto>,
      recurring: recurring == const $CopyWithPlaceholder()
          ? _value.recurring
          // ignore: cast_nullable_to_non_nullable
          : recurring as List<RecurringTaskDto>,
      habits: habits == const $CopyWithPlaceholder()
          ? _value.habits
          // ignore: cast_nullable_to_non_nullable
          : habits as List<HabitDto>,
      habitLogs: habitLogs == const $CopyWithPlaceholder()
          ? _value.habitLogs
          // ignore: cast_nullable_to_non_nullable
          : habitLogs as List<HabitLogDto>,
      goals: goals == const $CopyWithPlaceholder()
          ? _value.goals
          // ignore: cast_nullable_to_non_nullable
          : goals as List<GoalDto>,
      dayNotes: dayNotes == const $CopyWithPlaceholder()
          ? _value.dayNotes
          // ignore: cast_nullable_to_non_nullable
          : dayNotes as List<DayNoteDto>,
      weekNotes: weekNotes == const $CopyWithPlaceholder()
          ? _value.weekNotes
          // ignore: cast_nullable_to_non_nullable
          : weekNotes as List<WeekNoteDto>,
      years: years == const $CopyWithPlaceholder()
          ? _value.years
          // ignore: cast_nullable_to_non_nullable
          : years as List<YearMetaDto>,
      yearItems: yearItems == const $CopyWithPlaceholder()
          ? _value.yearItems
          // ignore: cast_nullable_to_non_nullable
          : yearItems as List<YearPlanItemDto>,
    );
  }
}

extension $BackupDtoCopyWith on BackupDto {
  /// Returns a callable class that can be used as follows: `instanceOfBackupDto.copyWith(...)` or like so:`instanceOfBackupDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BackupDtoCWProxy get copyWith => _$BackupDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupDto _$BackupDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BackupDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'version',
          'exportedAt',
          'tasks',
          'recurring',
          'habits',
          'habitLogs',
          'goals',
          'dayNotes',
          'weekNotes',
          'years',
          'yearItems',
        ],
      );
      final val = BackupDto(
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        exportedAt: $checkedConvert(
          'exportedAt',
          (v) => DateTime.parse(v as String),
        ),
        tasks: $checkedConvert(
          'tasks',
          (v) => (v as List<dynamic>)
              .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        recurring: $checkedConvert(
          'recurring',
          (v) => (v as List<dynamic>)
              .map((e) => RecurringTaskDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        habits: $checkedConvert(
          'habits',
          (v) => (v as List<dynamic>)
              .map((e) => HabitDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        habitLogs: $checkedConvert(
          'habitLogs',
          (v) => (v as List<dynamic>)
              .map((e) => HabitLogDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        goals: $checkedConvert(
          'goals',
          (v) => (v as List<dynamic>)
              .map((e) => GoalDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        dayNotes: $checkedConvert(
          'dayNotes',
          (v) => (v as List<dynamic>)
              .map((e) => DayNoteDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        weekNotes: $checkedConvert(
          'weekNotes',
          (v) => (v as List<dynamic>)
              .map((e) => WeekNoteDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        years: $checkedConvert(
          'years',
          (v) => (v as List<dynamic>)
              .map((e) => YearMetaDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        yearItems: $checkedConvert(
          'yearItems',
          (v) => (v as List<dynamic>)
              .map((e) => YearPlanItemDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BackupDtoToJson(BackupDto instance) => <String, dynamic>{
  'version': instance.version,
  'exportedAt': instance.exportedAt.toIso8601String(),
  'tasks': instance.tasks.map((e) => e.toJson()).toList(),
  'recurring': instance.recurring.map((e) => e.toJson()).toList(),
  'habits': instance.habits.map((e) => e.toJson()).toList(),
  'habitLogs': instance.habitLogs.map((e) => e.toJson()).toList(),
  'goals': instance.goals.map((e) => e.toJson()).toList(),
  'dayNotes': instance.dayNotes.map((e) => e.toJson()).toList(),
  'weekNotes': instance.weekNotes.map((e) => e.toJson()).toList(),
  'years': instance.years.map((e) => e.toJson()).toList(),
  'yearItems': instance.yearItems.map((e) => e.toJson()).toList(),
};
