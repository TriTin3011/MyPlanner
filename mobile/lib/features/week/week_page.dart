import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../design/palette.dart';
import '../../design/sketch.dart';
import '../../domain/models/task.dart';
import '../../domain/models/week.dart';
import '../../domain/values/calendar_date.dart';
import '../../domain/values/week_key.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/autosave_note.dart';
import '../../shared/widgets/chart_card.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../shared/widgets/section.dart';
import '../../shared/widgets/task_sheets.dart';
import '../../shared/widgets/task_tile.dart';
import 'week_providers.dart';

/// Màn Kế hoạch tuần (SPEC §9). Điện thoại: 7 ngày xếp dọc, chuyển việc sang ngày khác
/// qua menu ⋯ "Chọn ngày khác" thay cho kéo thả giữa các cột như trên web.
class WeekPage extends ConsumerWidget {
  const WeekPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = ref.watch(selectedWeekProvider);
    final today = ref.watch(todayProvider);
    final l10n = AppLocalizations.of(context);

    Future<void> refresh() async {
      ref.read(dataRevisionsProvider.notifier).bumpAll();
      await ref.read(weekDashboardProvider(key).future);
    }

    return PageScaffold(
      onRefresh: refresh,
      floating: FloatingActionButton(
        tooltip: l10n.todayAddTask,
        onPressed: () => _addTask(context, ref, today.isBefore(key.monday) || today.isAfter(key.sunday) ? key.monday : today),
        child: const Icon(Icons.add),
      ),
      children: [
        _WeekHeader(weekKey: key, today: today),
        _WeekChart(weekKey: key, today: today),
        _WeekNote(weekKey: key),
        _Deadlines(weekKey: key),
        _WeekDays(weekKey: key, today: today),
        _ClearWeek(weekKey: key),
      ],
    );
  }
}

Future<void> _addTask(BuildContext context, WidgetRef ref, CalendarDate date) async {
  final draft = await showTaskEditor(context, initial: TaskDraft(title: '', date: date), isNew: true);
  if (draft == null) return;
  try {
    await ref.read(weekActionsProvider).create(draft);
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}

class _WeekHeader extends ConsumerWidget {
  const _WeekHeader({required this.weekKey, required this.today});
  final WeekKey weekKey;
  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final sel = ref.read(selectedWeekProvider.notifier);
    final isThis = weekKey == WeekKey.of(today);
    final dash = ref.watch(weekDashboardProvider(weekKey));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SketchBox(
          seed: 21,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.weekTitle, style: Theme.of(context).textTheme.headlineSmall),
              Row(
                children: [
                  IconButton(tooltip: l10n.weekPrev, icon: const Icon(Icons.chevron_left), onPressed: sel.previous),
                  Expanded(
                    child: Text(
                      l10n.weekRange(weekKey.week, context.dates.dayMonth(weekKey.monday),
                          context.dates.dayMonth(weekKey.sunday)),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700, color: p.ink),
                    ),
                  ),
                  IconButton(tooltip: l10n.weekNext, icon: const Icon(Icons.chevron_right), onPressed: sel.next),
                ],
              ),
              if (!isThis)
                Center(child: TextButton(onPressed: sel.reset, child: Text(l10n.weekThis))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AsyncView<WeekDashboard>(
          value: dash,
          onRetry: () => ref.invalidate(weekDashboardProvider(weekKey)),
          data: (d) {
            final pct = d.tasksTotal == 0 ? 0 : (d.tasksDone * 100 / d.tasksTotal).round();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StatStrip(tiles: [
                  StatTile(label: l10n.weekTasksDone, value: '${d.tasksDone}/${d.tasksTotal}', sub: '$pct%'),
                  StatTile(label: l10n.weekHabitPercent, value: '${d.habitPercent}%'),
                  StatTile(label: l10n.weekTodayRemaining, value: '${d.todayRemaining}'),
                ]),
                if (d.comment.isNotEmpty || d.insights.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(d.comment, style: TextStyle(color: p.ink, fontWeight: FontWeight.w600)),
                  for (final s in d.insights)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('• $s', style: TextStyle(color: p.muted, fontSize: 13)),
                    ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

enum _ChartRange { w1, w4, w12 }

class _WeekChart extends ConsumerStatefulWidget {
  const _WeekChart({required this.weekKey, required this.today});
  final WeekKey weekKey;
  final CalendarDate today;

  @override
  ConsumerState<_WeekChart> createState() => _WeekChartState();
}

class _WeekChartState extends ConsumerState<_WeekChart> {
  _ChartRange _range = _ChartRange.w1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final key = widget.weekKey;
    final picker = SegmentedButton<_ChartRange>(
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact),
      segments: [
        ButtonSegment(value: _ChartRange.w1, label: Text(l10n.weekRange1)),
        ButtonSegment(value: _ChartRange.w4, label: Text(l10n.weekRange4)),
        ButtonSegment(value: _ChartRange.w12, label: Text(l10n.weekRange12)),
      ],
      selected: {_range},
      onSelectionChanged: (s) => setState(() => _range = s.first),
    );

    ChartCard card(List<ChartPoint> points) => ChartCard(
          title: l10n.weekProgress,
          settingsKey: 'week.progress',
          header: Align(alignment: Alignment.centerLeft, child: picker),
          points: points,
        );

    if (_range == _ChartRange.w12) {
      final weeks = ref.watch(weeksProvider(key.sunday));
      return AsyncView(
        value: weeks,
        onRetry: () => ref.invalidate(weeksProvider(key.sunday)),
        data: (list) => card([
          for (final w in list)
            ChartPoint(
              label: 'W${w.weekKey.week}',
              value: w.percent.toDouble(),
              detail: '${w.tasksDone}/${w.tasksTotal}',
              highlight: w.weekKey == key,
            ),
        ]),
      );
    }

    final from = _range == _ChartRange.w1 ? key.monday : key.monday.addDays(-21);
    final days = ref.watch(weekDaysRangeProvider((from, key.sunday)));
    return AsyncView(
      value: days,
      onRetry: () => ref.invalidate(weekDaysRangeProvider((from, key.sunday))),
      data: (list) => card([
        for (final d in list)
          ChartPoint(
            label: _range == _ChartRange.w1 ? l10n.weekdayShort(d.date.weekday) : context.dates.dayMonth(d.date),
            value: d.percent.toDouble(),
            detail: '${d.tasksDone}/${d.tasksTotal}',
            highlight: d.date == widget.today,
          ),
      ]),
    );
  }
}

class _WeekNote extends ConsumerWidget {
  const _WeekNote({required this.weekKey});
  final WeekKey weekKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final note = ref.watch(weekNoteProvider(weekKey));
    return AsyncView(
      value: note,
      onRetry: () => ref.invalidate(weekNoteProvider(weekKey)),
      data: (text) => AutosaveNote(
        title: l10n.weekNote,
        hint: l10n.weekNoteHint,
        initial: text,
        resetKey: weekKey,
        onSave: (t) => ref.read(weekActionsProvider).saveNote(weekKey, t),
      ),
    );
  }
}

class _Deadlines extends ConsumerWidget {
  const _Deadlines({required this.weekKey});
  final WeekKey weekKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final value = ref.watch(weekDeadlinesProvider(weekKey));
    // Không có hạn thì ẩn hẳn khối, đỡ chiếm chỗ trên điện thoại.
    final list = value.value ?? const <Deadline>[];
    if (list.isEmpty) return const SizedBox.shrink();
    return SectionCard(
      title: l10n.weekDeadlines,
      child: Column(
        children: [
          for (final d in list)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                d.done ? Icons.check_circle : Icons.flag_outlined,
                color: d.done ? p.primary : (d.overdue ? p.dangerText : p.warnInk),
              ),
              title: Text(d.title,
                  style: TextStyle(decoration: d.done ? TextDecoration.lineThrough : null, color: p.ink)),
              subtitle: Text(d.kind == DeadlineKind.step ? d.goalTitle : l10n.navGoals),
              trailing: Text(context.dates.dayMonth(d.date),
                  style: TextStyle(color: d.overdue ? p.dangerText : p.muted, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class _WeekDays extends ConsumerWidget {
  const _WeekDays({required this.weekKey, required this.today});
  final WeekKey weekKey;
  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final tasks = ref.watch(weekTasksProvider(weekKey));
    final dash = ref.watch(weekDashboardProvider(weekKey)).value;
    final actions = ref.read(weekActionsProvider);

    return AsyncView<List<Task>>(
      value: tasks,
      onRetry: () => ref.invalidate(weekTasksProvider(weekKey)),
      data: (all) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final day in weekKey.days) ...[
            Builder(builder: (context) {
              final items = all.where((t) => t.date == day).toList()..sort((a, b) => a.order.compareTo(b.order));
              final progress = dash?.days.where((d) => d.date == day).firstOrNull;
              final isToday = day == today;
              return SectionCard(
                seed: day.day * 7,
                title: '${context.dates.weekdayLong(day)} · ${context.dates.dayMonth(day)}${isToday ? ' ★' : ''}',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (progress != null && progress.tasksTotal > 0)
                      SizedBox(width: 64, child: ProgressBar(percent: progress.percent)),
                    IconButton(
                      tooltip: l10n.todayAddTask,
                      icon: const Icon(Icons.add),
                      onPressed: () => _addTask(context, ref, day),
                    ),
                  ],
                ),
                child: items.isEmpty
                    ? Text('—', style: TextStyle(color: p.muted))
                    : Column(
                        children: [
                          for (final t in items)
                            TaskTile(
                              key: ValueKey(t.id),
                              task: t,
                              dense: true,
                              onToggle: (v) => actions.toggle(t, v).catchError((Object e) {
                                if (context.mounted) showError(context, e);
                              }),
                              onTap: () => _menu(context, t, actions),
                              onMenu: () => _menu(context, t, actions),
                            ),
                        ],
                      ),
              );
            }),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Future<void> _menu(BuildContext context, Task t, WeekActions actions) =>
      runTaskMenu(context, t, today: today, update: actions.update, delete: actions.delete);
}

/// "Xóa dữ liệu tuần đang xem": xác nhận 2 bước như web (nút → hộp thoại nêu rõ hậu quả).
class _ClearWeek extends ConsumerWidget {
  const _ClearWeek({required this.weekKey});
  final WeekKey weekKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return Center(
      child: TextButton.icon(
        icon: Icon(Icons.delete_sweep_outlined, color: p.dangerText),
        label: Text(l10n.weekClear, style: TextStyle(color: p.dangerText)),
        onPressed: () async {
          final ok = await confirmDialog(context, l10n.weekClearConfirm(weekKey.toString()), confirmLabel: l10n.delete);
          if (!ok) return;
          try {
            final r = await ref.read(weekActionsProvider).clear(weekKey);
            if (context.mounted) showInfo(context, l10n.weekCleared(r.tasks, r.habitLogs));
          } catch (e) {
            if (context.mounted) showError(context, e);
          }
        },
      ),
    );
  }
}
