import type { DayProgressDto } from '../../api/types'
import type { ChartPoint } from '../../lib/chartSvg'
import { addDays, parseDateKey } from '../../lib/dates'

const DOW_LABELS = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7']

export function computeDateRange(today: string, daysCount: number): { from: string; to: string } {
  // Khoảng lùi từ today: ví dụ 7 ngày là từ today - 6 ngày đến today
  const from = addDays(today, -(daysCount - 1))
  return { from, to: today }
}

// Chỉ đổi dữ liệu BE đã tính (xong/tổng/%) sang điểm vẽ và gắn nhãn trục X.
// FE không tự đếm, để web và WPF luôn ra cùng con số (quy tắc "BE tính số liệu").
export function toProgressPoints(days: DayProgressDto[]): ChartPoint[] {
  const shortRange = days.length <= 7
  return days.map((d) => {
    const dateObj = parseDateKey(d.date)
    const label = shortRange
      ? DOW_LABELS[dateObj.getDay()]
      : `${String(dateObj.getDate()).padStart(2, '0')}/${String(dateObj.getMonth() + 1).padStart(2, '0')}`
    return { date: d.date, label, done: d.tasksDone, total: d.tasksTotal, percent: d.percent }
  })
}
