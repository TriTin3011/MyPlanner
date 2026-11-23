import type { DayProgressDto } from '../../api/types'
import type { ChartPoint } from '../../lib/chartSvg'
import { addDays, parseDateKey } from '../../lib/dates'

export function computeDateRange(today: string, daysCount: number): { from: string; to: string } {
  // Khoảng lùi từ today: ví dụ 7 ngày là từ today - 6 ngày đến today
  const from = addDays(today, -(daysCount - 1))
  return { from, to: today }
}

function formatDayMonthByLocale(dateObj: Date, locale: string): string {
  const parts = new Intl.DateTimeFormat(locale, { day: '2-digit', month: '2-digit' }).formatToParts(dateObj)
  return parts.map((p) => (p.type === 'literal' ? '/' : p.value)).join('')
}

// Chỉ đổi dữ liệu BE đã tính (xong/tổng/%) sang điểm vẽ và gắn nhãn trục X.
// FE không tự đếm, để web và WPF luôn ra cùng con số (quy tắc "BE tính số liệu").
export function toProgressPoints(days: DayProgressDto[], locale = 'vi-VN'): ChartPoint[] {
  const shortRange = days.length <= 7
  const isVi = locale.toLowerCase().startsWith('vi')
  const weekdayFmt = new Intl.DateTimeFormat(locale, { weekday: isVi ? 'narrow' : 'short' })
  return days.map((d) => {
    const dateObj = parseDateKey(d.date)
    const label = shortRange ? weekdayFmt.format(dateObj) : formatDayMonthByLocale(dateObj, locale)
    return { date: d.date, label, done: d.tasksDone, total: d.tasksTotal, percent: d.percent }
  })
}
