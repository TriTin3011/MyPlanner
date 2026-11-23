import { Repeat2 } from 'lucide-react'
import { type ReactNode, useRef } from 'react'
import { useTranslation } from 'react-i18next'
import type { TaskDto } from '../../api/types'
import { useHotkey } from '../../lib/useHotkey'
import { SortableTaskList } from './SortableTaskList'
import { AddTaskInput } from '../../components/AddTaskInput'
import { EmptyState } from '../../components/EmptyState'
import { NoteCollapsible } from '../../components/NoteCollapsible'
import { TaskItem, type TaskItemMenuActions } from '../../components/TaskItem'

interface TodayTasksBlockProps {
  tasks: TaskDto[]
  pendingTaskId?: string
  pendingRenameTaskId?: string
  pendingSubtaskId?: string
  error: boolean
  onToggle: (id: string, done: boolean) => void
  onRename: (task: TaskDto, title: string) => Promise<void>
  onToggleSubtask?: (task: TaskDto, subtaskId: string, done: boolean) => Promise<void>
  addPending: boolean
  onAdd: (title: string) => Promise<void>
  noteContent?: string
  onSaveNote?: (content: string) => Promise<void>
  isSavingNote?: boolean
  // Trang dựng bộ thao tác menu ⋯ cho từng task (đổi tag, thêm bước con, đổi ngày, xoá).
  menuFor?: (task: TaskDto) => TaskItemMenuActions
  // Nút "↻ Việc lặp lại N" (SPEC §6.3): undefined thì ẩn nút.
  recurringCount?: number
  onOpenRecurring?: () => void
  // Có thì bật kéo thả sắp xếp (thứ tự mới dạng danh sách id).
  onReorder?: (ids: string[]) => void
}

export function TodayTasksBlock({
  tasks,
  pendingTaskId,
  pendingRenameTaskId,
  pendingSubtaskId,
  error,
  onToggle,
  onRename,
  onToggleSubtask,
  addPending,
  onAdd,
  noteContent,
  onSaveNote,
  isSavingNote,
  menuFor,
  recurringCount,
  onOpenRecurring,
  onReorder,
}: TodayTasksBlockProps) {
  const { t } = useTranslation()
  const addInputRef = useRef<HTMLInputElement>(null)

  // Phím tắt N trên trang Hôm nay đưa con trỏ vào ô thêm việc (SPEC §15 giai đoạn 10).
  useHotkey('n', () => {
    addInputRef.current?.focus()
  })

  function renderTask(task: TaskDto, dragHandle?: ReactNode) {
    return (
      <TaskItem
        key={task.id}
        task={task}
        pending={pendingTaskId === task.id}
        renamePending={pendingRenameTaskId === task.id}
        pendingSubtaskId={pendingSubtaskId}
        onToggle={onToggle}
        onRename={onRename}
        onToggleSubtask={onToggleSubtask}
        menu={menuFor?.(task)}
        dragHandle={dragHandle}
      />
    )
  }

  return (
    <section aria-labelledby="today-tasks-title" className="sketch p-3.5 lg:p-5">
      <div className="mb-2 flex flex-wrap items-center justify-between gap-x-3 gap-y-1">
        <h2 id="today-tasks-title" className="font-display text-xl font-extrabold text-primary-ink">
          {t('today.tasks.title')}{' '}
          <span className="text-sm font-bold text-ink-muted">{t('today.tasks.countSuffix', { count: tasks.length })}</span>
        </h2>
        {onOpenRecurring && (
          <button
            type="button"
            onClick={onOpenRecurring}
            aria-haspopup="dialog"
            className="flex min-h-11 cursor-pointer items-center gap-1.5 rounded-xl px-3 text-sm font-bold text-primary-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
          >
            <Repeat2 size={16} aria-hidden="true" />
            {t('today.tasks.recurringButton')}
            {recurringCount !== undefined && (
              <span className="rounded-full bg-accent-tint px-2 py-0.5 text-xs">{recurringCount}</span>
            )}
          </button>
        )}
      </div>

      {error && (
        <p role="alert" className="mb-2 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          {t('today.tasks.updateError')}
        </p>
      )}

      {tasks.length === 0 ? (
        <EmptyState text={t('today.tasks.empty')} />
      ) : (
        <div>
          {onReorder ? (
            <SortableTaskList
              tasks={tasks}
              onReorder={onReorder}
              disabled={tasks.length < 2}
              renderItem={(task, dragHandle) => renderTask(task, dragHandle)}
            />
          ) : (
            tasks.map((task) => renderTask(task))
          )}
        </div>
      )}

      <AddTaskInput
        inputRef={addInputRef}
        shortcutHint={t('shortcuts.addTaskKey')}
        pending={addPending}
        onAdd={onAdd}
      />

      <NoteCollapsible
        initialContent={noteContent}
        onSave={onSaveNote ?? (() => Promise.resolve())}
        disabled={isSavingNote}
      />
    </section>
  )
}
