import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/models/task.dart';
import '../../domain/models/week.dart';
import '../../domain/values/calendar_date.dart';
import '../../domain/values/week_key.dart';

/// Tuần đang xem. Mặc định là tuần chứa "hôm nay"; nút ‹ › đổi tuần.
class SelectedWeek extends Notifier<WeekKey> {
  @override
  WeekKey build() => WeekKey.of(ref.watch(todayProvider));

  void previous() => state = state.previous();
  void next() => state = state.next();
  void reset() => state = WeekKey.of(ref.read(todayProvider));
}

final selectedWeekProvider = NotifierProvider<SelectedWeek, WeekKey>(SelectedWeek.new);

/// Số liệu tuần (`GET /api/dashboard/week`): tiến độ, % thói quen, câu nhận xét.
final weekDashboardProvider = FutureProvider.family<WeekDashboard, WeekKey>((ref, key) {
  ref.watchTopics(const [DataTopic.tasks, DataTopic.habits, DataTopic.recurring]);
  return ref.read(taskRepositoryProvider).week(key, ref.watch(todayProvider));
});

/// Việc trong 7 ngày của tuần, nhóm theo ngày ở widget.
final weekTasksProvider = FutureProvider.family<List<Task>, WeekKey>((ref, key) {
  ref.watchTopics(const [DataTopic.tasks, DataTopic.recurring]);
  return ref.read(taskRepositoryProvider).range(key.monday, key.sunday);
});

final weekNoteProvider = FutureProvider.family<String, WeekKey>((ref, key) {
  ref.watchTopics(const [DataTopic.notes]);
  return ref.read(taskRepositoryProvider).weekNote(key);
});

final weekDeadlinesProvider = FutureProvider.family<List<Deadline>, WeekKey>((ref, key) {
  ref.watchTopics(const [DataTopic.goals]);
  return ref.read(taskRepositoryProvider).deadlines(key.monday, key.sunday, ref.watch(todayProvider));
});

/// Tiến độ theo ngày trong 4 tuần kết thúc ở tuần đang xem.
final weekDaysRangeProvider = FutureProvider.family<List<DayProgress>, (CalendarDate, CalendarDate)>((ref, r) {
  ref.watchTopics(const [DataTopic.tasks, DataTopic.recurring]);
  return ref.read(taskRepositoryProvider).days(r.$1, r.$2);
});

/// 12 tuần gần nhất (`GET /api/dashboard/weeks`).
final weeksProvider = FutureProvider.family<List<WeekProgress>, CalendarDate>((ref, to) {
  ref.watchTopics(const [DataTopic.tasks, DataTopic.recurring]);
  return ref.read(taskRepositoryProvider).weeks(to, 12);
});

/// Thao tác ghi của màn Tuần. Không sửa tạm (optimistic) vì danh sách tuần nạp lại nhanh;
/// gọi API xong thì bump topic để Hôm nay, lịch, Thống kê cùng cập nhật.
class WeekActions {
  WeekActions(this._ref);
  final Ref _ref;

  TaskRepository get _tasks => _ref.read(taskRepositoryProvider);

  Future<void> _run(Future<void> Function() call, [List<DataTopic> topics = const [DataTopic.tasks]]) async {
    try {
      await call();
    } finally {
      _ref.bumpTopics(topics);
    }
  }

  Future<void> toggle(Task t, bool done) => _run(() => _tasks.setDone(t.id, done));
  Future<void> create(TaskDraft d) => _run(() => _tasks.create(d));
  Future<void> update(String id, TaskDraft d) => _run(() => _tasks.update(id, d));
  Future<void> delete(String id) => _run(() => _tasks.delete(id));

  /// Không bump `notes` để ô đang gõ không bị nạp lại giữa chừng.
  Future<void> saveNote(WeekKey key, String text) => _tasks.saveWeekNote(key, text);

  Future<WeekDeleteResult> clear(WeekKey key) async {
    late WeekDeleteResult result;
    await _run(() async => result = await _tasks.clearWeek(key),
        const [DataTopic.tasks, DataTopic.habits, DataTopic.notes]);
    return result;
  }
}

final weekActionsProvider = Provider(WeekActions.new);
