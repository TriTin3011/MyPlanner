import { Flag } from 'lucide-react'
import type { ReactNode } from 'react'
import { useTranslation } from 'react-i18next'
import type { DeadlineDto } from '../../api/types'
import { AddTaskInput } from '../../components/AddTaskInput'
import { NoteCollapsible } from '../../components/NoteCollapsible'
import { formatDayMonth } from '../../lib/dates'

const DAY_NAME_KEYS = [
  'week.dayNames.d0',
  'week.dayNames.d1',
  'week.dayNames.d2',
  'week.dayNames.d3',
  'week.dayNames.d4',
  'week.dayNames.d5',
  'week.dayNames.d6',
] as const

interface DayColumnProps {
  date: string
  // 0 = Thứ 2 … 6 = Chủ nhật (tuần ISO bắt đầu Thứ 2).
  dayIndex: number
  isToday: boolean
  deadlines: DeadlineDto[]
  taskCount: number
  // Danh sách việc đã dựng sẵn (có kéo thả) do WeekDaysBoard truyền vào.
  children: ReactNode
  addPending: boolean
  onAdd: (title: string) => Promise<void>
  noteContent: string
  onSaveNote: (content: string) => Promise<void>
}

// Một cột ngày của "Công việc trong tuần" (SPEC §9.4). Component trình bày thuần: không gọi API,
// không biết gì về kéo thả, chỉ nhận dữ liệu và callback qua props (giống một view nhận model).
export function DayColumn({
  date,
  dayIndex,
  isToday,
  deadlines,
  taskCount,
  children,
  addPending,
  onAdd,
  noteContent,
  onSaveNote,
}: DayColumnProps) {
  const { t } = useTranslation()
  const titleId = `day-${date}-title`
  return (
    <section
      aria-labelledby={titleId}
      data-today={isToday || undefined}
      className="sketch flex flex-col p-3 lg:p-4"
    >
      <header className="mb-2 flex items-center justify-between gap-2">
        <h3 id={titleId} className="flex items-center gap-2 font-display text-lg font-extrabold text-ink">
          {t(DAY_NAME_KEYS[dayIndex] ?? 'week.dayNames.d0')}
          {isToday && (
            <span className="rounded-full bg-primary px-2 py-0.5 text-xs font-bold text-white">
              {t('week.dayColumn.todayBadge')}
            </span>
          )}
        </h3>
        <span className="rounded-full bg-accent-tint px-2 py-0.5 text-xs font-bold text-primary-ink">
          {formatDayMonth(date)}
        </span>
      </header>

      {deadlines.length > 0 && (
        <ul className="mb-2 space-y-1.5" aria-label={t('week.dayColumn.deadlinesAria')}>
          {deadlines.map((d) => (
            <DeadlineRow key={`${d.kind}-${d.goalId}-${d.title}`} deadline={d} />
          ))}
        </ul>
      )}

      <div className="min-h-12 flex-1">
        {taskCount === 0 && (
          <p className="py-4 text-center text-sm font-medium text-ink-muted/70">{t('week.dayColumn.emptyDay')}</p>
        )}
        {children}
      </div>

      <AddTaskInput pending={addPending} onAdd={onAdd} placeholder={t('week.dayColumn.addTaskPlaceholder')} />

      <NoteCollapsible
        label={t('week.dayColumn.noteLabel')}
        placeholder={t('week.dayColumn.notePlaceholder')}
        textareaPlaceholder={t('week.dayColumn.noteTextareaPlaceholder')}
        initialContent={noteContent}
        onSave={onSaveNote}
      />
    </section>
  )
}

// Dòng hạn nền hồng: "⚑ Hạn bước: <bước> · <mục tiêu> · quá hạn" hoặc "⚑ Hạn mục tiêu: <mục tiêu>".
// Cờ "quá hạn" BE đã tính sẵn (SPEC §13.4), FE chỉ hiện.
export function DeadlineRow({ deadline }: { deadline: DeadlineDto }) {
  const { t } = useTranslation()
  const isStep = deadline.kind === 'step'
  return (
    <li
      className={`flex items-start gap-1.5 rounded-lg px-2 py-1.5 text-xs font-bold ${
        deadline.done ? 'bg-accent-tint text-ink-muted line-through' : 'bg-[var(--danger-bg)] text-danger'
      }`}
    >
      <Flag size={13} className="mt-0.5 shrink-0" aria-hidden="true" />
      <span>
        {isStep ? t('week.dayColumn.deadlineStep') : t('week.dayColumn.deadlineGoal')}: {deadline.title}
        {isStep && <span className="font-medium"> · {deadline.goalTitle}</span>}
        {deadline.overdue && <span> · {t('week.dayColumn.deadlineOverdue')}</span>}
        {deadline.done && <span className="sr-only">{t('week.dayColumn.deadlineDoneSr')}</span>}
      </span>
    </li>
  )
}
