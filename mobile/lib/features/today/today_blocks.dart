import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/palette.dart';
import '../../domain/models/task.dart';
import '../../domain/models/today.dart';
import '../../domain/values/calendar_date.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/autosave_note.dart';
import '../../shared/widgets/section.dart';
import '../../shared/widgets/task_tile.dart';
import 'today_page.dart';
import 'today_providers.dart';

/// Thói quen của hôm nay: tick là lưu luôn (optimistic).
class HabitsCard extends ConsumerWidget {
  const HabitsCard({super.key, required this.dashboard});
  final TodayDashboard dashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final habits = dashboard.habits;
    return SectionCard(
      title: l10n.todayHabits,
      child: habits.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.todayHabitsEmpty, style: TextStyle(color: p.muted)),
            )
          : Column(
              children: [
                for (final h in habits)
                  CheckboxListTile(
                    key: ValueKey(h.id),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    value: h.done,
                    title: Text(
                      h.title,
                      style: TextStyle(
                        decoration: h.done ? TextDecoration.lineThrough : null,
                        color: h.done ? p.muted : p.ink,
                      ),
                    ),
                    onChanged: (v) => ref
                        .read(todayActionsProvider)
                        .toggleHabit(h.id, dashboard.date, v ?? false)
                        .catchError((Object e) {
                      if (context.mounted) showError(context, e);
                    }),
                  ),
              ],
            ),
    );
  }
}

/// Ghi chú trong ngày: bọc `AutosaveNote` dùng chung, lưu qua `TodayActions.saveNote`.
class NoteCard extends ConsumerWidget {
  const NoteCard({super.key, required this.date, required this.initial});
  final CalendarDate date;
  final String initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(todayActionsProvider);
    return AutosaveNote(
      title: l10n.todayNote,
      hint: l10n.todayNoteHint,
      initial: initial,
      resetKey: date,
      onSave: (text) => actions.saveNote(date, text),
    );
  }
}

/// Việc còn tồn từ những ngày trước (chưa xong), kèm nút "chuyển hết về hôm nay".
class BacklogCard extends ConsumerWidget {
  const BacklogCard({super.key, required this.tasks, required this.today});
  final List<Task> tasks;
  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(todayActionsProvider);
    return SectionCard(
      title: '${l10n.todayBacklog} (${tasks.length})',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final t in tasks)
            TaskTile(
              key: ValueKey(t.id),
              task: t,
              today: today,
              dense: true,
              onToggle: (v) => actions.toggleTask(t, v).catchError((Object e) {
                if (context.mounted) showError(context, e);
              }),
              onTap: () => openTaskMenu(context, ref, t, today),
              onMenu: () => openTaskMenu(context, ref, t, today),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.move_down),
            label: Text(l10n.todayBacklogMove),
            onPressed: () async {
              try {
                final n = await actions.moveBacklog(today);
                if (context.mounted) showInfo(context, l10n.todayBacklogMoved(n));
              } catch (e) {
                if (context.mounted) showError(context, e);
              }
            },
          ),
        ],
      ),
    );
  }
}
