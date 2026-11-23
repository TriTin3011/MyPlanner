// @vitest-environment jsdom

import { cleanup, fireEvent, render } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { ClickEffect } from './ClickEffect'

afterEach(() => {
  cleanup()
  document.querySelectorAll('.click-fx').forEach((node) => node.remove())
  vi.unstubAllGlobals()
})

describe('ClickEffect', () => {
  it('hiện hiệu ứng tại vị trí chuột', () => {
    render(<ClickEffect />)
    fireEvent.click(document.body, { detail: 1, clientX: 40, clientY: 60 })
    const effect = document.querySelector<HTMLElement>('.click-fx')
    expect(effect?.style.left).toBe('40px')
    expect(effect?.style.top).toBe('60px')
  })

  it('bỏ qua click từ bàn phím', () => {
    render(<ClickEffect />)
    fireEvent.click(document.body, { detail: 0 })
    expect(document.querySelector('.click-fx')).toBeNull()
  })

  it('tôn trọng prefers-reduced-motion', () => {
    vi.stubGlobal('matchMedia', () => ({ matches: true }))
    render(<ClickEffect />)
    fireEvent.click(document.body, { detail: 1 })
    expect(document.querySelector('.click-fx')).toBeNull()
  })

  it('đặt hiệu ứng trong dialog đang mở', () => {
    render(<ClickEffect />)
    const dialog = document.createElement('dialog')
    dialog.setAttribute('open', '')
    document.body.appendChild(dialog)
    fireEvent.click(dialog, { detail: 1 })
    expect(dialog.querySelector('.click-fx')).not.toBeNull()
    dialog.remove()
  })
})
