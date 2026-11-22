import { ChevronDown, LoaderCircle } from 'lucide-react'
import { useId, useState } from 'react'
import type { TaskDto } from '../../api/types'
import { TaskMenu } from '../../components/TaskMenu'
import { TASK_TAGS as TAGS } from '../../components/taskTags'

interface TodayBacklogBlockProps {
  backlog: TaskDto[]
  moveAllPending: boolean
  pendingTaskId?: string
  error: boolean
  onMoveAll: () => Promise<void>
  onMoveTask: (task: TaskDto) => Promise<void>
  onChangeDate: (task: TaskDto, date: string) => Promise<void>
  onDeleteTask: (id: string) => Promise<void>
  onToggleTask: (id: string, done: boolean) => void
}

function formatDateBadge(dateStr: string) {
  const parts = dateStr.split('-')
  if (parts.length === 3) {
    return `${parts[2]}/${parts[1]}`
  }
  return dateStr
}

export function TodayBacklogBlock({
  backlog,
  moveAllPending,
  pendingTaskId,
  error,
  onMoveAll,
  onMoveTask,
  onChangeDate,
  onDeleteTask,
  onToggleTask,
}: TodayBacklogBlockProps) {
  // Mỗi lúc chỉ mở một menu: giữ id task đang mở ở khối cha thay vì state riêng từng dòng.
  const [menuTaskId, setMenuTaskId] = useState<string | null>(null)
  const [isOpen, setIsOpen] = useState(false)
  const contentId = useId()

  return (
    <section aria-labelledby="today-backlog-title" className="sketch p-3.5 sm:p-4">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <button
          type="button"
          onClick={() => setIsOpen((prev) => !prev)}
          aria-expanded={isOpen}
          aria-controls={contentId}
          className="flex cursor-pointer items-center gap-2 rounded-lg py-1 text-left font-display text-lg font-bold text-primary-ink hover:opacity-80 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          <span id="today-backlog-title">Việc còn tồn ({backlog.length})</span>
          <ChevronDown
            size={18}
            className={`transition-transform duration-200 motion-reduce:transition-none ${
              isOpen ? 'rotate-180' : ''
            }`}
            aria-hidden="true"
          />
        </button>

        <button
          type="button"
          onClick={onMoveAll}
          disabled={backlog.length === 0 || moveAllPending}
          className="flex min-h-11 items-center gap-2 rounded-lg border-2 border-[var(--ink)] bg-[var(--surface)] px-3.5 py-1.5 text-xs font-bold text-ink shadow-[2px_2px_0_0_var(--ink)] hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-45"
        >
          {moveAllPending ? (
            <>
              <LoaderCircle size={15} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
              <span>Đang chuyển…</span>
            </>
          ) : (
            <span>Chuyển tất cả vào hôm nay</span>
          )}
        </button>
      </div>

      {error && (
        <p role="alert" className="mt-2 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          Chưa xử lý được việc tồn. Hãy thử lại.
        </p>
      )}

      {isOpen && (
        <div id={contentId} className="mt-3 border-t border-[var(--line)] pt-2">
          {backlog.length === 0 ? (
            <p className="py-4 text-center text-sm font-medium text-ink-muted">
              Không còn công việc tồn đọng nào.
            </p>
          ) : (
            <div className="divide-y divide-[var(--line)]">
              {backlog.map((task) => {
                const isTaskPending = pendingTaskId === task.id
                return (
                  <div
                    key={task.id}
                    onContextMenu={(event) => {
                      event.preventDefault()
                      setMenuTaskId(task.id)
                    }}
                    className="flex min-w-0 items-center justify-between gap-3 py-2.5"
                  >
                    <div className="flex min-w-0 flex-1 items-center gap-2">
                      <label className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-full hover:bg-accent-tint focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2">
                        <span className="sr-only">
                          Đánh dấu hoàn thành việc tồn “{task.title}”
                        </span>
                        <input
                          type="checkbox"
                          checked={task.done}
                          disabled={isTaskPending}
                          onChange={(e) => onToggleTask(task.id, e.target.checked)}
                          className="size-5 cursor-pointer accent-primary disabled:cursor-wait disabled:opacity-50"
                        />
                      </label>

                      <div className="min-w-0 flex-1">
                        <p className="[overflow-wrap:anywhere] text-sm font-semibold text-ink">
                          {task.title}
                        </p>
                        <div className="mt-1 flex flex-wrap items-center gap-1.5 text-xs text-ink-muted">
                          <span className="rounded bg-[var(--line)] px-1.5 py-0.5 font-bold">
                            {formatDateBadge(task.date)}
                          </span>
                          {task.tags.map((tag) => (
                            <span key={tag} className={`rounded-full px-2 py-0.5 font-bold ${TAGS[tag].className}`}>
                              {TAGS[tag].label}
                            </span>
                          ))}
                        </div>
                      </div>
                    </div>

                    <TaskMenu
                      task={task}
                      open={menuTaskId === task.id}
                      onOpenChange={(open) => setMenuTaskId(open ? task.id : null)}
                      disabled={isTaskPending}
                      dateLabel="Chọn ngày khác"
                      onMoveToToday={() => onMoveTask(task)}
                      onChangeDate={(date) => onChangeDate(task, date)}
                      onDelete={() => onDeleteTask(task.id)}
                    />
                  </div>
                )
              })}
            </div>
          )}
        </div>
      )}
    </section>
  )
}
