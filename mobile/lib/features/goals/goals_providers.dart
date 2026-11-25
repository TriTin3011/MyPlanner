import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../data/repositories/planning_repository.dart';
import '../../domain/models/goal.dart';
import '../../domain/values/calendar_date.dart';

/// Bảng mục tiêu (`GET /api/dashboard/goals`): %, "chậm kế hoạch", tóm tắt theo lĩnh vực đều do backend tính.
final goalBoardProvider = FutureProvider<GoalBoard>((ref) {
  ref.watchTopics(const [DataTopic.goals]);
  return ref.read(goalRepositoryProvider).board(ref.watch(todayProvider));
});

/// Lĩnh vực đang lọc; `null` = Tất cả. Chỉ là trạng thái UI nên giữ trong bộ nhớ.
class GoalAreaFilter extends Notifier<LifeArea?> {
  @override
  LifeArea? build() => null;
  void set(LifeArea? a) => state = a;
}

final goalAreaFilterProvider = NotifierProvider<GoalAreaFilter, LifeArea?>(GoalAreaFilter.new);

/// Chi tiết một mục tiêu cho ngăn kéo (drawer). Mọi API sửa bước đều trả lại `Goal` mới,
/// nên controller gán thẳng kết quả vào `state` thay vì nạp lại.
class GoalDetailController extends AsyncNotifier<Goal> {
  GoalDetailController(this.id);
  final String id;

  GoalRepository get _repo => ref.read(goalRepositoryProvider);

  @override
  Future<Goal> build() {
    ref.watchTopics(const [DataTopic.goals]);
    return _repo.get(id);
  }

  Future<void> _apply(Future<Goal> Function() call) async {
    final g = await call();
    state = AsyncData(g);
    // Bảng, dòng hạn ở Tuần/Năm và Thống kê đọc cùng dữ liệu nên phải tính lại.
    ref.bumpTopics(const [DataTopic.goals]);
  }

  // Tên `save` vì `AsyncNotifier` đã có sẵn hàm `update` (sửa state bằng callback).
  Future<void> save(GoalDraft d) => _apply(() => _repo.update(id, d));
  Future<void> addStep(String title, CalendarDate? deadline) => _apply(() => _repo.addStep(id, title, deadline));
  Future<void> updateStep(GoalStep s) {
    // Tick bước: đổi ngay trên màn rồi mới gọi API (optimistic).
    final cur = state.value;
    if (cur != null) {
      state = AsyncData(cur.copyWith(steps: [for (final x in cur.steps) x.id == s.id ? s : x]));
    }
    return _apply(() => _repo.updateStep(id, s));
  }

  Future<void> deleteStep(String stepId) => _apply(() => _repo.deleteStep(id, stepId));

  Future<void> reorderSteps(List<GoalStep> steps) {
    final cur = state.value;
    if (cur != null) state = AsyncData(cur.copyWith(steps: steps));
    return _apply(() => _repo.reorderSteps(id, [for (final s in steps) s.id]));
  }
}

final goalDetailProvider = AsyncNotifierProvider.family<GoalDetailController, Goal, String>(GoalDetailController.new);

class GoalActions {
  GoalActions(this._ref);
  final Ref _ref;

  Future<Goal> create(GoalDraft d) async {
    try {
      return await _ref.read(goalRepositoryProvider).create(d);
    } finally {
      _ref.bumpTopics(const [DataTopic.goals]);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _ref.read(goalRepositoryProvider).delete(id);
    } finally {
      _ref.bumpTopics(const [DataTopic.goals]);
    }
  }
}

final goalActionsProvider = Provider(GoalActions.new);
