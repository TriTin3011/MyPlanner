import { describe, expect, it } from 'vitest'
import { collapsedView, miniFrameHeight, YOUTUBE_MIN_FRAME_HEIGHT } from './musicFrame'

describe('miniFrameHeight', () => {
  it('giữ vùng phát YouTube ít nhất 200px sau khi trừ viền', () => {
    expect(miniFrameHeight('YouTube', null) - 4).toBeGreaterThanOrEqual(200)
    expect(miniFrameHeight('YouTube', null)).toBe(YOUTUBE_MIN_FRAME_HEIGHT)
  })

  it('dùng cỡ gọn cho khung nhúng cao', () => {
    expect(miniFrameHeight('Spotify', 352)).toBe(152)
    expect(miniFrameHeight('Apple Music', 450)).toBe(175)
  })

  it('không phóng to khung nhúng vốn đã thấp', () => {
    expect(miniFrameHeight('Apple Music', 150)).toBe(150)
  })
})

describe('collapsedView', () => {
  it('YouTube luôn giữ iframe dù đang dừng', () => {
    expect(collapsedView('YouTube', true)).toBe('mini')
    expect(collapsedView('YouTube', false)).toBe('mini')
  })

  it('nhà cung cấp khác chỉ giữ khung khi đang phát', () => {
    expect(collapsedView('Spotify', true)).toBe('mini')
    expect(collapsedView('Spotify', false)).toBe('bar')
  })
})
