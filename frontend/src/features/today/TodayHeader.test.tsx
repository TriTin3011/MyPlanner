// @vitest-environment jsdom

import { act, cleanup, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it } from 'vitest'
import type { TodayDashboardDto } from '../../api/types'
import i18n from '../../i18n'
import { useSettings } from '../../store/settings'
import { TodayHeader } from './TodayHeader'

const dashboard: TodayDashboardDto = {
  date: '2026-11-22',
  percent: 38,
  tasksDone: 3,
  tasksTotal: 10,
  habitsDone: 3,
  habitsTotal: 6,
  tasks: [],
  backlog: [],
  habits: [],
  note: null,
}

afterEach(cleanup)

describe('TodayHeader', () => {
  it('shows the daily summary with accessible progress', () => {
    render(<TodayHeader dashboard={dashboard} />)

    expect(screen.getByRole('heading', { name: 'Hôm nay', level: 1 })).not.toBeNull()
    expect(screen.getByText('Chủ nhật, 22/11/2026')).not.toBeNull()
    expect(screen.getByText('38%')).not.toBeNull()
    expect(screen.getByText((_, element) => element?.tagName === 'P' && element.textContent === '3/10 việc')).not.toBeNull()
    expect(screen.getByText((_, element) => element?.tagName === 'P' && element.textContent === '3/6 thói quen')).not.toBeNull()

    const progress = screen.getByRole('progressbar', { name: 'Tiến độ hôm nay' })
    expect(progress.getAttribute('aria-valuenow')).toBe('38')
    expect(progress.getAttribute('aria-valuemin')).toBe('0')
    expect(progress.getAttribute('aria-valuemax')).toBe('100')
  })

  it('renders English labels and en-US date after i18n.changeLanguage("en")', async () => {
    render(<TodayHeader dashboard={dashboard} />)

    await act(async () => {
      useSettings.setState({ language: 'en' })
      await i18n.changeLanguage('en')
    })

    expect(screen.getByRole('heading', { name: 'Today', level: 1 })).not.toBeNull()
    expect(screen.getByText('Sunday, 11/22/2026')).not.toBeNull()
    expect(screen.getByText((_, element) => element?.tagName === 'P' && element.textContent === '3/10 tasks')).not.toBeNull()
    expect(screen.getByText((_, element) => element?.tagName === 'P' && element.textContent === '3/6 habits')).not.toBeNull()
    expect(screen.getByRole('progressbar', { name: "Today's progress" })).not.toBeNull()
    expect(screen.getByRole('button', { name: 'Arrange blocks' })).not.toBeNull()
  })
})
