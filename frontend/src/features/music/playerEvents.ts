import type { MusicEmbed, MusicProvider } from './musicLink'

export const YOUTUBE_ORIGIN = 'https://www.youtube-nocookie.com'
const SPOTIFY_ORIGIN = 'https://open.spotify.com'
const YOUTUBE_PLAYING = 1

export interface PlayerUpdate {
  playing?: boolean
  title?: string
  currentTime?: number
  playlistIndex?: number
}

export interface PlayerResume {
  start: number
  index?: number
}

// Dựng URL iframe. Chỉ YouTube cần thêm tham số: enablejsapi + origin để player gửi trạng thái về,
// autoplay vì iframe chỉ được tạo sau khi người dùng bấm mở khung phát.
export function playerSrc(embed: MusicEmbed, origin: string, resume?: PlayerResume) {
  if (embed.provider !== 'YouTube') return embed.src
  const url = new URL(embed.src)
  url.searchParams.set('enablejsapi', '1')
  url.searchParams.set('origin', origin)
  url.searchParams.set('autoplay', '1')
  if (resume && resume.start > 0) url.searchParams.set('start', String(Math.floor(resume.start)))
  if (resume?.index !== undefined) url.searchParams.set('index', String(resume.index))
  return url.toString()
}

// Hàm thuần đọc tin nhắn từ iframe. Luôn kiểm tra origin trước khi tin dữ liệu;
// định dạng này không phải API công khai nên gặp dữ liệu lạ thì trả null, không làm hỏng trình phát.
export function parsePlayerMessage(provider: MusicProvider, origin: string, data: unknown): PlayerUpdate | null {
  if (provider === 'YouTube' && origin === YOUTUBE_ORIGIN) return parseYouTube(data)
  if (provider === 'Spotify' && origin === SPOTIFY_ORIGIN) return parseSpotify(data)
  return null
}

function parseYouTube(data: unknown): PlayerUpdate | null {
  if (typeof data !== 'string') return null
  let message: { event?: unknown; info?: unknown }
  try {
    message = JSON.parse(data)
  } catch {
    return null
  }
  if (message?.event === 'onStateChange' && typeof message.info === 'number') {
    return { playing: message.info === YOUTUBE_PLAYING }
  }
  if (message?.event !== 'infoDelivery' && message?.event !== 'initialDelivery') return null
  if (!message.info || typeof message.info !== 'object') return null
  const info = message.info as {
    playerState?: unknown
    currentTime?: unknown
    playlistIndex?: unknown
    videoData?: { title?: unknown }
  }
  const update: PlayerUpdate = {}
  if (typeof info.playerState === 'number') update.playing = info.playerState === YOUTUBE_PLAYING
  if (typeof info.currentTime === 'number') update.currentTime = info.currentTime
  if (typeof info.playlistIndex === 'number') update.playlistIndex = info.playlistIndex
  if (typeof info.videoData?.title === 'string' && info.videoData.title) update.title = info.videoData.title
  return update
}

function parseSpotify(data: unknown): PlayerUpdate | null {
  if (!data || typeof data !== 'object') return null
  const message = data as { type?: unknown; payload?: { isPaused?: unknown } }
  if (message.type !== 'playback_update' || typeof message.payload?.isPaused !== 'boolean') return null
  return { playing: !message.payload.isPaused }
}

// oEmbed cho biết tên bài mà chưa cần tải trình phát. Apple Music không có endpoint công khai tương đương.
export function oembedUrl(provider: MusicProvider, link: string) {
  const encoded = encodeURIComponent(link)
  if (provider === 'YouTube') return `https://www.youtube.com/oembed?format=json&url=${encoded}`
  if (provider === 'Spotify') return `https://open.spotify.com/oembed?url=${encoded}`
  return null
}
