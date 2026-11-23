import { ChevronDown, LoaderCircle } from 'lucide-react'
import { useId, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { TaskDto } from '../../api/types'
import { EmptyState } from '../../components/EmptyState'
import { TaskMenu } from '../../components/TaskMenu'
import { getTaskTags } from '../../components/taskTags'
import { INTL_LOCALE } from '../../i18n/languages'
import { parseDateKey } from '../../lib/dates'
import { useSettings } from '../../store/settings'

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

function formatDateBadge(dateStr: string, locale: string) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) return dateStr
  const parts = new Intl.DateTimeFormat(locale, { day: '2-digit', month: '2-digit' }).formatToParts(
    parseDateKey(dateStr),
  )
  return parts.map((p) => (p.type === 'literal' ? '/' : p.value)).join('')
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
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const tags = getTaskTags(t)
  // Mỗi lúc chỉ mở một menu: giữ id task đang mở ở khối cha thay vì state riêng từng dòng.
  const [menuTaskId, setMenuTaskId] = useState<string | null>(null)
  const [isOpen, setIsOpen] = useState(false)
  const contentId = useId()

  return (
    <section aria-labelledby="today-backlog-title" className="sketch px-3.5 py-1 lg:px-5">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <button
          type="button"
          onClick={() => setIsOpen((prev) => !prev)}
          aria-expanded={isOpen}
          aria-controls={contentId}
          className="flex cursor-pointer items-center gap-2 rounded-lg py-1 text-left font-display text-lg font-bold text-primary-ink hover:opacity-80 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          <span id="today-backlog-title">{t('today.backlog.title', { count: backlog.length })}</span>
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
          className="flex min-h-11 items-center gap-2 rounded-lg px-2 text-sm font-bold text-primary-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-45"
        >
          {moveAllPending ? (
            <>
              <LoaderCircle size={15} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
              <span>{t('today.backlog.movingAll')}</span>
            </>
          ) : (
            <span>{t('today.backlog.moveAllToToday')}</span>
          )}
        </button>
      </div>

      {error && (
        <p role="alert" className="mt-2 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          {t('today.backlog.error')}
        </p>
      )}

      {isOpen && (
        <div id={contentId} className="mt-3 border-t border-[var(--line)] pt-2">
          {backlog.length === 0 ? (
            <EmptyState text={t('today.backlog.empty')} />
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
                      <label className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-xl hover:bg-accent-tint md:size-9 focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2">
                        <span className="sr-only">
                          {t('today.backlog.markDone', { title: task.title })}
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
                            {formatDateBadge(task.date, locale)}
                          </span>
                          {task.tags.map((tag) => (
                            <span key={tag} className={`rounded-full px-2 py-0.5 font-bold ${tags[tag].className}`}>
                              {tags[tag].label}
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
                      dateLabel={t('today.backlog.chooseAnotherDate')}
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
