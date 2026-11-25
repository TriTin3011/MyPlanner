import type { MusicProvider } from './musicLink'

// bar: chỉ thanh tiêu đề, chưa có iframe. full: khung đầy đủ.
// mini: iframe vẫn sống; YouTube được giấu ngoài màn hình, Spotify và Apple Music giữ khung nhỏ.
export type PlayerView = 'bar' | 'mini' | 'full'

export interface MusicFrame {
  x: number
  y: number
  width: number
}

export interface FrameViewport {
  width: number
  height: number
  // Phần đáy phải chừa ra, trên điện thoại là thanh điều hướng.
  bottomInset: number
}

// Dùng chung cho mọi khung nổi kéo được (hộp nhạc, Pomodoro thu nhỏ). Điện thoại chừa thanh điều hướng đáy.
export function readViewport(): FrameViewport {
  return {
    width: window.innerWidth,
    height: window.innerHeight,
    bottomInset: window.innerWidth < 768 ? 68 : 8,
  }
}

export const MIN_FRAME_WIDTH = 300
export const MAX_FRAME_WIDTH = 960
export const COLLAPSED_WIDTH = 340
const DEFAULT_WIDTH = 380
const EDGE = 8
// YouTube yêu cầu vùng phát tối thiểu 200px; iframe có viền 2px mỗi phía nên cao 204px.
export const YOUTUBE_MIN_FRAME_HEIGHT = 204
const MINI_HEIGHT: Record<MusicProvider, number> = {
  YouTube: YOUTUBE_MIN_FRAME_HEIGHT,
  Spotify: 152,
  'Apple Music': 175,
}

// Chiều cao iframe ở chế độ mini: dùng cỡ gọn của từng nhà cung cấp, không lớn hơn cỡ gốc của khung nhúng.
export function miniFrameHeight(provider: MusicProvider, embedHeight: number | null) {
  return embedHeight === null ? MINI_HEIGHT[provider] : Math.min(MINI_HEIGHT[provider], embedHeight)
}

// Thu gọn khung đầy đủ. YouTube luôn giữ iframe (điều khiển được qua postMessage, không mất vị trí nghe).
// Nhà cung cấp khác không có lệnh phát từ ngoài: đang phát thì giữ mini, không phát thì về thanh tiêu đề.
export function collapsedView(provider: MusicProvider, playing: boolean): PlayerView {
  return provider === 'YouTube' || playing ? 'mini' : 'bar'
}

export function clampWidth(width: number, viewport: FrameViewport) {
  const max = Math.min(MAX_FRAME_WIDTH, viewport.width - EDGE * 2)
  return Math.round(Math.max(Math.min(MIN_FRAME_WIDTH, max), Math.min(max, width)))
}

// Giữ khung luôn nằm trong màn hình. Nếu khung cao hơn màn hình thì ưu tiên mép trên để vẫn bấm được thanh tiêu đề.
export function clampPosition(
  position: { x: number; y: number },
  size: { width: number; height: number },
  viewport: FrameViewport,
) {
  const maxX = viewport.width - size.width - EDGE
  const maxY = viewport.height - size.height - viewport.bottomInset
  return {
    x: Math.round(Math.max(EDGE, Math.min(maxX, position.x))),
    y: Math.round(Math.max(EDGE, Math.min(maxY, position.y))),
  }
}

export function defaultFrame(viewport: FrameViewport, collapsedHeight = 72): MusicFrame {
  const width = clampWidth(DEFAULT_WIDTH, viewport)
  const shown = Math.min(width, COLLAPSED_WIDTH)
  const position = clampPosition(
    { x: viewport.width - shown - 24, y: viewport.height - collapsedHeight - 24 },
    { width: shown, height: collapsedHeight },
    viewport,
  )
  return { ...position, width }
}
