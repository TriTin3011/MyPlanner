// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { ChartCard } from './ChartCard'

afterEach(cleanup)

const mockData = [
  { date: '2026-11-16', label: 'T2', done: 3, total: 5, percent: 60 },
  { date: '2026-11-17', label: 'T3', done: 4, total: 4, percent: 100 },
  { date: '2026-11-18', label: 'T4', done: 1, total: 3, percent: 33 },
]

describe('ChartCard', () => {
  it('renders title, range select and legend', () => {
    render(
      <ChartCard
        title="Tiến độ gần đây"
        infoTooltip="Gợi ý tooltip"
        data={mockData}
        range="7"
        rangeOptions={[{ value: '7', label: '7 ngày' }]}
        onRangeChange={vi.fn()}
        mode="line"
        onModeChange={vi.fn()}
      />,
    )

    expect(screen.getByRole('heading', { name: 'Tiến độ gần đây' })).not.toBeNull()
    expect(screen.getByText('Đã xong')).not.toBeNull()
    expect(screen.getByText('Tổng việc')).not.toBeNull()
    expect(screen.getByRole('combobox')).not.toBeNull()
  })

  it('renders SVG area chart in line mode', () => {
    render(
      <ChartCard
        title="Tiến độ gần đây"
        data={mockData}
        range="7"
        rangeOptions={[{ value: '7', label: '7 ngày' }]}
        onRangeChange={vi.fn()}
        mode="line"
        onModeChange={vi.fn()}
      />,
    )

    const svg = screen.getByRole('img', { name: 'Biểu đồ tiến độ đường cong' })
    expect(svg).not.toBeNull()
  })

  it('triggers onModeChange when switching mode', () => {
    const handleModeChange = vi.fn()
    render(
      <ChartCard
        title="Tiến độ gần đây"
        data={mockData}
        range="7"
        rangeOptions={[{ value: '7', label: '7 ngày' }]}
        onRangeChange={vi.fn()}
        mode="line"
        onModeChange={handleModeChange}
      />,
    )

    expect(screen.getByRole('radio', { name: 'Bảng' })).not.toBeNull()
    fireEvent.click(screen.getByRole('radio', { name: 'Cột' }))
    expect(handleModeChange).toHaveBeenCalledWith('bar')
  })

  it('triggers onRangeChange when changing dropdown', () => {
    const handleRangeChange = vi.fn()
    render(
      <ChartCard
        title="Tiến độ gần đây"
        data={mockData}
        range="7"
        rangeOptions={[
          { value: '7', label: '7 ngày' },
          { value: '14', label: '14 ngày' },
        ]}
        onRangeChange={handleRangeChange}
        mode="line"
        onModeChange={vi.fn()}
      />,
    )

    fireEvent.click(screen.getByRole('combobox'))
    fireEvent.click(screen.getByRole('option', { name: '14 ngày' }))
    expect(handleRangeChange).toHaveBeenCalledWith('14')
  })
})
