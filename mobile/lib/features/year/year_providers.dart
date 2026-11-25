import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../data/repositories/planning_repository.dart';
import '../../domain/models/year.dart';

/// Năm đang xem; mặc định năm của "hôm nay".
class SelectedYear extends Notifier<int> {
  @override
  int build() => ref.watch(todayProvider).year;
  void previous() => state--;
  void next() => state++;
  void reset() => state = ref.read(todayProvider).year;
}

final selectedYearProvider = NotifierProvider<SelectedYear, int>(SelectedYear.new);

/// Bảng năm (`GET /api/dashboard/year`): %, tháng hiện tại, hạn mục tiêu theo tháng do backend gom.
class YearController extends AsyncNotifier<YearDashboard> {
  YearController(this.year);
  final int year;

  YearRepository get _repo => ref.read(yearRepositoryProvider);

  @override
  Future<YearDashboard> build() {
    // Hạn mục tiêu hiện trong từng tháng nên phải nghe cả chủ đề goals.
    ref.watchTopics(const [DataTopic.year, DataTopic.goals]);
    return _repo.dashboard(year, ref.watch(todayProvider));
  }

  /// Từ khoá và Tầm nhìn đi chung một PUT, nên lưu ô này phải gửi kèm giá trị hiện tại của ô kia.
  /// Cập nhật `state` trước để lần lưu sau của ô còn lại đọc được giá trị mới.
  /// Không bump chủ đề: chẳng màn nào khác đọc hai ô này, nạp lại chỉ tốn một request.
  Future<void> saveMeta({String? keyword, String? vision}) async {
    final cur = state.value;
    if (cur == null) return;
    final next = cur.copyWith(keyword: keyword ?? cur.keyword, vision: vision ?? cur.vision);
    state = AsyncData(next);
    await _repo.saveMeta(year, next.keyword, next.vision);
  }

  Future<void> _write(Future<void> Function() call) async {
    try {
      await call();
    } finally {
      ref.bumpTopics(const [DataTopic.year]);
    }
  }

  Future<void> addItem(int month, String title) => _write(() => _repo.addItem(year, month, title));
  Future<void> deleteItem(String id) => _write(() => _repo.deleteItem(id));

  /// Tick mục tháng: optimistic như tick thói quen.
  Future<void> updateItem(YearPlanItem item) {
    _patchMonth(item.month, (items) => [for (final i in items) i.id == item.id ? item : i]);
    return _write(() => _repo.updateItem(item));
  }

  Future<void> reorder(int month, List<YearPlanItem> items) {
    _patchMonth(month, (_) => items);
    return _write(() => _repo.reorder(year, month, [for (final i in items) i.id]));
  }

  void _patchMonth(int month, List<YearPlanItem> Function(List<YearPlanItem>) f) {
    final cur = state.value;
    if (cur == null) return;
    state = AsyncData(cur.copyWith(months: [
      for (final m in cur.months) m.month == month ? m.copyWith(items: f(m.items)) : m,
    ]));
  }
}

final yearProvider = AsyncNotifierProvider.family<YearController, YearDashboard, int>(YearController.new);
