import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/data_topics.dart';
import '../../design/palette.dart';
import '../../domain/models/goal.dart';
import '../../domain/values/calendar_date.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../shared/widgets/task_sheets.dart';
import 'goals_providers.dart';

/// FAB "Thêm mục tiêu": mở form, tạo xong thì mở luôn ngăn kéo để thêm bước (giống web).
Future<void> addGoal(BuildContext context, WidgetRef ref, LifeArea? area) async {
  final today = ref.read(todayProvider);
  final draft = await showGoalEditor(
    context,
    initial: GoalDraft(
      title: '',
      area: area ?? LifeArea.growth,
      status: GoalStatus.notStarted,
      startDate: today,
      deadline: today.addMonths(3),
    ),
    isNew: true,
  );
  if (draft == null || !context.mounted) return;
  try {
    final g = await ref.read(goalActionsProvider).create(draft);
    if (context.mounted) await showGoalDrawer(context, g.id);
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}

/// Form tạo / sửa mục tiêu. Trả `GoalDraft`, chưa gọi API.
Future<GoalDraft?> showGoalEditor(BuildContext context, {required GoalDraft initial, bool isNew = false}) =>
    showModalBottomSheet<GoalDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _GoalEditor(initial: initial, isNew: isNew),
    );

class _GoalEditor extends StatefulWidget {
  const _GoalEditor({required this.initial, required this.isNew});
  final GoalDraft initial;
  final bool isNew;

  @override
  State<_GoalEditor> createState() => _GoalEditorState();
}

class _GoalEditorState extends State<_GoalEditor> {
  late final _title = TextEditingController(text: widget.initial.title);
  late final _reward = TextEditingController(text: widget.initial.reward ?? '');
  late final _why = TextEditingController(text: widget.initial.why ?? '');
  late LifeArea _area = widget.initial.area;
  late GoalStatus _status = widget.initial.status;
  late CalendarDate _start = widget.initial.startDate;
  late CalendarDate _deadline = widget.initial.deadline;

  @override
  void dispose() {
    _title.dispose();
    _reward.dispose();
    _why.dispose();
    super.dispose();
  }

  void _save() {
    final title = _title.text.trim();
    if (title.isEmpty) return;
    // Backend cũng kiểm hạn >= ngày bắt đầu (FluentValidation); kiểm ở đây để báo sớm, không thay được kiểm ở server.
    if (_deadline.isBefore(_start)) {
      showInfo(context, AppLocalizations.of(context).goalsDeadlineBeforeStart);
      return;
    }
    String? opt(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
    Navigator.pop(
      context,
      GoalDraft(
        title: title,
        area: _area,
        status: _status,
        startDate: _start,
        deadline: _deadline,
        reward: opt(_reward),
        why: opt(_why),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.isNew ? l10n.goalsAdd : l10n.edit, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _title,
                autofocus: widget.isNew,
                maxLength: 200,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: l10n.goalsName, counterText: ''),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<LifeArea>(
                initialValue: _area,
                decoration: InputDecoration(labelText: l10n.goalsArea),
                items: [
                  for (final a in LifeArea.values)
                    DropdownMenuItem(
                      value: a,
                      child: Row(children: [
                        CircleAvatar(backgroundColor: areaColor(a), radius: 5),
                        const SizedBox(width: 8),
                        Text(l10n.area(a)),
                      ]),
                    ),
                ],
                onChanged: (v) => setState(() => _area = v ?? _area),
              ),
              const SizedBox(height: 12),
              Text(l10n.goalsStatus, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              SegmentedButton<GoalStatus>(
                segments: [
                  for (final s in GoalStatus.values) ButtonSegment(value: s, label: Text(l10n.status(s))),
                ],
                selected: {_status},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _status = s.first),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final d = await pickDate(context, _start);
                        if (d != null) setState(() => _start = d);
                      },
                      child: Text('${l10n.goalsStart}\n${context.dates.dayMonth(_start)}/${_start.year}',
                          textAlign: TextAlign.center),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final d = await pickDate(context, _deadline);
                        if (d != null) setState(() => _deadline = d);
                      },
                      child: Text('${l10n.goalsDeadline}\n${context.dates.dayMonth(_deadline)}/${_deadline.year}',
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reward,
                maxLength: 200,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: l10n.goalsReward, counterText: ''),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _why,
                minLines: 2,
                maxLines: 5,
                maxLength: 1000,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: l10n.goalsWhy, counterText: ''),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: _save, child: Text(l10n.save)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ngăn kéo chi tiết mục tiêu: bottom sheet kéo giãn được (`DraggableScrollableSheet`).
/// Web dùng drawer trượt từ phải; trên điện thoại sheet từ đáy dễ với ngón cái hơn.
Future<void> showGoalDrawer(BuildContext context, String id) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 1,
        builder: (_, scroll) => _GoalDrawer(id: id, scroll: scroll),
      ),
    );

class _GoalDrawer extends ConsumerWidget {
  const _GoalDrawer({required this.id, required this.scroll});
  final String id;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(goalDetailProvider(id));
    return AsyncView<Goal>(
      value: value,
      onRetry: () => ref.invalidate(goalDetailProvider(id)),
      data: (g) => _GoalDetail(goal: g, scroll: scroll),
    );
  }
}

class _GoalDetail extends ConsumerWidget {
  const _GoalDetail({required this.goal, required this.scroll});
  final Goal goal;
  final ScrollController scroll;

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
    final g = goal;
    final ctrl = ref.read(goalDetailProvider(g.id).notifier);
    final done = g.steps.where((s) => s.done).length;
    final pct = g.steps.isEmpty ? 0 : (done * 100 / g.steps.length).round();

    Future<void> edit() async {
      final d = await showGoalEditor(context, initial: GoalDraft.fromGoal(g));
      if (d != null && context.mounted) await _guard(context, () => ctrl.save(d));
    }

    Future<void> remove() async {
      if (!await confirmDialog(context, l10n.goalsDeleteConfirm(g.title), confirmLabel: l10n.delete)) return;
      if (!context.mounted) return;
      final nav = Navigator.of(context);
      await _guard(context, () async {
        await ref.read(goalActionsProvider).delete(g.id);
        nav.pop();
      });
    }

    Future<void> addStep() async {
      final title = await promptText(context, title: l10n.goalsAddStep, hint: l10n.goalsSteps);
      if (title == null || title.trim().isEmpty || !context.mounted) return;
      await _guard(context, () => ctrl.addStep(title.trim(), null));
    }

    return ListView(
      controller: scroll,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(g.title, style: Theme.of(context).textTheme.titleLarge)),
            IconButton(tooltip: l10n.edit, icon: const Icon(Icons.edit_outlined), onPressed: edit),
            IconButton(
              tooltip: l10n.delete,
              icon: Icon(Icons.delete_outline, color: p.dangerText),
              onPressed: remove,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            Text('${l10n.area(g.area)} · ${l10n.status(g.status)}', style: TextStyle(color: areaColor(g.area))),
            Text('${l10n.goalsStart}: ${context.dates.dayMonth(g.startDate)}/${g.startDate.year}',
                style: TextStyle(color: p.muted)),
            Text('${l10n.goalsDeadline}: ${context.dates.dayMonth(g.deadline)}/${g.deadline.year}',
                style: TextStyle(color: p.muted)),
          ],
        ),
        if (g.reward != null) ...[
          const SizedBox(height: 8),
          Text('${l10n.goalsReward}: ${g.reward}'),
        ],
        if (g.why != null) ...[
          const SizedBox(height: 8),
          Text('${l10n.goalsWhy}: ${g.why}', style: TextStyle(color: p.muted)),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Text(l10n.goalsSteps, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Text(l10n.goalsStepsProgress(done, g.steps.length), style: TextStyle(color: p.muted)),
          ],
        ),
        const SizedBox(height: 6),
        ProgressBar(percent: pct),
        const SizedBox(height: 8),
        if (g.steps.length > 1)
          Text(l10n.reorderHint, style: TextStyle(color: p.muted, fontSize: 12)),
        // Danh sách bước kéo thả được (nhấn giữ). Nằm trong ListView ngoài nên tắt cuộn riêng.
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorderItem: (from, to) {
            final list = [...g.steps];
            final item = list.removeAt(from);
            list.insert(to, item);
            _guard(context, () => ctrl.reorderSteps(list));
          },
          children: [
            for (var i = 0; i < g.steps.length; i++)
              _StepTile(
                key: ValueKey(g.steps[i].id),
                index: i,
                step: g.steps[i],
                onChanged: (s) => _guard(context, () => ctrl.updateStep(s)),
                onDelete: () => _guard(context, () => ctrl.deleteStep(g.steps[i].id)),
              ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(icon: const Icon(Icons.add), label: Text(l10n.goalsAddStep), onPressed: addStep),
        ),
      ],
    );
  }
}

enum _StepAction { rename, deadline, clearDeadline, delete }

class _StepTile extends StatelessWidget {
  const _StepTile({
    super.key,
    required this.index,
    required this.step,
    required this.onChanged,
    required this.onDelete,
  });
  final int index;
  final GoalStep step;
  final ValueChanged<GoalStep> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final s = step;
    return ReorderableDelayedDragStartListener(
      index: index,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minTileHeight: 48,
        leading: Checkbox(value: s.done, onChanged: (v) => onChanged(s.copyWith(done: v ?? false))),
        title: Text(
          s.title,
          style: s.done ? TextStyle(decoration: TextDecoration.lineThrough, color: p.muted) : null,
        ),
        subtitle: s.deadline == null
            ? null
            : Text('${l10n.goalsStepDeadline}: ${context.dates.dayMonth(s.deadline!)}',
                style: TextStyle(color: p.muted, fontSize: 12)),
        trailing: PopupMenuButton<_StepAction>(
          onSelected: (a) async {
            switch (a) {
              case _StepAction.rename:
                final t = await promptText(context, title: l10n.edit, initial: s.title);
                if (t != null && t.trim().isNotEmpty) onChanged(s.copyWith(title: t.trim()));
              case _StepAction.deadline:
                final d = await pickDate(context, s.deadline ?? CalendarDate.today());
                if (d != null) onChanged(s.copyWith(deadline: d));
              case _StepAction.clearDeadline:
                onChanged(s.copyWith(deadline: null));
              case _StepAction.delete:
                if (await confirmDialog(context, '${l10n.delete}: "${s.title}"?')) onDelete();
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: _StepAction.rename, child: Text(l10n.edit)),
            PopupMenuItem(value: _StepAction.deadline, child: Text(l10n.goalsStepDeadline)),
            if (s.deadline != null) PopupMenuItem(value: _StepAction.clearDeadline, child: Text(l10n.goalsClearDeadline)),
            PopupMenuItem(
              value: _StepAction.delete,
              child: Text(l10n.delete, style: TextStyle(color: p.dangerText)),
            ),
          ],
        ),
      ),
    );
  }
}
