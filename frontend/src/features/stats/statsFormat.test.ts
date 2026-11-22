import { describe, expect, it } from 'vitest'
import { buildHeatmapGrid, formatDecimal, formatDm, toChartPoints, weekdayLabel } from './statsFormat'

function days(from: string, count: number) {
  const start = new Date(`${from}T00:00:00Z`).getTime()
  return Array.from({ length: count }, (_, i) => ({
    date: new Date(start + i * 86_400_000).toISOString().slice(0, 10),
    done: i,
    level: i % 5,
  }))
}

describe('statsFormat', () => {
  it('đặt tên thứ theo ISO, CN là 7', () => {
    expect(weekdayLabel(1)).toBe('Thứ 2')
    expect(weekdayLabel(6, true)).toBe('T7')
    expect(weekdayLabel(7)).toBe('Chủ nhật')
    expect(weekdayLabel(7, true)).toBe('CN')
  })

  it('định dạng ngày và số kiểu Việt', () => {
    expect(formatDm('2026-11-16')).toBe('16/11')
    expect(formatDecimal(2.5)).toBe('2,5')
    expect(formatDecimal(3)).toBe('3,0')
  })

  it('đổi điểm tuần sang ChartPoint với nhãn dd/MM', () => {
    const pts = toChartPoints([{ weekKey: '2026-W47', monday: '2026-11-16', done: 3, total: 4, percent: 75 }])
    expect(pts).toEqual([{ date: '2026-11-16', label: '16/11', done: 3, total: 4, percent: 75 }])
  })

  it('xếp ngày vào cột tuần bắt đầu Thứ 2', () => {
    // 2026-11-04 là Thứ 4 → hàng 2 của cột 0; Thứ 2 kế tiếp (09/11) mở cột 1.
    const grid = buildHeatmapGrid(days('2026-11-04', 7))
    expect(grid.cells[0]).toMatchObject({ date: '2026-11-04', row: 2, col: 0 })
    expect(grid.cells.find((c) => c.date === '2026-11-08')).toMatchObject({ row: 6, col: 0 })
    expect(grid.cells.find((c) => c.date === '2026-11-09')).toMatchObject({ row: 0, col: 1 })
    expect(grid.columns).toBe(2)
  })

  it('gắn nhãn tháng ở cột đầu và cột chứa mùng 1', () => {
    // Cột 0 = 26/10…01/11 chứa mùng 1/11 nên nhãn Th10 bị thay bằng Th11; 30/11 → 01/12 mở nhãn Th12.
    expect(buildHeatmapGrid(days('2026-10-26', 14)).monthLabels).toEqual([{ col: 0, label: 'Th11' }])
    expect(buildHeatmapGrid(days('2026-11-16', 21)).monthLabels).toEqual([
      { col: 0, label: 'Th11' },
      { col: 2, label: 'Th12' },
    ])
  })

  it('trả lưới rỗng khi không có ngày', () => {
    expect(buildHeatmapGrid([])).toEqual({ cells: [], columns: 0, monthLabels: [] })
  })
})