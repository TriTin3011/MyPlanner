import { describe, expect, it } from 'vitest'
import { parseMusicLink } from './musicLink'

describe('parseMusicLink', () => {
  it.each([
    ['https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ'],
    ['https://youtu.be/dQw4w9WgXcQ?si=abc', 'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ'],
    ['https://music.youtube.com/watch?v=dQw4w9WgXcQ', 'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ'],
    [
      'https://www.youtube.com/playlist?list=PL1234567890abc',
      'https://www.youtube-nocookie.com/embed/videoseries?list=PL1234567890abc',
    ],
    [
      'https://open.spotify.com/intl-vi/track/4uLU6hMCjMI75M1A2tKUQF?si=x',
      'https://open.spotify.com/embed/track/4uLU6hMCjMI75M1A2tKUQF',
    ],
    [
      'https://music.apple.com/vn/album/some-name/1440857781?i=1440857782',
      'https://embed.music.apple.com/vn/album/some-name/1440857781?i=1440857782',
    ],
  ])('đổi %s thành URL nhúng', (input, src) => {
    expect(parseMusicLink(input)?.src).toBe(src)
  })

  it.each([
    'không phải link',
    'javascript:alert(1)',
    'https://evil.example/watch?v=dQw4w9WgXcQ',
    'https://youtube.com.evil.example/watch?v=dQw4w9WgXcQ',
    'https://www.youtube.com/watch?v=short',
    'https://open.spotify.com/user/abc',
  ])('từ chối %s', (input) => {
    expect(parseMusicLink(input)).toBeNull()
  })
})
