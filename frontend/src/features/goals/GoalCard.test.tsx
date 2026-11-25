// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { GoalCardDto } from '../../api/types'
import { GoalCard } from './GoalCard'
import { GoalCardGrid } from './GoalCardGrid'

const sampleGoal: GoalCardDto = {
  id: 'goal-1',
  title: 'Trả hết khoản vay thẻ tín dụng',
  areaId: 'area-finance',
  status: 'not_started',
  startDate: '2026-01-01',
  deadline: '2026-11-12',
  reward: 'Mua sách yêu thích',
  daysLeft: -10,
  stepsDone: 1,
  stepsTotal: 2,
  overdueSteps: 1,
  stepPercent: 50,
  timePercent: 100,
  behind: true,
}

describe('GoalCard', () => {
  afterEach(cleanup)

  it('shows overdue days, overdue steps, behind warning, and progress bars from backend DTO', () => {
    render(<GoalCard goal={sampleGoal} onOpen={vi.fn()} onToggleDone={vi.fn()} />)

    expect(screen.getByText('Trả hết khoản vay thẻ tín dụng')).not.toBeNull()
    expect(screen.getByText('Chưa bắt đầu')).not.toBeNull()
    expect(screen.getByText(/12\/11\/2026/)).not.toBeNull()
    expect(screen.getByText(/quá hạn 10 ngày/)).not.toBeNull()
    expect(screen.getByText('1 bước quá hạn')).not.toBeNull()
    expect(screen.getByText('1/2 bước')).not.toBeNull()
    expect(screen.getByText('Đang chậm hơn kế hoạch')).not.toBeNull()

    const stepBar = screen.getByRole('progressbar', { name: 'Tiến độ 50%' })
    const timeBar = screen.getByRole('progressbar', { name: 'Thời gian 100%' })
    expect(stepBar.getAttribute('aria-valuenow')).toBe('50')
    expect(timeBar.getAttribute('aria-valuenow')).toBe('100')
  })

  it('shows built-in area label and custom area name', () => {
    const { rerender } = render(
      <GoalCard
        goal={sampleGoal}
        area={{ id: 'area-finance', key: 'finance', name: null }}
        onOpen={vi.fn()}
        onToggleDone={vi.fn()}
      />,
    )
    expect(screen.getByText('Tài chính')).not.toBeNull()

    rerender(
      <GoalCard
        goal={sampleGoal}
        area={{ id: 'area-music', key: null, name: 'Âm nhạc' }}
        onOpen={vi.fn()}
        onToggleDone={vi.fn()}
      />,
    )
    expect(screen.getByText('Âm nhạc')).not.toBeNull()
  })

  it('calls onToggleDone when clicking checkbox without triggering onOpen', () => {
    const onOpen = vi.fn()
    const onToggleDone = vi.fn()
    render(<GoalCard goal={sampleGoal} onOpen={onOpen} onToggleDone={onToggleDone} />)

    const checkbox = screen.getByRole('checkbox', {
      name: 'Đánh dấu hoàn thành: Trả hết khoản vay thẻ tín dụng',
    })
    fireEvent.click(checkbox)

    expect(onToggleDone).toHaveBeenCalledWith('goal-1', true)
    expect(onOpen).not.toHaveBeenCalled()
  })

  it('calls onOpen when clicking the card body and hides remaining/overdue text when status is done', () => {
    const onOpen = vi.fn()
    const doneGoal: GoalCardDto = {
      ...sampleGoal,
      status: 'done',
      daysLeft: 90,
      behind: false,
    }
    render(<GoalCard goal={doneGoal} onOpen={onOpen} onToggleDone={vi.fn()} />)

    expect(screen.getByText('Đã hoàn thành')).not.toBeNull()
    expect(screen.queryByText(/còn 90 ngày/)).toBeNull()
    expect(screen.queryByText('Đang chậm hơn kế hoạch')).toBeNull()

    fireEvent.click(screen.getByText('Trả hết khoản vay thẻ tín dụng'))
    expect(onOpen).toHaveBeenCalledWith('goal-1')
  })

  it('renders emptyText in GoalCardGrid when goals list is empty', () => {
    render(
      <GoalCardGrid
        goals={[]}
        onOpen={vi.fn()}
        onToggleDone={vi.fn()}
        emptyText="Chưa có mục tiêu nào trong lĩnh vực này."
      />,
    )

    expect(screen.getByText('Chưa có mục tiêu nào trong lĩnh vực này.')).not.toBeNull()
  })
})
