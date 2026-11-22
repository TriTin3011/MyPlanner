// @vitest-environment jsdom

import { cleanup, render, screen } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { useSettings } from '../../store/settings'
import { WeekProgressChartBlock } from './WeekProgressChartBlock'

const mockUseDayProgress = vi.fn((_from: string, _to: string, _enabled?: boolean) => ({
  data: [],
  isPending: false,
}))

const mockUseWeekProgress = vi.fn((_to: string, _count: number, _enabled?: boolean) => ({
  data: [],
  isPending: false,
}))

vi.mock('../today/hooks', () => ({
  useDayProgress: (from: string, to: string, enabled?: boolean) => mockUseDayProgress(from, to, enabled),
}))

vi.mock('./hooks', () => ({
  useWeekProgress: (to: string, count: number, enabled?: boolean) => mockUseWeekProgress(to, count, enabled),
}))

describe('WeekProgressChartBlock', () => {
  beforeEach(() => {
    useSettings.setState({ chartModes: {}, chartRanges: {} })
    mockUseDayProgress.mockClear()
    mockUseWeekProgress.mockClear()
  })

  afterEach(cleanup)

  it('mặc định hiển thị tiến độ từng ngày cho 1 tuần của tuần đang xem', () => {
    render(<WeekProgressChartBlock monday="2026-11-16" />)

    expect(screen.getByRole('heading', { name: 'Tiến độ từng ngày' })).not.toBeNull()
    expect(mockUseDayProgress).toHaveBeenCalledWith('2026-11-16', '2026-11-22', true)
    expect(mockUseWeekProgress).toHaveBeenCalledWith('2026-W47', 12, false)
  })

  it('khoảng 4 tuần lấy dữ liệu theo ngày từ Thứ 2 của 3 tuần trước tới Chủ nhật tuần đang xem', () => {
    useSettings.getState().setChartRange('week_progress', '4')

    render(<WeekProgressChartBlock monday="2026-11-16" />)

    expect(screen.getByRole('heading', { name: 'Tiến độ từng ngày' })).not.toBeNull()
    expect(mockUseDayProgress).toHaveBeenCalledWith('2026-10-26', '2026-11-22', true)
    expect(mockUseWeekProgress).toHaveBeenCalledWith('2026-W47', 12, false)
  })

  it('khoảng 12 tuần chuyển sang tiến độ từng tuần và bật useWeekProgress', () => {
    useSettings.getState().setChartRange('week_progress', '12')

    render(<WeekProgressChartBlock monday="2026-11-16" />)

    expect(screen.getByRole('heading', { name: 'Tiến độ từng tuần' })).not.toBeNull()
    expect(mockUseWeekProgress).toHaveBeenCalledWith('2026-W47', 12, true)
    expect(mockUseDayProgress).toHaveBeenCalledWith('2026-08-31', '2026-11-22', false)
  })
})
