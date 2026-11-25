import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../data/repositories/planning_repository.dart';
import '../../domain/models/habit.dart';
import '../../domain/values/calendar_date.dart';

/// Tháng đang xem, lưu dạng ngày mùng 1. Mặc định là tháng chứa "hôm nay".
class SelectedHabitMonth extends Notifier<CalendarDate> {
  @override
  CalendarDate build() => ref.watch(todayProvider).firstOfMonth;

  void previous() => state = state.addMonths(-1);
  void next() => state = state.addMonths(1);
  void reset() => state = ref.read(todayProvider).firstOfMonth;
}

final selectedHabitMonthProvider = NotifierProvider<SelectedHabitMonth, CalendarDate>(SelectedHabitMonth.new);

String monthKey(CalendarDate first) => '${first.year}-${first.month.toString().padLeft(2, '0')}';

/// Lưới tháng (`GET /api/dashboard/habits`). Ngày tương lai backend trả `percent == null`.
///
/// Tick là optimistic: sửa `state` ngay rồi mới gọi API, lỗi thì nạp lại. Ô tick phải
/// phản hồi tức thì, chờ mạng 200–500ms mỗi lần chạm sẽ rất khó chịu trên điện thoại.
class HabitMonthController extends AsyncNotifier<HabitMonth> {
  // Riverpod 3: tham số family đi qua constructor thay cho lớp FamilyAsyncNotifier cũ.
  HabitMonthController(this.first);
  final CalendarDate first;

  @override
  Future<HabitMonth> build() {
    ref.watchTopics(const [DataTopic.habits]);
    return ref.read(habitRepositoryProvider).month(monthKey(first), ref.watch(todayProvider));
  }

  Future<void> toggle(String habitId, CalendarDate date, bool done) async {
    final cur = state.value;
    if (cur != null) {
      state = AsyncData(cur.copyWith(habits: [
        for (final h in cur.habits)
          if (h.id == habitId)
            h.copyWith(doneDates: done ? {...h.doneDates, date} : ({...h.doneDates}..remove(date)))
          else
            h,
      ]));
    }
    try {
      await ref.read(habitRepositoryProvider).setDone(habitId, date, done);
    } finally {
      // Bump để % ngày, chuỗi, màn Hôm nay và Thống kê tính lại từ backend.
      ref.bumpTopics(const [DataTopic.habits]);
    }
  }

  Future<void> reorder(List<HabitRow> rows) async {
    final cur = state.value;
    if (cur != null) state = AsyncData(cur.copyWith(habits: rows));
    try {
      await ref.read(habitRepositoryProvider).reorder([for (final r in rows) r.id]);
    } finally {
      ref.bumpTopics(const [DataTopic.habits]);
    }
  }
}

final habitMonthProvider =
    AsyncNotifierProvider.family<HabitMonthController, HabitMonth, CalendarDate>(HabitMonthController.new);

class HabitActions {
  HabitActions(this._ref);
  final Ref _ref;

  Future<void> _run(Future<void> Function() call) async {
    try {
      await call();
    } finally {
      _ref.bumpTopics(const [DataTopic.habits]);
    }
  }

  Future<void> create(String title) =>
      _run(() => _ref.read(habitRepositoryProvider).create(title, _ref.read(todayProvider)));
  Future<void> rename(String id, String title) => _run(() => _ref.read(habitRepositoryProvider).rename(id, title));
  Future<void> delete(String id) => _run(() => _ref.read(habitRepositoryProvider).delete(id));
}

final habitActionsProvider = Provider(HabitActions.new);
