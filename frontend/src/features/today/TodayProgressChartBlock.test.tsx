// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { TodayProgressChartBlock } from './TodayProgressChartBlock'

const { get } = vi.hoisted(() => ({ get: vi.fn() }))
vi.mock('../../api/client', () => ({ api: { get } }))

function renderWithClient(ui: React.ReactElement) {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false } },
  })
  return render(<QueryClientProvider client={queryClient}>{ui}</QueryClientProvider>)
}

afterEach(() => {
  cleanup()
  get.mockReset()
})

describe('TodayProgressChartBlock', () => {
  it('renders section title and fetches backend day metrics for 7 days by default', () => {
    get.mockResolvedValueOnce({
      data: [{ date: '2026-11-22', tasksDone: 1, tasksTotal: 1, percent: 100, hasDeadline: false }],
    })

    renderWithClient(<TodayProgressChartBlock today="2026-11-22" />)

    expect(screen.getByRole('heading', { level: 2, name: 'Tiến độ gần đây' })).not.toBeNull()
    expect(screen.getByText('Đã xong')).not.toBeNull()
    expect(get).toHaveBeenCalledWith('/dashboard/days', {
      params: { from: '2026-11-16', to: '2026-11-22' },
    })
  })

  it('allows switching range from 7 to 14 days and refetches', async () => {
    get.mockResolvedValue({ data: [] })

    renderWithClient(<TodayProgressChartBlock today="2026-11-22" />)

    fireEvent.click(screen.getByRole('combobox'))
    fireEvent.click(screen.getByRole('option', { name: '14 ngày' }))

    expect(get).toHaveBeenCalledWith('/dashboard/days', {
      params: { from: '2026-11-09', to: '2026-11-22' },
    })
  })
})
