import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_api/planner_api.dart' as api;

import '../../domain/models/task.dart';
import '../../domain/models/today.dart';
import '../../domain/models/week.dart';
import '../../domain/values/calendar_date.dart';
import '../../domain/values/week_key.dart';
import '../api/planner_api_provider.dart';
import '../mappers/mappers.dart';

/// Việc, ghi chú, việc lặp lại và các dashboard theo ngày/tuần.
class TaskRepository {
  TaskRepository(this._api);
  final api.PlannerApi _api;

  api.TasksApi get _tasks => _api.getTasksApi();
  api.DashboardApi get _dash => _api.getDashboardApi();
  api.RecurringApi get _recurring => _api.getRecurringApi();
  api.NotesApi get _notes => _api.getNotesApi();

  // ---- dashboard ----
  Future<TodayDashboard> today(CalendarDate date) async =>
      (await _dash.apiDashboardTodayGet(date: date.toIso()).body()).toModel();

  Future<List<DayProgress>> days(CalendarDate from, CalendarDate to) async =>
      (await _dash.apiDashboardDaysGet(from: from.toIso(), to: to.toIso()).body()).map((d) => d.toModel()).toList();

  Future<WeekDashboard> week(WeekKey key, CalendarDate today) async =>
      (await _dash.apiDashboardWeekGet(weekKey: key.toString(), today: today.toIso()).body()).toModel();

  Future<List<WeekProgress>> weeks(CalendarDate to, int count) async =>
      (await _dash.apiDashboardWeeksGet(to: to.toIso(), count: count).body()).map((w) => w.toModel()).toList();

  Future<List<Deadline>> deadlines(CalendarDate from, CalendarDate to, CalendarDate today) async =>
      (await _api
              .getGoalsApi()
              .apiDeadlinesGet(from: from.toIso(), to: to.toIso(), today: today.toIso())
              .body())
          .map((d) => d.toModel())
          .toList();

  // ---- tasks ----
  Future<List<Task>> range(CalendarDate from, CalendarDate to) async =>
      (await _tasks.apiTasksGet(from: from.toIso(), to: to.toIso()).body()).map((t) => t.toModel()).toList();

  Future<Task> create(TaskDraft draft) async =>
      (await _tasks.apiTasksPost(saveTaskRequest: taskDraftToDto(draft)).body()).toModel();

  Future<Task> update(String id, TaskDraft draft) async =>
      (await _tasks.apiTasksIdPut(id: id, saveTaskRequest: taskDraftToDto(draft)).body()).toModel();

  Future<void> delete(String id) => _tasks.apiTasksIdDelete(id: id);

  Future<Task> setDone(String id, bool done) async =>
      (await _tasks.apiTasksIdDonePatch(id: id, setDoneRequest: api.SetDoneRequest(done: done)).body()).toModel();

  Future<int> moveBacklogToToday(CalendarDate today) async => (await _tasks
          .apiTasksMoveBacklogToTodayPost(moveBacklogRequest: api.MoveBacklogRequest(today: today.toIso()))
          .body())
      .count;

  Future<void> reorder(CalendarDate date, List<String> ids) => _tasks.apiTasksReorderPut(
      reorderTasksRequest: api.ReorderTasksRequest(date: date.toIso(), ids: ids));

  // ---- recurring ----
  Future<List<RecurringTask>> recurring() async =>
      (await _recurring.apiRecurringGet().body()).map((r) => r.toModel()).toList();

  api.SaveRecurringRequest _rec(String title, List<int> weekdays, List<TaskTag> tags, bool active, CalendarDate start) =>
      api.SaveRecurringRequest(
        title: title.trim(),
        weekdays: weekdays,
        tags: tags.map(taskTagToDto).toList(),
        active: active,
        startDate: start.toIso(),
      );

  Future<void> createRecurring(String title, List<int> weekdays, List<TaskTag> tags, CalendarDate start) =>
      _recurring.apiRecurringPost(saveRecurringRequest: _rec(title, weekdays, tags, true, start));

  Future<void> updateRecurring(RecurringTask r) => _recurring.apiRecurringIdPut(
      id: r.id, saveRecurringRequest: _rec(r.title, r.weekdays, r.tags, r.active, r.startDate));

  Future<void> deleteRecurring(String id) => _recurring.apiRecurringIdDelete(id: id);

  /// Sinh task từ việc lặp lại trong khoảng; trả số task mới được tạo.
  Future<int> materialize(CalendarDate from, CalendarDate to, CalendarDate today) async => (await _recurring
          .apiRecurringMaterializePost(
              materializeRequest: api.MaterializeRequest(from: from.toIso(), to: to.toIso(), today: today.toIso()))
          .body())
      .count;

  // ---- notes ----
  Future<void> saveDayNote(CalendarDate date, String content) =>
      _notes.apiNotesDayDatePut(date: date.toIso(), saveNoteRequest: api.SaveNoteRequest(content: content));

  Future<String> weekNote(WeekKey key) async =>
      (await _notes.apiNotesWeekWeekKeyGet(weekKey: key.toString()).body()).content;

  Future<void> saveWeekNote(WeekKey key, String content) =>
      _notes.apiNotesWeekWeekKeyPut(weekKey: key.toString(), saveNoteRequest: api.SaveNoteRequest(content: content));

  Future<WeekDeleteResult> clearWeek(WeekKey key) async {
    final r = await _api.getDataApi().apiWeeksWeekKeyDelete(weekKey: key.toString()).body();
    return WeekDeleteResult(tasks: r.tasks, habitLogs: r.habitLogs, notes: r.notes);
  }
}

final taskRepositoryProvider = Provider((ref) => TaskRepository(ref.watch(plannerApiProvider)));
