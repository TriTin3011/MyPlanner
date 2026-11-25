// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { cleanup, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import '../i18n'
import type { BackupDto } from '../api/types'
import { useSettings } from '../store/settings'
import { BackupControls } from './BackupControls'

const { get, post } = vi.hoisted(() => ({ get: vi.fn(), post: vi.fn() }))

vi.mock('../api/client', () => ({ api: { get, post } }))

const sampleBackup: BackupDto = {
  version: 1,
  exportedAt: '2026-11-22T09:00:00Z',
  tasks: [],
  recurring: [],
  habits: [],
  habitLogs: [],
  goals: [],
  dayNotes: [],
  weekNotes: [],
  years: [],
  yearItems: [],
}

describe('BackupControls', () => {
  beforeEach(() => {
    vi.useFakeTimers({ toFake: ['Date'] })
    vi.setSystemTime(new Date(2026, 10, 22, 10, 0))
    useSettings.setState({ language: 'vi' })
    URL.createObjectURL = vi.fn(() => 'blob:mam-backup')
    URL.revokeObjectURL = vi.fn()
    HTMLAnchorElement.prototype.click = vi.fn()
  })

  afterEach(() => {
    cleanup()
    get.mockReset()
    post.mockReset()
    vi.useRealTimers()
  })

  it('exports backup and downloads mam-backup-YYYY-MM-DD.json', async () => {
    get.mockResolvedValueOnce({ data: sampleBackup })
    const appendSpy = vi.spyOn(document.body, 'appendChild')

    render(
      <QueryClientProvider client={new QueryClient()}>
        <BackupControls />
      </QueryClientProvider>,
    )
    fireEvent.click(screen.getByRole('button', { name: 'Xuất dữ liệu (.json)' }))

    await waitFor(() => expect(get).toHaveBeenCalledWith('/export'))
    await waitFor(() => {
      const anchor = appendSpy.mock.calls.find(([node]) => node instanceof HTMLAnchorElement)?.[0] as
        | HTMLAnchorElement
        | undefined
      expect(anchor?.download).toBe('mam-backup-2026-11-22.json')
    })
    appendSpy.mockRestore()
  })

  it('confirms before importing, calls POST /api/import, shows ImportResultDto, and invalidates queries', async () => {
    post.mockResolvedValueOnce({
      data: { tasks: 12, habits: 4, habitLogs: 30, goals: 3 },
    })
    const queryClient = new QueryClient({
      defaultOptions: { queries: { retry: false }, mutations: { retry: false } },
    })
    const invalidateSpy = vi.spyOn(queryClient, 'invalidateQueries')

    render(
      <QueryClientProvider client={queryClient}>
        <BackupControls />
      </QueryClientProvider>,
    )

    const fileInput = screen.getByLabelText('Nhập dữ liệu') as HTMLInputElement
    const file = new File([JSON.stringify(sampleBackup)], 'mam-backup-2026-11-22.json', {
      type: 'application/json',
    })
    fireEvent.change(fileInput, { target: { files: [file] } })

    const dialog = await screen.findByRole('dialog', { hidden: true })
    expect(within(dialog).getByText(/ghi đè toàn bộ dữ liệu/i)).not.toBeNull()
    expect(post).not.toHaveBeenCalled()

    fireEvent.click(within(dialog).getByRole('button', { name: 'Ghi đè & nhập dữ liệu', hidden: true }))

    await waitFor(() => expect(post).toHaveBeenCalledWith('/import', sampleBackup))
    expect(invalidateSpy).toHaveBeenCalledWith()
    await waitFor(() =>
      expect(within(dialog).getByRole('status', { hidden: true }).textContent).toContain('12 công việc'),
    )
  })

  it('shows ProblemDetails error text when POST /api/import fails with 400', async () => {
    post.mockRejectedValueOnce(new Error('File sao lưu phiên bản 99 mới hơn ứng dụng (hỗ trợ tới 1).'))
    const queryClient = new QueryClient()

    render(
      <QueryClientProvider client={queryClient}>
        <BackupControls />
      </QueryClientProvider>,
    )

    const fileInput = screen.getByLabelText('Nhập dữ liệu') as HTMLInputElement
    const file = new File([JSON.stringify({ ...sampleBackup, version: 99 })], 'bad.json', {
      type: 'application/json',
    })
    fireEvent.change(fileInput, { target: { files: [file] } })

    const dialog = await screen.findByRole('dialog', { hidden: true })
    fireEvent.click(within(dialog).getByRole('button', { name: 'Ghi đè & nhập dữ liệu', hidden: true }))

    await waitFor(() =>
      expect(within(dialog).getByRole('alert', { hidden: true }).textContent).toContain(
        'File sao lưu phiên bản 99 mới hơn ứng dụng',
      ),
    )
  })
})
