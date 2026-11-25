import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../design/palette.dart';
import '../../design/sketch.dart';
import '../../domain/models/week.dart';
import '../../domain/models/year.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/autosave_note.dart';
import '../../shared/widgets/chart_card.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../shared/widgets/section.dart';
import 'year_providers.dart';

/// Màn Kế hoạch năm (SPEC §10): Từ khoá + Tầm nhìn tự lưu, biểu đồ theo tháng, 12 thẻ tháng.
/// Web kéo thả việc giữa các tháng; trên điện thoại đổi thứ tự bằng menu Chuyển lên / xuống.
class YearPage extends ConsumerWidget {
  const YearPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(selectedYearProvider);
    final value = ref.watch(yearProvider(year));

    Future<void> refresh() async {
      ref.read(dataRevisionsProvider.notifier).bumpAll();
      await ref.read(yearProvider(year).future);
    }

    return PageScaffold(
      onRefresh: refresh,
      children: [
        AsyncView<YearDashboard>(
          value: value,
          onRetry: () => ref.invalidate(yearProvider(year)),
          data: (d) => _YearBody(data: d),
        ),
      ],
    );
  }
}

class _YearBody extends ConsumerWidget {
  const _YearBody({required this.data});
  final YearDashboard data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ctrl = ref.read(yearProvider(data.year).notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(data: data),
        const SizedBox(height: 12),
        AutosaveNote(
          title: l10n.yearKeyword,
          hint: l10n.yearKeywordHint,
          initial: data.keyword,
          resetKey: ('kw', data.year),
          onSave: (t) => ctrl.saveMeta(keyword: t),
        ),
        const SizedBox(height: 12),
        AutosaveNote(
          title: l10n.yearVision,
          hint: l10n.yearVisionHint,
          initial: data.vision,
          resetKey: ('vi', data.year),
          onSave: (t) => ctrl.saveMeta(vision: t),
        ),
        const SizedBox(height: 12),
        ChartCard(
          title: l10n.yearProgress,
          settingsKey: 'year.months',
          points: [
            for (final m in data.months)
              ChartPoint(
                label: context.dates.monthShort(m.month),
                value: m.percent.toDouble(),
                detail: '${m.done}/${m.total}',
                highlight: m.month == data.currentMonth,
              ),
          ],
        ),
        const SizedBox(height: 12),
        for (final m in data.months) ...[
          _MonthCard(year: data.year, month: m, current: m.month == data.currentMonth),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.data});
  final YearDashboard data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sel = ref.read(selectedYearProvider.notifier);
    final isThisYear = data.year == ref.watch(todayProvider).year;
    return SketchBox(
      seed: 51,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.yearTitle, style: Theme.of(context).textTheme.headlineSmall),
                Row(
                  children: [
                    IconButton(tooltip: '${data.year - 1}', icon: const Icon(Icons.chevron_left), onPressed: sel.previous),
                    Text('${data.year}', style: Theme.of(context).textTheme.titleLarge),
                    IconButton(tooltip: '${data.year + 1}', icon: const Icon(Icons.chevron_right), onPressed: sel.next),
                    if (!isThisYear) TextButton(onPressed: sel.reset, child: Text(l10n.yearThisYear)),
                  ],
                ),
                Text(l10n.yearDone(data.done, data.total), style: TextStyle(color: context.palette.muted)),
              ],
            ),
          ),
          ProgressRing(percent: data.percent, size: 68),
        ],
      ),
    );
  }
}

enum _ItemAction { rename, moveUp, moveDown, delete }

class _MonthCard extends ConsumerWidget {
  const _MonthCard({required this.year, required this.month, required this.current});
  final int year;
  final YearMonth month;
  final bool current;

  Future<void> _guard(BuildContext context, Future<void> Function() call) async {
    try {
      await call();
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final ctrl = ref.read(yearProvider(year).notifier);
    final items = month.items;

    Future<void> add() async {
      final t = await promptText(context, title: '${l10n.yearAddItem} ${month.month}');
      if (t == null || t.trim().isEmpty || !context.mounted) return;
      await _guard(context, () => ctrl.addItem(month.month, t.trim()));
    }

    Future<void> act(_ItemAction a, int i) async {
      final item = items[i];
      switch (a) {
        case _ItemAction.rename:
          final t = await promptText(context, title: l10n.edit, initial: item.title);
          if (t != null && t.trim().isNotEmpty && context.mounted) {
            await _guard(context, () => ctrl.updateItem(item.copyWith(title: t.trim())));
          }
        case _ItemAction.moveUp:
        case _ItemAction.moveDown:
          final list = [...items];
          final to = a == _ItemAction.moveUp ? i - 1 : i + 1;
          list.insert(to, list.removeAt(i));
          await _guard(context, () => ctrl.reorder(month.month, list));
        case _ItemAction.delete:
          if (await confirmDialog(context, '${l10n.delete}: "${item.title}"?') && context.mounted) {
            await _guard(context, () => ctrl.deleteItem(item.id));
          }
      }
    }

    return SectionCard(
      seed: 60 + month.month,
      title: l10n.yearMonth(month.month),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (current) ...[
            Pill(label: l10n.yearCurrentMonth, bg: p.accentSoft, fg: p.primaryText),
            const SizedBox(width: 6),
          ],
          Text('${month.done}/${month.total}', style: TextStyle(color: p.muted)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (month.total > 0) ...[ProgressBar(percent: month.percent), const SizedBox(height: 6)],
          for (final d in month.deadlines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(d.done ? Icons.check_circle : Icons.flag_outlined,
                      size: 18, color: d.done ? p.primary : (d.overdue ? p.dangerText : p.warnInk)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      d.kind == DeadlineKind.step ? '${d.title} · ${d.goalTitle}' : d.title,
                      style: TextStyle(fontSize: 13, color: p.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(context.dates.dayMonth(d.date), style: TextStyle(fontSize: 12, color: p.muted)),
                ],
              ),
            ),
          if (items.isEmpty && month.deadlines.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(l10n.yearMonthEmpty, style: TextStyle(color: p.muted)),
            ),
          for (var i = 0; i < items.length; i++)
            Row(
              children: [
                Checkbox(
                  value: items[i].done,
                  onChanged: (v) => _guard(context, () => ctrl.updateItem(items[i].copyWith(done: v ?? false))),
                ),
                Expanded(
                  child: Text(
                    items[i].title,
                    style: items[i].done ? TextStyle(decoration: TextDecoration.lineThrough, color: p.muted) : null,
                  ),
                ),
                PopupMenuButton<_ItemAction>(
                  onSelected: (a) => act(a, i),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: _ItemAction.rename, child: Text(l10n.edit)),
                    if (i > 0) PopupMenuItem(value: _ItemAction.moveUp, child: Text(l10n.moveUp)),
                    if (i < items.length - 1) PopupMenuItem(value: _ItemAction.moveDown, child: Text(l10n.moveDown)),
                    PopupMenuItem(
                      value: _ItemAction.delete,
                      child: Text(l10n.delete, style: TextStyle(color: p.dangerText)),
                    ),
                  ],
                ),
              ],
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(icon: const Icon(Icons.add), label: Text(l10n.add), onPressed: add),
          ),
        ],
      ),
    );
  }
}
