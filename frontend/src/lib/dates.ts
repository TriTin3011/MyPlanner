export function toLocalDateKey(date: Date) {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

export function parseDateKey(dateKey: string) {
  const [year, month, day] = dateKey.split('-').map(Number)
  return new Date(year, month - 1, day)
}

export function addDays(dateKey: string, days: number) {
  const d = parseDateKey(dateKey)
  d.setDate(d.getDate() + days)
  return toLocalDateKey(d)
}

// Thứ 2 của tuần chứa ngày này (tuần bắt đầu Thứ 2, theo ISO).
export function startOfWeek(dateKey: string) {
  const jsDay = parseDateKey(dateKey).getDay()
  const isoDay = jsDay === 0 ? 7 : jsDay
  return addDays(dateKey, -(isoDay - 1))
}

// Số tuần ISO 8601 và năm ISO của tuần chứa ngày này. Quy tắc ISO: tuần thuộc năm chứa Thứ 5 của nó,
// nên 31/12 có thể là tuần 1 của năm sau, và 01/01 có thể là tuần 52/53 của năm trước.
export function isoWeek(dateKey: string) {
  const thursday = parseDateKey(addDays(startOfWeek(dateKey), 3))
  const year = thursday.getFullYear()
  const jan1 = new Date(year, 0, 1)
  const dayOfYear = Math.round((thursday.getTime() - jan1.getTime()) / 86_400_000)
  return { year, week: Math.floor(dayOfYear / 7) + 1 }
}

// "2026-W47": khoá tuần dùng chung với BE (WeekKeys.ToKey) cho URL API, query key và ghi chú tuần.
export function isoWeekKey(dateKey: string) {
  const { year, week } = isoWeek(dateKey)
  return `${year}-W${String(week).padStart(2, '0')}`
}

// "16/11" từ "2026-11-16".
export function formatDayMonth(dateKey: string) {
  const [, month, day] = dateKey.split('-')
  return `${day}/${month}`
}

export interface CalendarDay {
  date: string
  dayNumber: number
  isCurrentMonth: boolean
}

export function getMonthCalendarGrid(year: number, month: number): CalendarDay[] {
  const firstDay = new Date(year, month - 1, 1)
  const jsDay = firstDay.getDay()
  const isoDay = jsDay === 0 ? 7 : jsDay // 1 (T2) .. 7 (CN)
  const daysBefore = isoDay - 1

  const startDate = new Date(year, month - 1, 1 - daysBefore)
  const days: CalendarDay[] = []

  // Lưới cố định 6 hàng x 7 cột = 42 ngày (SPEC §6.6)
  for (let i = 0; i < 42; i++) {
    const d = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + i)
    days.push({
      date: toLocalDateKey(d),
      dayNumber: d.getDate(),
      isCurrentMonth: d.getMonth() === month - 1,
    })
  }

  return days
}
