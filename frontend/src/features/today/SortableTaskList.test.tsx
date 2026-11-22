// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { TaskDto } from '../../api/types'
import { SortableTaskList } from './SortableTaskList'

function task(id: string, title: string): TaskDto {
  return {
    id,
    title,
    date: '2026-11-22',
    done: false,
    tags: [],
    subtasks: [],
    order: 0,
    recurringId: null,
  } as unknown as TaskDto
}

const tasks = [task('a', 'Đọc sách'), task('b', 'Chạy bộ'), task('c', 'Học tiếng Anh')]

describe('SortableTaskList', () => {
  afterEach(cleanup)

  it('renders a drag handle per row inside the item', () => {
    render(
      <SortableTaskList
        tasks={tasks}
        onReorder={vi.fn()}
        renderItem={(t, handle) => (
          <div key={t.id} data-testid={`row-${t.id}`}>
            {handle}
            {t.title}
          </div>
        )}
      />,
    )

    expect(screen.getByRole('button', { name: 'Kéo để sắp xếp “Chạy bộ”' })).not.toBeNull()
    expect(screen.getAllByRole('button', { name: /^Kéo để sắp xếp/ })).toHaveLength(3)
  })

  it('moves a task one step with the arrow keys on its handle', () => {
    const onReorder = vi.fn()
    render(
      <SortableTaskList
        tasks={tasks}
        onReorder={onReorder}
        renderItem={(t, handle) => (
          <div key={t.id}>
            {handle}
            {t.title}
          </div>
        )}
      />,
    )

    fireEvent.keyDown(screen.getByRole('button', { name: 'Kéo để sắp xếp “Chạy bộ”' }), { key: 'ArrowDown' })
    expect(onReorder).toHaveBeenLastCalledWith(['a', 'c', 'b'])
    expect(screen.getByText('Đã chuyển “Chạy bộ” tới vị trí 3 trên 3.')).not.toBeNull()

    fireEvent.keyDown(screen.getByRole('button', { name: 'Kéo để sắp xếp “Chạy bộ”' }), { key: 'ArrowUp' })
    expect(onReorder).toHaveBeenLastCalledWith(['b', 'a', 'c'])

    // Đã ở đầu danh sách thì ↑ không làm gì.
    onReorder.mockClear()
    fireEvent.keyDown(screen.getByRole('button', { name: 'Kéo để sắp xếp “Đọc sách”' }), { key: 'ArrowUp' })
    expect(onReorder).not.toHaveBeenCalled()
  })

  it('disables the handles when disabled', () => {
    render(
      <SortableTaskList
        tasks={tasks.slice(0, 1)}
        onReorder={vi.fn()}
        disabled
        renderItem={(t, handle) => (
          <div key={t.id}>
            {handle}
            {t.title}
          </div>
        )}
      />,
    )

    const handle = screen.getByRole('button', { name: 'Kéo để sắp xếp “Đọc sách”' }) as HTMLButtonElement
    expect(handle.disabled).toBe(true)
  })
})
