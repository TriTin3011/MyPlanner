import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../design/palette.dart';
import '../../design/sketch.dart';
import '../../domain/models/habit.dart';
import '../../domain/values/calendar_date.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/chart_card.dart';
import '../../shared/widgets/section.dart';
import 'habits_providers.dart';

/// Màn Theo dõi thói quen (SPEC §8): header, StatStrip, biểu đồ theo ngày, lưới tick.
class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final first = ref.watch(selectedHabitMonthProvider);
    final today = ref.watch(todayProvider);
    final value = ref.watch(habitMonthProvider(first));
    final l10n = AppLocalizations.of(context);

    Future<void> refresh() async {
      ref.read(dataRevisionsProvider.notifier).bumpAll();
      await ref.read(habitMonthProvider(first).future);
    }

    return PageScaffold(
      onRefresh: refresh,
      floating: FloatingActionButton(
        tooltip: l10n.habitsAdd,
        onPressed: () => _addHabit(context, ref),
        child: const Icon(Icons.add),
      ),
      children: [
        _MonthHeader(first: first, today: today),
        AsyncView<HabitMonth>(
          value: value,
          onRetry: () => ref.invalidate(habitMonthProvider(first)),
          data: (m) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatStrip(tiles: [
                StatTile(label: l10n.habitsMonthPercent, value: '${m.percent}%'),
                StatTile(
                  label: l10n.habitsLongestStreak,
                  value: m.longestStreak == null ? '—' : '${m.longestStreak!.value}',
                  sub: m.longestStreak?.title,
                ),
                StatTile(
                  label: l10n.habitsMostConsistent,
                  value: m.mostConsistent == null ? '—' : '${m.mostConsistent!.value}%',
                  sub: m.mostConsistent?.title,
                ),
              ]),
              const SizedBox(height: 12),
              ChartCard(
                title: l10n.habitsDaily,
                settingsKey: 'habits.daily',
                points: [
                  for (final d in m.days)
                    if (d.percent != null)
                      ChartPoint(
                        label: '${d.date.day}',
                        value: d.percent!.toDouble(),
                        detail: '${d.done}/${d.total}',
                        highlight: d.date == today,
                      ),
                ],
              ),
              const SizedBox(height: 12),
              _HabitGridCard(month: m, first: first, today: today),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _addHabit(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final name = await promptText(context, title: l10n.habitsAdd, hint: l10n.habitsName);
  if (name == null || name.trim().isEmpty) return;
  try {
    await ref.read(habitActionsProvider).create(name);
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}

class _MonthHeader extends ConsumerWidget {
  const _MonthHeader({required this.first, required this.today});
  final CalendarDate first;
  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sel = ref.read(selectedHabitMonthProvider.notifier);
    final isThis = first == today.firstOfMonth;
    return SketchBox(
      seed: 31,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.habitsTitle, style: Theme.of(context).textTheme.headlineSmall),
          Row(
            children: [
              IconButton(tooltip: '‹', icon: const Icon(Icons.chevron_left), onPressed: sel.previous),
              Expanded(
                child: Text(context.dates.monthYear(first),
                    textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              IconButton(tooltip: '›', icon: const Icon(Icons.chevron_right), onPressed: sel.next),
            ],
          ),
          if (!isThis) Center(child: TextButton(onPressed: sel.reset, child: Text(l10n.habitsThisMonth))),
        ],
      ),
    );
  }
}

enum _GridMode { month, week }

/// Lưới tick: cột tên dính bên trái, các cột ngày cuộn ngang (≈ `position: sticky` của web).
class _HabitGridCard extends ConsumerStatefulWidget {
  const _HabitGridCard({required this.month, required this.first, required this.today});
  final HabitMonth month;
  final CalendarDate first;
  final CalendarDate today;

  @override
  ConsumerState<_HabitGridCard> createState() => _HabitGridCardState();
}

class _HabitGridCardState extends ConsumerState<_HabitGridCard> {
  _GridMode _mode = _GridMode.month;
  final _scroll = ScrollController();

  static const _nameWidth = 128.0;
  static const _cell = 40.0;
  static const _rowH = 48.0;

  @override
  void initState() {
    super.initState();
    // Mở màn thì cuộn tới gần hôm nay, khỏi phải vuốt qua 20 cột.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    if (!_scroll.hasClients || _mode != _GridMode.month) return;
    final idx = widget.month.from.daysUntil(widget.today);
    if (idx < 0) return;
    final target = (idx - 3) * _cell;
    _scroll.jumpTo(target.clamp(0, _scroll.position.maxScrollExtent));
  }

  List<CalendarDate> get _days {
    final m = widget.month;
    if (_mode == _GridMode.month) {
      return [for (var d = m.from; !d.isAfter(m.to); d = d.addDays(1)) d];
    }
    final inMonth = !widget.today.isBefore(m.from) && !widget.today.isAfter(m.to);
    final monday = (inMonth ? widget.today : m.from).monday;
    return [
      for (var i = 0; i < 7; i++)
        if (!monday.addDays(i).isBefore(m.from) && !monday.addDays(i).isAfter(m.to)) monday.addDays(i),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final m = widget.month;
    final days = _days;
    final ctrl = ref.read(habitMonthProvider(widget.first).notifier);

    return SectionCard(
      title: l10n.navHabits,
      trailing: SegmentedButton<_GridMode>(
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: [
          ButtonSegment(value: _GridMode.month, label: Text(l10n.todayCalendarMonth)),
          ButtonSegment(value: _GridMode.week, label: Text(l10n.todayCalendarWeek)),
        ],
        selected: {_mode},
        onSelectionChanged: (s) {
          setState(() => _mode = s.first);
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
        },
      ),
      child: m.habits.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.habitsEmpty, style: TextStyle(color: p.muted)),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cột tên không cuộn ngang nên luôn nhìn thấy khi lướt qua các ngày.
                SizedBox(
                  width: _nameWidth,
                  child: Column(
                    children: [
                      const SizedBox(height: _rowH),
                      for (var i = 0; i < m.habits.length; i++)
                        _NameCell(row: m.habits[i], index: i, month: m, height: _rowH, first: widget.first),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scroll,
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Row(children: [
                          for (final d in days)
                            SizedBox(
                              width: _cell,
                              height: _rowH,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(l10n.weekdayShort(d.weekday), style: TextStyle(fontSize: 10, color: p.muted)),
                                  Text('${d.day}',
                                      style: TextStyle(
                                        fontWeight: d == widget.today ? FontWeight.w800 : FontWeight.w500,
                                        color: d == widget.today ? p.primaryText : p.ink,
                                      )),
                                ],
                              ),
                            ),
                        ]),
                        for (final h in m.habits)
                          Row(children: [
                            for (final d in days)
                              SizedBox(
                                width: _cell,
                                height: _rowH,
                                child: _TickCell(
                                  done: h.doneDates.contains(d),
                                  // Không tick ngày tương lai hoặc trước ngày bắt đầu thói quen.
                                  enabled: !d.isAfter(widget.today) && !d.isBefore(h.startDate),
                                  isToday: d == widget.today,
                                  label: '${h.title} ${context.dates.dayMonth(d)}',
                                  onChanged: (v) => ctrl.toggle(h.id, d, v).catchError((Object e) {
                                    if (context.mounted) showError(context, e);
                                  }),
                                ),
                              ),
                          ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _TickCell extends StatelessWidget {
  const _TickCell({
    required this.done,
    required this.enabled,
    required this.isToday,
    required this.label,
    required this.onChanged,
  });
  final bool done, enabled, isToday;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      checked: done,
      enabled: enabled,
      label: label,
      child: InkWell(
        onTap: enabled ? () => onChanged(!done) : null,
        customBorder: const CircleBorder(),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: done ? p.primary : (enabled ? p.surface : p.line.withValues(alpha: 0.35)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isToday ? p.ink : p.line, width: isToday ? 2 : 1),
            ),
            child: done ? Icon(Icons.check, size: 18, color: p.primaryInk) : null,
          ),
        ),
      ),
    );
  }
}

enum _HabitAction { rename, up, down, delete }

class _NameCell extends ConsumerWidget {
  const _NameCell({
    required this.row,
    required this.index,
    required this.month,
    required this.height,
    required this.first,
  });
  final HabitRow row;
  final int index;
  final HabitMonth month;
  final double height;
  final CalendarDate first;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return InkWell(
      onTap: () => _menu(context, ref),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(row.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600, color: p.ink)),
            Text('${row.percent}% · ${l10n.habitsStreak(row.currentStreak)}',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: p.muted)),
          ],
        ),
      ),
    );
  }

  /// Điện thoại không kéo thả trong lưới (dễ nhầm với vuốt ngang), nên sắp xếp qua menu Lên/Xuống.
  Future<void> _menu(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final last = month.habits.length - 1;
    final choice = await showModalBottomSheet<_HabitAction>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(row.title, style: Theme.of(c).textTheme.titleMedium),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.habitsRename),
              onTap: () => Navigator.pop(c, _HabitAction.rename),
            ),
            if (index > 0)
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: Text(l10n.moveUp),
                onTap: () => Navigator.pop(c, _HabitAction.up),
              ),
            if (index < last)
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(l10n.moveDown),
                onTap: () => Navigator.pop(c, _HabitAction.down),
              ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: p.dangerText),
              title: Text(l10n.delete, style: TextStyle(color: p.dangerText)),
              onTap: () => Navigator.pop(c, _HabitAction.delete),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    final actions = ref.read(habitActionsProvider);
    try {
      switch (choice) {
        case _HabitAction.rename:
          final name = await promptText(context, title: l10n.habitsRename, hint: l10n.habitsName, initial: row.title);
          if (name != null && name.trim().isNotEmpty) await actions.rename(row.id, name);
        case _HabitAction.up || _HabitAction.down:
          final rows = [...month.habits];
          final to = choice == _HabitAction.up ? index - 1 : index + 1;
          rows.insert(to, rows.removeAt(index));
          await ref.read(habitMonthProvider(first).notifier).reorder(rows);
        case _HabitAction.delete:
          if (await confirmDialog(context, l10n.habitsDeleteConfirm(row.title), confirmLabel: l10n.delete)) {
            await actions.delete(row.id);
          }
      }
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }
}
