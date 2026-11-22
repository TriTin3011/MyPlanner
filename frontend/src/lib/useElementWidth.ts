import { useEffect, useRef, useState } from 'react'

// Đo bề rộng thật (px) của một phần tử và cập nhật khi nó đổi cỡ.
// Biểu đồ dùng số này làm bề rộng viewBox, nên 1 đơn vị SVG = 1px màn hình:
// chữ trục giữ đúng cỡ chữ đã đặt, không bị phóng to/thu nhỏ theo bề rộng thẻ.
export function useElementWidth<T extends HTMLElement>(fallback: number) {
  const ref = useRef<T>(null)
  const [width, setWidth] = useState(fallback)

  useEffect(() => {
    const el = ref.current
    if (!el || typeof ResizeObserver === 'undefined') return
    const observer = new ResizeObserver(([entry]) => {
      const w = Math.round(entry.contentRect.width)
      if (w > 0) setWidth(w)
    })
    observer.observe(el)
    return () => observer.disconnect()
  }, [])

  return [ref, width] as const
}
