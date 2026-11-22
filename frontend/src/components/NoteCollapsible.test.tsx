// @vitest-environment jsdom

import { act, cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { NoteCollapsible } from './NoteCollapsible'

describe('NoteCollapsible', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  afterEach(() => {
    cleanup()
    vi.useRealTimers()
  })

  it('toggles open and closed with keyboard or click', () => {
    render(<NoteCollapsible onSave={vi.fn()} />)

    const toggleButton = screen.getByRole('button', { name: /Ghi chú hôm nay/i })
    expect(toggleButton.getAttribute('aria-expanded')).toBe('false')

    fireEvent.click(toggleButton)
    expect(toggleButton.getAttribute('aria-expanded')).toBe('true')
    expect(screen.getByPlaceholderText('Viết ghi chú nhanh cho hôm nay…')).not.toBeNull()

    fireEvent.click(toggleButton)
    expect(toggleButton.getAttribute('aria-expanded')).toBe('false')
  })

  it('triggers onSave after 500ms debounce when user stops typing', async () => {
    const onSave = vi.fn().mockResolvedValue(undefined)
    render(<NoteCollapsible initialContent="" onSave={onSave} />)

    fireEvent.click(screen.getByRole('button', { name: /Ghi chú hôm nay/i }))
    const textarea = screen.getByPlaceholderText('Viết ghi chú nhanh cho hôm nay…')

    fireEvent.change(textarea, { target: { value: 'Họp lúc 14h' } })

    // Chưa đủ 500ms thì chưa gọi onSave
    vi.advanceTimersByTime(200)
    expect(onSave).not.toHaveBeenCalled()

    // Sau khi qua 500ms
    vi.advanceTimersByTime(350)
    expect(onSave).toHaveBeenCalledWith('Họp lúc 14h')
  })

  it('triggers onSave immediately on blur if content changed', () => {
    const onSave = vi.fn().mockResolvedValue(undefined)
    render(<NoteCollapsible initialContent="Cũ" onSave={onSave} />)

    const textarea = screen.getByPlaceholderText('Viết ghi chú nhanh cho hôm nay…')
    fireEvent.change(textarea, { target: { value: 'Mới' } })

    // Blur ngay lập tức không đợi 500ms
    fireEvent.blur(textarea)
    expect(onSave).toHaveBeenCalledWith('Mới')
  })

  it('displays error alert when saving fails', async () => {
    const onSave = vi.fn().mockRejectedValue(new Error('Lỗi máy chủ'))
    render(<NoteCollapsible initialContent="Ghi chú" onSave={onSave} />)

    const textarea = screen.getByPlaceholderText('Viết ghi chú nhanh cho hôm nay…')
    fireEvent.change(textarea, { target: { value: 'Nội dung lỗi' } })

    await act(async () => {
      await vi.advanceTimersByTimeAsync(600)
    })

    expect(screen.getByRole('alert').textContent).toContain('Lỗi máy chủ')
  })
})
