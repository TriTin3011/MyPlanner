import 'package:freezed_annotation/freezed_annotation.dart';

import '../values/calendar_date.dart';

part 'task.freezed.dart';

enum TaskTag { urgent, important }

@freezed
abstract class Subtask with _$Subtask {
  const factory Subtask({
    String? id,
    required String title,
    @Default(false) bool done,
  }) = _Subtask;
}

@freezed
abstract class Task with _$Task {
  const Task._();

  const factory Task({
    required String id,
    required String title,
    required CalendarDate date,
    CalendarDate? originalDate,
    required bool done,
    @Default([]) List<TaskTag> tags,
    @Default([]) List<Subtask> subtasks,
    String? recurringId,
    @Default(0) int order,
  }) = _Task;

  bool get isRecurring => recurringId != null;
}

/// Dữ liệu để tạo hoặc sửa task (một form dùng cho cả hai).
@freezed
abstract class TaskDraft with _$TaskDraft {
  const factory TaskDraft({
    required String title,
    required CalendarDate date,
    @Default([]) List<TaskTag> tags,
    @Default([]) List<Subtask> subtasks,
  }) = _TaskDraft;

  factory TaskDraft.fromTask(Task t) =>
      TaskDraft(title: t.title, date: t.date, tags: t.tags, subtasks: t.subtasks);
}

/// Một ngày trong lịch / biểu đồ: số liệu do backend tính (`dashboard/days`).
@freezed
abstract class DayProgress with _$DayProgress {
  const factory DayProgress({
    required CalendarDate date,
    required int tasksDone,
    required int tasksTotal,
    required int percent,
    @Default(false) bool hasDeadline,
  }) = _DayProgress;
}

@freezed
abstract class RecurringTask with _$RecurringTask {
  const factory RecurringTask({
    required String id,
    required String title,
    /// 1 = Thứ 2 … 7 = Chủ nhật.
    required List<int> weekdays,
    @Default([]) List<TaskTag> tags,
    required bool active,
    required CalendarDate startDate,
  }) = _RecurringTask;
}
