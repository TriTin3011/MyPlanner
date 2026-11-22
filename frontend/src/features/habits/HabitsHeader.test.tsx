// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { HabitMonthDto } from '../../api/types'
import { HabitsHeader } from './HabitsHeader'

const sampleMonth: HabitMonthDto = {
  month: '2026-11',
  from: '2026-11-01',
  to: '2026-11-30',
  percent: 64,
  longestStreak: {
    habitId: 'h1',
    title: 'Uống đủ 2 lít nước',
    value: 13,
  },
  mostConsistent: {
    habitId: 'h2',
    title: 'Học từ vựng 20 phút',
    value: 95,
  },
  habits: [],
  days: [],
}

function renderHeader(overrides: Partial<HabitMonthDto> = {}) {
  const handlers = { onPrev: vi.fn(), onNext: vi.fn(), onCurrent: vi.fn() }
  render(<HabitsHeader month={{ ...sampleMonth, ...overrides }} isCurrentMonth {...handlers} />)
  return handlers
}

describe('HabitsHeader', () => {
  afterEach(cleanup)

  it('shows the month subtitle and 3 stat strip values from BE', () => {
    renderHeader()

    expect(screen.getByRole('heading', { name: 'Theo dõi thói quen', level: 1 })).not.toBeNull()
    expect(screen.getByText('Tháng 11/2026')).not.toBeNull()
    expect(screen.getByText('64%')).not.toBeNull()
    expect(screen.getByText('13')).not.toBeNull()
    expect(screen.getByText('ngày')).not.toBeNull()
    expect(screen.getByText('Chuỗi dài nhất: Uống đủ 2 lít nước')).not.toBeNull()
    expect(screen.getByText('Học từ vựng 20 phút')).not.toBeNull()
    expect(screen.getByText('95%')).not.toBeNull()
  })

  it('renders em-dash when longestStreak and mostConsistent are null', () => {
    renderHeader({ longestStreak: null, mostConsistent: null })

    expect(screen.getAllByText('—').length).toBe(2)
    expect(screen.queryByText(/Chuỗi dài nhất:/)).toBeNull()
  })

  it('reports prev / current / next clicks to the page', () => {
    const handlers = renderHeader()

    fireEvent.click(screen.getByRole('button', { name: 'tháng trước' }))
    fireEvent.click(screen.getByRole('button', { name: 'Tháng này' }))
    fireEvent.click(screen.getByRole('button', { name: 'tháng sau' }))

    expect(handlers.onPrev).toHaveBeenCalledOnce()
    expect(handlers.onCurrent).toHaveBeenCalledOnce()
    expect(handlers.onNext).toHaveBeenCalledOnce()
  })
})
