// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { YearMonthDto } from '../../api/types'
import { YearMonthsBoard } from './YearMonthsBoard'

function months(): YearMonthDto[] {
  return Array.from({ length: 12 }, (_, i) => ({
    month: i + 1,
    done: i === 10 ? 1 : 0,
    total: i === 10 ? 2 : 0,
    percent: i === 10 ? 50 : 0,
    deadlines: [],
    items:
      i === 10
        ? [
            { id: 'a', year: 2026, month: 11, title: 'Thi HSK 4', done: false, order: 0 },
            { id: 'b', year: 2026, month: 11, title: 'Tiết kiệm', done: true, order: 1 },
          ]
        : [],
  }))
}

function renderBoard(overrides: Partial<Parameters<typeof YearMonthsBoard>[0]> = {}) {
  const props = {
    months: months(),
    currentMonth: 11,
    onReorder: vi.fn(),
    onToggle: vi.fn(),
    onDelete: vi.fn(),
    onAdd: vi.fn().mockResolvedValue(undefined),
    ...overrides,
  }
  render(<YearMonthsBoard {...props} />)
  return props
}

afterEach(cleanup)

describe('YearMonthsBoard', () => {
  it('chỉ mở sẵn tháng hiện tại, có nhãn Nay', () => {
    renderBoard()
    expect(screen.getByRole('button', { name: /Tháng 11/ }).getAttribute('aria-expanded')).toBe('true')
    expect(screen.getByRole('button', { name: /Tháng 3/ }).getAttribute('aria-expanded')).toBe('false')
    expect(screen.getByText('Nay')).toBeTruthy()
    expect((screen.getByLabelText('Thi HSK 4') as HTMLInputElement).checked).toBe(false)
  })

  it('tick và phím mũi tên trên tay nắm gọi đúng lệnh', () => {
    const props = renderBoard()
    fireEvent.click(screen.getByLabelText('Thi HSK 4'))
    expect(props.onToggle).toHaveBeenCalledWith(expect.objectContaining({ id: 'a' }), true)

    fireEvent.keyDown(screen.getByRole('button', { name: /Kéo để sắp xếp.*Thi HSK 4/ }), { key: 'ArrowDown' })
    expect(props.onReorder).toHaveBeenCalledWith({ month: 11, ids: ['b', 'a'] })

    fireEvent.keyDown(screen.getByRole('button', { name: /Kéo để sắp xếp.*Thi HSK 4/ }), { key: 'ArrowRight' })
    expect(props.onReorder).toHaveBeenCalledWith({ month: 12, ids: ['a'] })
  })

  it('năm khác: không tháng nào mở sẵn', () => {
    renderBoard({ currentMonth: null })
    expect(screen.queryByText('Nay')).toBeNull()
    expect(screen.getByRole('button', { name: /Tháng 11/ }).getAttribute('aria-expanded')).toBe('false')
  })
})
