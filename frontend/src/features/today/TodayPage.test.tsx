// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import '../../i18n'
import type { TodayDashboardDto } from '../../api/types'
import { TodayPage } from './TodayPage'

const { get, post } = vi.hoisted(() => ({ get: vi.fn(), post: vi.fn() }))

vi.mock('../../api/client', () => ({ api: { get, post } }))

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

function renderPage() {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false } },
  })
  return render(
    <QueryClientProvider client={queryClient}>
      <MemoryRouter>
        <TodayPage />
      </MemoryRouter>
    </QueryClientProvider>,
  )
}

describe('TodayPage', () => {
  beforeEach(() => {
    vi.useFakeTimers({ toFake: ['Date'] })
    vi.setSystemTime(new Date(2026, 10, 22, 9, 0))
    post.mockResolvedValue({ data: { count: 0 } })
  })

  afterEach(() => {
    cleanup()
    get.mockReset()
    post.mockReset()
    vi.useRealTimers()
  })

  it('shows loading feedback while the dashboard request is pending', () => {
    get.mockReturnValue(new Promise(() => {}))

    renderPage()

    expect(screen.getByRole('status').textContent).toContain('Đang tải dữ liệu hôm nay')
  })

  it('renders the dashboard summary returned by the API', async () => {
    get.mockImplementation((url: string) => {
      if (url.startsWith('/dashboard/today')) {
        return Promise.resolve({ data: dashboard })
      }
      return Promise.resolve({ data: [] })
    })

    renderPage()

    await waitFor(() => expect(screen.getByRole('progressbar', { name: 'Tiến độ hôm nay' })).not.toBeNull())
  })

  it('materializes recurring tasks for today..+7 on mount', async () => {
    get.mockImplementation((url: string) =>
      Promise.resolve({ data: url.startsWith('/dashboard/today') ? dashboard : [] }),
    )

    renderPage()

    await waitFor(() =>
      expect(post).toHaveBeenCalledWith('/recurring/materialize', {
        from: '2026-11-22',
        to: '2026-11-29',
        today: '2026-11-22',
      }),
    )
  })

  it('shows an accessible error when the dashboard request fails', async () => {
    get.mockImplementation((url: string) =>
      url.startsWith('/dashboard/today')
        ? Promise.reject(new Error('Không kết nối được backend'))
        : Promise.resolve({ data: [] }),
    )

    renderPage()

    await waitFor(() => expect(screen.getByRole('alert').textContent).toContain('Không kết nối được backend'))
  })

  it('focuses the add task input when pressing N on TodayPage and ignores N while typing in inputs', async () => {
    get.mockImplementation((url: string) =>
      Promise.resolve({ data: url.startsWith('/dashboard/today') ? dashboard : [] }),
    )

    renderPage()

    const addInput = await screen.findByRole('textbox', { name: 'Tên việc mới' })
    expect(addInput.getAttribute('aria-keyshortcuts')).toBe('n')

    fireEvent.keyDown(window, { key: 'n' })
    expect(document.activeElement).toBe(addInput)

    // Mở ghi chú và gõ phím N trong textarea thì không cướp focus về ô thêm việc
    fireEvent.click(screen.getByRole('button', { name: /Ghi chú/i }))
    const noteTextarea = screen.getByPlaceholderText(/Ghi chú/i)
    noteTextarea.focus()
    fireEvent.keyDown(noteTextarea, { key: 'n' })
    expect(document.activeElement).toBe(noteTextarea)
  })
})
