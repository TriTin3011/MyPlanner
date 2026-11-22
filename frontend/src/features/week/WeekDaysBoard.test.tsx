// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { DeadlineDto, TaskDto } from '../../api/types'
import { groupTasksByDate } from './hooks'
import { WeekDaysBoard } from './WeekDaysBoard'

const dates = ['2026-11-16', '2026-11-17', '2026-11-18', '2026-11-19', '2026-11-20', '2026-11-21', '2026-11-22']

function task(id: string, date: string, order: number): TaskDto {
  return {
    id,
    title: `Việc ${id}`,
    date,
    originalDate: null,
    done: false,
    doneAt: null,
    tags: [],
    subtasks: [],
    recurringId: null,
    order,
    createdAt: '2026-11-01T00:00:00Z',
    updatedAt: '2026-11-01T00:00:00Z',
  }
}

const overdueStep: DeadlineDto = {
  date: '2026-11-17',
  kind: 'step',
  goalId: 'g1',
  goalTitle: 'IELTS 7.0',
  title: 'Làm xong 10 đề',
  done: false,
  overdue: true,
}

function renderBoard(tasks: TaskDto[]) {
  const onArrange = vi.fn()
  render(
    <WeekDaysBoard
      dates={dates}
      today="2026-11-22"
      tasksByDate={groupTasksByDate(tasks, dates)}
      deadlinesByDate={{ '2026-11-17': [overdueStep] }}
      notesByDate={{}}
      onArrange={onArrange}
      renderTask={(t, handle) => (
        <div>
          {t.title}
          {handle}
        </div>
      )}
      onAdd={vi.fn()}
      onSaveNote={vi.fn()}
    />,
  )
  return onArrange
}

describe('groupTasksByDate', () => {
  it('puts every day in the result and sorts each day by order', () => {
    const byDate = groupTasksByDate([task('b', dates[0], 1), task('a', dates[0], 0), task('x', '2026-12-01', 0)], dates)
    expect(Object.keys(byDate)).toEqual(dates)
    expect(byDate[dates[0]].map((t) => t.id)).toEqual(['a', 'b'])
    expect(byDate[dates[1]]).toEqual([])
  })
})

describe('WeekDaysBoard', () => {
  afterEach(cleanup)

  it('renders 7 day columns, the today badge, empty text and the pink deadline row', () => {
    renderBoard([task('a', dates[0], 0)])
    expect(screen.getByRole('heading', { name: 'Thứ 2' })).not.toBeNull()
    expect(screen.getByRole('heading', { name: /Chủ nhật/ }).textContent).toContain('Hôm nay')
    expect(screen.getAllByText('Chưa có việc nào')).toHaveLength(6)
    expect(screen.getByText(/Hạn bước: Làm xong 10 đề/).textContent).toContain('quá hạn')
  })

  it('moves a task down inside its day with ArrowDown', () => {
    const onArrange = renderBoard([task('a', dates[0], 0), task('b', dates[0], 1)])
    fireEvent.keyDown(screen.getByRole('button', { name: /Việc a/ }), { key: 'ArrowDown' })
    expect(onArrange).toHaveBeenCalledWith({ date: dates[0], ids: ['b', 'a'] })
  })

  it('moves a task to the end of the next day with ArrowRight', () => {
    const onArrange = renderBoard([task('a', dates[0], 0), task('c', dates[1], 0)])
    fireEvent.keyDown(screen.getByRole('button', { name: /Việc a/ }), { key: 'ArrowRight' })
    expect(onArrange).toHaveBeenCalledWith({ date: dates[1], ids: ['c', 'a'] })
  })

  it('does nothing with ArrowLeft on Monday', () => {
    const onArrange = renderBoard([task('a', dates[0], 0)])
    fireEvent.keyDown(screen.getByRole('button', { name: /Việc a/ }), { key: 'ArrowLeft' })
    expect(onArrange).not.toHaveBeenCalled()
  })
})
