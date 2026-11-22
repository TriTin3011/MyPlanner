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
    { area: 'health', count: 2, percent: 50 },
    { area: 'finance', count: 2, percent: 50 },
    { area: 'career', count: 2, percent: 33 },
    { area: 'growth', count: 1, percent: 100 },
    { area: 'relationship', count: 1, percent: 50 },
    { area: 'learning', count: 2, percent: 54 },
    { area: 'family', count: 1, percent: 0 },
    { area: 'hobby', count: 1, percent: 100 },
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

  it('renders 8 area chips and toggles filter off when clicking the selected chip', () => {
    const onSelectArea = vi.fn()
    const { rerender } = render(
      <GoalsOverview board={board} selectedArea={null} onSelectArea={onSelectArea} />,
    )

    const healthChip = screen.getByRole('button', { name: /Sức khỏe/ })
    expect(healthChip.getAttribute('aria-pressed')).toBe('false')
    fireEvent.click(healthChip)
    expect(onSelectArea).toHaveBeenCalledWith('health')

    // Khi chip đang được chọn, bấm lại phải gọi onSelectArea(null) để bỏ lọc
    rerender(<GoalsOverview board={board} selectedArea="health" onSelectArea={onSelectArea} />)
    const selectedChip = screen.getByRole('button', { name: /Sức khỏe/ })
    expect(selectedChip.getAttribute('aria-pressed')).toBe('true')
    fireEvent.click(selectedChip)
    expect(onSelectArea).toHaveBeenLastCalledWith(null)
  })
})
