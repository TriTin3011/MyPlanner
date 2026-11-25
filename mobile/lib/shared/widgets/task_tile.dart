import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../domain/models/task.dart';
import '../../domain/values/calendar_date.dart';
import '../../l10n/app_localizations.dart';
import '../labels.dart';
import 'section.dart';

/// Một dòng việc: ô tick (44px), tên, tag, tiến độ việc con, cờ "trễ từ ngày…".
///
/// Widget "ngốc" (presentational): chỉ nhận dữ liệu + callback, không gọi API.
/// Màn Hôm nay và Tuần dùng chung nên đặt ở `shared/`.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onTap,
    this.onMenu,
    this.today,
    this.dragHandle,
    this.dense = false,
  });

  final Task task;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTap;
  final VoidCallback? onMenu;
  final CalendarDate? today;
  final Widget? dragHandle;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final subDone = task.subtasks.where((s) => s.done).length;
    final late = today != null && task.date.isBefore(today!) && !task.done;
    final carried = task.originalDate != null && task.originalDate != task.date;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        onLongPress: onMenu,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: dense ? 44 : 48),
          child: Row(
            children: [
              ?dragHandle,
              Semantics(
                label: task.title,
                child: Checkbox(value: task.done, onChanged: (v) => onToggle(v ?? false)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: dense ? 14 : 15,
                          decoration: task.done ? TextDecoration.lineThrough : null,
                          color: task.done ? p.muted : p.ink,
                        ),
                      ),
                      if (task.tags.isNotEmpty || task.subtasks.isNotEmpty || task.isRecurring || late || carried)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              for (final t in task.tags)
                                Builder(builder: (_) {
                                  final (bg, fg) = p.tagColors(t);
                                  return Pill(label: l10n.tag(t), bg: bg, fg: fg);
                                }),
                              if (task.subtasks.isNotEmpty)
                                Text('☑ $subDone/${task.subtasks.length}', style: TextStyle(fontSize: 11, color: p.muted)),
                              if (task.isRecurring) Icon(Icons.repeat, size: 14, color: p.muted),
                              if (late || carried)
                                Text(
                                  l10n.taskLate(context.dates.dayMonth(task.originalDate ?? task.date)),
                                  style: TextStyle(fontSize: 11, color: p.warnInk, fontWeight: FontWeight.w600),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (onMenu != null)
                IconButton(
                  tooltip: l10n.taskEdit,
                  icon: Icon(Icons.more_horiz, color: p.muted),
                  onPressed: onMenu,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
