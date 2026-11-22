import { useEffect, useRef } from 'react'

// Kiểm tra phần tử đang giữ focus có phải ô nhập liệu hay không.
function isEditableTarget(target: EventTarget | null): boolean {
  if (!(target instanceof HTMLElement)) return false
  const tag = target.tagName
  if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return true
  if (target.isContentEditable || target.contentEditable === 'true') return true
  return Boolean(target.closest('[contenteditable="true"], [contenteditable=""]'))
}

// Kiểm tra có modal/dialog nào đang mở trên trang không.
function hasOpenDialog(): boolean {
  if (typeof document === 'undefined') return false
  return Boolean(document.querySelector('dialog[open], [role="dialog"]'))
}

// Hook lắng nghe phím tắt đơn (không kèm Ctrl/Alt/Meta/Shift), tự bỏ qua khi đang gõ chữ hoặc mở hộp thoại.
export function useHotkey(key: string, onTrigger: () => void, enabled = true) {
  const callbackRef = useRef(onTrigger)

  useEffect(() => {
    callbackRef.current = onTrigger
  }, [onTrigger])

  useEffect(() => {
    if (!enabled) return
    const targetKey = key.toLowerCase()

    function handleKeyDown(event: KeyboardEvent) {
      if (event.defaultPrevented) return
      if (event.ctrlKey || event.metaKey || event.altKey || event.shiftKey) return
      if (event.key.toLowerCase() !== targetKey) return
      if (isEditableTarget(event.target) || isEditableTarget(document.activeElement)) return
      if (hasOpenDialog()) return

      event.preventDefault()
      callbackRef.current()
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [key, enabled])
}
