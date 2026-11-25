import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session/session_controller.dart';
import '../../core/sync/data_topics.dart';
import '../../design/palette.dart';
import '../../design/sketch.dart';
import '../../domain/models/task.dart';
import '../../domain/models/today.dart';
import '../../domain/values/calendar_date.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/chart_card.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../shared/widgets/section.dart';
import '../../shared/widgets/task_sheets.dart';
import '../../shared/widgets/task_tile.dart';
import 'planning_calendar.dart';
import 'recurring_sheet.dart';
import 'today_blocks.dart';
import 'today_providers.dart';

/// Màn Hôm nay (SPEC §6). Trên điện thoại các khối xếp dọc một cột:
/// header → việc hôm nay → thói quen → ghi chú → việc còn tồn → lịch → biểu đồ.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(todayDashboardProvider);
    final today = ref.watch(todayProvider);
    final l10n = AppLocalizations.of(context);

    Future<void> refresh() async {
      ref.read(todayProvider.notifier).refresh();
      ref.read(dataRevisionsProvider.notifier).bumpAll();
      await ref.read(todayDashboardProvider.future);
    }

    return PageScaffold(
      onRefresh: refresh,
      floating: FloatingActionButton(
        tooltip: l10n.todayAddTask,
        onPressed: () => addTask(context, ref, today),
        child: const Icon(Icons.add),
      ),
      children: [
        AsyncView<TodayDashboard>(
          value: value,
          onRetry: () => ref.invalidate(todayDashboardProvider),
          data: (d) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(dashboard: d),
              const SizedBox(height: 12),
              _TasksCard(dashboard: d, today: today),
              const SizedBox(height: 12),
              HabitsCard(dashboard: d),
              const SizedBox(height: 12),
              NoteCard(date: d.date, initial: d.note),
              if (d.backlog.isNotEmpty) ...[
                const SizedBox(height: 12),
                BacklogCard(tasks: d.backlog, today: today),
              ],
            ],
          ),
        ),
        PlanningCalendar(today: today),
        _RecentChart(today: today),
      ],
    );
  }
}

/// Mở form thêm việc cho [date] rồi lưu. Dùng cho FAB và sheet của ô lịch.
Future<void> addTask(BuildContext context, WidgetRef ref, CalendarDate date) async {
  final draft = await showTaskEditor(context, initial: TaskDraft(title: '', date: date), isNew: true);
  if (draft == null) return;
  try {
    await ref.read(todayActionsProvider).create(draft);
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}

/// Menu ⋯ của một việc: sửa, đổi ngày, chuyển về hôm nay, xoá.
Future<void> openTaskMenu(BuildContext context, WidgetRef ref, Task task, CalendarDate today) {
  final actions = ref.read(todayActionsProvider);
  return runTaskMenu(context, task, today: today, update: actions.update, delete: actions.delete);
}

class _Header extends ConsumerWidget {
  const _Header({required this.dashboard});
  final TodayDashboard dashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final name = ref.watch(sessionProvider).value?.session?.name ?? '';
    final d = dashboard;
    return SketchBox(
      seed: 11,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.dates.full(d.date), style: TextStyle(color: p.muted, fontSize: 13)),
                const SizedBox(height: 2),
                Text(l10n.todayGreeting(name),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(l10n.todayProgress(d.tasksDone, d.tasksTotal, d.habitsDone, d.habitsTotal),
                    style: TextStyle(color: p.muted)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ProgressRing(percent: d.percent, size: 76),
        ],
      ),
    );
  }
}

class _TasksCard extends ConsumerWidget {
  const _TasksCard({required this.dashboard, required this.today});
  final TodayDashboard dashboard;
  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final tasks = dashboard.tasks;
    final actions = ref.read(todayActionsProvider);

    return SectionCard(
      title: l10n.todayTasks,
      trailing: IconButton(
        tooltip: l10n.todayRecurring,
        icon: const Icon(Icons.repeat),
        onPressed: () => showRecurringSheet(context, today),
      ),
      child: tasks.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.todayTasksEmpty, style: TextStyle(color: p.muted)),
            )
          : ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: tasks.length,
              // onReorderItem đã trừ sẵn chỉ số khi kéo xuống dưới (khác onReorder cũ).
              onReorderItem: (from, to) {
                final list = [...tasks];
                list.insert(to, list.removeAt(from));
                actions.reorder(dashboard.date, list).catchError((Object e) {
                  if (context.mounted) showError(context, e);
                });
              },
              itemBuilder: (context, i) {
                final t = tasks[i];
                return TaskTile(
                  key: ValueKey(t.id),
                  task: t,
                  today: today,
                  dragHandle: ReorderableDragStartListener(
                    index: i,
                    child: Tooltip(
                      message: l10n.reorderHint,
                      child: SizedBox(
                        width: 32,
                        height: 44,
                        child: Icon(Icons.drag_indicator, color: p.muted, size: 20),
                      ),
                    ),
                  ),
                  onToggle: (v) => actions.toggleTask(t, v).catchError((Object e) {
                    if (context.mounted) showError(context, e);
                  }),
                  onTap: () => openTaskMenu(context, ref, t, today),
                  onMenu: () => openTaskMenu(context, ref, t, today),
                );
              },
            ),
    );
  }
}

class _RecentChart extends ConsumerWidget {
  const _RecentChart({required this.today});
  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final days = ref.watch(daysProvider((today.addDays(-6), today)));
    return AsyncView(
      value: days,
      data: (list) => ChartCard(
        title: l10n.todayRecent,
        settingsKey: 'today.recent',
        points: [
          for (final d in list)
            ChartPoint(
              label: l10n.weekdayShort(d.date.weekday),
              value: d.percent.toDouble(),
              detail: '${d.tasksDone}/${d.tasksTotal}',
              highlight: d.date == today,
            ),
        ],
      ),
    );
  }
}
