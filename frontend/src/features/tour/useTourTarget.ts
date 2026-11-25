import { useEffect, useState } from 'react'
import type { Box } from './tourPosition'

export type TargetStatus = 'none' | 'locating' | 'found' | 'missing'

interface TargetResult {
  name: string | null
  rect: Box | null
  status: TargetStatus
}

// Trang lazy và dữ liệu API có thể về chậm, nhưng không để người dùng chờ mãi: quá hạn thì thẻ ra giữa màn hình.
const LOCATE_TIMEOUT_MS = 3000

// Có hai <nav> (sidebar và thanh đáy) cùng mốc: phần tử display:none không có client rect nên lấy cái đang hiện.
export function findVisibleTarget(name: string): HTMLElement | null {
  const nodes = document.querySelectorAll<HTMLElement>(`[data-tour="${name}"]`)
  return Array.from(nodes).find((node) => node.getClientRects().length > 0) ?? null
}

const sameBox = (a: Box | null, b: Box) =>
  a !== null && a.left === b.left && a.top === b.top && a.width === b.width && a.height === b.height

// Theo dõi vị trí phần tử của bước hiện tại. `ready` là false khi router chưa sang đúng trang.
export function useTourTarget(name: string | null, ready: boolean): { rect: Box | null; status: TargetStatus } {
  const [result, setResult] = useState<TargetResult>({ name: null, rect: null, status: 'none' })

  useEffect(() => {
    if (!name || !ready) return
    let element: HTMLElement | null = null
    let frame = 0

    const resize = typeof ResizeObserver === 'undefined' ? null : new ResizeObserver(() => schedule())
    const timer = window.setTimeout(() => {
      if (!element) setResult({ name, rect: null, status: 'missing' })
    }, LOCATE_TIMEOUT_MS)

    function measure() {
      const next = findVisibleTarget(name as string)
      if (!next) {
        // Phần tử biến mất (đổi breakpoint, dữ liệu tải lại): quay về tìm, giữ thẻ ở chỗ cũ.
        if (element) {
          element = null
          resize?.disconnect()
          setResult({ name, rect: null, status: 'locating' })
        }
        return
      }
      if (next !== element) {
        element = next
        resize?.disconnect()
        resize?.observe(next)
        // Điện thoại đưa phần tử lên đầu để chừa chỗ cho thẻ ở dưới. Cuộn tức thì để đo được ngay.
        next.scrollIntoView?.({ block: window.innerWidth < 768 ? 'start' : 'center', inline: 'nearest' })
      }
      const r = next.getBoundingClientRect()
      const rect = { left: r.left, top: r.top, width: r.width, height: r.height }
      setResult((prev) => (prev.name === name && sameBox(prev.rect, rect) ? prev : { name, rect, status: 'found' }))
    }

    // Gom nhiều sự kiện trong một khung hình thành một lần đo.
    function schedule() {
      cancelAnimationFrame(frame)
      frame = requestAnimationFrame(measure)
    }

    const mutations = new MutationObserver(schedule)
    mutations.observe(document.body, { childList: true, subtree: true })
    window.addEventListener('resize', schedule)
    // capture: sự kiện scroll không nổi bọt, mà #main-content là vùng cuộn riêng.
    window.addEventListener('scroll', schedule, true)
    measure()

    return () => {
      cancelAnimationFrame(frame)
      window.clearTimeout(timer)
      mutations.disconnect()
      resize?.disconnect()
      window.removeEventListener('resize', schedule)
      window.removeEventListener('scroll', schedule, true)
    }
  }, [name, ready])

  if (!name) return { rect: null, status: 'none' }
  // Kết quả của bước trước không được dùng cho bước này.
  if (!ready || result.name !== name) return { rect: null, status: 'locating' }
  return { rect: result.rect, status: result.status }
}
