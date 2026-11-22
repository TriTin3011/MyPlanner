// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { act, cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { createMemoryRouter, RouterProvider } from 'react-router'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import '../../i18n'
import { useSettings } from '../../store/settings'
import { LoginPage } from './LoginPage'
import { RequireAuth } from './RequireAuth'
import { isSessionActive, msUntilExpiry, useSession } from './session'

const { post } = vi.hoisted(() => ({ post: vi.fn() }))
vi.mock('../../api/client', () => ({ api: { post } }))

const NOW = new Date('2026-11-22T08:00:00Z').getTime()
const IN_ONE_HOUR = new Date(NOW + 60 * 60_000).toISOString()

function renderAt(path: string, state?: unknown) {
  const router = createMemoryRouter(
    [
      { path: '/login', element: <LoginPage /> },
      {
        path: '/*',
        element: (
          <RequireAuth>
            <p>Trang trong app</p>
          </RequireAuth>
        ),
      },
    ],
    { initialEntries: [{ pathname: path, state }] },
  )
  const client = new QueryClient({ defaultOptions: { mutations: { retry: false } } })
  render(
    <QueryClientProvider client={client}>
      <RouterProvider router={router} />
    </QueryClientProvider>,
  )
  return router
}

describe('session helpers', () => {
  it('is active only with a token that has not expired', () => {
    expect(isSessionActive({ token: null, expiresAt: IN_ONE_HOUR }, NOW)).toBe(false)
    expect(isSessionActive({ token: 'jwt', expiresAt: null }, NOW)).toBe(false)
    expect(isSessionActive({ token: 'jwt', expiresAt: 'không phải ngày' }, NOW)).toBe(false)
    expect(isSessionActive({ token: 'jwt', expiresAt: new Date(NOW - 1).toISOString() }, NOW)).toBe(false)
    expect(isSessionActive({ token: 'jwt', expiresAt: IN_ONE_HOUR }, NOW)).toBe(true)
  })

  it('clamps the expiry delay to what setTimeout accepts', () => {
    expect(msUntilExpiry(IN_ONE_HOUR, NOW)).toBe(60 * 60_000)
    expect(msUntilExpiry(new Date(NOW - 5000).toISOString(), NOW)).toBe(0)
    expect(msUntilExpiry('2099-01-01T00:00:00Z', NOW)).toBe(2_147_483_647)
  })
})

describe('RequireAuth & LoginPage', () => {
  beforeEach(() => {
    vi.useFakeTimers({ toFake: ['Date', 'setTimeout', 'clearTimeout'], shouldAdvanceTime: true })
    vi.setSystemTime(NOW)
    useSettings.setState({ language: 'vi' })
    useSession.setState({ token: null, userName: null, expiresAt: null })
  })

  afterEach(() => {
    cleanup()
    post.mockReset()
    vi.useRealTimers()
  })

  it('redirects to /login when there is no session', async () => {
    const router = renderAt('/week')
    expect(await screen.findByRole('heading', { name: 'Đăng nhập' })).not.toBeNull()
    expect(router.state.location.pathname).toBe('/login')
  })

  it('shows the page while the token is valid and signs out when it expires', async () => {
    useSession.setState({ token: 'jwt', userName: 'tin', expiresAt: IN_ONE_HOUR })
    const router = renderAt('/week')
    expect(screen.getByText('Trang trong app')).not.toBeNull()

    await act(async () => {
      vi.advanceTimersByTime(60 * 60_000 + 1)
    })

    expect(useSession.getState().token).toBeNull()
    expect(router.state.location.pathname).toBe('/login')
  })

  it('drops an already expired token left in storage', async () => {
    useSession.setState({ token: 'old', userName: 'tin', expiresAt: new Date(NOW - 1000).toISOString() })
    renderAt('/')
    await screen.findByRole('heading', { name: 'Đăng nhập' })
    expect(useSession.getState().token).toBeNull()
  })

  it('logs in, stores the token and returns to the page the user wanted', async () => {
    post.mockResolvedValueOnce({ data: { accessToken: 'new-jwt', expiresAt: IN_ONE_HOUR, userName: 'tin' } })
    const router = renderAt('/login', { from: '/habits' })

    fireEvent.change(screen.getByLabelText('Tên đăng nhập'), { target: { value: '  tin ' } })
    fireEvent.change(screen.getByLabelText('Mật khẩu'), { target: { value: 'mat-khau-test' } })
    fireEvent.click(screen.getByRole('button', { name: 'Đăng nhập' }))

    await waitFor(() => expect(router.state.location.pathname).toBe('/habits'))
    expect(post).toHaveBeenCalledWith('/auth/login', { userName: 'tin', password: 'mat-khau-test' })
    expect(useSession.getState()).toMatchObject({ token: 'new-jwt', userName: 'tin', expiresAt: IN_ONE_HOUR })
  })

  it('shows the backend message and clears the password when login fails', async () => {
    post.mockRejectedValueOnce(new Error('Tên đăng nhập hoặc mật khẩu không đúng.'))
    renderAt('/login')

    fireEvent.change(screen.getByLabelText('Tên đăng nhập'), { target: { value: 'tin' } })
    const password = screen.getByLabelText('Mật khẩu') as HTMLInputElement
    fireEvent.change(password, { target: { value: 'sai' } })
    fireEvent.click(screen.getByRole('button', { name: 'Đăng nhập' }))

    expect((await screen.findByRole('alert')).textContent).toBe('Tên đăng nhập hoặc mật khẩu không đúng.')
    expect(password.value).toBe('')
    expect(password.getAttribute('aria-invalid')).toBe('true')
    expect(useSession.getState().token).toBeNull()
  })

  it('keeps the submit button disabled until both fields are filled', () => {
    renderAt('/login')
    const submit = screen.getByRole('button', { name: 'Đăng nhập' }) as HTMLButtonElement
    expect(submit.disabled).toBe(true)
    fireEvent.change(screen.getByLabelText('Tên đăng nhập'), { target: { value: 'tin' } })
    expect(submit.disabled).toBe(true)
    fireEvent.change(screen.getByLabelText('Mật khẩu'), { target: { value: 'x' } })
    expect(submit.disabled).toBe(false)
  })
})
