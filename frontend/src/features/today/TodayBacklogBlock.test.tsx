// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { TaskDto } from '../../api/types'
import { TodayBacklogBlock } from './TodayBacklogBlock'

const sampleBacklog: TaskDto[] = [
  {
    id: 'backlog-1',
    title: 'Nộp báo cáo tuần trước',
    date: '2026-11-20',
    originalDate: null,
    done: false,
    doneAt: null,
    tags: ['urgent'],
    subtasks: [],
    recurringId: null,
    order: 0,
    createdAt: '2026-11-20T10:00:00Z',
    updatedAt: '2026-11-20T10:00:00Z',
  },
  {
    id: 'backlog-2',
    title: 'Gửi email cho đối tác',
    date: '2026-11-21',
    originalDate: null,
    done: false,
    doneAt: null,
    tags: ['important'],
    subtasks: [],
    recurringId: null,
    order: 1,
    createdAt: '2026-11-21T10:00:00Z',
    updatedAt: '2026-11-21T10:00:00Z',
  },
]

afterEach(cleanup)

describe('TodayBacklogBlock', () => {
  it('renders backlog count and collapses/expands properly', () => {
    render(
      <TodayBacklogBlock
        backlog={sampleBacklog}
        moveAllPending={false}
        pendingTaskId={undefined}
        error={false}
        onMoveAll={vi.fn()}
        onMoveTask={vi.fn()}
        onChangeDate={vi.fn()}
        onDeleteTask={vi.fn()}
        onToggleTask={vi.fn()}
      />,
    )

    const toggle = screen.getByRole('button', { name: /Việc còn tồn \(2\)/i })
    expect(toggle.getAttribute('aria-expanded')).toBe('false')

    fireEvent.click(toggle)
    expect(toggle.getAttribute('aria-expanded')).toBe('true')
    expect(screen.getByText('Nộp báo cáo tuần trước')).not.toBeNull()
    expect(screen.getByText('20/11')).not.toBeNull()
    expect(screen.getByText('Gấp')).not.toBeNull()
  })

  it('triggers onMoveAll when clicking "Chuyển tất cả vào hôm nay"', () => {
    const onMoveAll = vi.fn()
    render(
      <TodayBacklogBlock
        backlog={sampleBacklog}
        moveAllPending={false}
        pendingTaskId={undefined}
        error={false}
        onMoveAll={onMoveAll}
        onMoveTask={vi.fn()}
        onChangeDate={vi.fn()}
        onDeleteTask={vi.fn()}
        onToggleTask={vi.fn()}
      />,
    )

    const moveAllButton = screen.getByRole('button', { name: 'Chuyển tất cả vào hôm nay' })
    fireEvent.click(moveAllButton)

    expect(onMoveAll).toHaveBeenCalled()
  })

  it('triggers onMoveTask when moving an individual task to today', () => {
    const onMoveTask = vi.fn()
    render(
      <TodayBacklogBlock
        backlog={sampleBacklog}
        moveAllPending={false}
        pendingTaskId={undefined}
        error={false}
        onMoveAll={vi.fn()}
        onMoveTask={onMoveTask}
        onChangeDate={vi.fn()}
        onDeleteTask={vi.fn()}
        onToggleTask={vi.fn()}
      />,
    )

    // Mở danh sách, rồi mở menu ⋯ của việc đầu tiên
    fireEvent.click(screen.getByRole('button', { name: /Việc còn tồn/i }))
    fireEvent.click(screen.getByRole('button', { name: 'Thao tác với “Nộp báo cáo tuần trước”' }))

    fireEvent.click(screen.getByRole('menuitem', { name: 'Chuyển vào hôm nay' }))

    expect(onMoveTask).toHaveBeenCalledWith(sampleBacklog[0])
  })

  it('moves a backlog task to another date via "Chọn ngày khác"', async () => {
    const onChangeDate = vi.fn().mockResolvedValue(undefined)
    render(
      <TodayBacklogBlock
        backlog={sampleBacklog}
        moveAllPending={false}
        error={false}
        onMoveAll={vi.fn()}
        onMoveTask={vi.fn()}
        onChangeDate={onChangeDate}
        onDeleteTask={vi.fn()}
        onToggleTask={vi.fn()}
      />,
    )

    fireEvent.click(screen.getByRole('button', { name: /Việc còn tồn/i }))
    // Chuột phải trên dòng cũng mở menu
    fireEvent.contextMenu(screen.getByText('Gửi email cho đối tác'))
    fireEvent.click(screen.getByRole('menuitem', { name: 'Chọn ngày khác…' }))

    fireEvent.change(screen.getByLabelText('Chọn ngày khác'), { target: { value: '2026-11-25' } })
    fireEvent.click(screen.getByRole('button', { name: 'Chuyển' }))

    await waitFor(() => expect(onChangeDate).toHaveBeenCalledWith(sampleBacklog[1], '2026-11-25'))
    await waitFor(() => expect(screen.queryByRole('menu')).toBeNull())
  })

  it('triggers onDeleteTask when clicking delete on a backlog task', () => {
    const onDeleteTask = vi.fn()
    render(
      <TodayBacklogBlock
        backlog={sampleBacklog}
        moveAllPending={false}
        pendingTaskId={undefined}
        error={false}
        onMoveAll={vi.fn()}
        onMoveTask={vi.fn()}
        onChangeDate={vi.fn()}
        onDeleteTask={onDeleteTask}
        onToggleTask={vi.fn()}
      />,
    )

    fireEvent.click(screen.getByRole('button', { name: /Việc còn tồn/i }))
    fireEvent.click(screen.getByRole('button', { name: 'Thao tác với “Gửi email cho đối tác”' }))
    fireEvent.click(screen.getByRole('menuitem', { name: 'Xoá việc' }))

    expect(onDeleteTask).toHaveBeenCalledWith('backlog-2')
  })

  it('disables "Chuyển tất cả" when backlog is empty', () => {
    render(
      <TodayBacklogBlock
        backlog={[]}
        moveAllPending={false}
        pendingTaskId={undefined}
        error={false}
        onMoveAll={vi.fn()}
        onMoveTask={vi.fn()}
        onChangeDate={vi.fn()}
        onDeleteTask={vi.fn()}
        onToggleTask={vi.fn()}
      />,
    )

    const moveAllButton = screen.getByRole('button', { name: 'Chuyển tất cả vào hôm nay' }) as HTMLButtonElement
    expect(moveAllButton.disabled).toBe(true)
  })
})
