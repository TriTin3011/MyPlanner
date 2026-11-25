import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/calendar_date.dart';

/// Nhóm dữ liệu. Một thay đổi (ví dụ tick task) làm cũ mọi màn đọc nhóm đó.
///
/// Bên web dùng `invalidateQueries(['dashboard'])` của TanStack Query. Ở đây
/// các feature không được import nhau, nên chúng gặp nhau qua "số phiên bản"
/// của từng nhóm: provider của màn nào `watch` nhóm nào thì tự tải lại khi
/// nhóm đó tăng phiên bản.
enum DataTopic { tasks, habits, notes, goals, year, recurring, profile }

class DataRevisions extends Notifier<Map<DataTopic, int>> {
  @override
  Map<DataTopic, int> build() => {for (final t in DataTopic.values) t: 0};

  void bump(Iterable<DataTopic> topics) {
    state = {
      for (final entry in state.entries)
        entry.key: topics.contains(entry.key) ? entry.value + 1 : entry.value,
    };
  }

  void bumpAll() => bump(DataTopic.values);
}

final dataRevisionsProvider = NotifierProvider<DataRevisions, Map<DataTopic, int>>(DataRevisions.new);

extension WatchTopics on Ref {
  /// Gọi đầu hàm build của provider để nó tải lại khi các nhóm này đổi.
  void watchTopics(List<DataTopic> topics) {
    for (final t in topics) {
      watch(dataRevisionsProvider.select((m) => m[t]));
    }
  }

  void bumpTopics(List<DataTopic> topics) => read(dataRevisionsProvider.notifier).bump(topics);
}

/// "Hôm nay" theo giờ máy. Client gửi ngày này lên server (SPEC: không lấy
/// đồng hồ server). App shell gọi `refresh()` khi app quay lại foreground để
/// qua nửa đêm thì đổi ngày.
class TodayController extends Notifier<CalendarDate> {
  @override
  CalendarDate build() => CalendarDate.today();

  void refresh() {
    final now = CalendarDate.today();
    if (now != state) state = now;
  }
}

final todayProvider = NotifierProvider<TodayController, CalendarDate>(TodayController.new);
