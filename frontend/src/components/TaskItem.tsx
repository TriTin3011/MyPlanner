import { Check, ChevronDown, LoaderCircle, Repeat2, X } from 'lucide-react'
import {
  type FormEvent,
  type KeyboardEvent,
  type MouseEvent,
  type ReactNode,
  useEffect,
  useId,
  useRef,
  useState,
} from 'react'
import type { TaskDto } from '../api/types'
import { TaskMenu, type TaskMenuProps } from './TaskMenu'
import { TASK_TAGS as TAGS } from './taskTags'

export type TaskItemMenuActions = Omit<TaskMenuProps, 'task' | 'open' | 'onOpenChange' | 'disabled'>

interface TaskItemProps {
  task: TaskDto
  pending: boolean
  renamePending: boolean
  pendingSubtaskId?: string
  onToggle: (id: string, done: boolean) => void
  onRename: (task: TaskDto, title: string) => Promise<void>
  onToggleSubtask?: (task: TaskDto, subtaskId: string, done: boolean) => Promise<void>
  // Các thao tác của menu ⋯; không truyền thì không có menu.
  menu?: TaskItemMenuActions
  // Tay nắm kéo thả do danh sách cha cung cấp (dnd-kit), TaskItem chỉ đặt vào đúng chỗ.
  dragHandle?: ReactNode
}

export function TaskItem({
  task,
  pending,
  renamePending,
  pendingSubtaskId,
  onToggle,
  onRename,
  onToggleSubtask,
  menu,
  dragHandle,
}: TaskItemProps) {
  const [menuOpen, setMenuOpen] = useState(false)
  const [editing, setEditing] = useState(false)
  const [expanded, setExpanded] = useState(false)
  const [draft, setDraft] = useState(task.title)
  const [renameError, setRenameError] = useState<string | null>(null)
  const [subtaskError, setSubtaskError] = useState<string | null>(null)
  const inputRef = useRef<HTMLInputElement>(null)
  const titleButtonRef = useRef<HTMLButtonElement>(null)
  const restoreTitleFocus = useRef(false)
  const inputId = useId()
  const errorId = useId()
  const subtasksListId = useId()
  const completedSubtasks = task.subtasks.filter((subtask) => subtask.done).length
  const action = task.done ? 'chưa hoàn thành' : 'hoàn thành'
  const trimmedDraft = draft.trim()

  useEffect(() => {
    if (editing) {
      inputRef.current?.focus()
      inputRef.current?.select()
    } else if (restoreTitleFocus.current) {
      titleButtonRef.current?.focus()
      restoreTitleFocus.current = false
    }
  }, [editing])

  function startEditing() {
    if (pending || renamePending) return
    setDraft(task.title)
    setRenameError(null)
    setEditing(true)
  }

  function cancelEditing() {
    restoreTitleFocus.current = true
    setDraft(task.title)
    setRenameError(null)
    setEditing(false)
  }

  async function submitRename(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!trimmedDraft || renamePending) return
    if (trimmedDraft === task.title) {
      cancelEditing()
      return
    }

    setRenameError(null)
    try {
      await onRename(task, trimmedDraft)
      restoreTitleFocus.current = true
      setEditing(false)
    } catch (reason) {
      setRenameError(reason instanceof Error ? reason.message : 'Chưa lưu được tiêu đề. Hãy thử lại.')
    }
  }

  function handleEditKeyDown(event: KeyboardEvent<HTMLInputElement>) {
    if (event.key === 'Escape') {
      event.preventDefault()
      cancelEditing()
    }
  }

  // Chuột phải trên desktop mở cùng menu ⋯ (SPEC §6.4). Trên điện thoại dùng nút ⋯ vì không có chuột phải.
  function handleContextMenu(event: MouseEvent<HTMLElement>) {
    if (!menu || editing) return
    event.preventDefault()
    setMenuOpen(true)
  }

  return (
    <article
      onContextMenu={handleContextMenu}
      className="flex min-w-0 items-start gap-1 border-b border-[var(--line)] py-2.5 last:border-b-0 sm:gap-2"
    >
      {dragHandle}
      <label className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-full hover:bg-accent-tint focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2">
        <span className="sr-only">Đánh dấu “{task.title}” là {action}</span>
        <input
          type="checkbox"
          checked={task.done}
          disabled={pending || renamePending}
          onChange={(event) => onToggle(task.id, event.target.checked)}
          className="size-5 cursor-pointer accent-primary disabled:cursor-wait disabled:opacity-50"
        />
      </label>

      <div className="min-w-0 flex-1 py-1.5">
        {editing ? (
          <form onSubmit={submitRename} aria-busy={renamePending} className="space-y-1.5">
            <div className="flex min-w-0 gap-2">
              <label htmlFor={inputId} className="sr-only">
                Tiêu đề công việc
              </label>
              <input
                ref={inputRef}
                id={inputId}
                value={draft}
                onChange={(event) => setDraft(event.target.value)}
                onKeyDown={handleEditKeyDown}
                disabled={renamePending}
                aria-invalid={renameError ? true : undefined}
                aria-describedby={renameError ? errorId : undefined}
                className="min-h-11 min-w-0 flex-1 rounded-lg border-2 border-primary bg-surface px-3 text-base font-semibold text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-wait disabled:opacity-60"
              />
              <button
                type="submit"
                disabled={renamePending || !trimmedDraft}
                aria-label={renamePending ? 'Đang lưu tiêu đề' : 'Lưu tiêu đề'}
                className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg bg-primary text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-45"
              >
                {renamePending ? (
                  <LoaderCircle size={18} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
                ) : (
                  <Check size={18} aria-hidden="true" />
                )}
              </button>
              <button
                type="button"
                onClick={cancelEditing}
                disabled={renamePending}
                aria-label="Hủy sửa tiêu đề"
                className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg border-2 border-[var(--line)] text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-45"
              >
                <X size={18} aria-hidden="true" />
              </button>
            </div>
            {renameError && (
              <p id={errorId} role="alert" className="text-sm font-semibold text-danger">
                {renameError}
              </p>
            )}
          </form>
        ) : (
          <button
            ref={titleButtonRef}
            type="button"
            onClick={startEditing}
            disabled={pending || renamePending}
            aria-label={`Sửa tiêu đề “${task.title}”`}
            className="block min-h-6 w-full cursor-text rounded text-left focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-wait disabled:opacity-60"
          >
            <span
              className={`[overflow-wrap:anywhere] font-semibold text-ink ${
                task.done ? 'text-ink-muted line-through' : ''
              }`}
            >
              {task.title}
            </span>
          </button>
        )}

        {(task.tags.length > 0 || task.subtasks.length > 0 || task.recurringId) && (
          <div className="mt-2 flex flex-wrap items-center gap-2 text-xs font-bold text-ink-muted">
            {task.tags.map((tag) => (
              <span key={tag} className={`rounded-full px-2 py-1 ${TAGS[tag].className}`}>
                {TAGS[tag].label}
              </span>
            ))}
            {task.subtasks.length > 0 && (
              <button
                type="button"
                onClick={() => {
                  setSubtaskError(null)
                  setExpanded((prev) => !prev)
                }}
                aria-expanded={expanded}
                aria-controls={subtasksListId}
                disabled={pending || renamePending}
                className="inline-flex cursor-pointer items-center gap-1 rounded bg-[var(--surface)] px-1.5 py-0.5 text-xs font-bold text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-wait disabled:opacity-50"
              >
                <span>
                  {completedSubtasks}/{task.subtasks.length} việc nhỏ
                </span>
                <ChevronDown
                  size={14}
                  className={`transition-transform duration-200 motion-reduce:transition-none ${
                    expanded ? 'rotate-180' : ''
                  }`}
                  aria-hidden="true"
                />
              </button>
            )}
            {task.recurringId && (
              <span aria-label="Việc lặp lại" title="Việc lặp lại" className="inline-flex items-center">
                <Repeat2 size={15} aria-hidden="true" />
              </span>
            )}
          </div>
        )}

        {expanded && task.subtasks.length > 0 && (
          <div id={subtasksListId} className="mt-3 space-y-1.5 border-t border-[var(--line)] pt-2 pl-2">
            {subtaskError && (
              <p role="alert" className="text-sm font-semibold text-danger">
                {subtaskError}
              </p>
            )}
            <ul className="space-y-1">
              {task.subtasks.map((subtask) => {
                const isSubtaskPending = pendingSubtaskId === subtask.id
                const subtaskAction = subtask.done ? 'chưa hoàn thành' : 'hoàn thành'
                return (
                  <li key={subtask.id} className="flex min-w-0 items-center gap-2 py-1">
                    <label className="grid min-h-11 min-w-11 shrink-0 cursor-pointer place-items-center rounded-full hover:bg-accent-tint focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2">
                      <span className="sr-only">
                        Đánh dấu bước “{subtask.title}” là {subtaskAction}
                      </span>
                      <input
                        type="checkbox"
                        checked={subtask.done}
                        disabled={pending || renamePending || isSubtaskPending}
                        onChange={async (e) => {
                          if (!onToggleSubtask) return
                          setSubtaskError(null)
                          try {
                            await onToggleSubtask(task, subtask.id, e.target.checked)
                          } catch (reason) {
                            setSubtaskError(
                              reason instanceof Error ? reason.message : 'Chưa cập nhật được bước con. Hãy thử lại.'
                            )
                          }
                        }}
                        className="size-4 cursor-pointer accent-primary disabled:cursor-wait disabled:opacity-50"
                      />
                    </label>
                    <span
                      className={`min-w-0 flex-1 [overflow-wrap:anywhere] text-sm font-medium ${
                        subtask.done ? 'text-ink-muted line-through' : 'text-ink'
                      }`}
                    >
                      {subtask.title}
                    </span>
                    {isSubtaskPending && (
                      <span
                        role="status"
                        aria-label="Đang cập nhật bước con"
                        className="grid size-8 shrink-0 place-items-center text-primary"
                      >
                        <LoaderCircle size={15} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
                      </span>
                    )}
                  </li>
                )
              })}
            </ul>
          </div>
        )}
      </div>

      {pending && !editing && (
        <span
          role="status"
          aria-label="Đang cập nhật công việc"
          className="grid size-11 shrink-0 place-items-center text-primary"
        >
          <LoaderCircle size={18} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
        </span>
      )}

      {menu && !editing && (
        <TaskMenu
          {...menu}
          task={task}
          open={menuOpen}
          onOpenChange={setMenuOpen}
          disabled={pending || renamePending}
        />
      )}
    </article>
  )
}
