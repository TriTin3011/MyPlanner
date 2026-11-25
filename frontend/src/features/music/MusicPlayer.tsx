import { useQuery } from '@tanstack/react-query'
import { ChevronDown, ChevronUp, GripVertical, MoveDiagonal2, Pause, Play, X } from 'lucide-react'
import {
  type FormEvent,
  type KeyboardEvent,
  type PointerEvent,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
} from 'react'
import { useTranslation } from 'react-i18next'
import { useSettings } from '../../store/settings'
import { MusicBoxIcon } from './MusicBoxIcon'
import {
  clampPosition,
  clampWidth,
  COLLAPSED_WIDTH,
  collapsedView,
  defaultFrame,
  type FrameViewport,
  miniFrameHeight,
  type MusicFrame,
  type PlayerView,
} from './musicFrame'
import { parseMusicLink } from './musicLink'
import {
  oembedUrl,
  parsePlayerMessage,
  playerSrc,
  type PlayerResume,
  YOUTUBE_ORIGIN,
  youtubeCommand,
} from './playerEvents'

const KEY_STEP = 24
const ARROWS: Record<string, [number, number]> = {
  ArrowLeft: [-KEY_STEP, 0],
  ArrowRight: [KEY_STEP, 0],
  ArrowUp: [0, -KEY_STEP],
  ArrowDown: [0, KEY_STEP],
}

function readViewport(): FrameViewport {
  return {
    width: window.innerWidth,
    height: window.innerHeight,
    bottomInset: window.innerWidth < 768 ? 68 : 8,
  }
}

async function fetchTitle(url: string) {
  const response = await fetch(url)
  if (!response.ok) return null
  const body = (await response.json()) as { title?: unknown }
  return typeof body.title === 'string' ? body.title : null
}

interface Gesture {
  kind: 'move' | 'resize'
  startX: number
  startY: number
  origin: MusicFrame
  latest: MusicFrame
}

// Khung phát nổi, gắn ở AppShell ngoài <Outlet /> nên chuyển trang không ngắt nhạc.
// Giữa mini và full, iframe vẫn là cùng một phần tử nên nhạc không bị tải lại.
// YouTube ở mini được đẩy ra ngoài màn hình và điều khiển qua postMessage. Đây là lựa chọn của chủ dự án,
// điều khoản YouTube không cho phát khi giấu trình phát nên phải xem lại trước khi mở app cho công chúng.
// Spotify và Apple Music không có lệnh phát từ ngoài nên giữ khung nhỏ; về thanh tiêu đề thì gỡ iframe và nhớ vị trí.
export function MusicPlayer({
  onClose,
  onPlayingChange,
}: {
  onClose: () => void
  onPlayingChange?: (playing: boolean) => void
}) {
  const { t } = useTranslation()
  const musicUrl = useSettings((s) => s.musicUrl)
  const setMusicUrl = useSettings((s) => s.setMusicUrl)
  const savedFrame = useSettings((s) => s.musicFrame)
  const setMusicFrame = useSettings((s) => s.setMusicFrame)
  const embed = musicUrl ? parseMusicLink(musicUrl) : null

  const [view, setView] = useState<PlayerView>('bar')
  const [editing, setEditing] = useState(false)
  const [draft, setDraft] = useState(musicUrl ?? '')
  const [invalid, setInvalid] = useState(false)
  const [frame, setFrame] = useState<MusicFrame>(() => savedFrame ?? defaultFrame(readViewport()))
  const [dragging, setDragging] = useState(false)
  const [playing, setPlaying] = useState(false)
  const [liveTitle, setLiveTitle] = useState<string | null>(null)
  const [resume, setResume] = useState<PlayerResume | undefined>()

  const sectionRef = useRef<HTMLElement>(null)
  const iframeRef = useRef<HTMLIFrameElement>(null)
  const gestureRef = useRef<Gesture | null>(null)
  const progressRef = useRef<PlayerResume>({ start: 0 })

  const showForm = editing || !embed
  const provider = embed?.provider
  const expanded = view === 'full'
  const frameOpen = view !== 'bar'
  const shownWidth = expanded || showForm ? frame.width : Math.min(frame.width, COLLAPSED_WIDTH)
  const titleUrl = embed && musicUrl ? oembedUrl(embed.provider, musicUrl) : null
  const { data: fetchedTitle } = useQuery({
    queryKey: ['music-title', titleUrl],
    queryFn: () => fetchTitle(titleUrl!),
    enabled: titleUrl !== null,
    staleTime: Infinity,
    retry: false,
  })
  const title = liveTitle ?? fetchedTitle ?? embed?.provider ?? t('music.title')
  // Apple Music không báo trạng thái, nên coi khung đang mở là đang phát.
  const isPlaying = frameOpen && (provider === 'Apple Music' || playing)
  const statusKey = isPlaying ? 'music.playing' : frameOpen ? 'music.framePaused' : 'music.paused'
  const frameHeight = embed && view === 'mini' ? miniFrameHeight(embed.provider, embed.height) : (embed?.height ?? null)
  const frameHidden = provider === 'YouTube' && view === 'mini'
  const showPause = provider === 'YouTube' ? isPlaying : frameOpen
  const playLabelKey = !showPause ? 'music.play' : provider === 'YouTube' ? 'music.pause' : 'music.stop'

  useEffect(() => {
    onPlayingChange?.(isPlaying)
  }, [isPlaying, onPlayingChange])
  useEffect(() => () => onPlayingChange?.(false), [onPlayingChange])

  // Khung đổi chiều cao (mở, thu gọn, hiện form) hoặc cửa sổ đổi cỡ thì đẩy khung về trong màn hình.
  useLayoutEffect(() => {
    const fit = () => {
      const element = sectionRef.current
      if (!element) return
      const viewport = readViewport()
      setFrame((current) => {
        const width = clampWidth(current.width, viewport)
        const used = expanded || showForm ? width : Math.min(width, COLLAPSED_WIDTH)
        const position = clampPosition(current, { width: used, height: element.offsetHeight }, viewport)
        const same = width === current.width && position.x === current.x && position.y === current.y
        return same ? current : { ...position, width }
      })
    }
    fit()
    window.addEventListener('resize', fit)
    return () => window.removeEventListener('resize', fit)
  }, [view, expanded, showForm, frame.width])

  useEffect(() => {
    if (!frameOpen || !provider) return
    const onMessage = (event: MessageEvent) => {
      if (event.source !== iframeRef.current?.contentWindow) return
      const update = parsePlayerMessage(provider, event.origin, event.data)
      if (!update) return
      if (update.playing !== undefined) setPlaying(update.playing)
      if (update.failed) setView('full')
      if (update.title) setLiveTitle(update.title)
      if (update.currentTime !== undefined) progressRef.current.start = update.currentTime
      if (update.playlistIndex !== undefined) progressRef.current.index = update.playlistIndex
    }
    window.addEventListener('message', onMessage)
    return () => window.removeEventListener('message', onMessage)
  }, [frameOpen, provider])

  // Gỡ iframe nên phải chốt vị trí nghe trước. Không đặt resume lúc iframe còn sống, vì đổi src sẽ tải lại nhạc.
  const stopToBar = () => {
    setResume({ ...progressRef.current })
    setPlaying(false)
    setView('bar')
  }

  const toggleExpanded = () => {
    if (!expanded) setView('full')
    else if (provider && collapsedView(provider, isPlaying) === 'mini') setView('mini')
    else stopToBar()
  }

  const togglePlay = () => {
    if (!frameOpen) setView('mini')
    else if (provider === 'YouTube') {
      iframeRef.current?.contentWindow?.postMessage(youtubeCommand(isPlaying ? 'pauseVideo' : 'playVideo'), YOUTUBE_ORIGIN)
    } else stopToBar()
  }

  const submit = (event: FormEvent) => {
    event.preventDefault()
    if (!parseMusicLink(draft)) {
      setInvalid(true)
      return
    }
    setMusicUrl(draft.trim())
    progressRef.current = { start: 0 }
    setResume(undefined)
    setLiveTitle(null)
    setPlaying(false)
    setInvalid(false)
    setEditing(false)
    setView('mini')
  }

  const beginGesture = (kind: Gesture['kind']) => (event: PointerEvent<HTMLElement>) => {
    if (event.button !== 0) return
    if (kind === 'move' && (event.target as HTMLElement).closest('button:not([data-drag-handle])')) return
    event.currentTarget.setPointerCapture(event.pointerId)
    gestureRef.current = { kind, startX: event.clientX, startY: event.clientY, origin: frame, latest: frame }
    setDragging(true)
    event.stopPropagation()
  }

  const moveGesture = (event: PointerEvent<HTMLElement>) => {
    const gesture = gestureRef.current
    const element = sectionRef.current
    if (!gesture || !element) return
    const viewport = readViewport()
    const dx = event.clientX - gesture.startX
    const dy = event.clientY - gesture.startY
    const next =
      gesture.kind === 'move'
        ? {
            ...gesture.origin,
            ...clampPosition(
              { x: gesture.origin.x + dx, y: gesture.origin.y + dy },
              { width: element.offsetWidth, height: element.offsetHeight },
              viewport,
            ),
          }
        : { ...gesture.origin, width: clampWidth(gesture.origin.width + dx, viewport) }
    gesture.latest = next
    setFrame(next)
  }

  const endGesture = () => {
    if (gestureRef.current) setMusicFrame(gestureRef.current.latest)
    gestureRef.current = null
    setDragging(false)
  }

  const onMoveKey = (event: KeyboardEvent<HTMLButtonElement>) => {
    const step = ARROWS[event.key]
    const element = sectionRef.current
    if (!step || !element) return
    event.preventDefault()
    const position = clampPosition(
      { x: frame.x + step[0], y: frame.y + step[1] },
      { width: element.offsetWidth, height: element.offsetHeight },
      readViewport(),
    )
    const next = { ...frame, ...position }
    setFrame(next)
    setMusicFrame(next)
  }

  const onResizeKey = (event: KeyboardEvent<HTMLButtonElement>) => {
    const delta = event.key === 'ArrowRight' ? KEY_STEP : event.key === 'ArrowLeft' ? -KEY_STEP : 0
    if (!delta) return
    event.preventDefault()
    const next = { ...frame, width: clampWidth(frame.width + delta, readViewport()) }
    setFrame(next)
    setMusicFrame(next)
  }

  const onFrameLoad = () => {
    if (provider !== 'YouTube') return
    iframeRef.current?.contentWindow?.postMessage(
      JSON.stringify({ event: 'listening', id: 1, channel: 'widget' }),
      YOUTUBE_ORIGIN,
    )
  }

  return (
    <section
      ref={sectionRef}
      aria-label={t('music.title')}
      style={{ left: frame.x, top: frame.y, width: shownWidth }}
      className="sketch fixed z-30 p-2.5"
    >
      <div
        onPointerDown={beginGesture('move')}
        onPointerMove={moveGesture}
        onPointerUp={endGesture}
        onPointerCancel={endGesture}
        className={`flex touch-none items-center gap-1.5 select-none ${dragging ? 'cursor-grabbing' : 'cursor-grab'}`}
      >
        <button
          type="button"
          data-drag-handle
          aria-label={t('music.move')}
          title={t('music.move')}
          onKeyDown={onMoveKey}
          className="grid h-11 w-6 shrink-0 cursor-grab place-items-center rounded-lg text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
        >
          <GripVertical size={16} aria-hidden />
        </button>
        <MusicBoxIcon playing={isPlaying} size={34} />
        <div className="min-w-0 flex-1 pl-1">
          <h2 className="truncate text-sm font-bold text-ink" title={title}>
            {title}
          </h2>
          <p className="truncate text-xs text-ink-muted">
            {embed ? `${embed.provider} · ${t(statusKey)}` : t('music.noTrack')}
          </p>
        </div>
        {embed && expanded && !editing && (
          <button
            type="button"
            onClick={() => {
              setDraft(musicUrl ?? '')
              setEditing(true)
            }}
            className="min-h-11 shrink-0 cursor-pointer rounded-xl px-2.5 text-xs font-bold text-ink-muted hover:bg-accent-tint hover:text-ink"
          >
            {t('music.change')}
          </button>
        )}
        {embed && !expanded && !editing && (
          <button
            type="button"
            aria-label={t(playLabelKey)}
            title={t(playLabelKey)}
            onClick={togglePlay}
            className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-xl bg-primary text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
          >
            {showPause ? <Pause size={18} aria-hidden /> : <Play size={18} aria-hidden />}
          </button>
        )}
        {embed && (
          <button
            type="button"
            aria-expanded={expanded}
            aria-label={t(expanded ? 'music.collapse' : 'music.expand')}
            title={t(expanded ? 'music.collapse' : 'music.expand')}
            onClick={toggleExpanded}
            className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-xl text-primary hover:bg-accent-tint"
          >
            {/* Khung neo theo cạnh trên nên phần mở rộng hiện ra phía dưới: mở là mũi tên xuống, thu gọn là mũi tên lên. */}
            {expanded ? <ChevronUp size={19} aria-hidden /> : <ChevronDown size={19} aria-hidden />}
          </button>
        )}
        <button
          type="button"
          aria-label={t('music.close')}
          onClick={onClose}
          className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-xl hover:bg-accent-tint"
        >
          <X size={18} aria-hidden />
        </button>
      </div>

      {showForm && (
        <form onSubmit={submit} className="mt-2 flex flex-col gap-2">
          <label className="text-xs font-bold text-ink-muted">
            {t('music.linkLabel')}
            <input
              type="url"
              required
              autoFocus
              value={draft}
              aria-invalid={invalid}
              placeholder={t('music.placeholder')}
              onChange={(event) => {
                setDraft(event.target.value)
                setInvalid(false)
              }}
              className="mt-1 min-h-11 w-full rounded-xl border-2 border-ink bg-surface px-3 text-sm font-normal text-ink"
            />
          </label>
          {invalid ? (
            <p role="alert" className="text-xs font-semibold text-danger">
              {t('music.invalid')}
            </p>
          ) : (
            <p className="text-xs text-ink-muted">{t('music.hint')}</p>
          )}
          <div className="flex justify-end gap-2">
            {embed && (
              <button
                type="button"
                onClick={() => {
                  setEditing(false)
                  setInvalid(false)
                }}
                className="min-h-11 cursor-pointer rounded-xl px-4 text-sm font-bold text-ink-muted hover:bg-accent-tint"
              >
                {t('music.cancel')}
              </button>
            )}
            <button
              type="submit"
              className="min-h-11 cursor-pointer rounded-xl border-2 border-ink bg-primary px-5 text-sm font-bold text-white"
            >
              {t('music.save')}
            </button>
          </div>
        </form>
      )}

      {embed && frameOpen && (
        // Chỉ đổi class của khung bọc, không đổi cây phần tử: React giữ nguyên iframe nên nhạc không tải lại.
        // position: fixed đưa khung ra khỏi luồng nên thanh tiêu đề không còn chừa chỗ, và không tạo thanh cuộn ngang.
        <div inert={frameHidden} className={frameHidden ? 'fixed top-0 left-[-9999px] w-[204px]' : 'relative mt-2'}>
          <iframe
            ref={iframeRef}
            key={embed.src}
            src={playerSrc(embed, window.location.origin, resume)}
            title={t('music.frameTitle', { provider: embed.provider })}
            allow="autoplay; encrypted-media; picture-in-picture; fullscreen"
            referrerPolicy="strict-origin-when-cross-origin"
            onLoad={onFrameLoad}
            // Lúc kéo, con trỏ đi qua iframe sẽ bị trang con nuốt sự kiện nên tạm tắt tương tác.
            className={`block w-full rounded-xl border-2 border-ink ${frameHeight === null ? 'aspect-video min-h-[204px]' : ''} ${dragging ? 'pointer-events-none' : ''}`}
            style={frameHeight === null ? undefined : { height: frameHeight }}
          />
          {expanded && (
            <button
              type="button"
              aria-label={t('music.resize')}
              title={t('music.resize')}
              onPointerDown={beginGesture('resize')}
              onPointerMove={moveGesture}
              onPointerUp={endGesture}
              onPointerCancel={endGesture}
              onKeyDown={onResizeKey}
              className="absolute -right-1.5 -bottom-1.5 grid size-8 cursor-nwse-resize touch-none place-items-center rounded-lg border-2 border-ink bg-surface text-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
            >
              <MoveDiagonal2 size={14} className="rotate-90" aria-hidden />
            </button>
          )}
        </div>
      )}
    </section>
  )
}
