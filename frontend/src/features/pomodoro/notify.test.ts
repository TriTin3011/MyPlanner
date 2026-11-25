import { describe, expect, it } from 'vitest'
import { shouldNotify } from './notify'

describe('shouldNotify', () => {
  it('báo khi đã bật, có quyền và người dùng đang ở nơi khác', () => {
    expect(shouldNotify(true, 'granted', false)).toBe(true)
  })

  it('không báo khi người dùng đang nhìn vào app', () => {
    expect(shouldNotify(true, 'granted', true)).toBe(false)
  })

  it('không báo khi đã tắt', () => {
    expect(shouldNotify(false, 'granted', false)).toBe(false)
  })

  it.each(['default', 'denied', 'unsupported'] as const)('không báo khi quyền là %s', (permission) => {
    expect(shouldNotify(true, permission, false)).toBe(false)
  })
})
