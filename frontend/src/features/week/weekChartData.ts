import type { WeekProgressDto } from '../../api/types'
import type { ChartPoint } from '../../lib/chartSvg'
import { addDays, formatDayMonth } from '../../lib/dates'

// Ba khoảng của biểu đồ Kế hoạch tuần (SPEC §9.2). Giá trị là số tuần, lưu dạng chuỗi trong settings.
export type WeekChartRange = '1' | '4' | '12'

export function parseWeekRange(value: string | undefined): WeekChartRange {
  return value === '4' || value === '12' ? value : '1'
}

// 1 tuần và 4 tuần vẽ theo NGÀY, luôn kết thúc ở Chủ nhật của tuần đang xem (không phải "hôm nay"),
// để lùi về tuần trước thì biểu đồ cũng lùi theo.
export function dayRangeForWeeks(monday: string, weeks: number): { from: string; to: string } {
  return { from: addDays(monday, -7 * (weeks - 1)), to: addDays(monday, 6) }
}

// 12 tuần vẽ theo TUẦN: mỗi điểm là một tuần, nhãn trục X là Thứ 2 của tuần đó dạng dd/MM.
export function toWeekPoints(weeks: WeekProgressDto[]): ChartPoint[] {
  return weeks.map((w) => ({
    date: w.monday,
    label: formatDayMonth(w.monday),
    done: w.tasksDone,
    total: w.tasksTotal,
    percent: w.percent,
  }))
}
