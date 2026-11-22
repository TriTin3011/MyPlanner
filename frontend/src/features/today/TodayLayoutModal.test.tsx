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

    fireEvent.click(within(dialog).getByRole('button', { name: 'Đưa “Lên kế hoạch” lên trên', hidden: true }))
    expect(order()).toEqual(['progress', 'backlog', 'tasks', 'calendar', 'habits'])

    fireEvent.click(within(dialog).getByRole('checkbox', { name: 'Tiến độ gần đây', hidden: true }))
    expect(useSettings.getState().todayLayout[0]).toEqual({ id: 'progress', hidden: true })

    fireEvent.click(within(dialog).getByRole('button', { name: 'Đặt lại mặc định', hidden: true }))
    expect(useSettings.getState().todayLayout).toEqual(DEFAULT_TODAY_LAYOUT)
  })

  it('disables moving the first block up', () => {
    render(<TodayLayoutModal open onClose={vi.fn()} />)
    const up = screen.getByRole('button', { name: 'Đưa “Tiến độ gần đây” lên trên', hidden: true }) as HTMLButtonElement
    expect(up.disabled).toBe(true)
  })
})
