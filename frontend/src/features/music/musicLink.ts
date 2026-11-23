export type MusicProvider = 'YouTube' | 'Spotify' | 'Apple Music'

export interface MusicEmbed {
  provider: MusicProvider
  src: string
  // Chiều cao khung phát; null nghĩa là theo tỉ lệ video 16:9.
  height: number | null
}

const YOUTUBE_ID = /^[\w-]{11}$/
const YOUTUBE_LIST = /^[\w-]{10,64}$/
const SPOTIFY_PATH = /^\/(?:intl-[a-z]{2}\/)?(track|album|playlist|episode|show|artist)\/([A-Za-z0-9]{10,32})\/?$/
const APPLE_PATH = /^\/[a-z]{2}\/(album|playlist|song|station)\/[^/]+\/[\w.-]+\/?$|^\/[a-z]{2}\/(album|playlist|song|station)\/[\w.-]+\/?$/

// Hàm thuần: đổi link người dùng dán thành URL nhúng. Chỉ nhận đúng các host đã biết rồi tự dựng lại URL,
// nên chuỗi lạ (javascript:, trang giả mạo) không bao giờ lọt vào thuộc tính src của iframe.
export function parseMusicLink(input: string): MusicEmbed | null {
  let url: URL
  try {
    url = new URL(input.trim())
  } catch {
    return null
  }
  if (url.protocol !== 'https:' && url.protocol !== 'http:') return null

  const host = url.hostname.toLowerCase()
  if (host === 'youtu.be' || host === 'youtube.com' || host.endsWith('.youtube.com')) return parseYouTube(url, host)
  if (host === 'open.spotify.com') return parseSpotify(url)
  if (host === 'music.apple.com') return parseApple(url)
  return null
}

function parseYouTube(url: URL, host: string): MusicEmbed | null {
  const parts = url.pathname.split('/').filter(Boolean)
  let id: string | null = null
  if (host === 'youtu.be') id = parts[0] ?? null
  else if (parts[0] === 'watch') id = url.searchParams.get('v')
  else if (parts[0] === 'shorts' || parts[0] === 'embed' || parts[0] === 'live') id = parts[1] ?? null
  else if (parts[0] !== 'playlist') return null

  const rawList = url.searchParams.get('list')
  const list = rawList && YOUTUBE_LIST.test(rawList) ? rawList : null
  const validId = id && YOUTUBE_ID.test(id) ? id : null
  if (!validId && !list) return null

  const base = 'https://www.youtube-nocookie.com/embed/'
  const src = validId
    ? `${base}${validId}${list ? `?list=${list}` : ''}`
    : `${base}videoseries?list=${list}`
  return { provider: 'YouTube', src, height: null }
}

function parseSpotify(url: URL): MusicEmbed | null {
  const match = SPOTIFY_PATH.exec(url.pathname)
  if (!match) return null
  return { provider: 'Spotify', src: `https://open.spotify.com/embed/${match[1]}/${match[2]}`, height: 152 }
}

function parseApple(url: URL): MusicEmbed | null {
  if (!APPLE_PATH.test(url.pathname)) return null
  const track = url.searchParams.get('i')
  const query = track && /^\d+$/.test(track) ? `?i=${track}` : ''
  return { provider: 'Apple Music', src: `https://embed.music.apple.com${url.pathname}${query}`, height: 175 }
}
