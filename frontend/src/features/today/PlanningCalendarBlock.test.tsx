// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { PlanningCalendarBlock } from './PlanningCalendarBlock'

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

describe('PlanningCalendarBlock', () => {
  it('renders calendar title and weekdays header', () => {
    get.mockResolvedValueOnce({ data: [] })

    renderWithClient(
      <PlanningCalendarBlock
        today="2026-11-22"
        onAddTask={vi.fn()}
        addPending={false}
      />,
    )

    expect(screen.getByRole('heading', { level: 2, name: 'Lên kế hoạch' })).not.toBeNull()
    expect(screen.getByText('Tháng 11/2026')).not.toBeNull()
    expect(screen.getByText('T2')).not.toBeNull()
    expect(screen.getByText('CN')).not.toBeNull()
  })

  it('navigates next and previous months', () => {
    get.mockResolvedValue({ data: [] })

    renderWithClient(
      <PlanningCalendarBlock
        today="2026-11-22"
        onAddTask={vi.fn()}
        addPending={false}
      />,
    )

    const nextBtn = screen.getByRole('button', { name: 'Tháng sau' })
    fireEvent.click(nextBtn)
    expect(screen.getByText('Tháng 12/2026')).not.toBeNull()

    const prevBtn = screen.getByRole('button', { name: 'Tháng trước' })
    fireEvent.click(prevBtn)
    expect(screen.getByText('Tháng 11/2026')).not.toBeNull()
  })

  it('changes selected date when clicking tomorrow link', () => {
    get.mockResolvedValue({ data: [] })

    renderWithClient(
      <PlanningCalendarBlock
        today="2026-11-22"
        onAddTask={vi.fn()}
        addPending={false}
      />,
    )

    const tomorrowBtn = screen.getByRole('button', { name: /Lên kế hoạch ngày mai/i })
    fireEvent.click(tomorrowBtn)

    expect(screen.getByText(/Ngày 23\/11/i)).not.toBeNull()
    expect(screen.getByPlaceholderText('Thêm việc cho ngày 23/11…')).not.toBeNull()
  })

  it('allows switching view mode between month and week', () => {
    get.mockResolvedValue({ data: [] })

    renderWithClient(
      <PlanningCalendarBlock
        today="2026-11-22"
        onAddTask={vi.fn()}
        addPending={false}
      />,
    )

    const weekRadio = screen.getByRole('radio', { name: 'Tuần' })
    fireEvent.click(weekRadio)
    expect(weekRadio.getAttribute('aria-checked')).toBe('true')

    // 22/11/2026 là Chủ nhật, tuần ISO chứa nó là 16/11 – 22/11
    expect(screen.getByText('Tuần 16/11 – 22/11')).not.toBeNull()
    expect(screen.getAllByRole('gridcell')).toHaveLength(7)

    fireEvent.click(screen.getByRole('button', { name: 'Tuần sau' }))
    expect(screen.getByText('Tuần 23/11 – 29/11')).not.toBeNull()
  })

  it('shows task count and deadline flag from backend day metrics', async () => {
    get.mockImplementation((url: string) =>
      Promise.resolve({
        data:
          url === '/dashboard/days'
            ? [{ date: '2026-11-25', tasksDone: 1, tasksTotal: 3, percent: 33, hasDeadline: true }]
            : [],
      }),
    )

    renderWithClient(
      <PlanningCalendarBlock today="2026-11-22" onAddTask={vi.fn()} addPending={false} />,
    )

    expect(await screen.findByRole('gridcell', { name: 'Ngày 25/11, 3 việc, có hạn mục tiêu' })).not.toBeNull()
    expect(get).toHaveBeenCalledWith('/dashboard/days', {
      params: { from: '2026-10-26', to: '2026-12-06' },
    })
  })
})
