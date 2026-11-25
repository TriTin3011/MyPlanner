import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/palette.dart';
import '../../domain/models/task.dart';
import '../../domain/values/calendar_date.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/section.dart';
import '../../shared/widgets/task_tile.dart';
import 'today_page.dart';
import 'today_providers.dart';

enum _CalendarMode { month, week }

/// Lịch "Lên kế hoạch" (SPEC §6): ô ngày tô theo % hoàn thành, cờ ⚑ khi có hạn.
/// Chạm một ô mở sheet danh sách việc của ngày đó.
class PlanningCalendar extends ConsumerStatefulWidget {
  const PlanningCalendar({super.key, required this.today});
  final CalendarDate today;

  @override
  ConsumerState<PlanningCalendar> createState() => _PlanningCalendarState();
}

class _PlanningCalendarState extends ConsumerState<PlanningCalendar> {
  _CalendarMode _mode = _CalendarMode.month;
  late CalendarDate _anchor = widget.today;

  /// Khoảng ngày hiển thị: tháng → đủ tuần chứa ngày 1 tới cuối tháng; tuần → T2..CN.
  (CalendarDate, CalendarDate) get _range {
    if (_mode == _CalendarMode.week) {
      final mon = _anchor.monday;
      return (mon, mon.addDays(6));
    }
    final first = _anchor.firstOfMonth;
    final last = first.addDays(first.daysInMonth - 1);
    return (first.monday, last.monday.addDays(6));
  }

  void _shift(int dir) => setState(() {
        _anchor = _mode == _CalendarMode.week ? _anchor.addDays(7 * dir) : _anchor.firstOfMonth.addMonths(dir);
      });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final range = _range;
    final days = ref.watch(daysProvider(range));
    final title = _mode == _CalendarMode.month
        ? context.dates.monthYear(_anchor)
        : '${context.dates.dayMonth(range.$1)} – ${context.dates.dayMonth(range.$2)}';

    return SectionCard(
      title: l10n.todayCalendar,
      trailing: SegmentedButton<_CalendarMode>(
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: [
          ButtonSegment(value: _CalendarMode.month, label: Text(l10n.todayCalendarMonth)),
          ButtonSegment(value: _CalendarMode.week, label: Text(l10n.todayCalendarWeek)),
        ],
        selected: {_mode},
        onSelectionChanged: (s) => setState(() => _mode = s.first),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _shift(-1)),
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => _anchor = widget.today),
                  child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: p.ink)),
                ),
              ),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _shift(1)),
            ],
          ),
          Row(
            children: [
              for (var w = 1; w <= 7; w++)
                Expanded(
                  child: Center(
                    child: Text(l10n.weekdayShort(w), style: TextStyle(fontSize: 11, color: p.muted)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          AsyncView(
            value: days,
            onRetry: () => ref.invalidate(daysProvider(range)),
            data: (list) {
              final byDate = {for (final d in list) d.date: d};
              final cells = <CalendarDate>[];
              for (var d = range.$1; !d.isAfter(range.$2); d = d.addDays(1)) {
                cells.add(d);
              }
              return GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: _mode == _CalendarMode.week ? 0.8 : 1,
                children: [
                  for (final d in cells)
                    _DayCell(
                      date: d,
                      progress: byDate[d],
                      isToday: d == widget.today,
                      outside: _mode == _CalendarMode.month && d.month != _anchor.month,
                      onTap: () => showDaySheet(context, d, widget.today),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.progress,
    required this.isToday,
    required this.outside,
    required this.onTap,
  });

  final CalendarDate date;
  final DayProgress? progress;
  final bool isToday, outside;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final pr = progress;
    final hasTasks = pr != null && pr.tasksTotal > 0;
    final fill = !hasTasks
        ? Colors.transparent
        : pr.percent >= 100
            ? p.primary.withValues(alpha: 0.55)
            : pr.percent > 0
                ? p.primary.withValues(alpha: 0.12 + pr.percent / 100 * 0.35)
                : p.accentTint;
    return Semantics(
      button: true,
      label: '${context.dates.full(date)}${hasTasks ? ', ${pr.tasksDone}/${pr.tasksTotal}' : ''}',
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Opacity(
          opacity: outside ? 0.4 : 1,
          child: Container(
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isToday ? p.ink : p.line, width: isToday ? 2 : 1),
            ),
            padding: const EdgeInsets.all(3),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('${date.day}',
                      style: TextStyle(fontSize: 12, fontWeight: isToday ? FontWeight.w800 : FontWeight.w500, color: p.ink)),
                ),
                if (pr?.hasDeadline ?? false)
                  Align(
                    alignment: Alignment.topRight,
                    child: Text('⚑', style: TextStyle(fontSize: 11, color: p.dangerText)),
                  ),
                if (hasTasks)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text('${pr.tasksDone}/${pr.tasksTotal}', style: TextStyle(fontSize: 10, color: p.muted)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sheet việc của một ngày (chạm ô lịch): tick, sửa, thêm việc cho đúng ngày đó.
Future<void> showDaySheet(BuildContext context, CalendarDate date, CalendarDate today) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.7,
      child: _DaySheet(date: date, today: today),
    ),
  );
}

class _DaySheet extends ConsumerWidget {
  const _DaySheet({required this.date, required this.today});
  final CalendarDate date, today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final tasks = ref.watch(dayTasksProvider(date));
    final actions = ref.read(todayActionsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.dayTasksTitle(context.dates.full(date)), style: Theme.of(context).textTheme.titleMedium),
              ),
              IconButton(
                tooltip: l10n.todayAddTask,
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => addTask(context, ref, date),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AsyncView(
              value: tasks,
              onRetry: () => ref.invalidate(dayTasksProvider(date)),
              data: (list) => list.isEmpty
                  ? Text(l10n.todayTasksEmpty, style: TextStyle(color: p.muted))
                  : ListView(
                      children: [
                        for (final t in list)
                          TaskTile(
                            key: ValueKey(t.id),
                            task: t,
                            dense: true,
                            onToggle: (v) => actions.toggleTask(t, v).catchError((Object e) {
                              if (context.mounted) showError(context, e);
                            }),
                            onMenu: () => openTaskMenu(context, ref, t, today),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
