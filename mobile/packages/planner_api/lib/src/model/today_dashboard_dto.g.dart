// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_dashboard_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TodayDashboardDtoCWProxy {
  TodayDashboardDto date(String date);

  TodayDashboardDto percent(int percent);

  TodayDashboardDto tasksDone(int tasksDone);

  TodayDashboardDto tasksTotal(int tasksTotal);

  TodayDashboardDto habitsDone(int habitsDone);

  TodayDashboardDto habitsTotal(int habitsTotal);

  TodayDashboardDto tasks(List<TaskDto> tasks);

  TodayDashboardDto backlog(List<TaskDto> backlog);

  TodayDashboardDto habits(List<TodayHabitDto> habits);

  TodayDashboardDto note(DayNoteDto? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodayDashboardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodayDashboardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TodayDashboardDto call({
    String date,
    int percent,
    int tasksDone,
    int tasksTotal,
    int habitsDone,
    int habitsTotal,
    List<TaskDto> tasks,
    List<TaskDto> backlog,
    List<TodayHabitDto> habits,
    DayNoteDto? note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTodayDashboardDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTodayDashboardDto.copyWith.fieldName(...)`
class _$TodayDashboardDtoCWProxyImpl implements _$TodayDashboardDtoCWProxy {
  const _$TodayDashboardDtoCWProxyImpl(this._value);

  final TodayDashboardDto _value;

  @override
  TodayDashboardDto date(String date) => this(date: date);

  @override
  TodayDashboardDto percent(int percent) => this(percent: percent);

  @override
  TodayDashboardDto tasksDone(int tasksDone) => this(tasksDone: tasksDone);

  @override
  TodayDashboardDto tasksTotal(int tasksTotal) => this(tasksTotal: tasksTotal);

  @override
  TodayDashboardDto habitsDone(int habitsDone) => this(habitsDone: habitsDone);

  @override
  TodayDashboardDto habitsTotal(int habitsTotal) =>
      this(habitsTotal: habitsTotal);

  @override
  TodayDashboardDto tasks(List<TaskDto> tasks) => this(tasks: tasks);

  @override
  TodayDashboardDto backlog(List<TaskDto> backlog) => this(backlog: backlog);

  @override
  TodayDashboardDto habits(List<TodayHabitDto> habits) => this(habits: habits);

  @override
  TodayDashboardDto note(DayNoteDto? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodayDashboardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodayDashboardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TodayDashboardDto call({
    Object? date = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? tasksDone = const $CopyWithPlaceholder(),
    Object? tasksTotal = const $CopyWithPlaceholder(),
    Object? habitsDone = const $CopyWithPlaceholder(),
    Object? habitsTotal = const $CopyWithPlaceholder(),
    Object? tasks = const $CopyWithPlaceholder(),
    Object? backlog = const $CopyWithPlaceholder(),
    Object? habits = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return TodayDashboardDto(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
      tasksDone: tasksDone == const $CopyWithPlaceholder()
          ? _value.tasksDone
          // ignore: cast_nullable_to_non_nullable
          : tasksDone as int,
      tasksTotal: tasksTotal == const $CopyWithPlaceholder()
          ? _value.tasksTotal
          // ignore: cast_nullable_to_non_nullable
          : tasksTotal as int,
      habitsDone: habitsDone == const $CopyWithPlaceholder()
          ? _value.habitsDone
          // ignore: cast_nullable_to_non_nullable
          : habitsDone as int,
      habitsTotal: habitsTotal == const $CopyWithPlaceholder()
          ? _value.habitsTotal
          // ignore: cast_nullable_to_non_nullable
          : habitsTotal as int,
      tasks: tasks == const $CopyWithPlaceholder()
          ? _value.tasks
          // ignore: cast_nullable_to_non_nullable
          : tasks as List<TaskDto>,
      backlog: backlog == const $CopyWithPlaceholder()
          ? _value.backlog
          // ignore: cast_nullable_to_non_nullable
          : backlog as List<TaskDto>,
      habits: habits == const $CopyWithPlaceholder()
          ? _value.habits
          // ignore: cast_nullable_to_non_nullable
          : habits as List<TodayHabitDto>,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as DayNoteDto?,
    );
  }
}

extension $TodayDashboardDtoCopyWith on TodayDashboardDto {
  /// Returns a callable class that can be used as follows: `instanceOfTodayDashboardDto.copyWith(...)` or like so:`instanceOfTodayDashboardDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TodayDashboardDtoCWProxy get copyWith =>
      _$TodayDashboardDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayDashboardDto _$TodayDashboardDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TodayDashboardDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'date',
          'percent',
          'tasksDone',
          'tasksTotal',
          'habitsDone',
          'habitsTotal',
          'tasks',
          'backlog',
          'habits',
          'note',
        ],
      );
      final val = TodayDashboardDto(
        date: $checkedConvert('date', (v) => v as String),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
        tasksDone: $checkedConvert('tasksDone', (v) => (v as num).toInt()),
        tasksTotal: $checkedConvert('tasksTotal', (v) => (v as num).toInt()),
        habitsDone: $checkedConvert('habitsDone', (v) => (v as num).toInt()),
        habitsTotal: $checkedConvert('habitsTotal', (v) => (v as num).toInt()),
        tasks: $checkedConvert(
          'tasks',
          (v) => (v as List<dynamic>)
              .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        backlog: $checkedConvert(
          'backlog',
          (v) => (v as List<dynamic>)
              .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        habits: $checkedConvert(
          'habits',
          (v) => (v as List<dynamic>)
              .map((e) => TodayHabitDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        note: $checkedConvert(
          'note',
          (v) =>
              v == null ? null : DayNoteDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TodayDashboardDtoToJson(TodayDashboardDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'percent': instance.percent,
      'tasksDone': instance.tasksDone,
      'tasksTotal': instance.tasksTotal,
      'habitsDone': instance.habitsDone,
      'habitsTotal': instance.habitsTotal,
      'tasks': instance.tasks.map((e) => e.toJson()).toList(),
      'backlog': instance.backlog.map((e) => e.toJson()).toList(),
      'habits': instance.habits.map((e) => e.toJson()).toList(),
      'note': instance.note?.toJson(),
    };
