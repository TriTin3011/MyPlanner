import { describe, expect, it } from 'vitest'
import { dayRangeForWeeks, parseWeekRange, toWeekPoints } from './weekChartData'

describe('dayRangeForWeeks', () => {
  it('1 tuần là đúng Thứ 2 → Chủ nhật của tuần đang xem', () => {
    expect(dayRangeForWeeks('2026-11-16', 1)).toEqual({ from: '2026-11-16', to: '2026-11-22' })
  })

  it('4 tuần lùi 3 tuần trước, vẫn kết thúc ở Chủ nhật tuần đang xem', () => {
    expect(dayRangeForWeeks('2026-11-16', 4)).toEqual({ from: '2026-10-26', to: '2026-11-22' })
  })
})

describe('parseWeekRange', () => {
  it('giá trị lạ (hoặc chưa lưu) quay về 1 tuần', () => {
    expect(parseWeekRange(undefined)).toBe('1')
    expect(parseWeekRange('7')).toBe('1')
    expect(parseWeekRange('12')).toBe('12')
  })
})

describe('toWeekPoints', () => {
  it('nhãn là Thứ 2 dạng dd/MM, số liệu giữ nguyên từ BE', () => {
    const points = toWeekPoints([
      { weekKey: '2026-W47', monday: '2026-11-16', tasksDone: 24, tasksTotal: 42, percent: 57 },
    ])
    expect(points).toEqual([{ date: '2026-11-16', label: '16/11', done: 24, total: 42, percent: 57 }])
  })
})
