import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../design/palette.dart';
import '../../design/sketch.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/stats.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/chart_card.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../shared/widgets/section.dart';
import 'stats_providers.dart';

/// Màn Thống kê (SPEC §11): chip khoảng thời gian, hero, KPI, xu hướng, heatmap, theo thứ,
/// thói quen, mục tiêu. Mọi con số đến từ `GET /api/stats`, app không tự đếm.
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(statsRangeProvider);
    final value = ref.watch(statsProvider(range));

    Future<void> refresh() async {
      ref.read(dataRevisionsProvider.notifier).bumpAll();
      await ref.read(statsProvider(range).future);
    }

    return PageScaffold(
      onRefresh: refresh,
      children: [
        _RangeChips(selected: range),
        const SizedBox(height: 12),
        AsyncView<Stats>(
          value: value,
          onRetry: () => ref.invalidate(statsProvider(range)),
          data: (s) => _StatsBody(stats: s),
        ),
      ],
    );
  }
}

extension on AppLocalizations {
  String range(StatsRange r) => switch (r) {
        StatsRange.w4 => statsRange4w,
        StatsRange.w8 => statsRange8w,
        StatsRange.w12 => statsRange12w,
        StatsRange.m6 => statsRange6m,
        StatsRange.y1 => statsRange1y,
      };
}

class _RangeChips extends ConsumerWidget {
  const _RangeChips({required this.selected});
  final StatsRange selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final r in StatsRange.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(l10n.range(r)),
                selected: r == selected,
                onSelected: (_) => ref.read(statsRangeProvider.notifier).set(r),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.stats});
  final Stats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = stats;
    final empty = s.hero.tasksTotal == 0 && s.habits.isEmpty && s.goals.total == 0;
    if (empty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(l10n.statsEmpty, textAlign: TextAlign.center, style: TextStyle(color: context.palette.muted)),
      );
    }
    final maxWeekday = s.weekdays.fold<double>(0, (m, w) => math.max(m, w.averageDone));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Hero(stats: s),
        const SizedBox(height: 12),
        StatStrip(tiles: [
          StatTile(
            label: l10n.statsTasksDone,
            value: '${s.kpis.tasksDone}',
            sub: s.kpis.tasksDonePercentChange == null ? null : _signed(s.kpis.tasksDonePercentChange!, '%'),
          ),
          StatTile(
            label: l10n.statsActivityStreak,
            value: '${s.kpis.activityCurrentStreak}',
            sub: l10n.statsLongest(s.kpis.activityLongestStreak),
          ),
          StatTile(
            label: l10n.statsHabit,
            value: '${s.kpis.habitPercent}%',
            sub: l10n.statsDelta(_signed(s.kpis.habitDeltaPoints, '')),
          ),
        ]),
        const SizedBox(height: 12),
        ChartCard(
          title: l10n.statsTrend,
          settingsKey: 'stats.trend',
          header: Text(l10n.statsAverage(s.trendAverage), style: TextStyle(color: context.palette.muted)),
          points: [
            for (final w in s.trend)
              ChartPoint(
                label: context.dates.dayMonth(w.monday),
                value: w.percent.toDouble(),
                detail: '${w.done}/${w.total}',
              ),
          ],
        ),
        const SizedBox(height: 12),
        _Heatmap(days: s.heatmap),
        const SizedBox(height: 12),
        ChartCard(
          title: l10n.statsWeekday,
          settingsKey: 'stats.weekday',
          unit: '',
          // Trục Y theo giá trị lớn nhất (làm tròn lên) vì đây là số việc trung bình, không phải %.
          maxY: math.max(1, maxWeekday.ceilToDouble()),
          points: [
            for (final w in s.weekdays)
              ChartPoint(
                label: l10n.weekdayShort(w.weekday),
                value: w.averageDone,
                highlight: w.weekday == s.hero.bestWeekday,
              ),
          ],
        ),
        const SizedBox(height: 12),
        _HabitsCard(habits: s.habits),
        const SizedBox(height: 12),
        _GoalsCard(goals: s.goals),
      ],
    );
  }
}

String _signed(int v, String unit) => '${v > 0 ? '+' : ''}$v$unit';

class _Hero extends StatelessWidget {
  const _Hero({required this.stats});
  final Stats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final h = stats.hero;
    final best = h.bestWeekday == null ? null : stats.from.monday.addDays(h.bestWeekday! - 1);
    return SketchBox(
      seed: 71,
      child: Row(
        children: [
          ProgressRing(percent: h.completionPercent, size: 84),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.statsCompletion, style: Theme.of(context).textTheme.titleMedium),
                Text('${h.tasksDone}/${h.tasksTotal}', style: TextStyle(color: p.muted)),
                const SizedBox(height: 4),
                Text(
                  l10n.statsDelta(_signed(h.deltaPoints, '')),
                  style: TextStyle(color: h.deltaPoints < 0 ? p.dangerText : p.primaryText, fontSize: 13),
                ),
                if (best != null)
                  Text(l10n.statsBestWeekday(context.dates.weekdayLong(best)),
                      style: TextStyle(color: p.muted, fontSize: 13)),
                Text('${context.dates.dayMonth(stats.from)} – ${context.dates.dayMonth(stats.to)}',
                    style: TextStyle(color: p.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lịch hoạt động kiểu GitHub: mỗi cột một tuần (Thứ 2 → CN), màu theo `level` 0–4 backend chia sẵn.
class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.days});
  final List<StatsHeatmapDay> days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    if (days.isEmpty) return const SizedBox.shrink();
    final first = days.first.date.monday;
    final byDate = {for (final d in days) d.date: d};
    final weeks = (first.daysUntil(days.last.date) ~/ 7) + 1;
    Color shade(int level) =>
        level <= 0 ? p.line.withValues(alpha: 0.35) : p.primary.withValues(alpha: 0.25 + 0.75 * (level / 4));
    const cell = 14.0, gap = 3.0;
    return SectionCard(
      title: l10n.statsHeatmap,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true, // tuần gần nhất ở bên phải và hiện ngay khi mở
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                for (var r = 0; r < 7; r++)
                  SizedBox(
                    height: cell + gap,
                    width: 22,
                    child: r.isEven ? Text(l10n.weekdayShort(r + 1), style: TextStyle(fontSize: 9, color: p.muted)) : null,
                  ),
              ],
            ),
            for (var w = 0; w < weeks; w++)
              Padding(
                padding: const EdgeInsets.only(right: gap),
                child: Column(
                  children: [
                    for (var r = 0; r < 7; r++)
                      Builder(builder: (_) {
                        final date = first.addDays(w * 7 + r);
                        final d = byDate[date];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: gap),
                          child: Tooltip(
                            message: d == null ? '' : '${context.dates.dayMonth(date)}: ${d.done}',
                            child: Container(
                              width: cell,
                              height: cell,
                              decoration: BoxDecoration(
                                color: d == null ? Colors.transparent : shade(d.level),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HabitsCard extends StatelessWidget {
  const _HabitsCard({required this.habits});
  final List<StatsHabit> habits;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    if (habits.isEmpty) return const SizedBox.shrink();
    return SectionCard(
      title: l10n.statsHabits,
      child: Column(
        children: [
          for (final h in habits)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(h.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Text('${h.percent}%', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ProgressBar(percent: h.percent),
                  const SizedBox(height: 2),
                  Text(
                    '${h.doneDays}/${h.possibleDays} · ${l10n.habitsStreak(h.currentStreak)} · ${l10n.statsLongest(h.longestStreak)}',
                    style: TextStyle(color: p.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  const _GoalsCard({required this.goals});
  final StatsGoals goals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final g = goals;
    if (g.total == 0) return const SizedBox.shrink();
    return SectionCard(
      title: l10n.statsGoals,
      trailing: Text('${g.percentDone}%', style: const TextStyle(fontWeight: FontWeight.w700)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Pill(label: '${l10n.status(GoalStatus.notStarted)}: ${g.notStarted}', bg: p.accentTint, fg: p.ink),
              Pill(label: '${l10n.status(GoalStatus.inProgress)}: ${g.inProgress}', bg: p.importantBg, fg: p.importantFg),
              Pill(label: '${l10n.status(GoalStatus.done)}: ${g.done}', bg: p.accentSoft, fg: p.primaryText),
            ],
          ),
          const SizedBox(height: 10),
          for (final a in g.byArea)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: areaColor(a.area), radius: 5),
                  const SizedBox(width: 8),
                  SizedBox(width: 96, child: Text(l10n.area(a.area), style: const TextStyle(fontSize: 13))),
                  Expanded(child: ProgressBar(percent: a.total == 0 ? 0 : (a.done * 100 / a.total).round())),
                  const SizedBox(width: 8),
                  Text('${a.done}/${a.total}', style: TextStyle(color: p.muted, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
