import { describe, expect, it } from 'vitest'
import type { DayProgressDto } from '../../api/types'
import { computeDateRange, toProgressPoints } from './chartData'

function day(date: string, tasksDone = 0, tasksTotal = 0, percent = 0): DayProgressDto {
  return { date, tasksDone, tasksTotal, percent, hasDeadline: false }
}

describe('chartData', () => {
  it('computes date range correctly for 7, 14 days', () => {
    expect(computeDateRange('2026-11-22', 7)).toEqual({ from: '2026-11-16', to: '2026-11-22' })
    expect(computeDateRange('2026-11-22', 14)).toEqual({ from: '2026-11-09', to: '2026-11-22' })
  })

  it('maps backend numbers to points with T2..CN labels for 7 days', () => {
    const days = Array.from({ length: 7 }, (_, i) => day(`2026-11-${16 + i}`))
    days[0] = day('2026-11-16', 1, 2, 50)
    days[6] = day('2026-11-22', 1, 1, 100)

    const points = toProgressPoints(days)

    expect(points).toHaveLength(7)
    expect(points[0]).toEqual({ date: '2026-11-16', label: 'T2', done: 1, total: 2, percent: 50 })
    expect(points[6]).toEqual({ date: '2026-11-22', label: 'CN', done: 1, total: 1, percent: 100 })
  })

  it('uses dd/MM labels when the range is longer than 7 days', () => {
    const days = Array.from({ length: 14 }, (_, i) => day(`2026-11-${String(9 + i).padStart(2, '0')}`))
    const points = toProgressPoints(days)
    expect(points[0].label).toBe('09/11')
    expect(points[13].label).toBe('22/11')
  })
})
