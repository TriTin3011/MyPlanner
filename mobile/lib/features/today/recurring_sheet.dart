import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/palette.dart';
import '../../domain/models/task.dart';
import '../../domain/values/calendar_date.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/labels.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/task_sheets.dart';
import 'today_providers.dart';

/// Sheet "Việc lặp lại" (bản điện thoại của `RecurringModal` bên web).
Future<void> showRecurringSheet(BuildContext context, CalendarDate today) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => FractionallySizedBox(heightFactor: 0.85, child: _RecurringSheet(today: today)),
  );
}

class _RecurringSheet extends ConsumerWidget {
  const _RecurringSheet({required this.today});
  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final list = ref.watch(recurringListProvider);
    final actions = ref.read(todayActionsProvider);

    Future<void> edit([RecurringTask? r]) async {
      final saved = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _RecurringForm(existing: r, today: today),
      );
      if (saved == true && context.mounted) showInfo(context, l10n.saved);
    }

    String weekdaysText(List<int> days) => days.length == 7
        ? l10n.recurringEveryday
        : ([...days]..sort()).map(l10n.weekdayShort).join(', ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.recurringTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Expanded(
            child: AsyncView(
              value: list,
              onRetry: () => ref.invalidate(recurringListProvider),
              data: (items) => items.isEmpty
                  ? Text(l10n.recurringEmpty, style: TextStyle(color: p.muted))
                  : ListView(
                      children: [
                        for (final r in items)
                          ListTile(
                            key: ValueKey(r.id),
                            contentPadding: EdgeInsets.zero,
                            title: Text(r.title,
                                style: TextStyle(color: r.active ? p.ink : p.muted)),
                            subtitle: Text(
                                '${weekdaysText(r.weekdays)} · ${l10n.recurringStart} ${context.dates.dayMonth(r.startDate)}'),
                            onTap: () => edit(r),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: r.active,
                                  onChanged: (v) => actions.setRecurringActive(r, v).catchError((Object e) {
                                    if (context.mounted) showError(context, e);
                                  }),
                                ),
                                IconButton(
                                  tooltip: l10n.delete,
                                  icon: Icon(Icons.delete_outline, color: p.dangerText),
                                  onPressed: () async {
                                    if (!await confirmDialog(context, '${l10n.delete} "${r.title}"?')) return;
                                    try {
                                      await actions.deleteRecurring(r.id);
                                    } catch (e) {
                                      if (context.mounted) showError(context, e);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.recurringAdd),
            onPressed: () => edit(),
          ),
        ],
      ),
    );
  }
}

class _RecurringForm extends ConsumerStatefulWidget {
  const _RecurringForm({required this.existing, required this.today});
  final RecurringTask? existing;
  final CalendarDate today;

  @override
  ConsumerState<_RecurringForm> createState() => _RecurringFormState();
}

class _RecurringFormState extends ConsumerState<_RecurringForm> {
  late final TextEditingController _title = TextEditingController(text: widget.existing?.title ?? '');
  late final Set<int> _days = {...?widget.existing?.weekdays};
  late final Set<TaskTag> _tags = {...?widget.existing?.tags};
  late CalendarDate _start = widget.existing?.startDate ?? widget.today;
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty || _days.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(todayActionsProvider).saveRecurring(
            existing: widget.existing,
            title: title,
            weekdays: [..._days]..sort(),
            tags: TaskTag.values.where(_tags.contains).toList(),
            start: _start,
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showError(context, e);
      }
    }
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
              Text(widget.existing == null ? l10n.recurringAdd : l10n.edit,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _title,
                autofocus: widget.existing == null,
                maxLength: 200,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: l10n.taskTitle, counterText: ''),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(l10n.recurringWeekdays, style: Theme.of(context).textTheme.labelLarge)),
                  TextButton(
                    onPressed: () => setState(() => _days.length == 7 ? _days.clear() : _days.addAll([1, 2, 3, 4, 5, 6, 7])),
                    child: Text(l10n.recurringEveryday),
                  ),
                ],
              ),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var d = 1; d <= 7; d++)
                    FilterChip(
                      label: Text(l10n.weekdayShort(d)),
                      selected: _days.contains(d),
                      onSelected: (on) => setState(() => on ? _days.add(d) : _days.remove(d)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(l10n.taskTags, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  for (final t in TaskTag.values)
                    FilterChip(
                      label: Text(l10n.tag(t)),
                      selected: _tags.contains(t),
                      onSelected: (on) => setState(() => on ? _tags.add(t) : _tags.remove(t)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.event_outlined),
                label: Text('${l10n.recurringStart}: ${context.dates.full(_start)}'),
                onPressed: () async {
                  final d = await pickDate(context, _start);
                  if (d != null) setState(() => _start = d);
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _save,
                child: _busy
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
