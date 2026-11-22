// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import type { ReactNode } from 'react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { weekNoteQueryOptions } from './weekExtrasHooks'
import { WeekNoteBlock } from './WeekNoteBlock'

const { get, put } = vi.hoisted(() => ({ get: vi.fn(), put: vi.fn() }))

vi.mock('../../api/client', () => ({ api: { get, put } }))

function renderWithQueryClient(ui: ReactNode) {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false }, mutations: { retry: false } },
  })
  return render(<QueryClientProvider client={queryClient}>{ui}</QueryClientProvider>)
}

afterEach(() => {
  cleanup()
  get.mockReset()
  put.mockReset()
})

describe('weekNoteQueryOptions', () => {
  it('loads the note with the shared week-note query key', async () => {
    const note = {
      weekKey: '2026-W47',
      content: 'Tập trung hoàn thành báo cáo.',
      updatedAt: '2026-11-22T10:00:00Z',
    }
    get.mockResolvedValueOnce({ data: note })

    const options = weekNoteQueryOptions('2026-W47')
    const result = await options.queryFn?.({} as never)

    expect(options.queryKey).toEqual(['notes', 'week', '2026-W47'])
    expect(result).toEqual(note)
    expect(get).toHaveBeenCalledWith('/notes/week/2026-W47')
  })
})

describe('WeekNoteBlock', () => {
  it('shows the loaded note and saves changed content', async () => {
    get.mockResolvedValue({
      data: {
        weekKey: '2026-W47',
        content: 'Tập trung hoàn thành báo cáo.',
        updatedAt: '2026-11-22T10:00:00Z',
      },
    })
    put.mockResolvedValue({
      data: {
        weekKey: '2026-W47',
        content: 'Ôn từ vựng và hoàn thành báo cáo.',
        updatedAt: '2026-11-22T11:00:00Z',
      },
    })

    renderWithQueryClient(<WeekNoteBlock weekKey="2026-W47" />)

    const textarea = await screen.findByRole('textbox', { name: 'Ghi chú tuần' })
    expect((textarea as HTMLTextAreaElement).value).toBe('Tập trung hoàn thành báo cáo.')

    fireEvent.change(textarea, { target: { value: 'Ôn từ vựng và hoàn thành báo cáo.' } })
    fireEvent.blur(textarea)

    await vi.waitFor(() => {
      expect(put).toHaveBeenCalledWith('/notes/week/2026-W47', {
        content: 'Ôn từ vựng và hoàn thành báo cáo.',
      })
    })
  })

  it('shows a load error as an alert', async () => {
    get.mockRejectedValueOnce(new Error('Mất kết nối'))

    renderWithQueryClient(<WeekNoteBlock weekKey="2026-W47" />)

    expect((await screen.findByRole('alert')).textContent).toContain('Mất kết nối')
  })
})
