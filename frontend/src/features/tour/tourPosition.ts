export interface Box {
  left: number
  top: number
  width: number
  height: number
}

export interface Size {
  width: number
  height: number
}

const EDGE = 12
const GAP = 12
const SPOT_PADDING = 6

const clamp = (value: number, min: number, max: number) => Math.max(min, Math.min(value, Math.max(min, max)))

// Vùng sáng: nới phần tử ra một chút rồi cắt theo màn hình, vì bảng dài có thể vượt khỏi khung nhìn.
export function spotlightBox(target: Box, viewport: Size): Box {
  const left = Math.max(target.left - SPOT_PADDING, 0)
  const top = Math.max(target.top - SPOT_PADDING, 0)
  const right = Math.min(target.left + target.width + SPOT_PADDING, viewport.width)
  const bottom = Math.min(target.top + target.height + SPOT_PADDING, viewport.height)
  return { left, top, width: Math.max(right - left, 0), height: Math.max(bottom - top, 0) }
}

// Chọn chỗ đặt thẻ: thử dưới, trên, phải, trái. Không chỗ nào đủ (phần tử quá lớn) thì ghim vào
// nửa màn hình còn trống hơn. Hàm thuần nên test được mà không cần trình duyệt.
export function placeCard(spot: Box | null, card: Size, viewport: Size): { x: number; y: number } {
  const maxX = viewport.width - card.width - EDGE
  const maxY = viewport.height - card.height - EDGE
  if (!spot) {
    return { x: clamp((viewport.width - card.width) / 2, EDGE, maxX), y: clamp((viewport.height - card.height) / 2, EDGE, maxY) }
  }

  const alignedX = clamp(spot.left, EDGE, maxX)
  const alignedY = clamp(spot.top, EDGE, maxY)
  const below = spot.top + spot.height + GAP
  const above = spot.top - GAP - card.height
  const right = spot.left + spot.width + GAP
  const left = spot.left - GAP - card.width

  if (below <= maxY) return { x: alignedX, y: below }
  if (above >= EDGE) return { x: alignedX, y: above }
  if (right <= maxX) return { x: right, y: alignedY }
  if (left >= EDGE) return { x: left, y: alignedY }

  const spotCenter = spot.top + spot.height / 2
  return { x: clamp((viewport.width - card.width) / 2, EDGE, maxX), y: spotCenter < viewport.height / 2 ? maxY : EDGE }
}
