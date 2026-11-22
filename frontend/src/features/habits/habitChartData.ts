import type { HabitDayCountDto } from '../../api/types'
import type { ChartPoint } from '../../lib/chartSvg'

// Chuyển danh sách ngày của tháng sang điểm vẽ biểu đồ (SPEC §8.2).
// Ngày tương lai BE trả done = null thì bỏ qua để phần sau hôm nay để trống; FE không tự tính lại %.
export function toHabitDayPoints(days: HabitDayCountDto[]): ChartPoint[] {
  const points: ChartPoint[] = []
  for (const d of days) {
    if (d.done === null || d.done === undefined) continue
    points.push({
      date: d.date,
      label: String(Number(d.date.split('-')[2])),
      done: d.done,
      total: d.total ?? 0,
      percent: d.percent ?? 0,
    })
  }
  return points
}
