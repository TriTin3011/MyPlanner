import { describe, expect, it } from 'vitest'
import { getHabitGridDays, isWeekend, weekdayLabel } from './habitGridDays'

describe('getHabitGridDays', () => {
  it('trả đủ ngày từ đầu đến cuối tháng', () => {
    const days = getHabitGridDays('2026-11-01', '2026-11-30', 'month', '2026-11-22')

    expect(days).toHaveLength(30)
    expect(days[0]).toBe('2026-11-01')
    expect(days[29]).toBe('2026-11-30')
  })

  it('trả tuần Thứ 2 đến Chủ nhật chứa hôm nay', () => {
    expect(getHabitGridDays('2026-11-01', '2026-11-30', 'week', '2026-11-18')).toEqual([
      '2026-11-16',
      '2026-11-17',
      '2026-11-18',
      '2026-11-19',
      '2026-11-20',
      '2026-11-21',
      '2026-11-22',
    ])
  })

  it('chọn tuần đầu giao với tháng và cắt ngày ngoài tháng khi hôm nay ở ngoài tháng', () => {
    expect(getHabitGridDays('2026-11-01', '2026-11-30', 'week', '2026-12-10')).toEqual(['2026-11-01'])
  })
})

describe('nhãn ngày', () => {
  it('đổi thứ sang nhãn Việt Nam và nhận diện cuối tuần', () => {
    expect(weekdayLabel('2026-11-22')).toBe('CN')
    expect(weekdayLabel('2026-11-23')).toBe('T2')
    expect(isWeekend('2026-11-21')).toBe(true)
    expect(isWeekend('2026-11-23')).toBe(false)
  })
})
