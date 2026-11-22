// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { HabitMonthDto } from '../../api/types'
import { HabitGrid, type HabitGridProps } from './HabitGrid'

const month: HabitMonthDto = {
  month: '2026-11',
  from: '2026-11-01',
  to: '2026-11-30',
  percent: 50,
  longestStreak: null,
  mostConsistent: null,
  habits: [
    {
      id: 'habit-1',
      title: 'Uống đủ nước',
      order: 0,
      startDate: '2026-11-02',
      percent: 75,
      currentStreak: 3,
      longestStreak: 8,
      doneDates: ['2026-11-02'],
    },
  ],
  days: [],
}

function renderGrid(overrides: Partial<HabitGridProps> = {}) {
  const props: HabitGridProps = {
    month,
    today: '2026-11-22',
    recurringCount: 5,
    onToggle: vi.fn(),
    onAdd: vi.fn(),
    onDelete: vi.fn(),
    onReorder: vi.fn(),
    onOpenRecurring: vi.fn(),
    ...overrides,
  }
  render(<HabitGrid {...props} />)
  return props
}

afterEach(() => {
  cleanup()
  vi.restoreAllMocks()
})

describe('HabitGrid', () => {
  it('khóa ngày tương lai', () => {
    renderGrid()

    const checkbox = screen.getByRole('checkbox', { name: 'Uống đủ nước ngày 23/11' }) as HTMLButtonElement
    expect(checkbox.disabled).toBe(true)
  })

  it('khóa ngày trước khi tạo thói quen', () => {
    renderGrid()

    const checkbox = screen.getByRole('checkbox', { name: 'Uống đủ nước ngày 1/11' }) as HTMLButtonElement
    expect(checkbox.disabled).toBe(true)
  })

  it('gửi trạng thái mới khi đổi ô theo dõi', () => {
    const { onToggle } = renderGrid()

    fireEvent.click(screen.getByRole('checkbox', { name: 'Uống đủ nước ngày 2/11' }))

    expect(onToggle).toHaveBeenCalledWith('habit-1', '2026-11-02', false)
  })

  it('khóa nút thêm khi trống và gửi tiêu đề đã cắt khoảng trắng', () => {
    const { onAdd } = renderGrid()
    const input = screen.getByRole('textbox', { name: 'Tên thói quen mới' }) as HTMLInputElement
    const button = screen.getByRole('button', { name: 'Thêm thói quen' }) as HTMLButtonElement

    expect(button.disabled).toBe(true)
    fireEvent.change(input, { target: { value: '  Thiền 10 phút  ' } })
    fireEvent.submit(input.closest('form')!)

    expect(onAdd).toHaveBeenCalledWith('Thiền 10 phút')
    expect(input.value).toBe('')
  })

  it('hiện đúng 7 cột ngày ở chế độ Tuần', () => {
    renderGrid({ today: '2026-11-18' })

    fireEvent.click(screen.getByRole('button', { name: /bấm để xem tuần/ }))

    expect(screen.getAllByRole('columnheader')).toHaveLength(8)
    expect(screen.getByRole('button', { name: /bấm để xem cả tháng/ })).not.toBeNull()
  })

  it('hỏi xác nhận trước khi xóa', () => {
    const confirm = vi.spyOn(window, 'confirm').mockReturnValue(false)
    const { onDelete } = renderGrid()
    const button = screen.getByRole('button', { name: 'Xoá thói quen Uống đủ nước' })

    fireEvent.click(button)
    expect(confirm).toHaveBeenCalledOnce()
    expect(onDelete).not.toHaveBeenCalled()

    confirm.mockReturnValue(true)
    fireEvent.click(button)
    expect(onDelete).toHaveBeenCalledWith('habit-1')
  })
})
