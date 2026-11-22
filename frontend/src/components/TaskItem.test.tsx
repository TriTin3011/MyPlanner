// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { TaskDto } from '../api/types'
import { TaskItem } from './TaskItem'

const task: TaskDto = {
  id: '11111111-1111-1111-1111-111111111111',
  title: 'Hoàn thành bài tập React',
  date: '2026-11-22',
  originalDate: null,
  done: false,
  doneAt: null,
  tags: ['urgent', 'important'],
  subtasks: [
    { id: '22222222-2222-2222-2222-222222222222', title: 'Viết test', done: true },
    { id: '33333333-3333-3333-3333-333333333333', title: 'Viết component', done: false },
  ],
  recurringId: '44444444-4444-4444-4444-444444444444',
  order: 1,
  createdAt: '2026-11-20T08:00:00Z',
  updatedAt: '2026-11-20T08:00:00Z',
}

afterEach(cleanup)

describe('TaskItem', () => {
  it('shows task metadata and sends the next completion state', () => {
    const onToggle = vi.fn()
    render(
      <TaskItem
        task={task}
        pending={false}
        renamePending={false}
        pendingSubtaskId={undefined}
        onToggle={onToggle}
        onRename={vi.fn()}
        onToggleSubtask={vi.fn()}
      />,
    )

    expect(screen.getByText('Hoàn thành bài tập React')).not.toBeNull()
    expect(screen.getByText('Gấp')).not.toBeNull()
    expect(screen.getByText('Quan trọng')).not.toBeNull()
    expect(screen.getByText('1/2 việc nhỏ')).not.toBeNull()
    expect(screen.getByLabelText('Việc lặp lại')).not.toBeNull()

    fireEvent.click(screen.getByRole('checkbox', { name: 'Đánh dấu “Hoàn thành bài tập React” là hoàn thành' }))

    expect(onToggle).toHaveBeenCalledWith(task.id, true)
  })

  it('disables the checkbox and exposes progress while updating', () => {
    render(
      <TaskItem
        task={task}
        pending
        renamePending={false}
        pendingSubtaskId={undefined}
        onToggle={vi.fn()}
        onRename={vi.fn()}
        onToggleSubtask={vi.fn()}
      />,
    )

    expect((screen.getByRole('checkbox') as HTMLInputElement).disabled).toBe(true)
    expect(screen.getByRole('status', { name: 'Đang cập nhật công việc' })).not.toBeNull()
  })

  it('submits a trimmed inline title and closes the editor after success', async () => {
    const onRename = vi.fn().mockResolvedValue(undefined)
    render(
      <TaskItem
        task={task}
        pending={false}
        renamePending={false}
        pendingSubtaskId={undefined}
        onToggle={vi.fn()}
        onRename={onRename}
        onToggleSubtask={vi.fn()}
      />,
    )

    fireEvent.click(screen.getByRole('button', { name: 'Sửa tiêu đề “Hoàn thành bài tập React”' }))
    const input = screen.getByRole('textbox', { name: 'Tiêu đề công việc' }) as HTMLInputElement
    fireEvent.change(input, { target: { value: '  Hoàn thành bài tập TypeScript  ' } })
    fireEvent.submit(input.closest('form')!)

    expect(onRename).toHaveBeenCalledWith(task, 'Hoàn thành bài tập TypeScript')
    await waitFor(() => expect(screen.queryByRole('textbox', { name: 'Tiêu đề công việc' })).toBeNull())
  })

  it('keeps the draft open and announces a rename error', async () => {
    const onRename = vi.fn().mockRejectedValue(new Error('Không lưu được tiêu đề'))
    render(
      <TaskItem
        task={task}
        pending={false}
        renamePending={false}
        pendingSubtaskId={undefined}
        onToggle={vi.fn()}
        onRename={onRename}
        onToggleSubtask={vi.fn()}
      />,
    )

    fireEvent.click(screen.getByRole('button', { name: 'Sửa tiêu đề “Hoàn thành bài tập React”' }))
    const input = screen.getByRole('textbox', { name: 'Tiêu đề công việc' }) as HTMLInputElement
    fireEvent.change(input, { target: { value: 'Bản nháp mới' } })
    fireEvent.submit(input.closest('form')!)

    await waitFor(() => expect(screen.getByRole('alert').textContent).toContain('Không lưu được tiêu đề'))
    expect(input.value).toBe('Bản nháp mới')
  })

  it('cancels inline editing with Escape', () => {
    const onRename = vi.fn()
    render(
      <TaskItem
        task={task}
        pending={false}
        renamePending={false}
        pendingSubtaskId={undefined}
        onToggle={vi.fn()}
        onRename={onRename}
        onToggleSubtask={vi.fn()}
      />,
    )

    fireEvent.click(screen.getByRole('button', { name: 'Sửa tiêu đề “Hoàn thành bài tập React”' }))
    fireEvent.keyDown(screen.getByRole('textbox', { name: 'Tiêu đề công việc' }), { key: 'Escape' })

    expect(screen.queryByRole('textbox', { name: 'Tiêu đề công việc' })).toBeNull()
    expect(onRename).not.toHaveBeenCalled()
  })

  it('expands subtasks and sends the next checked state', () => {
    const onToggleSubtask = vi.fn().mockResolvedValue(undefined)
    render(
      <TaskItem
        task={task}
        pending={false}
        renamePending={false}
        pendingSubtaskId={undefined}
        onToggle={vi.fn()}
        onRename={vi.fn()}
        onToggleSubtask={onToggleSubtask}
      />,
    )

    const disclosure = screen.getByRole('button', { name: '1/2 việc nhỏ' })
    expect(disclosure.getAttribute('aria-expanded')).toBe('false')
    fireEvent.click(disclosure)

    expect(disclosure.getAttribute('aria-expanded')).toBe('true')
    expect(screen.getByRole('checkbox', { name: 'Đánh dấu bước “Viết test” là chưa hoàn thành' })).not.toBeNull()
    fireEvent.click(screen.getByRole('checkbox', { name: 'Đánh dấu bước “Viết component” là hoàn thành' }))

    expect(onToggleSubtask).toHaveBeenCalledWith(
      task,
      '33333333-3333-3333-3333-333333333333',
      true,
    )
  })

  it('keeps subtasks expanded and announces a toggle error', async () => {
    const onToggleSubtask = vi.fn().mockRejectedValue(new Error('Không cập nhật được bước con'))
    render(
      <TaskItem
        task={task}
        pending={false}
        renamePending={false}
        pendingSubtaskId={undefined}
        onToggle={vi.fn()}
        onRename={vi.fn()}
        onToggleSubtask={onToggleSubtask}
      />,
    )

    fireEvent.click(screen.getByRole('button', { name: '1/2 việc nhỏ' }))
    fireEvent.click(screen.getByRole('checkbox', { name: 'Đánh dấu bước “Viết component” là hoàn thành' }))

    await waitFor(() => expect(screen.getByRole('alert').textContent).toContain('Không cập nhật được bước con'))
    expect(screen.getByRole('button', { name: '1/2 việc nhỏ' }).getAttribute('aria-expanded')).toBe('true')
  })
})
