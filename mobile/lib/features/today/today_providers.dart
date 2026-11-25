import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../data/repositories/planning_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/models/task.dart';
import '../../domain/models/today.dart';
import '../../domain/values/calendar_date.dart';

/// Sinh task từ việc lặp lại cho hôm nay → 7 ngày tới (SPEC §12.2).
///
/// Tách thành provider riêng theo ngày để chỉ chạy khi đổi ngày hoặc khi danh
/// sách việc lặp lại đổi, không chạy lại mỗi lần tick một task.
final materializeProvider = FutureProvider.family<int, CalendarDate>((ref, today) {
  ref.watchTopics(const [DataTopic.recurring]);
  return ref.read(taskRepositoryProvider).materialize(today, today.addDays(7), today);
});

/// Dashboard màn Hôm nay (`GET /api/dashboard/today`). Mọi con số do backend tính.
class TodayDashboardController extends AsyncNotifier<TodayDashboard> {
  @override
  Future<TodayDashboard> build() async {
    ref.watchTopics(const [DataTopic.tasks, DataTopic.habits, DataTopic.notes, DataTopic.recurring]);
    final today = ref.watch(todayProvider);
    await ref.watch(materializeProvider(today).future);
    return ref.read(taskRepositoryProvider).today(today);
  }

  /// Sửa tạm dữ liệu đang hiển thị (optimistic update) trước khi server trả lời.
  void patch(TodayDashboard Function(TodayDashboard d) change) {
    final current = state.value;
    if (current != null) state = AsyncData(change(current));
  }
}

final todayDashboardProvider =
    AsyncNotifierProvider<TodayDashboardController, TodayDashboard>(TodayDashboardController.new);

/// Số liệu từng ngày cho lịch và biểu đồ (`GET /api/dashboard/days`).
/// Tham số là record `(from, to)`: record có so sánh theo giá trị nên dùng làm khoá family được.
final daysProvider = FutureProvider.family<List<DayProgress>, (CalendarDate, CalendarDate)>((ref, range) {
  ref.watchTopics(const [DataTopic.tasks, DataTopic.goals, DataTopic.recurring]);
  return ref.read(taskRepositoryProvider).days(range.$1, range.$2);
});

/// Việc của một ngày bất kỳ (sheet khi chạm vào ô lịch).
final dayTasksProvider = FutureProvider.family<List<Task>, CalendarDate>((ref, date) {
  ref.watchTopics(const [DataTopic.tasks]);
  return ref.read(taskRepositoryProvider).range(date, date);
});

final recurringListProvider = FutureProvider<List<RecurringTask>>((ref) {
  ref.watchTopics(const [DataTopic.recurring]);
  return ref.read(taskRepositoryProvider).recurring();
});

/// Các thao tác ghi của màn Hôm nay. Widget gọi hàm ở đây, không gọi repository trực tiếp:
/// giống tầng Service bên backend, gom luật "sửa tạm → gọi API → báo các màn khác tải lại".
class TodayActions {
  TodayActions(this._ref);
  final Ref _ref;

  TaskRepository get _tasks => _ref.read(taskRepositoryProvider);
  TodayDashboardController get _dash => _ref.read(todayDashboardProvider.notifier);

  Future<void> _thenBump(Future<void> Function() call, List<DataTopic> topics) async {
    try {
      await call();
    } finally {
      // Thành công: lấy số liệu mới. Lỗi: tải lại để bỏ thay đổi tạm.
      _ref.bumpTopics(topics);
    }
  }

  Future<void> toggleTask(Task task, bool done) {
    List<Task> flip(List<Task> list) => [for (final t in list) t.id == task.id ? t.copyWith(done: done) : t];
    _dash.patch((d) => d.copyWith(tasks: flip(d.tasks), backlog: flip(d.backlog)));
    return _thenBump(() => _tasks.setDone(task.id, done), const [DataTopic.tasks]);
  }

  Future<void> toggleHabit(String habitId, CalendarDate date, bool done) {
    _dash.patch((d) => d.copyWith(habits: [
          for (final h in d.habits) h.id == habitId ? h.copyWith(done: done) : h,
        ]));
    return _thenBump(
        () => _ref.read(habitRepositoryProvider).setDone(habitId, date, done), const [DataTopic.habits]);
  }

  Future<void> create(TaskDraft draft) => _thenBump(() => _tasks.create(draft), const [DataTopic.tasks]);

  Future<void> update(String id, TaskDraft draft) =>
      _thenBump(() => _tasks.update(id, draft), const [DataTopic.tasks]);

  Future<void> move(Task task, CalendarDate date) =>
      update(task.id, TaskDraft.fromTask(task).copyWith(date: date));

  Future<void> delete(String id) {
    _dash.patch((d) => d.copyWith(
          tasks: d.tasks.where((t) => t.id != id).toList(),
          backlog: d.backlog.where((t) => t.id != id).toList(),
        ));
    return _thenBump(() => _tasks.delete(id), const [DataTopic.tasks]);
  }

  Future<int> moveBacklog(CalendarDate today) async {
    var count = 0;
    await _thenBump(() async => count = await _tasks.moveBacklogToToday(today), const [DataTopic.tasks]);
    return count;
  }

  Future<void> reorder(CalendarDate date, List<Task> ordered) {
    _dash.patch((d) => d.copyWith(tasks: ordered));
    return _thenBump(() => _tasks.reorder(date, [for (final t in ordered) t.id]), const [DataTopic.tasks]);
  }

  /// Ghi chú tự lưu: không bump `notes` để ô đang gõ không bị nạp lại giữa chừng.
  Future<void> saveNote(CalendarDate date, String content) => _tasks.saveDayNote(date, content);

  Future<void> saveRecurring({
    RecurringTask? existing,
    required String title,
    required List<int> weekdays,
    required List<TaskTag> tags,
    required CalendarDate start,
  }) =>
      _thenBump(
        () => existing == null
            ? _tasks.createRecurring(title, weekdays, tags, start)
            : _tasks.updateRecurring(existing.copyWith(title: title, weekdays: weekdays, tags: tags, startDate: start)),
        const [DataTopic.recurring, DataTopic.tasks],
      );

  Future<void> setRecurringActive(RecurringTask r, bool active) =>
      _thenBump(() => _tasks.updateRecurring(r.copyWith(active: active)), const [DataTopic.recurring, DataTopic.tasks]);

  Future<void> deleteRecurring(String id) =>
      _thenBump(() => _tasks.deleteRecurring(id), const [DataTopic.recurring, DataTopic.tasks]);
}

final todayActionsProvider = Provider(TodayActions.new);
