// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { AddTaskInput } from './AddTaskInput'

afterEach(cleanup)

describe('AddTaskInput', () => {
  it('submits a trimmed title and clears only after success', async () => {
    const onAdd = vi.fn().mockResolvedValue(undefined)
    render(<AddTaskInput pending={false} onAdd={onAdd} />)

    const input = screen.getByRole('textbox', { name: 'Tên việc mới' }) as HTMLInputElement
    fireEvent.change(input, { target: { value: '  Viết báo cáo  ' } })
    fireEvent.submit(input.closest('form')!)

    expect(onAdd).toHaveBeenCalledWith('Viết báo cáo')
    await waitFor(() => expect(input.value).toBe(''))
  })

  it('keeps the title and announces the API error', async () => {
    const onAdd = vi.fn().mockRejectedValue(new Error('Không kết nối được backend'))
    render(<AddTaskInput pending={false} onAdd={onAdd} />)

    const input = screen.getByRole('textbox', { name: 'Tên việc mới' }) as HTMLInputElement
    fireEvent.change(input, { target: { value: 'Viết báo cáo' } })
    fireEvent.submit(input.closest('form')!)

    await waitFor(() => expect(screen.getByRole('alert').textContent).toContain('Không kết nối được backend'))
    expect(input.value).toBe('Viết báo cáo')
  })

  it('does not submit a blank title', () => {
    const onAdd = vi.fn()
    render(<AddTaskInput pending={false} onAdd={onAdd} />)

    const input = screen.getByRole('textbox', { name: 'Tên việc mới' })
    fireEvent.change(input, { target: { value: '   ' } })
    fireEvent.submit(input.closest('form')!)

    expect(onAdd).not.toHaveBeenCalled()
    expect((screen.getByRole('button', { name: 'Thêm việc' }) as HTMLButtonElement).disabled).toBe(true)
  })
})
