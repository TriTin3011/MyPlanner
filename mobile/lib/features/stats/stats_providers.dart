import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../data/repositories/planning_repository.dart';
import '../../domain/models/stats.dart';

/// Khoảng thời gian đang xem; mặc định 12 tuần như web.
class SelectedStatsRange extends Notifier<StatsRange> {
  @override
  StatsRange build() => StatsRange.w12;
  void set(StatsRange r) => state = r;
}

final statsRangeProvider = NotifierProvider<SelectedStatsRange, StatsRange>(SelectedStatsRange.new);

/// Toàn bộ số liệu (`GET /api/stats`) do `StatsCalculator` ở backend tính; app chỉ vẽ.
/// Thống kê đọc task, thói quen và mục tiêu nên nghe cả ba chủ đề.
final statsProvider = FutureProvider.family<Stats, StatsRange>((ref, range) {
  ref.watchTopics(const [DataTopic.tasks, DataTopic.habits, DataTopic.goals, DataTopic.recurring]);
  return ref.read(statsRepositoryProvider).load(range, ref.watch(todayProvider));
});
