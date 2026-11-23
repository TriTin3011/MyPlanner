import { describe, expect, it } from 'vitest'
import { themeForSession } from './sessionTheme'

const now = Date.parse('2026-11-24T00:00:00Z')

describe('themeForSession', () => {
  it('chưa đăng nhập thì dùng màu xanh', () => {
    expect(themeForSession('lavender', { token: null, expiresAt: null }, now)).toBe('forest')
  })

  it('phiên hết hạn thì dùng màu xanh', () => {
    expect(themeForSession('ocean', { token: 'x', expiresAt: '2026-11-23T00:00:00Z' }, now)).toBe('forest')
  })

  it('đã đăng nhập thì dùng theme đã chọn', () => {
    expect(themeForSession('sunset', { token: 'x', expiresAt: '2026-11-25T00:00:00Z' }, now)).toBe('sunset')
  })
})
