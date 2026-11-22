import { describe, expect, it } from 'vitest'
import { toHabitDayPoints } from './habitChartData'

describe('toHabitDayPoints', () => {
  it('bỏ qua ngày tương lai có done null và lấy số ngày không đệm số 0', () => {
    const points = toHabitDayPoints([
      { date: '2026-11-01', done: 4, total: 6, percent: 67 },
      { date: '2026-11-22', done: 3, total: 6, percent: 50 },
      { date: '2026-11-23', done: null, total: null, percent: null },
    ])

    expect(points).toEqual([
      { date: '2026-11-01', label: '1', done: 4, total: 6, percent: 67 },
      { date: '2026-11-22', label: '22', done: 3, total: 6, percent: 50 },
    ])
  })
})
