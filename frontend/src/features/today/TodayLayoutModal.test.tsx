// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen, within } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { DEFAULT_TODAY_LAYOUT, useSettings } from '../../store/settings'
import { TodayLayoutModal } from './TodayLayoutModal'
import { groupTodayBlocks, normalizeTodayLayout } from './todayLayout'

function order() {
  return useSettings.getState().todayLayout.map((b) => b.id)
}

describe('normalizeTodayLayout', () => {
  it('drops unknown and duplicate ids and appends missing blocks', () => {
    const result = normalizeTodayLayout([
      { id: 'habits', hidden: true },
      { id: 'nope' as never, hidden: false },
      { id: 'habits', hidden: false },
    ])
    expect(result.map((b) => b.id)).toEqual(['habits', 'progress', 'backlog', 'tasks', 'calendar'])
    expect(result[0].hidden).toBe(true)
  })
})

describe('groupTodayBlocks', () => {
  it('pairs tasks and habits only when adjacent and visible', () => {
    expect(groupTodayBlocks(DEFAULT_TODAY_LAYOUT)).toEqual([['progress'], ['backlog'], ['tasks', 'habits'], ['calendar']])
    expect(
      groupTodayBlocks([
        { id: 'tasks', hidden: false },
        { id: 'calendar', hidden: false },
        { id: 'habits', hidden: false },
      ]),
    ).toEqual([['tasks'], ['calendar'], ['habits']])
    expect(
      groupTodayBlocks([
        { id: 'tasks', hidden: false },
        { id: 'calendar', hidden: true },
        { id: 'habits', hidden: false },
      ]),
    ).toEqual([['tasks', 'habits']])
  })
})

describe('TodayLayoutModal', () => {
  beforeEach(() => {
    useSettings.setState({ todayLayout: DEFAULT_TODAY_LAYOUT.map((b) => ({ ...b })) })
  })
  afterEach(cleanup)

  it('moves a block, hides a block and resets to default', () => {
    render(<TodayLayoutModal open onClose={vi.fn()} />)
    const dialog = screen.getByRole('dialog', { hidden: true })

    fireEvent.keyDown(within(dialog).getByRole('button', { name: /Kéo để đổi chỗ “Lên kế hoạch”/, hidden: true }), {
      key: 'ArrowUp',
    })
    expect(order()).toEqual(['progress', 'backlog', 'tasks', 'calendar', 'habits'])

    fireEvent.click(within(dialog).getByRole('button', { name: 'Hiện khối “Tiến độ gần đây”', hidden: true }))
    expect(useSettings.getState().todayLayout[0]).toEqual({ id: 'progress', hidden: true })

    fireEvent.click(within(dialog).getByRole('button', { name: 'Về thứ tự ban đầu', hidden: true }))
    expect(useSettings.getState().todayLayout).toEqual(DEFAULT_TODAY_LAYOUT)
  })

  it('keeps the first block in place when moved up', () => {
    render(<TodayLayoutModal open onClose={vi.fn()} />)
    fireEvent.keyDown(screen.getByRole('button', { name: /Kéo để đổi chỗ “Tiến độ gần đây”/, hidden: true }), {
      key: 'ArrowUp',
    })
    expect(order()).toEqual(DEFAULT_TODAY_LAYOUT.map((b) => b.id))
  })
})
