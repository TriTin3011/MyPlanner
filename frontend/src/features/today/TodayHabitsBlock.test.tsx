// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { MemoryRouter } from 'react-router'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { TodayHabitDto } from '../../api/types'
import { TodayHabitsBlock } from './TodayHabitsBlock'

const sampleHabits: TodayHabitDto[] = [
  {
    id: 'habit-1',
    title: 'Uống đủ 2 lít nước',
    order: 0,
    done: true,
  },
  {
    id: 'habit-2',
    title: 'Tập thể dục 30 phút',
    order: 1,
    done: false,
  },
]

afterEach(cleanup)

function renderWithRouter(ui: React.ReactElement) {
  return render(<MemoryRouter>{ui}</MemoryRouter>)
}

describe('TodayHabitsBlock', () => {
  it('renders habits list and sends next checked state on toggle', () => {
    const onToggle = vi.fn()
    renderWithRouter(
      <TodayHabitsBlock
        habits={sampleHabits}
        pendingHabitId={undefined}
        error={false}
        onToggle={onToggle}
      />,
    )

    expect(screen.getByRole('heading', { level: 2, name: 'Thói quen hôm nay' })).not.toBeNull()
    expect(screen.getByText('Uống đủ 2 lít nước')).not.toBeNull()
    expect(screen.getByText('Tập thể dục 30 phút')).not.toBeNull()

    const link = screen.getByRole('link', { name: 'Quản lý →' })
    expect(link.getAttribute('href')).toBe('/habits')

    const uncheckedBox = screen.getByRole('checkbox', {
      name: 'Đánh dấu thói quen “Tập thể dục 30 phút” là hoàn thành',
    })
    fireEvent.click(uncheckedBox)

    expect(onToggle).toHaveBeenCalledWith('habit-2', true)
  })

  it('disables checkbox and shows progress when habit is pending', () => {
    renderWithRouter(
      <TodayHabitsBlock
        habits={sampleHabits}
        pendingHabitId="habit-1"
        error={false}
        onToggle={vi.fn()}
      />,
    )

    const pendingCheckbox = screen.getByRole('checkbox', {
      name: 'Đánh dấu thói quen “Uống đủ 2 lít nước” là chưa hoàn thành',
    }) as HTMLInputElement
    expect(pendingCheckbox.disabled).toBe(true)
    expect(screen.getByRole('status', { name: 'Đang cập nhật thói quen' })).not.toBeNull()
  })

  it('renders empty message when no habits exist', () => {
    renderWithRouter(
      <TodayHabitsBlock
        habits={[]}
        pendingHabitId={undefined}
        error={false}
        onToggle={vi.fn()}
      />,
    )

    expect(screen.getByText('Chưa có thói quen nào. Tạo thói quen ở trang Quản lý.')).not.toBeNull()
  })

  it('announces error alert when mutation fails', () => {
    renderWithRouter(
      <TodayHabitsBlock
        habits={sampleHabits}
        pendingHabitId={undefined}
        error={true}
        onToggle={vi.fn()}
      />,
    )

    expect(screen.getByRole('alert').textContent).toContain('Chưa cập nhật được thói quen')
  })
})
