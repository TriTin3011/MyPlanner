import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../design/palette.dart';
import '../../design/sketch.dart';
import '../../domain/models/goal.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../shared/widgets/section.dart';
import 'goal_sheets.dart';
import 'goals_providers.dart';

/// Màn Mục tiêu & tầm nhìn (SPEC §7): header, chip lọc lĩnh vực, radar cân bằng, thẻ mục tiêu.
/// Chạm thẻ mở ngăn kéo chi tiết (bottom sheet thay cho drawer bên phải của web).
class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(goalBoardProvider);
    final filter = ref.watch(goalAreaFilterProvider);
    final l10n = AppLocalizations.of(context);

    Future<void> refresh() async {
      ref.read(dataRevisionsProvider.notifier).bumpAll();
      await ref.read(goalBoardProvider.future);
    }

    return PageScaffold(
      onRefresh: refresh,
      floating: FloatingActionButton(
        tooltip: l10n.goalsAdd,
        onPressed: () => addGoal(context, ref, filter),
        child: const Icon(Icons.add),
      ),
      children: [
        AsyncView<GoalBoard>(
          value: value,
          onRetry: () => ref.invalidate(goalBoardProvider),
          data: (b) {
            final goals = filter == null ? b.goals : b.goals.where((g) => g.area == filter).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(board: b),
                const SizedBox(height: 12),
                _AreaChips(selected: filter),
                const SizedBox(height: 12),
                _BalanceCard(board: b),
                const SizedBox(height: 12),
                if (goals.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(l10n.goalsEmpty,
                        textAlign: TextAlign.center, style: TextStyle(color: context.palette.muted)),
                  )
                else
                  for (final g in goals) ...[
                    _GoalCardView(card: g),
                    const SizedBox(height: 12),
                  ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.board});
  final GoalBoard board;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SketchBox(
      seed: 41,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.goalsTitle, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(l10n.goalsDone(board.done, board.total), style: TextStyle(color: context.palette.muted)),
              ],
            ),
          ),
          ProgressRing(percent: board.percent, size: 68),
        ],
      ),
    );
  }
}

class _AreaChips extends ConsumerWidget {
  const _AreaChips({required this.selected});
  final LifeArea? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final f = ref.read(goalAreaFilterProvider.notifier);
    // Cuộn ngang thay vì xuống dòng: 9 chip xếp nhiều hàng sẽ đẩy nội dung chính xuống quá sâu.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(label: Text(l10n.goalsAll), selected: selected == null, onSelected: (_) => f.set(null)),
          for (final a in LifeArea.values)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ChoiceChip(
                avatar: CircleAvatar(backgroundColor: areaColor(a), radius: 5),
                label: Text(l10n.area(a)),
                selected: selected == a,
                onSelected: (_) => f.set(selected == a ? null : a),
              ),
            ),
        ],
      ),
    );
  }
}

/// Radar "Cân bằng các lĩnh vực" (fl_chart `RadarChart`) + nút Bảng như web.
class _BalanceCard extends StatefulWidget {
  const _BalanceCard({required this.board});
  final GoalBoard board;

  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard> {
  bool _table = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final byArea = {for (final a in widget.board.areas) a.area: a};
    int pct(LifeArea a) => byArea[a]?.percent ?? 0;

    return SectionCard(
      title: l10n.goalsRadar,
      trailing: IconButton(
        tooltip: l10n.chartTable,
        isSelected: _table,
        icon: const Icon(Icons.table_rows_outlined),
        onPressed: () => setState(() => _table = !_table),
      ),
      child: _table
          ? Column(
              children: [
                for (final a in LifeArea.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: areaColor(a), radius: 5),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l10n.area(a))),
                        Text('${byArea[a]?.count ?? 0}', style: TextStyle(color: p.muted)),
                        const SizedBox(width: 12),
                        SizedBox(width: 44, child: Text('${pct(a)}%', textAlign: TextAlign.end)),
                      ],
                    ),
                  ),
              ],
            )
          : SizedBox(
              height: 260,
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,
                  tickCount: 4,
                  ticksTextStyle: const TextStyle(fontSize: 0, color: Colors.transparent),
                  radarBorderData: BorderSide(color: p.line),
                  gridBorderData: BorderSide(color: p.line),
                  tickBorderData: BorderSide(color: p.line.withValues(alpha: 0.5)),
                  titleTextStyle: TextStyle(fontSize: 11, color: p.ink),
                  titlePositionPercentageOffset: 0.12,
                  getTitle: (i, _) => RadarChartTitle(text: l10n.area(LifeArea.values[i])),
                  dataSets: [
                    RadarDataSet(
                      fillColor: p.primary.withValues(alpha: 0.3),
                      borderColor: p.primary,
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: [for (final a in LifeArea.values) RadarEntry(value: pct(a).toDouble())],
                    ),
                    // Bộ dữ liệu ẩn 0–100 để thang đo luôn cố định, không co theo giá trị lớn nhất.
                    RadarDataSet(
                      fillColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      entryRadius: 0,
                      dataEntries: [for (var i = 0; i < LifeArea.values.length; i++) RadarEntry(value: i == 0 ? 100 : 0)],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _GoalCardView extends ConsumerWidget {
  const _GoalCardView({required this.card});
  final GoalCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final g = card;
    final days = g.daysLeft >= 0 ? l10n.goalsDaysLeft(g.daysLeft) : l10n.goalsOverdue(-g.daysLeft);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // Cả thẻ là một nút (giống "stretched button" ở web): vùng chạm lớn, đọc màn hình chỉ đọc một lần.
        onTap: () => showGoalDrawer(context, g.id),
        borderRadius: BorderRadius.circular(12),
        child: SketchBox(
          seed: g.id.hashCode & 0xff,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Pill(label: l10n.area(g.area), bg: areaColor(g.area).withValues(alpha: 0.15), fg: areaColor(g.area)),
                  const SizedBox(width: 6),
                  Pill(label: l10n.status(g.status), bg: p.accentSoft, fg: p.ink),
                  const Spacer(),
                  if (g.behind) Pill(label: l10n.goalsBehind, bg: p.dangerBg, fg: p.dangerText),
                ],
              ),
              const SizedBox(height: 8),
              Text(g.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ProgressBar(percent: g.stepPercent),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(l10n.goalsStepsProgress(g.stepsDone, g.stepsTotal), style: TextStyle(color: p.muted, fontSize: 13)),
                  const Spacer(),
                  Text('${l10n.goalsDeadline}: ${context.dates.dayMonth(g.deadline)} · $days',
                      style: TextStyle(
                        color: g.daysLeft < 0 && g.status != GoalStatus.done ? p.dangerText : p.muted,
                        fontSize: 13,
                      )),
                ],
              ),
              if (g.reward != null && g.reward!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('🎁 ${g.reward}', style: TextStyle(color: p.muted, fontSize: 13)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
