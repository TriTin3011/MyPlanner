import { describe, expect, it } from 'vitest'
import { clampPosition, clampWidth } from './musicFrame'
import type { MusicEmbed } from './musicLink'
import { oembedUrl, parsePlayerMessage, playerSrc, YOUTUBE_ORIGIN, youtubeCommand } from './playerEvents'

const youtube: MusicEmbed = { provider: 'YouTube', src: `${YOUTUBE_ORIGIN}/embed/abcdefghijk?list=PL123456789`, height: null }
const viewport = { width: 1000, height: 700, bottomInset: 8 }

describe('playerSrc', () => {
  it('giữ list và thêm tham số điều khiển, vị trí phát tiếp', () => {
    const url = new URL(playerSrc(youtube, 'http://localhost:5173', { start: 42.8, index: 3 }))
    expect(url.searchParams.get('list')).toBe('PL123456789')
    expect(url.searchParams.get('enablejsapi')).toBe('1')
    expect(url.searchParams.get('start')).toBe('42')
    expect(url.searchParams.get('index')).toBe('3')
  })
})

describe('parsePlayerMessage', () => {
  it('đọc trạng thái, thời gian và tên bài của YouTube', () => {
    const data = JSON.stringify({ event: 'infoDelivery', info: { playerState: 1, currentTime: 9, videoData: { title: 'Lofi' } } })
    expect(parsePlayerMessage('YouTube', YOUTUBE_ORIGIN, data)).toEqual({ playing: true, currentTime: 9, title: 'Lofi' })
  })

  it('bỏ qua tin nhắn từ origin lạ hoặc dữ liệu hỏng', () => {
    const data = JSON.stringify({ event: 'onStateChange', info: 1 })
    expect(parsePlayerMessage('YouTube', 'https://evil.example', data)).toBeNull()
    expect(parsePlayerMessage('YouTube', YOUTUBE_ORIGIN, '{hỏng')).toBeNull()
  })

  it('báo lỗi khi video YouTube không phát được', () => {
    const data = JSON.stringify({ event: 'onError', info: 150 })
    expect(parsePlayerMessage('YouTube', YOUTUBE_ORIGIN, data)).toEqual({ playing: false, failed: true })
  })

  it('đọc trạng thái Spotify', () => {
    const data = { type: 'playback_update', payload: { isPaused: true } }
    expect(parsePlayerMessage('Spotify', 'https://open.spotify.com', data)).toEqual({ playing: false })
  })
})

describe('youtubeCommand', () => {
  it('dựng đúng tin nhắn phát và dừng', () => {
    expect(JSON.parse(youtubeCommand('playVideo'))).toEqual({ event: 'command', func: 'playVideo', args: [] })
    expect(JSON.parse(youtubeCommand('pauseVideo'))).toEqual({ event: 'command', func: 'pauseVideo', args: [] })
  })
})

describe('oembedUrl', () => {
  it('Apple Music không có oEmbed', () => {
    expect(oembedUrl('Apple Music', 'https://music.apple.com/us/album/x/1')).toBeNull()
  })
})

describe('musicFrame', () => {
  it('giới hạn bề rộng theo màn hình', () => {
    expect(clampWidth(100, viewport)).toBe(300)
    expect(clampWidth(5000, viewport)).toBe(960)
    expect(clampWidth(380, { ...viewport, width: 320 })).toBe(304)
  })

  it('không cho khung ra ngoài màn hình', () => {
    expect(clampPosition({ x: 5000, y: 5000 }, { width: 300, height: 200 }, viewport)).toEqual({ x: 692, y: 492 })
    expect(clampPosition({ x: -50, y: -50 }, { width: 300, height: 200 }, viewport)).toEqual({ x: 8, y: 8 })
  })
})
