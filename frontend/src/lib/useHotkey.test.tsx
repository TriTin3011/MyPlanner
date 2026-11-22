// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { useRef } from 'react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { useHotkey } from './useHotkey'

afterEach(cleanup)

function HotkeyHarness({ onTrigger }: { onTrigger?: () => void }) {
  const targetRef = useRef<HTMLInputElement>(null)
  useHotkey('n', () => {
    onTrigger?.()
    targetRef.current?.focus()
  })

  return (
    <div>
      <input ref={targetRef} aria-label="Ô thêm việc" />
      <input aria-label="Ô nhập khác" />
      <textarea aria-label="Ghi chú" />
      <div contentEditable="true" aria-label="Soạn thảo" />
    </div>
  )
}

describe('useHotkey', () => {
  it('focuses the target input when pressing N outside editable elements', () => {
    const onTrigger = vi.fn()
    render(<HotkeyHarness onTrigger={onTrigger} />)

    fireEvent.keyDown(window, { key: 'n' })

    expect(onTrigger).toHaveBeenCalledTimes(1)
    expect(document.activeElement).toBe(screen.getByRole('textbox', { name: 'Ô thêm việc' }))
  })

  it('ignores N while typing in an input, textarea, or contenteditable', () => {
    const onTrigger = vi.fn()
    render(<HotkeyHarness onTrigger={onTrigger} />)

    const otherInput = screen.getByRole('textbox', { name: 'Ô nhập khác' })
    otherInput.focus()
    fireEvent.keyDown(otherInput, { key: 'n' })

    const textarea = screen.getByRole('textbox', { name: 'Ghi chú' })
    textarea.focus()
    fireEvent.keyDown(textarea, { key: 'N' })

    const editable = screen.getByLabelText('Soạn thảo')
    fireEvent.keyDown(editable, { key: 'n' })

    expect(onTrigger).not.toHaveBeenCalled()
  })

  it('ignores N when modifier keys are pressed or a dialog is open', () => {
    const onTrigger = vi.fn()
    const { container } = render(
      <div>
        <HotkeyHarness onTrigger={onTrigger} />
        <dialog open>Hộp thoại</dialog>
      </div>,
    )

    fireEvent.keyDown(window, { key: 'n', ctrlKey: true })
    fireEvent.keyDown(window, { key: 'n' })
    expect(onTrigger).not.toHaveBeenCalled()

    container.querySelector('dialog')?.removeAttribute('open')
    fireEvent.keyDown(window, { key: 'n' })
    expect(onTrigger).toHaveBeenCalledTimes(1)
  })
})
