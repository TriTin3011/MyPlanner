// @vitest-environment jsdom
// hooks.ts nhập api/client → i18n (đụng tới document), nên file test này cần môi trường DOM.
import { describe, expect, it } from 'vitest'
import type { YearDashboardDto, YearMonthDto, YearPlanItemDto } from '../../api/types'
import { applyYearReorder } from './hooks'

function item(id: string, month: number, order: number): YearPlanItemDto {
  return { id, year: 2026, month, title: id, done: false, order }
}

function board(items: YearPlanItemDto[]): YearDashboardDto {
  const months: YearMonthDto[] = Array.from({ length: 12 }, (_, i) => ({
    month: i + 1,
    done: 0,
    total: 0,
    percent: 0,
    deadlines: [],
    items: items.filter((it) => it.month === i + 1),
  }))
  return { year: 2026, keyword: '', vision: '', done: 0, total: 0, percent: 0, currentMonth: 11, months }
}

describe('applyYearReorder', () => {
  it('đổi thứ tự trong cùng tháng và đánh lại order', () => {
    const result = applyYearReorder(board([item('a', 3, 0), item('b', 3, 1)]), 3, ['b', 'a'])
    expect(result.months[2].items.map((i) => [i.id, i.order])).toEqual([
      ['b', 0],
      ['a', 1],
    ])
  })

  it('chuyển sang tháng khác: gỡ khỏi tháng cũ, cập nhật month', () => {
    const result = applyYearReorder(board([item('a', 3, 0), item('b', 4, 0)]), 4, ['b', 'a'])
    expect(result.months[2].items).toEqual([])
    expect(result.months[3].items.map((i) => [i.id, i.month])).toEqual([
      ['b', 4],
      ['a', 4],
    ])
  })

  it('bỏ qua id không có trong board', () => {
    const result = applyYearReorder(board([item('a', 1, 0)]), 1, ['x', 'a'])
    expect(result.months[0].items.map((i) => i.id)).toEqual(['a'])
  })
})
