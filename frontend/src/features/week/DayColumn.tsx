import { Flag } from 'lucide-react'
import type { ReactNode } from 'react'
import type { DeadlineDto } from '../../api/types'
import { AddTaskInput } from '../../components/AddTaskInput'
import { NoteCollapsible } from '../../components/NoteCollapsible'
import { formatDayMonth } from '../../lib/dates'

const DAY_NAMES = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật']

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
  const titleId = `day-${date}-title`
  return (
    <section
      aria-labelledby={titleId}
      data-today={isToday || undefined}
      className="sketch flex flex-col p-3 lg:p-4"
    >
      <header className="mb-2 flex items-center justify-between gap-2">
        <h3 id={titleId} className="flex items-center gap-2 font-display text-lg font-extrabold text-ink">
          {DAY_NAMES[dayIndex]}
          {isToday && (
            <span className="rounded-full bg-primary px-2 py-0.5 text-xs font-bold text-white">Hôm nay</span>
          )}
        </h3>
        <span className="rounded-full bg-accent-tint px-2 py-0.5 text-xs font-bold text-primary-ink">
          {formatDayMonth(date)}
        </span>
      </header>

      {deadlines.length > 0 && (
        <ul className="mb-2 space-y-1.5" aria-label="Hạn trong ngày">
          {deadlines.map((d) => (
            <DeadlineRow key={`${d.kind}-${d.goalId}-${d.title}`} deadline={d} />
          ))}
        </ul>
      )}

      <div className="min-h-12 flex-1">
        {taskCount === 0 && (
          <p className="py-4 text-center text-sm font-medium text-ink-muted/70">Chưa có việc nào</p>
        )}
        {children}
      </div>

      <AddTaskInput pending={addPending} onAdd={onAdd} placeholder="Thêm việc…" />

      <NoteCollapsible
        label="Ghi chú"
        placeholder="Bấm để ghi"
        textareaPlaceholder="Ghi chú cho ngày này…"
        initialContent={noteContent}
        onSave={onSaveNote}
      />
    </section>
  )
}

// Dòng hạn nền hồng: "⚑ Hạn bước: <bước> · <mục tiêu> · quá hạn" hoặc "⚑ Hạn mục tiêu: <mục tiêu>".
// Cờ "quá hạn" BE đã tính sẵn (SPEC §13.4), FE chỉ hiện.
export function DeadlineRow({ deadline }: { deadline: DeadlineDto }) {
  const isStep = deadline.kind === 'step'
  return (
    <li
      className={`flex items-start gap-1.5 rounded-lg px-2 py-1.5 text-xs font-bold ${
        deadline.done ? 'bg-accent-tint text-ink-muted line-through' : 'bg-[var(--danger-bg)] text-danger'
      }`}
    >
      <Flag size={13} className="mt-0.5 shrink-0" aria-hidden="true" />
      <span>
        {isStep ? 'Hạn bước' : 'Hạn mục tiêu'}: {deadline.title}
        {isStep && <span className="font-medium"> · {deadline.goalTitle}</span>}
        {deadline.overdue && <span> · quá hạn</span>}
        {deadline.done && <span className="sr-only"> (đã xong)</span>}
      </span>
    </li>
  )
}
