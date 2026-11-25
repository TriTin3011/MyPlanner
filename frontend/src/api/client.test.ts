// @vitest-environment jsdom

import { AxiosError, AxiosHeaders, type InternalAxiosRequestConfig } from 'axios'
import { afterEach, beforeEach, describe, expect, it } from 'vitest'
import { isSessionActive, useSession } from '../features/auth/session'
import { api, logout } from './client'

// Thay adapter (lớp gửi HTTP thật) bằng hàm giả: request vẫn đi qua đủ interceptor như thật.
function respondWith(status: number, data: unknown) {
  return route(() => [status, data])
}

// Adapter giả trả lời theo từng request, dùng cho các kịch bản nhiều bước.
function route(reply: (config: InternalAxiosRequestConfig) => [number, unknown] | 'network-error') {
  const seen: InternalAxiosRequestConfig[] = []
  api.defaults.adapter = async (config) => {
    seen.push(config)
    const result = reply(config)
    if (result === 'network-error') throw new AxiosError('Network Error', 'ERR_NETWORK', config)
    const [status, data] = result
    const response = { status, statusText: '', data, headers: {}, config }
    if (!config.validateStatus?.(status)) throw new AxiosError('fail', 'ERR_BAD_REQUEST', config, null, response)
    return response
  }
  return seen
}

const bearer = (config: InternalAxiosRequestConfig) => AxiosHeaders.from(config.headers).get('Authorization')
const calls = (seen: InternalAxiosRequestConfig[], url: string) => seen.filter((c) => c.url === url)

const renewed = {
  accessToken: 'jwt-new',
  expiresAt: '2099-01-01T00:15:00Z',
  userName: 'tin',
  refreshToken: 'refresh-new',
  refreshExpiresAt: '2099-01-31T00:00:00Z',
}

// Server giả: chỉ nhận access token mới, và đổi được refresh token.
const acceptOnlyNewToken = (config: InternalAxiosRequestConfig): [number, unknown] => {
  if (config.url === '/auth/refresh') return [200, renewed]
  return bearer(config) === 'Bearer jwt-new' ? [200, { ok: true }] : [401, { detail: 'Hết hạn.' }]
}

describe('api client interceptors', () => {
  const originalAdapter = api.defaults.adapter

  beforeEach(() => {
    useSession.setState({
      token: 'jwt-abc',
      userName: 'tin',
      expiresAt: '2099-01-01T00:00:00Z',
      refreshToken: null,
      refreshExpiresAt: null,
    })
  })

  afterEach(() => {
    api.defaults.adapter = originalAdapter
  })

  it('sends the Bearer token from the session store', async () => {
    const seen = respondWith(200, {})
    await api.get('/tasks')
    expect(AxiosHeaders.from(seen[0].headers).get('Authorization')).toBe('Bearer jwt-abc')
  })

  it('signs out on 401 when the session has no refresh token and surfaces ProblemDetails.detail', async () => {
    respondWith(401, { title: 'Unauthorized', detail: 'Phiên đã hết hạn.' })
    await expect(api.get('/dashboard/today')).rejects.toThrow('Phiên đã hết hạn.')
    expect(useSession.getState().token).toBeNull()
  })

  it('does not touch the session on 401 from the login endpoint (wrong password)', async () => {
    useSession.setState({ refreshToken: 'refresh-old' })
    const seen = respondWith(401, { detail: 'Sai mật khẩu.' })
    await expect(api.post('/auth/login', {})).rejects.toThrow('Sai mật khẩu.')
    expect(useSession.getState().token).toBe('jwt-abc')
    expect(calls(seen, '/auth/refresh')).toHaveLength(0)
  })

  describe('with a refresh token', () => {
    beforeEach(() => {
      useSession.setState({ refreshToken: 'refresh-old', refreshExpiresAt: '2099-01-30T00:00:00Z' })
    })

    it('renews on 401, retries the request and stores the rotated tokens', async () => {
      const seen = route(acceptOnlyNewToken)
      const res = await api.get('/tasks')

      expect(res.data).toEqual({ ok: true })
      expect(JSON.parse(calls(seen, '/auth/refresh')[0].data)).toEqual({ refreshToken: 'refresh-old' })
      expect(bearer(seen.at(-1)!)).toBe('Bearer jwt-new')
      expect(useSession.getState()).toMatchObject({ token: 'jwt-new', refreshToken: 'refresh-new' })
    })

    it('shares one refresh between concurrent 401s', async () => {
      const seen = route(acceptOnlyNewToken)
      await Promise.all([api.get('/tasks'), api.get('/habits'), api.get('/goals')])
      expect(calls(seen, '/auth/refresh')).toHaveLength(1)
    })

    it('signs out when the server rejects the refresh token', async () => {
      route((config) => (config.url === '/auth/refresh' ? [401, {}] : [401, { detail: 'Hết hạn.' }]))
      await expect(api.get('/tasks')).rejects.toThrow('Hết hạn.')
      expect(useSession.getState().token).toBeNull()
    })

    it.each([[503], [429]])('keeps the session when refresh fails with %i', async (status) => {
      route((config) => (config.url === '/auth/refresh' ? [status, {}] : [401, { detail: 'Hết hạn.' }]))
      await expect(api.get('/tasks')).rejects.toThrow('Hết hạn.')
      expect(useSession.getState().refreshToken).toBe('refresh-old')
    })

    it('keeps the session when refresh hits a network error', async () => {
      route((config) => (config.url === '/auth/refresh' ? 'network-error' : [401, { detail: 'Hết hạn.' }]))
      await expect(api.get('/tasks')).rejects.toThrow('Hết hạn.')
      expect(useSession.getState().refreshToken).toBe('refresh-old')
    })

    it('retries only once, then signs out', async () => {
      const seen = route((config) => (config.url === '/auth/refresh' ? [200, renewed] : [401, { detail: 'Từ chối.' }]))
      await expect(api.get('/tasks')).rejects.toThrow('Từ chối.')
      expect(calls(seen, '/tasks')).toHaveLength(2)
      expect(useSession.getState().token).toBeNull()
    })

    it('ignores a late 401 from the previous account', async () => {
      let release = () => {}
      const gate = new Promise<void>((resolve) => (release = resolve))
      api.defaults.adapter = async (config) => {
        await gate
        const response = { status: 401, statusText: '', data: { detail: 'Cũ.' }, headers: {}, config }
        throw new AxiosError('fail', 'ERR_BAD_REQUEST', config, null, response)
      }
      const pending = api.get('/tasks')
      await Promise.resolve()
      await new Promise((resolve) => setTimeout(resolve))
      useSession.getState().signIn({ ...renewed, userName: 'an', accessToken: 'jwt-an', refreshToken: 'refresh-an' })
      release()

      await expect(pending).rejects.toThrow('Cũ.')
      expect(useSession.getState()).toMatchObject({ userName: 'an', refreshToken: 'refresh-an' })
    })

    it('logout clears the session immediately and revokes on the server', () => {
      const seen = respondWith(204, null)
      logout()
      expect(useSession.getState().token).toBeNull()
      return Promise.resolve()
        .then(() => new Promise((resolve) => setTimeout(resolve)))
        .then(() => expect(JSON.parse(calls(seen, '/auth/logout')[0].data)).toEqual({ refreshToken: 'refresh-old' }))
    })

    it('stays active after the access token expires while the refresh token is valid', () => {
      const now = Date.parse('2026-11-24T12:00:00Z')
      const session = {
        token: 'jwt',
        expiresAt: '2026-11-24T11:59:00Z',
        refreshToken: 'r',
        refreshExpiresAt: '2026-12-24T12:00:00Z',
      }
      expect(isSessionActive(session, now)).toBe(true)
      expect(isSessionActive({ ...session, refreshExpiresAt: '2026-11-24T11:59:59Z' }, now)).toBe(false)
    })
  })
})
