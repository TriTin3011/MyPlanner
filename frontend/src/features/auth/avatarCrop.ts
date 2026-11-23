export interface ImageSize {
  width: number
  height: number
}

export interface CropOffset {
  x: number
  y: number
}

export const MIN_ZOOM = 1
export const MAX_ZOOM = 3

// Tỉ lệ hiển thị: zoom = 1 nghĩa là cạnh ngắn của ảnh vừa khít khung cắt.
export function cropScale(image: ImageSize, viewport: number, zoom: number) {
  return (viewport / Math.min(image.width, image.height)) * zoom
}

// offset là độ lệch của tâm ảnh so với tâm khung. Giới hạn để ảnh luôn phủ kín khung, không lộ vùng trống.
export function clampOffset(offset: CropOffset, image: ImageSize, viewport: number, zoom: number): CropOffset {
  const scale = cropScale(image, viewport, zoom)
  const maxX = Math.max(0, (image.width * scale - viewport) / 2)
  const maxY = Math.max(0, (image.height * scale - viewport) / 2)
  return {
    x: Math.max(-maxX, Math.min(maxX, offset.x)),
    y: Math.max(-maxY, Math.min(maxY, offset.y)),
  }
}

// Đổi từ toạ độ màn hình sang vùng điểm ảnh gốc cần cắt.
export function cropSource(image: ImageSize, viewport: number, zoom: number, offset: CropOffset) {
  const scale = cropScale(image, viewport, zoom)
  const size = viewport / scale
  return {
    x: image.width / 2 - size / 2 - offset.x / scale,
    y: image.height / 2 - size / 2 - offset.y / scale,
    size,
  }
}
