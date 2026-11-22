// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { act, cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { DeleteWeekLink } from './DeleteWeekLink'

const { del } = vi.hoisted(() => ({ del: vi.fn() }))

vi.mock('../../api/client', () => ({ api: { delete: del } }))

function renderLink(onDeleted = vi.fn()) {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false }, mutations: { retry: false } },
  })
  const invalidate = vi.spyOn(queryClient, 'invalidateQueries')
  render(
    <QueryClientProvider client={queryClient}>
      <DeleteWeekLink weekKey="2026-W47" onDeleted={onDeleted} />
    </QueryClientProvider>,
  )
  return { invalidate, onDeleted }
}

describe('DeleteWeekLink', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  afterEach(() => {
    cleanup()
    vi.useRealTimers()
    del.mockReset()
  })

  it('requires a second click and resets confirmation after four seconds', () => {
    renderLink()

    fireEvent.click(screen.getByRole('button', { name: 'Xóa dữ liệu tuần đang xem' }))
    expect(screen.getByRole('button', { name: 'Bấm lần nữa để xóa vĩnh viễn' })).not.toBeNull()
    expect(del).not.toHaveBeenCalled()

    act(() => vi.advanceTimersByTime(4_000))

    expect(screen.getByRole('button', { name: 'Xóa dữ liệu tuần đang xem' })).not.toBeNull()
  })

  it('deletes on the second click, invalidates dependent data, then calls onDeleted', async () => {
    del.mockResolvedValueOnce({ data: { tasks: 4, habitLogs: 3, notes: 2 } })
    const { invalidate, onDeleted } = renderLink()

    fireEvent.click(screen.getByRole('button', { name: 'Xóa dữ liệu tuần đang xem' }))
    fireEvent.click(screen.getByRole('button', { name: 'Bấm lần nữa để xóa vĩnh viễn' }))

    await vi.waitFor(() => expect(onDeleted).toHaveBeenCalledOnce())

    expect(del).toHaveBeenCalledWith('/weeks/2026-W47')
    expect(invalidate).toHaveBeenCalledWith({ queryKey: ['tasks'] })
    expect(invalidate).toHaveBeenCalledWith({ queryKey: ['notes'] })
    expect(invalidate).toHaveBeenCalledWith({ queryKey: ['dashboard'] })
    expect(invalidate).toHaveBeenCalledWith({ queryKey: ['stats'] })
    expect(invalidate).toHaveBeenCalledWith({ queryKey: ['deadlines'] })
  })

  it('shows pending state while deletion is running', () => {
    del.mockReturnValueOnce(new Promise(() => undefined))
    renderLink()

    fireEvent.click(screen.getByRole('button', { name: 'Xóa dữ liệu tuần đang xem' }))
    fireEvent.click(screen.getByRole('button', { name: 'Bấm lần nữa để xóa vĩnh viễn' }))

    expect(screen.getByRole('button', { name: 'Đang xóa…' }).hasAttribute('disabled')).toBe(true)
  })

  it('shows the server error as an alert', async () => {
    del.mockRejectedValueOnce(new Error('Không thể xóa tuần'))
    renderLink()

    fireEvent.click(screen.getByRole('button', { name: 'Xóa dữ liệu tuần đang xem' }))
    fireEvent.click(screen.getByRole('button', { name: 'Bấm lần nữa để xóa vĩnh viễn' }))

    await vi.waitFor(() => {
      expect(screen.getByRole('alert').textContent).toContain('Không thể xóa tuần')
    })
  })
})
