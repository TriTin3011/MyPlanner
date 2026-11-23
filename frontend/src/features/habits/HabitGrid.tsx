import {
  DndContext,
  KeyboardSensor,
  MouseSensor,
  TouchSensor,
  type DragEndEvent,
  useSensor,
  useSensors,
} from '@dnd-kit/core'
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  useSortable,
  verticalListSortingStrategy,
} from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { Check, GripVertical, Repeat, Trash2 } from 'lucide-react'
import { type FormEvent, type KeyboardEvent, useId, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { HabitMonthDto, HabitMonthRowDto } from '../../api/types'
import { INTL_LOCALE } from '../../i18n/languages'
import { useSettings } from '../../store/settings'
import { getHabitGridDays, isWeekend, type HabitGridView, weekdayLabel } from './habitGridDays'

export interface HabitGridProps {
  month: HabitMonthDto
  today: string
  recurringCount: number
  isAdding?: boolean
  onToggle: (habitId: string, date: string, done: boolean) => void
  onAdd: (title: string) => void
  onDelete: (habitId: string) => void
  onReorder: (ids: string[]) => void
  onOpenRecurring: () => void
}

export function HabitGrid(props: HabitGridProps) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const [view, setView] = useState<HabitGridView>('month')
  const days = getHabitGridDays(props.month.from, props.month.to, view, props.today)
  const propsOrder = [...props.month.habits].sort((a, b) => a.order - b.order).map((habit) => habit.id)
  const sourceOrder = `${props.month.from}:${propsOrder.map((id) => `${id}:${props.month.habits.find((h) => h.id === id)?.order}`).join('|')}`
  const [draftOrder, setDraftOrder] = useState(() => ({ source: sourceOrder, ids: propsOrder }))

  // Bỏ thứ tự lạc quan khi dữ liệu mới từ cha đã về.
  if (draftOrder.source !== sourceOrder) setDraftOrder({ source: sourceOrder, ids: propsOrder })

  const habitById = new Map(props.month.habits.map((habit) => [habit.id, habit]))
  const habits = draftOrder.ids.flatMap((id) => {
    const habit = habitById.get(id)
    return habit ? [habit] : []
  })
  const sensors = useSensors(
    useSensor(MouseSensor, { activationConstraint: { distance: 5 } }),
    useSensor(TouchSensor, { activationConstraint: { delay: 200, tolerance: 5 } }),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates }),
  )

  function commitOrder(ids: string[]) {
    setDraftOrder({ source: sourceOrder, ids })
    props.onReorder(ids)
  }

  function handleDragEnd({ active, over }: DragEndEvent) {
    if (!over || active.id === over.id) return
    const from = draftOrder.ids.indexOf(String(active.id))
    const to = draftOrder.ids.indexOf(String(over.id))
    if (from < 0 || to < 0) return
    commitOrder(arrayMove(draftOrder.ids, from, to))
  }

  function moveWithKeys(id: string, key: string) {
    const from = draftOrder.ids.indexOf(id)
    const to = from + (key === 'ArrowUp' ? -1 : 1)
    if (from < 0 || to < 0 || to >= draftOrder.ids.length) return
    commitOrder(arrayMove(draftOrder.ids, from, to))
  }

  return (
    <section className="sketch min-w-0 max-w-full bg-surface p-3.5 lg:p-5" aria-labelledby="habit-grid-title">
      <div className="mb-3 flex items-center justify-between gap-3">
        <h2 id="habit-grid-title" className="text-xl font-bold text-ink sm:text-2xl">
          {t('habits.grid.title')}
        </h2>
        <button
          type="button"
          onClick={() => setView((current) => (current === 'month' ? 'week' : 'month'))}
          aria-label={view === 'month' ? t('habits.grid.viewMonthAria') : t('habits.grid.viewWeekAria')}
          className="min-h-11 shrink-0 rounded-xl bg-accent-tint px-3 font-semibold text-primary-ink hover:bg-accent-soft focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
        >
          {view === 'month' ? t('habits.grid.viewMonthBtn') : t('habits.grid.viewWeekBtn')}
        </button>
      </div>

      <DndContext sensors={sensors} onDragEnd={handleDragEnd}>
        <div className="max-w-full overflow-x-auto overscroll-x-contain rounded-lg border border-line">
          <table className="w-max min-w-full border-separate border-spacing-0 text-sm">
            <thead>
              <tr>
                <th
                  scope="col"
                  className="sticky left-0 z-20 w-52 min-w-52 border-b border-line bg-surface px-2 py-2 text-left text-xs font-semibold text-ink-muted"
                >
                  {t('habits.grid.habitColumn')}
                </th>
                {days.map((date) => (
                  <DayHeader key={date} date={date} today={props.today} locale={locale} />
                ))}
              </tr>
            </thead>
            <SortableContext items={draftOrder.ids} strategy={verticalListSortingStrategy}>
              <tbody>
                {habits.map((habit) => (
                  <SortableHabitRow
                    key={habit.id}
                    habit={habit}
                    days={days}
                    today={props.today}
                    onToggle={props.onToggle}
                    onDelete={props.onDelete}
                    onMoveKey={(key) => moveWithKeys(habit.id, key)}
                  />
                ))}
                {habits.length === 0 && (
                  <tr>
                    <td colSpan={days.length + 1} className="px-4 py-8 text-center text-ink-muted">
                      {t('habits.grid.empty')}
                    </td>
                  </tr>
                )}
              </tbody>
            </SortableContext>
          </table>
        </div>
      </DndContext>

      <AddHabitForm isAdding={props.isAdding ?? false} onAdd={props.onAdd} />

      <div className="mt-3 flex flex-wrap items-center gap-x-2 gap-y-1 text-sm text-ink-muted">
        <span>{t('habits.grid.recurringPrompt')}</span>
        <button
          type="button"
          onClick={props.onOpenRecurring}
          className="inline-flex min-h-11 items-center gap-1.5 rounded-lg px-1 font-semibold text-primary-ink underline-offset-4 hover:underline focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
        >
          <Repeat size={16} aria-hidden="true" />
          {t('habits.grid.useRecurring', { count: props.recurringCount })}
        </button>
      </div>
    </section>
  )
}

function DayHeader({ date, today, locale }: { date: string; today: string; locale: string }) {
  const [, , day] = date.split('-')
  const isToday = date === today
  return (
    <th
      scope="col"
      className={`w-11 min-w-11 border-b border-line py-1.5 text-center text-xs sm:w-7 sm:min-w-7 ${dayBackground(date, today)} ${isToday ? 'font-bold text-primary-ink' : 'font-semibold text-ink-muted'}`}
    >
      <span className="block">{weekdayLabel(date, locale)}</span>
      <span className="block text-ink">{Number(day)}</span>
    </th>
  )
}

function SortableHabitRow({
  habit,
  days,
  today,
  onToggle,
  onDelete,
  onMoveKey,
}: {
  habit: HabitMonthRowDto
  days: string[]
  today: string
  onToggle: HabitGridProps['onToggle']
  onDelete: HabitGridProps['onDelete']
  onMoveKey: (key: string) => void
}) {
  const { t } = useTranslation()
  const { attributes, listeners, setNodeRef, setActivatorNodeRef, transform, transition, isDragging } = useSortable({
    id: habit.id,
  })
  const doneDates = new Set(habit.doneDates)

  function handleDelete() {
    if (window.confirm(t('habits.grid.confirmDelete', { title: habit.title }))) onDelete(habit.id)
  }

  function handleKeyDown(event: KeyboardEvent<HTMLButtonElement>) {
    if (event.key !== 'ArrowUp' && event.key !== 'ArrowDown') {
      listeners?.onKeyDown?.(event)
      return
    }
    event.preventDefault()
    event.stopPropagation()
    onMoveKey(event.key)
  }

  return (
    <tr
      ref={setNodeRef}
      style={{ transform: CSS.Transform.toString(transform), transition }}
      className={isDragging ? 'relative z-30 bg-surface opacity-90 shadow-lg' : undefined}
    >
      <th scope="row" className="sticky left-0 z-10 w-52 min-w-52 border-b border-line bg-surface p-0 text-left">
        {/* Ô bảng bỏ qua max-width nên khoá rộng ở div trong; nhờ vậy tên dài bị cắt bằng … thay vì đẩy giãn cả cột. */}
          <div className="flex min-h-14 w-52 items-center px-2 md:min-h-12">
          <div className="min-w-0 flex-1 py-2 md:py-1">
            <span className="block truncate font-semibold text-ink" title={habit.title}>
              {habit.title}
            </span>
            {/* % nằm cạnh thanh tiến độ (không cạnh tên) để trên điện thoại tên có trọn một hàng. */}
            <div className="mt-1 flex items-center gap-2">
              <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-accent-tint" aria-hidden="true">
                <div
                  className="h-full rounded-full bg-primary"
                  style={{ width: `${Math.max(0, Math.min(100, habit.percent))}%` }}
                />
              </div>
              <span className="shrink-0 text-xs font-bold text-primary-ink">{habit.percent}%</span>
            </div>
          </div>
          <button
            type="button"
            onClick={handleDelete}
            aria-label={t('habits.grid.deleteAria', { title: habit.title })}
            className="grid size-11 shrink-0 place-items-center rounded-lg text-ink-muted md:size-8 hover:bg-danger-bg hover:text-danger focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
          >
            <Trash2 size={16} aria-hidden="true" />
          </button>
          <button
            type="button"
            ref={setActivatorNodeRef}
            {...attributes}
            {...listeners}
            onKeyDown={handleKeyDown}
            aria-label={t('habits.grid.dragAria', { title: habit.title })}
            aria-keyshortcuts="ArrowUp ArrowDown"
            className="grid size-11 shrink-0 cursor-grab md:size-8 touch-none place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none active:cursor-grabbing"
          >
            <GripVertical size={17} aria-hidden="true" />
          </button>
        </div>
      </th>
      {days.map((date) => {
        const checked = doneDates.has(date)
        const disabled = date > today || date < habit.startDate
        const [, month, day] = date.split('-')
        return (
          <td key={date} className={`border-b border-line p-0 text-center ${dayBackground(date, today)}`}>
            <button
              type="button"
              role="checkbox"
              aria-checked={checked}
              aria-label={t('habits.grid.cellAria', { title: habit.title, day: Number(day), month: Number(month) })}
              disabled={disabled}
              onClick={() => onToggle(habit.id, date, !checked)}
              className="group grid size-11 place-items-center focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-inset focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-35 sm:size-7"
            >
              <span
                className={`grid size-5 place-items-center rounded-[5px] border-2 ${checked ? 'border-primary bg-primary text-white' : 'border-ink-muted bg-surface text-transparent group-hover:border-primary'}`}
                aria-hidden="true"
              >
                <Check size={14} strokeWidth={3} />
              </span>
            </button>
          </td>
        )
      })}
    </tr>
  )
}

function AddHabitForm({ isAdding, onAdd }: { isAdding: boolean; onAdd: HabitGridProps['onAdd'] }) {
  const { t } = useTranslation()
  const [title, setTitle] = useState('')
  const inputId = useId()
  const trimmedTitle = title.trim()

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!trimmedTitle || isAdding) return
    onAdd(trimmedTitle)
    setTitle('')
  }

  return (
    <form
      onSubmit={handleSubmit}
      aria-busy={isAdding}
      className="mt-3 flex min-h-11 overflow-hidden rounded-xl border-2 border-ink bg-surface focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2"
    >
      <label htmlFor={inputId} className="sr-only">
        {t('habits.grid.newHabitLabel')}
      </label>
      <input
        id={inputId}
        value={title}
        onChange={(event) => setTitle(event.target.value)}
        disabled={isAdding}
        autoComplete="off"
        placeholder={t('habits.grid.newHabitPlaceholder')}
        className="min-w-0 flex-1 bg-transparent px-3 text-base text-ink placeholder:text-ink-muted focus:outline-none disabled:cursor-wait disabled:opacity-60"
      />
      <button
        type="submit"
        disabled={isAdding || !trimmedTitle}
        aria-label={t('habits.grid.addHabitAria')}
        className="min-h-11 shrink-0 bg-primary px-4 font-semibold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-inset disabled:cursor-not-allowed disabled:opacity-45"
      >
        {t('habits.grid.addHabitBtn')}
      </button>
    </form>
  )
}

function dayBackground(date: string, today: string) {
  if (date === today) return 'bg-accent-soft'
  return isWeekend(date) ? 'bg-accent-tint/50' : 'bg-surface'
}
