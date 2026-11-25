import { GripVertical, LoaderCircle } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router'
import type { TodayHabitDto } from '../../api/types'
import { EmptyState } from '../../components/EmptyState'

interface TodayHabitsBlockProps {
  habits: TodayHabitDto[]
  pendingHabitId?: string
  error: boolean
  onToggle: (habitId: string, done: boolean) => void
}

export function TodayHabitsBlock({
  habits,
  pendingHabitId,
  error,
  onToggle,
}: TodayHabitsBlockProps) {
  const { t } = useTranslation()

  return (
    <section data-tour="today-habits" aria-labelledby="today-habits-title" className="sketch p-3.5 lg:p-5">
      <div className="mb-2 flex items-baseline justify-between gap-3">
        <h2 id="today-habits-title" className="font-display text-xl font-extrabold text-primary-ink">
          {t('today.habits.title')}
        </h2>
        <Link
          to="/habits"
          className="text-sm font-bold text-primary hover:underline focus-visible:rounded focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          {t('today.habits.manageLink')}
        </Link>
      </div>

      {error && (
        <p role="alert" className="mb-2 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          {t('today.habits.updateError')}
        </p>
      )}

      {habits.length === 0 ? (
        <EmptyState text={t('today.habits.empty')} />
      ) : (
        <div>
          {habits.map((habit) => {
            const isPending = pendingHabitId === habit.id
            return (
              <div
                key={habit.id}
                className="flex min-w-0 items-center gap-1.5 border-b border-dashed border-[var(--line)] py-0.5 last:border-b-0"
              >
                <label className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-xl hover:bg-accent-tint md:size-9 focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2">
                  <span className="sr-only">
                    {t(habit.done ? 'today.habits.markUndone' : 'today.habits.markDone', { title: habit.title })}
                  </span>
                  <input
                    type="checkbox"
                    checked={habit.done}
                    disabled={isPending}
                    onChange={(event) => onToggle(habit.id, event.target.checked)}
                    className="size-5 cursor-pointer accent-primary disabled:cursor-wait disabled:opacity-50"
                  />
                </label>

                <span
                  className={`min-w-0 flex-1 [overflow-wrap:anywhere] font-bold ${
                    habit.done ? 'text-primary-ink' : 'text-ink'
                  }`}
                >
                  {habit.title}
                </span>

                {isPending ? (
                  <span
                    role="status"
                    aria-label={t('today.habits.updating')}
                    className="grid size-9 shrink-0 place-items-center text-primary"
                  >
                    <LoaderCircle size={16} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
                  </span>
                ) : (
                  <span
                    aria-hidden="true"
                    title={t('today.habits.dragTitle')}
                    className="grid size-9 shrink-0 cursor-grab place-items-center text-ink-muted hover:text-ink select-none"
                  >
                    <GripVertical size={16} />
                  </span>
                )}
              </div>
            )
          })}
        </div>
      )}
    </section>
  )
}
