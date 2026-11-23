import { useEffect } from 'react'
import { sketchImageUrl } from '../lib/sketchStroke'

const MAX_CACHED_IMAGES = 200

// Gắn nét vẽ tay cho mọi phần tử `.sketch` (SPEC §4.4). Component không vẽ gì, chỉ theo dõi DOM:
// MutationObserver phát hiện thẻ mới, ResizeObserver báo thẻ đổi cỡ, rồi đặt ảnh vào biến CSS `--sketch-stroke`.
// Không chèn node vào cây của React nên component khác không cần sửa. Thiếu JS thì vẫn còn viền CSS thường.
export function SketchBorders() {
  useEffect(() => {
    if (typeof ResizeObserver === 'undefined') return

    const images = new Map<string, string>()
    const tracked = new Set<HTMLElement>()

    const paint = (element: HTMLElement) => {
      const width = element.offsetWidth
      const height = element.offsetHeight
      if (!width || !height) return
      const size = `${width}x${height}`
      if (element.dataset.sketched === size) return
      const color = getComputedStyle(element).getPropertyValue('--ink').trim() || '#1c2b24'
      const key = `${size}:${color}`
      let image = images.get(key)
      if (!image) {
        if (images.size >= MAX_CACHED_IMAGES) images.clear()
        image = sketchImageUrl(width, height, color)
        images.set(key, image)
      }
      element.style.setProperty('--sketch-stroke', image)
      element.dataset.sketched = size
    }

    const resizes = new ResizeObserver((entries) => {
      for (const entry of entries) paint(entry.target as HTMLElement)
    })

    const track = (element: HTMLElement) => {
      if (tracked.has(element)) return
      tracked.add(element)
      resizes.observe(element)
    }

    const untrack = (element: HTMLElement) => {
      if (!tracked.delete(element)) return
      resizes.unobserve(element)
      element.style.removeProperty('--sketch-stroke')
      delete element.dataset.sketched
    }

    const within = (node: Node, action: (element: HTMLElement) => void) => {
      if (!(node instanceof HTMLElement)) return
      if (node.classList.contains('sketch')) action(node)
      node.querySelectorAll<HTMLElement>('.sketch').forEach(action)
    }

    const mutations = new MutationObserver((records) => {
      for (const record of records) {
        if (record.type === 'attributes') {
          const target = record.target as HTMLElement
          if (target.classList.contains('sketch')) track(target)
          else untrack(target)
          continue
        }
        record.removedNodes.forEach((node) => {
          if (!node.isConnected) within(node, untrack)
        })
        record.addedNodes.forEach((node) => within(node, track))
      }
    })

    within(document.body, track)
    mutations.observe(document.body, { childList: true, subtree: true, attributes: true, attributeFilter: ['class'] })

    return () => {
      mutations.disconnect()
      resizes.disconnect()
      Array.from(tracked).forEach(untrack)
    }
  }, [])

  return null
}
