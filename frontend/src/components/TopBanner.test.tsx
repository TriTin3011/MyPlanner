// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { cleanup, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import '../i18n'
import type { BackupDto } from '../api/types'
import { useSettings } from '../store/settings'
import { BackupControls } from './BackupControls'
import { TopBanner } from './TopBanner'

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

describe('TopBanner & BackupControls', () => {
  beforeEach(() => {
    vi.useFakeTimers({ toFake: ['Date'] })
    vi.setSystemTime(new Date(2026, 10, 22, 10, 0))
    useSettings.setState({ language: 'vi', lastExportAt: undefined, lastBackupAt: undefined })
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

  it('shows the backup banner when lastExportAt is missing or older than 7 days, and hides it when recent', () => {
    const { rerender } = render(<TopBanner />)
    expect(screen.getByRole('region', { name: 'Dữ liệu' })).not.toBeNull()

    // Vừa xuất cách đây 2 ngày → ẩn banner
    useSettings.setState({ lastExportAt: new Date(2026, 10, 20, 10, 0).toISOString() })
    rerender(<TopBanner />)
    expect(screen.queryByRole('region', { name: 'Dữ liệu' })).toBeNull()

    // Xuất cách đây 8 ngày → hiện lại banner
    useSettings.setState({ lastExportAt: new Date(2026, 10, 14, 9, 0).toISOString() })
    rerender(<TopBanner />)
    expect(screen.getByRole('region', { name: 'Dữ liệu' })).not.toBeNull()
  })

  it('dismisses the banner for the current session without modifying lastExportAt', () => {
    render(<TopBanner />)
    fireEvent.click(screen.getByRole('button', { name: 'Đóng thông báo sao lưu' }))

    expect(screen.queryByRole('region', { name: 'Dữ liệu' })).toBeNull()
    expect(useSettings.getState().lastExportAt).toBeUndefined()
  })

  it('exports backup from banner, downloads mam-backup-YYYY-MM-DD.json, and records lastExportAt', async () => {
    get.mockResolvedValueOnce({ data: sampleBackup })
    const appendSpy = vi.spyOn(document.body, 'appendChild')

    render(<TopBanner />)
    fireEvent.click(screen.getByRole('button', { name: 'Xuất dữ liệu' }))

    await waitFor(() => expect(get).toHaveBeenCalledWith('/export'))
    expect(useSettings.getState().lastExportAt).toBe(new Date(2026, 10, 22, 10, 0).toISOString())

    const anchor = appendSpy.mock.calls.find(([node]) => node instanceof HTMLAnchorElement)?.[0] as
      | HTMLAnchorElement
      | undefined
    expect(anchor?.download).toBe('mam-backup-2026-11-22.json')
    expect(screen.queryByRole('region', { name: 'Dữ liệu' })).toBeNull()
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
