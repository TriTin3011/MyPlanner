import { useEffect } from 'react'
import './ClickEffect.css'

const LIFETIME_MS = 520

// Tạo thẳng DOM thay vì setState: mỗi cú click không làm React render lại gì cả.
function spawnClickEffect(x: number, y: number, host: Element) {
  const effect = document.createElement('span')
  effect.className = 'click-fx'
  effect.setAttribute('aria-hidden', 'true')
  effect.style.left = `${x}px`
  effect.style.top = `${y}px`
  effect.innerHTML = '<i class="click-fx__ring"></i><i class="click-fx__dot"></i><i class="click-fx__dot"></i><i class="click-fx__dot"></i>'
  host.appendChild(effect)
  window.setTimeout(() => effect.remove(), LIFETIME_MS)
}

// Lắng nghe một lần ở document (event delegation) nên không phải sửa từng nút.
export function ClickEffect() {
  useEffect(() => {
    const onClick = (event: MouseEvent) => {
      // detail = 0 là click sinh từ bàn phím (Enter/Space), không có vị trí con trỏ.
      if (event.detail === 0) return
      if (window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) return
      // <dialog> mở nằm ở top layer, hiệu ứng phải vào trong nó thì mới không bị che.
      const dialog = event.target instanceof Element ? event.target.closest('dialog[open]') : null
      spawnClickEffect(event.clientX, event.clientY, dialog ?? document.body)
    }
    // capture: vẫn chạy khi component bên trong gọi stopPropagation.
    document.addEventListener('click', onClick, true)
    return () => document.removeEventListener('click', onClick, true)
  }, [])

  return null
}
