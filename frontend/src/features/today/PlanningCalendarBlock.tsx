import { ChevronLeft, ChevronRight, Flag } from 'lucide-react'
import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { DayProgressDto } from '../../api/types'
import { AddTaskInput } from '../../components/AddTaskInput'
import { INTL_LOCALE } from '../../i18n/languages'
import { addDays, getMonthCalendarGrid, parseDateKey, startOfWeek, type CalendarDay } from '../../lib/dates'
import { useSettings } from '../../store/settings'
import { getWeekdays } from '../recurring/weekdays'
import { useDayProgress, useTasksRange } from './hooks'

interface PlanningCalendarBlockProps {
  today: string
  onAddTask: (title: string, date: string) => Promise<void>
  addPending: boolean
}

function formatDayMonthByLocale(dateStr: string, locale: string): string {
  const parts = new Intl.DateTimeFormat(locale, { day: '2-digit', month: '2-digit' }).formatToParts(
    parseDateKey(dateStr),
  )
  return parts.map((p) => (p.type === 'literal' ? '/' : p.value)).join('')
}

function formatMonthPeriodLabel(year: number, month: number, locale: string, tMonthPeriod: (month: string, year: number) => string) {
  const dateObj = new Date(year, month - 1, 1)
  if (locale.toLowerCase().startsWith('vi')) {
    const monthNum = new Intl.DateTimeFormat(locale, { month: 'numeric' }).format(dateObj).replace(/\D/g, '') || String(month)
    return tMonthPeriod(monthNum, year)
  }
  return new Intl.DateTimeFormat(locale, { month: 'long', year: 'numeric' }).format(dateObj)
}

export function PlanningCalendarBlock({ today, onAddTask, addPending }: PlanningCalendarBlockProps) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const weekdayHeaders = useMemo(() => getWeekdays(locale).map((w) => w.short), [locale])
  const todayDate = useMemo(() => parseDateKey(today), [today])
  const [viewMode, setViewMode] = useState<'month' | 'week'>('month')
  const [currentYear, setCurrentYear] = useState(todayDate.getFullYear())
  const [currentMonth, setCurrentMonth] = useState(todayDate.getMonth() + 1)
  const [selectedDate, setSelectedDate] = useState(today)

  const tomorrow = useMemo(() => addDays(today, 1), [today])

  // Ngày đầu tuần đang xem ở chế độ Tuần (Thứ 2)
  const [weekStart, setWeekStart] = useState(() => startOfWeek(today))

  // Tháng: lưới 42 ô (SPEC §6.6). Tuần: 7 ô bắt đầu từ Thứ 2.
  const calendarDays: CalendarDay[] = useMemo(() => {
    if (viewMode === 'month') return getMonthCalendarGrid(currentYear, currentMonth)
    return Array.from({ length: 7 }, (_, i) => {
      const date = addDays(weekStart, i)
      return { date, dayNumber: parseDateKey(date).getDate(), isCurrentMonth: true }
    })
  }, [viewMode, currentYear, currentMonth, weekStart])

  const rangeFrom = calendarDays[0].date
  const rangeTo = calendarDays[calendarDays.length - 1].date

  // Số việc và cờ hạn của mỗi ô do BE tính (GET /dashboard/days); FE chỉ hiển thị.
  const { data: days = [] } = useDayProgress(rangeFrom, rangeTo)
  const progressByDate = useMemo(() => {
    const map: Record<string, DayProgressDto> = {}
    for (const d of days) map[d.date] = d
    return map
  }, [days])

  // Danh sách việc chỉ cần cho đúng ngày đang chọn
  const { data: selectedTasks = [] } = useTasksRange(selectedDate, selectedDate)

  function prev() {
    if (viewMode === 'week') setWeekStart((w) => addDays(w, -7))
    else if (currentMonth === 1) {
      setCurrentMonth(12)
      setCurrentYear((y) => y - 1)
    } else setCurrentMonth((m) => m - 1)
  }

  function next() {
    if (viewMode === 'week') setWeekStart((w) => addDays(w, 7))
    else if (currentMonth === 12) {
      setCurrentMonth(1)
      setCurrentYear((y) => y + 1)
    } else setCurrentMonth((m) => m + 1)
  }

  function switchMode(mode: 'month' | 'week') {
    // Giữ ngữ cảnh: sang Tuần mở tuần của ngày đang chọn, sang Tháng mở tháng của nó
    if (mode === 'week') setWeekStart(startOfWeek(selectedDate))
    else {
      const sel = parseDateKey(selectedDate)
      setCurrentYear(sel.getFullYear())
      setCurrentMonth(sel.getMonth() + 1)
    }
    setViewMode(mode)
  }

  const fmt = (key: string) => formatDayMonthByLocale(key, locale)
  const periodLabel =
    viewMode === 'month'
      ? formatMonthPeriodLabel(currentYear, currentMonth, locale, (m, y) =>
          t('today.calendar.monthPeriod', { month: m, year: y }),
        )
      : t('today.calendar.weekPeriod', { from: fmt(rangeFrom), to: fmt(rangeTo) })
  const selectedDoneCount = selectedTasks.filter((task) => task.done).length
  const isSelectedToday = selectedDate === today

  const formattedSelectedDay = fmt(selectedDate)
  const formattedTomorrow = fmt(tomorrow)

  return (
    <section aria-labelledby="planning-title" className="sketch p-3.5 lg:p-5">
      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <h2 id="planning-title" className="font-display text-xl font-extrabold text-primary-ink">
          {t('today.calendar.title')}
        </h2>

        {/* Toggle Tháng / Tuần */}
        <div
          role="radiogroup"
          aria-label={t('today.calendar.viewModeAria')}
          className="flex rounded-lg border-2 border-[var(--ink)] bg-[var(--surface)] p-0.5 shadow-[2px_2px_0_0_var(--ink)]"
        >
          <button
            type="button"
            role="radio"
            aria-checked={viewMode === 'month'}
            onClick={() => switchMode('month')}
            className={`rounded-md px-3 py-1 text-xs font-bold transition-colors ${
              viewMode === 'month'
                ? 'bg-primary text-white'
                : 'text-ink-muted hover:text-ink'
            }`}
          >
            {t('today.calendar.modeMonth')}
          </button>
          <button
            type="button"
            role="radio"
            aria-checked={viewMode === 'week'}
            onClick={() => switchMode('week')}
            className={`rounded-md px-3 py-1 text-xs font-bold transition-colors ${
              viewMode === 'week'
                ? 'bg-primary text-white'
                : 'text-ink-muted hover:text-ink'
            }`}
          >
            {t('today.calendar.modeWeek')}
          </button>
        </div>
      </div>

      {/* Điều hướng tháng */}
      <div className="mb-3 flex items-center justify-between">
        <button
          type="button"
          onClick={prev}
          aria-label={viewMode === 'month' ? t('today.calendar.prevMonth') : t('today.calendar.prevWeek')}
          className="grid size-9 cursor-pointer place-items-center rounded-lg hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
        >
          <ChevronLeft size={18} aria-hidden="true" />
        </button>

        <span className="font-display text-base font-bold text-ink">
          {periodLabel}
        </span>

        <button
          type="button"
          onClick={next}
          aria-label={viewMode === 'month' ? t('today.calendar.nextMonth') : t('today.calendar.nextWeek')}
          className="grid size-9 cursor-pointer place-items-center rounded-lg hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
        >
          <ChevronRight size={18} aria-hidden="true" />
        </button>
      </div>

      {/* Lưới lịch */}
      <div role="grid" aria-label={t('today.calendar.gridAria', { period: periodLabel })} className="w-full">
        <div role="row" className="grid grid-cols-7 text-center">
          {weekdayHeaders.map((wd) => (
            <div key={wd} role="columnheader" className="py-1 text-xs font-bold text-ink-muted">
              {wd}
            </div>
          ))}
        </div>

        <div className="grid grid-cols-7 gap-1 sm:gap-1.5 pt-1">
          {calendarDays.map((day) => {
            const progress = progressByDate[day.date]
            const taskCount = progress?.tasksTotal ?? 0
            const isSelected = day.date === selectedDate
            const isToday = day.date === today
            const hasDeadline = progress?.hasDeadline ?? false

            return (
              <button
                key={day.date}
                type="button"
                role="gridcell"
                aria-selected={isSelected}
                aria-label={t(
                  hasDeadline ? 'today.calendar.cellAriaDeadline' : 'today.calendar.cellAria',
                  { date: fmt(day.date), count: taskCount },
                )}
                onClick={() => setSelectedDate(day.date)}
                className={`relative flex min-h-[58px] sm:min-h-[68px] flex-col items-center justify-between rounded-lg p-1.5 text-center transition-all focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none ${
                  isSelected
                    ? 'bg-primary text-white shadow-md'
                    : isToday
                      ? 'border-2 border-primary bg-accent-soft text-ink font-bold'
                      : day.isCurrentMonth
                        ? 'bg-[var(--surface)] hover:bg-accent-tint text-ink border border-[var(--line)]'
                        : 'bg-transparent text-ink-muted/40 hover:bg-accent-tint/30'
                }`}
              >
                <div className="flex w-full items-center justify-between px-0.5">
                  <span className={`text-xs sm:text-sm font-bold ${isSelected ? 'text-white' : ''}`}>
                    {day.dayNumber}
                  </span>
                  {hasDeadline && (
                    <Flag
                      size={11}
                      className={isSelected ? 'text-accent-soft' : 'text-danger'}
                      aria-hidden="true"
                    />
                  )}
                </div>

                {taskCount > 0 && (
                  <div className="flex items-center gap-0.5 text-[10px] sm:text-xs">
                    <span className={`inline-block size-1.5 rounded-full ${isSelected ? 'bg-white' : 'bg-primary'}`} />
                    <span className={`font-bold ${isSelected ? 'text-white' : 'text-ink-muted'}`}>
                      +{taskCount}
                    </span>
                  </div>
                )}
              </button>
            )
          })}
        </div>
      </div>

      {/* Chi tiết ngày được chọn */}
      <div className="mt-5 border-t border-[var(--line)] pt-4">
        <div className="mb-2 flex items-baseline justify-between gap-2">
          <h3 className="font-display text-base font-bold text-ink">
            {isSelectedToday
              ? t('today.calendar.selectedTodayHeading', {
                  date: formattedSelectedDay,
                  done: selectedDoneCount,
                  total: selectedTasks.length,
                })
              : t('today.calendar.selectedDayHeading', {
                  date: formattedSelectedDay,
                  done: selectedDoneCount,
                  total: selectedTasks.length,
                })}
          </h3>
          <button
            type="button"
            onClick={() => setSelectedDate(tomorrow)}
            className="text-xs font-bold text-primary hover:underline"
          >
            {t('today.calendar.planTomorrow', { date: formattedTomorrow })}
          </button>
        </div>

        {isSelectedToday ? (
          <p className="text-xs text-ink-muted">
            {t('today.calendar.todayHintBefore')}
            <strong>{t('today.calendar.todayHintStrong')}</strong>
            {t('today.calendar.todayHintAfter')}
          </p>
        ) : (
          <div className="space-y-3">
            {selectedTasks.length === 0 ? (
              <p className="text-xs text-ink-muted">{t('today.calendar.emptyDay')}</p>
            ) : (
              <ul className="space-y-1.5 divide-y divide-[var(--line)]">
                {selectedTasks.map((item) => (
                  <li key={item.id} className="flex items-center justify-between pt-1.5 text-xs">
                    <span className={`font-medium ${item.done ? 'line-through text-ink-muted' : 'text-ink'}`}>
                      {item.title}
                    </span>
                    {item.done && <span className="text-[10px] font-bold text-primary">{t('today.calendar.doneBadge')}</span>}
                  </li>
                ))}
              </ul>
            )}

            <AddTaskInput
              placeholder={t('today.calendar.addForDayPlaceholder', { date: formattedSelectedDay })}
              pending={addPending}
              onAdd={(title) => onAddTask(title, selectedDate)}
            />
          </div>
        )}
      </div>
    </section>
  )
}
