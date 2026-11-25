// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { GoalBoardDto } from '../../api/types'
import { GoalsOverview } from './GoalsOverview'

const board: GoalBoardDto = {
  done: 2,
  total: 12,
  percent: 17,
  areas: [
    { id: 'a-health', key: 'health', name: null, count: 2, percent: 50 },
    { id: 'a-finance', key: 'finance', name: null, count: 2, percent: 50 },
    { id: 'a-career', key: 'career', name: null, count: 2, percent: 33 },
    { id: 'a-growth', key: 'growth', name: null, count: 1, percent: 100 },
    { id: 'a-relationship', key: 'relationship', name: null, count: 1, percent: 50 },
    { id: 'a-learning', key: 'learning', name: null, count: 2, percent: 54 },
    { id: 'a-family', key: 'family', name: null, count: 1, percent: 0 },
    { id: 'a-hobby', key: 'hobby', name: null, count: 1, percent: 100 },
    { id: 'a-music', key: null, name: 'Âm nhạc', count: 0, percent: 0 },
  ],
  goals: [],
}

describe('GoalsOverview', () => {
  afterEach(cleanup)

  it('displays completion ring and done/total goals count from backend', () => {
    render(<GoalsOverview board={board} selectedArea={null} onSelectArea={vi.fn()} />)

    const ring = screen.getByRole('progressbar', { name: 'Tỉ lệ mục tiêu đã hoàn thành' })
    expect(ring.getAttribute('aria-valuenow')).toBe('17')
    expect(screen.getByText('2/12')).not.toBeNull()
    expect(screen.getByText('mục tiêu')).not.toBeNull()
  })

  it('renders built-in and custom area chips and toggles filter off when clicking the selected chip', () => {
    const onSelectArea = vi.fn()
    const { rerender } = render(
      <GoalsOverview board={board} selectedArea={null} onSelectArea={onSelectArea} />,
    )

    expect(screen.getAllByRole('button')).toHaveLength(9)
    fireEvent.click(screen.getByRole('button', { name: /Âm nhạc/ }))
    expect(onSelectArea).toHaveBeenCalledWith('a-music')

    const healthChip = screen.getByRole('button', { name: /Sức khỏe/ })
    expect(healthChip.getAttribute('aria-pressed')).toBe('false')
    fireEvent.click(healthChip)
    expect(onSelectArea).toHaveBeenCalledWith('a-health')

    // Khi chip đang được chọn, bấm lại phải gọi onSelectArea(null) để bỏ lọc
    rerender(<GoalsOverview board={board} selectedArea="a-health" onSelectArea={onSelectArea} />)
    const selectedChip = screen.getByRole('button', { name: /Sức khỏe/ })
    expect(selectedChip.getAttribute('aria-pressed')).toBe('true')
    fireEvent.click(selectedChip)
    expect(onSelectArea).toHaveBeenLastCalledWith(null)
  })
})
