// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { WeekDashboardDto } from '../../api/types'
import { WeekHeader } from './WeekHeader'

const week: WeekDashboardDto = {
  weekKey: '2026-W47',
  from: '2026-11-16',
  to: '2026-11-22',
  tasksDone: 24,
  tasksTotal: 42,
  habitPercent: 55,
  todayRemaining: 7,
  comment: 'Khá tốt, giữ nhịp này nhé.',
  days: [],
  insights: ['Xong ít hơn tuần trước 10 việc, thử chia nhỏ việc để dễ hoàn thành hơn.'],
}

function renderHeader(overrides: Partial<WeekDashboardDto> = {}) {
  const handlers = { onPrev: vi.fn(), onNext: vi.fn(), onCurrent: vi.fn() }
  render(<WeekHeader week={{ ...week, ...overrides }} isCurrentWeek {...handlers} />)
  return handlers
}

describe('WeekHeader', () => {
  afterEach(cleanup)

  it('shows the ISO week subtitle and the numbers from the BE', () => {
    renderHeader()

    expect(screen.getByRole('heading', { name: 'Kế hoạch tuần', level: 1 })).not.toBeNull()
    expect(screen.getByText('Tuần 47 · 16/11 – 22/11/2026')).not.toBeNull()
    expect(screen.getByText('24')).not.toBeNull()
    expect(screen.getByText('/ 42')).not.toBeNull()
    expect(screen.getByText('55%')).not.toBeNull()
    expect(screen.getByText('Khá tốt, giữ nhịp này nhé.')).not.toBeNull()
  })

  it('toggles the insights with Xem thêm / Thu gọn', () => {
    renderHeader()
    const list = screen.getByText(/Xong ít hơn tuần trước 10 việc/).closest('ul')!
    const toggle = screen.getByRole('button', { name: 'Xem thêm' })

    expect(list.hidden).toBe(true)
    fireEvent.click(toggle)
    expect(list.hidden).toBe(false)
    expect(toggle.getAttribute('aria-expanded')).toBe('true')
    expect(toggle.textContent).toContain('Thu gọn')
    fireEvent.click(toggle)
    expect(list.hidden).toBe(true)
  })

  it('hides Xem thêm when there are no insights', () => {
    renderHeader({ insights: [] })

    expect(screen.queryByRole('button', { name: 'Xem thêm' })).toBeNull()
  })

  it('reports prev / current / next clicks to the page', () => {
    const handlers = renderHeader()

    fireEvent.click(screen.getByRole('button', { name: 'tuần trước' }))
    fireEvent.click(screen.getByRole('button', { name: 'Tuần này' }))
    fireEvent.click(screen.getByRole('button', { name: 'tuần sau' }))

    expect(handlers.onPrev).toHaveBeenCalledOnce()
    expect(handlers.onCurrent).toHaveBeenCalledOnce()
    expect(handlers.onNext).toHaveBeenCalledOnce()
  })
})
