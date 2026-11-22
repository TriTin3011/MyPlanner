// @vitest-environment jsdom

import { AxiosError, AxiosHeaders, type InternalAxiosRequestConfig } from 'axios'
import { afterEach, beforeEach, describe, expect, it } from 'vitest'
import { useSession } from '../features/auth/session'
import { api } from './client'

// Thay adapter (lớp gửi HTTP thật) bằng hàm giả: request vẫn đi qua đủ interceptor như thật.
function respondWith(status: number, data: unknown) {
  const seen: InternalAxiosRequestConfig[] = []
  api.defaults.adapter = async (config) => {
    seen.push(config)
    const response = { status, statusText: '', data, headers: {}, config }
    if (status >= 400) throw new AxiosError('fail', 'ERR_BAD_REQUEST', config, null, response)
    return response
  }
  return seen
}

describe('api client interceptors', () => {
  const originalAdapter = api.defaults.adapter

  beforeEach(() => {
    useSession.setState({ token: 'jwt-abc', userName: 'tin', expiresAt: '2099-01-01T00:00:00Z' })
  })

  afterEach(() => {
    api.defaults.adapter = originalAdapter
  })

  it('sends the Bearer token from the session store', async () => {
    const seen = respondWith(200, {})
    await api.get('/tasks')
    expect(AxiosHeaders.from(seen[0].headers).get('Authorization')).toBe('Bearer jwt-abc')
  })

  it('signs out on 401 from a protected endpoint and surfaces ProblemDetails.detail', async () => {
    respondWith(401, { title: 'Unauthorized', detail: 'Phiên đã hết hạn.' })
    await expect(api.get('/dashboard/today')).rejects.toThrow('Phiên đã hết hạn.')
    expect(useSession.getState().token).toBeNull()
  })

  it('does not touch the session on 401 from the login endpoint (wrong password)', async () => {
    respondWith(401, { detail: 'Sai mật khẩu.' })
    await expect(api.post('/auth/login', {})).rejects.toThrow('Sai mật khẩu.')
    expect(useSession.getState().token).toBe('jwt-abc')
  })
})
