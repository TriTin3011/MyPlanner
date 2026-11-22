import { describe, expect, it } from 'vitest'
import { addDays, formatDayMonth, getMonthCalendarGrid, isoWeekKey, toLocalDateKey } from './dates'

describe('isoWeekKey', () => {
  it('uses the ISO week of the week containing the date', () => {
    expect(isoWeekKey('2026-11-16')).toBe('2026-W47')
    expect(isoWeekKey('2026-11-22')).toBe('2026-W47') // Chủ nhật vẫn thuộc tuần bắt đầu Thứ 2 16/11
  })

  it('handles weeks that cross the year boundary', () => {
    expect(isoWeekKey('2026-01-01')).toBe('2026-W01') // Thứ 5, nên tuần 1 thuộc 2026
    expect(isoWeekKey('2027-01-01')).toBe('2026-W53') // Thứ 6, thuộc tuần 53 của 2026
    expect(isoWeekKey('2024-12-30')).toBe('2025-W01') // Thứ 2 của tuần có Thứ 5 là 02/01/2025
  })
})

describe('formatDayMonth', () => {
  it('formats as dd/MM', () => {
    expect(formatDayMonth('2026-11-16')).toBe('16/11')
  })
})

describe('toLocalDateKey', () => {
  it('formats the calendar date without converting to UTC', () => {
    const localLateNight = new Date(2026, 10, 22, 23, 45)

    expect(toLocalDateKey(localLateNight)).toBe('2026-11-22')
  })
})

describe('addDays', () => {
  it('adds and subtracts days correctly', () => {
    expect(addDays('2026-11-22', 1)).toBe('2026-11-23')
    expect(addDays('2026-11-01', -1)).toBe('2026-10-31')
  })
})

describe('getMonthCalendarGrid', () => {
  it('generates 42 days grid starting on Monday for November 2026', () => {
    const grid = getMonthCalendarGrid(2026, 11)

    expect(grid).toHaveLength(42)
    // 1/11/2026 là Chủ nhật, nên tuần đầu tiên bắt đầu từ Thứ Hai 26/10/2026
    expect(grid[0].date).toBe('2026-10-26')
    expect(grid[0].dayNumber).toBe(26)
    expect(grid[0].isCurrentMonth).toBe(false)

    // Ô thứ 7 là Chủ nhật 01/11/2026
    expect(grid[6].date).toBe('2026-11-01')
    expect(grid[6].dayNumber).toBe(1)
    expect(grid[6].isCurrentMonth).toBe(true)

    // Ô thứ 27 là Chủ nhật 22/11/2026
    expect(grid[27].date).toBe('2026-11-22')
    expect(grid[27].isCurrentMonth).toBe(true)
  })
})
