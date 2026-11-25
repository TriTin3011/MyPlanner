import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../domain/models/task.dart';
import '../../domain/values/calendar_date.dart';
import '../../l10n/app_localizations.dart';
import '../labels.dart';
import 'async_view.dart';

/// Hành động người dùng chọn trong menu ⋯ của một việc.
enum TaskAction { edit, moveDate, moveToday, delete }

/// Menu ⋯ dạng bottom sheet (SPEC §3.4: modal trên điện thoại mở từ đáy).
Future<TaskAction?> showTaskMenu(BuildContext context, Task task, {required CalendarDate today}) {
  final l10n = AppLocalizations.of(context);
  final p = context.palette;
  return showModalBottomSheet<TaskAction>(
    context: context,
    showDragHandle: true,
    builder: (c) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(task.title, style: Theme.of(c).textTheme.titleMedium, maxLines: 2),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.taskEdit),
            onTap: () => Navigator.pop(c, TaskAction.edit),
          ),
          ListTile(
            leading: const Icon(Icons.event_outlined),
            title: Text(l10n.taskMoveDate),
            onTap: () => Navigator.pop(c, TaskAction.moveDate),
          ),
          if (task.date != today)
            ListTile(
              leading: const Icon(Icons.today_outlined),
              title: Text(l10n.taskMoveToday),
              onTap: () => Navigator.pop(c, TaskAction.moveToday),
            ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: p.dangerText),
            title: Text(l10n.taskDelete, style: TextStyle(color: p.dangerText)),
            onTap: () => Navigator.pop(c, TaskAction.delete),
          ),
        ],
      ),
    ),
  );
}

/// Chạy trọn menu ⋯: hỏi hành động → mở form / chọn ngày / xác nhận xoá → gọi callback.
/// Màn nào cũng dùng được (Hôm nay, Tuần) vì việc ghi dữ liệu nằm ở callback do màn truyền vào.
Future<void> runTaskMenu(
  BuildContext context,
  Task task, {
  required CalendarDate today,
  required Future<void> Function(String id, TaskDraft draft) update,
  required Future<void> Function(String id) delete,
}) async {
  final l10n = AppLocalizations.of(context);
  final choice = await showTaskMenu(context, task, today: today);
  if (choice == null || !context.mounted) return;
  try {
    switch (choice) {
      case TaskAction.edit:
        final draft = await showTaskEditor(context, initial: TaskDraft.fromTask(task));
        if (draft != null) await update(task.id, draft);
      case TaskAction.moveDate:
        final date = await pickDate(context, task.date);
        if (date != null) await update(task.id, TaskDraft.fromTask(task).copyWith(date: date));
      case TaskAction.moveToday:
        await update(task.id, TaskDraft.fromTask(task).copyWith(date: today));
      case TaskAction.delete:
        if (await confirmDialog(context, '${l10n.taskDelete}: "${task.title}"?')) {
          await delete(task.id);
          if (context.mounted) showInfo(context, l10n.taskDeleted);
        }
    }
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}

/// Chọn ngày (dùng `showDatePicker` của Material, đã dịch theo locale).
Future<CalendarDate?> pickDate(BuildContext context, CalendarDate initial) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: initial.toLocalDateTime(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  return picked == null ? null : CalendarDate.fromLocal(picked);
}

/// Form tạo / sửa việc. Trả `TaskDraft` (chưa gọi API): màn gọi sẽ lưu.
Future<TaskDraft?> showTaskEditor(BuildContext context, {required TaskDraft initial, bool isNew = false}) =>
    showModalBottomSheet<TaskDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _TaskEditor(initial: initial, isNew: isNew),
    );

class _TaskEditor extends StatefulWidget {
  const _TaskEditor({required this.initial, required this.isNew});
  final TaskDraft initial;
  final bool isNew;

  @override
  State<_TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<_TaskEditor> {
  late final TextEditingController _title = TextEditingController(text: widget.initial.title);
  late CalendarDate _date = widget.initial.date;
  late final Set<TaskTag> _tags = {...widget.initial.tags};
  late final List<Subtask> _subs = [...widget.initial.subtasks];
  late final List<TextEditingController> _subCtrls =
      [for (final s in widget.initial.subtasks) TextEditingController(text: s.title)];

  @override
  void dispose() {
    _title.dispose();
    for (final c in _subCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final title = _title.text.trim();
    if (title.isEmpty) return;
    Navigator.pop(
      context,
      TaskDraft(
        title: title,
        date: _date,
        tags: TaskTag.values.where(_tags.contains).toList(),
        subtasks: [
          for (var i = 0; i < _subs.length; i++)
            if (_subCtrls[i].text.trim().isNotEmpty) _subs[i].copyWith(title: _subCtrls[i].text.trim()),
        ],
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
              Text(widget.isNew ? l10n.todayAddTask : l10n.taskEdit, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _title,
                autofocus: widget.isNew,
                maxLength: 200,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: l10n.taskTitle, counterText: ''),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.event_outlined),
                label: Text('${l10n.taskDate}: ${context.dates.full(_date)}'),
                onPressed: () async {
                  final d = await pickDate(context, _date);
                  if (d != null) setState(() => _date = d);
                },
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
              Text(l10n.taskSubtasks, style: Theme.of(context).textTheme.labelLarge),
              for (var i = 0; i < _subs.length; i++)
                Row(
                  children: [
                    Checkbox(
                      value: _subs[i].done,
                      onChanged: (v) => setState(() => _subs[i] = _subs[i].copyWith(done: v ?? false)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _subCtrls[i],
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(isDense: true),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.delete,
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() {
                        _subs.removeAt(i);
                        _subCtrls.removeAt(i).dispose();
                      }),
                    ),
                  ],
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(l10n.taskAddSubtask),
                  onPressed: () => setState(() {
                    _subs.add(const Subtask(title: ''));
                    _subCtrls.add(TextEditingController());
                  }),
                ),
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
