// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it } from 'vitest'
import { useSettings } from '../../store/settings'
import { WeekdayBars } from './WeekdayBars'

const items = [1, 2, 3, 4, 5, 6, 7].map((weekday) => ({ weekday, averageDone: weekday === 5 ? 4.5 : 1 }))

describe('WeekdayBars', () => {
  afterEach(() => {
    cleanup()
    useSettings.setState({ chartModes: {} })
  })

  it('hiện số trung bình dạng dấu phẩy và tô màu chính cho thứ cao nhất', () => {
    render(<WeekdayBars items={items} />)
    const top = screen.getByText('4,5')
    expect(top.className).toContain('text-primary-ink')
    expect(screen.getAllByText('1,0')).toHaveLength(6)
  })

  it('nút Bảng chuyển sang bảng và nhớ lựa chọn', () => {
    render(<WeekdayBars items={items} />)
    const toggle = screen.getByRole('button', { name: 'Bảng' })
    expect(toggle.getAttribute('aria-pressed')).toBe('false')
    fireEvent.click(toggle)
    expect(screen.getByRole('table')).toBeTruthy()
    expect(screen.getByRole('rowheader', { name: 'Thứ 6' })).toBeTruthy()
    expect(useSettings.getState().chartModes['stats-weekday']).toBe('table')
  })
})