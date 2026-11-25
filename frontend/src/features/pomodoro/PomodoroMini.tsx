import { GripVertical, Maximize2, Pause, PictureInPicture2, Play, RotateCcw } from 'lucide-react'
import {
  type ComponentPropsWithRef,
  type KeyboardEvent,
  type PointerEvent,
  type ReactNode,
  useEffect,
  useRef,
  useState,
} from 'react'
import { useTranslation } from 'react-i18next'
import { useSettings } from '../../store/settings'
import { clampPosition, readViewport } from '../music/musicFrame'
import { formatClock, remainingMs } from './pomodoro'
import { usePomodoro, usePomodoroNow } from './store'
import { TomatoIcon } from './TomatoIcon'

const MINI_BUTTON =
  'grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none'

const KEY_STEP = 24
const ARROWS: Record<string, [number, number]> = {
  ArrowLeft: [-KEY_STEP, 0],
  ArrowRight: [KEY_STEP, 0],
  ArrowUp: [0, -KEY_STEP],
  ArrowDown: [0, KEY_STEP],
}

type Point = { x: number; y: number }

interface CompactProps {
  className: string
  onExpand: () => void
  onFloat?: () => void
  // Phần tử đứng đầu hàng, thanh nhỏ trong trang dùng làm tay nắm kéo.
  handle?: ReactNode
  sectionProps?: ComponentPropsWithRef<'section'>
}

// Thanh đếm nhỏ khi modal đóng. Không dùng <dialog> nên người dùng vẫn thao tác được với trang phía sau.
// Mặc định đặt bên trái vì hộp nhạc nằm góc phải dưới; điện thoại nằm trên thanh điều hướng đáy và hộp nhạc.
// Kéo được như hộp nhạc: đã kéo thì chuyển sang toạ độ left/top lưu trong settings, chưa kéo thì giữ vị trí CSS.
export function PomodoroMini({ onExpand, onFloat }: Pick<CompactProps, 'onExpand' | 'onFloat'>) {
  const { t } = useTranslation()
  const started = usePomodoro((s) => s.endsAt !== null || s.pausedMs !== null)
  const saved = useSettings((s) => s.pomodoroPosition)
  const save = useSettings((s) => s.setPomodoroPosition)
  const [position, setPosition] = useState<Point | null>(saved ?? null)
  const [dragging, setDragging] = useState(false)
  const sectionRef = useRef<HTMLElement>(null)
  const gestureRef = useRef<{ startX: number; startY: number; origin: Point; latest: Point } | null>(null)

  // Cửa sổ thu nhỏ lại thì kéo thanh về trong màn hình. Chỉ cần đăng ký lại khi chuyển giữa vị trí CSS và toạ độ.
  const placed = position !== null
  useEffect(() => {
    if (!started || !placed) return
    const fit = () => {
      const element = sectionRef.current
      if (!element) return
      const size = { width: element.offsetWidth, height: element.offsetHeight }
      setPosition((current) => {
        if (!current) return current
        const next = clampPosition(current, size, readViewport())
        return next.x === current.x && next.y === current.y ? current : next
      })
    }
    fit()
    window.addEventListener('resize', fit)
    return () => window.removeEventListener('resize', fit)
  }, [started, placed])

  if (!started) return null

  const moveTo = (target: Point) => {
    const element = sectionRef.current
    if (!element) return target
    const next = clampPosition(target, { width: element.offsetWidth, height: element.offsetHeight }, readViewport())
    setPosition(next)
    return next
  }

  // Lần kéo đầu tiên lấy toạ độ thật trên màn hình làm gốc, vì lúc đó thanh còn đặt bằng bottom/left trong CSS.
  const currentPoint = (): Point => {
    if (position) return position
    const rect = sectionRef.current!.getBoundingClientRect()
    return { x: rect.left, y: rect.top }
  }

  const begin = (event: PointerEvent<HTMLElement>) => {
    if (event.button !== 0) return
    if ((event.target as HTMLElement).closest('button:not([data-drag-handle])')) return
    event.currentTarget.setPointerCapture(event.pointerId)
    const origin = currentPoint()
    gestureRef.current = { startX: event.clientX, startY: event.clientY, origin, latest: origin }
    setDragging(true)
  }

  const move = (event: PointerEvent<HTMLElement>) => {
    const gesture = gestureRef.current
    if (!gesture) return
    gesture.latest = moveTo({
      x: gesture.origin.x + event.clientX - gesture.startX,
      y: gesture.origin.y + event.clientY - gesture.startY,
    })
  }

  const end = () => {
    if (gestureRef.current) save(gestureRef.current.latest)
    gestureRef.current = null
    setDragging(false)
  }

  const onKey = (event: KeyboardEvent<HTMLButtonElement>) => {
    const step = ARROWS[event.key]
    if (!step) return
    event.preventDefault()
    const origin = currentPoint()
    save(moveTo({ x: origin.x + step[0], y: origin.y + step[1] }))
  }

  const placement = position
    ? ''
    : 'bottom-[calc(8.75rem+env(safe-area-inset-bottom))] left-2 md:bottom-7 md:left-[108px] lg:left-[266px]'

  return (
    <PomodoroCompact
      onExpand={onExpand}
      onFloat={onFloat}
      className={`sketch fixed z-30 flex touch-none items-center gap-1 py-1 pr-1 pl-1 select-none ${placement} ${dragging ? 'cursor-grabbing' : 'cursor-grab'}`}
      sectionProps={{
        ref: sectionRef,
        style: position ? { left: position.x, top: position.y } : undefined,
        onPointerDown: begin,
        onPointerMove: move,
        onPointerUp: end,
        onPointerCancel: end,
      }}
      handle={
        <button
          type="button"
          data-drag-handle
          aria-label={t('pomodoro.move')}
          title={t('pomodoro.move')}
          onKeyDown={onKey}
          className="grid h-11 w-6 shrink-0 cursor-grab place-items-center rounded-lg text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
        >
          <GripVertical size={16} aria-hidden />
        </button>
      }
    />
  )
}

// Dùng chung cho thanh nhỏ trong trang và cửa sổ nổi, nên hai nơi luôn cùng nút và cùng số.
export function PomodoroCompact({ className, onExpand, onFloat, handle, sectionProps }: CompactProps) {
  const { t } = useTranslation()
  const timer = usePomodoro()
  const running = timer.endsAt !== null
  const paused = timer.pausedMs !== null
  const [now, setNow] = usePomodoroNow(running)

  const status = running
    ? t(`pomodoro.running.${timer.mode}`)
    : paused
      ? t('pomodoro.paused')
      : t(`pomodoro.ready.${timer.mode}`)
  const toggleLabel = running ? t('pomodoro.pause') : paused ? t('pomodoro.resume') : t('pomodoro.start')

  return (
    <section {...sectionProps} aria-label={t('pomodoro.title')} className={className}>
      {handle}
      <TomatoIcon size={24} />
      <div className="mx-1 min-w-16">
        <p role="timer" className="font-display text-lg leading-none font-extrabold tabular-nums">
          {formatClock(remainingMs(timer, now))}
        </p>
        <p className="mt-0.5 max-w-24 truncate text-[11px] font-bold text-ink-muted">{status}</p>
      </div>
      <button
        type="button"
        aria-label={toggleLabel}
        title={toggleLabel}
        onClick={() => {
          setNow(Date.now())
          if (running) timer.pause()
          else timer.start()
        }}
        className={`${MINI_BUTTON} text-primary`}
      >
        {running ? <Pause size={18} aria-hidden="true" /> : <Play size={18} aria-hidden="true" />}
      </button>
      <button
        type="button"
        aria-label={t('pomodoro.reset')}
        title={t('pomodoro.reset')}
        onClick={timer.reset}
        className={MINI_BUTTON}
      >
        <RotateCcw size={16} aria-hidden="true" />
      </button>
      {onFloat && (
        <button
          type="button"
          aria-label={t('pomodoro.float')}
          title={t('pomodoro.float')}
          onClick={onFloat}
          className={MINI_BUTTON}
        >
          <PictureInPicture2 size={16} aria-hidden="true" />
        </button>
      )}
      <button
        type="button"
        aria-label={t('pomodoro.expand')}
        title={t('pomodoro.expand')}
        onClick={onExpand}
        className={MINI_BUTTON}
      >
        <Maximize2 size={16} aria-hidden="true" />
      </button>
    </section>
  )
}
