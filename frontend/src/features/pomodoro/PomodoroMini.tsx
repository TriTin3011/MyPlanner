import { Maximize2, Pause, PictureInPicture2, Play, RotateCcw } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { formatClock, remainingMs } from './pomodoro'
import { usePomodoro, usePomodoroNow } from './store'
import { TomatoIcon } from './TomatoIcon'

const MINI_BUTTON =
  'grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none'

interface CompactProps {
  className: string
  onExpand: () => void
  onFloat?: () => void
}

// Thanh đếm nhỏ khi modal đóng. Không dùng <dialog> nên người dùng vẫn thao tác được với trang phía sau.
// Đặt bên trái vì hộp nhạc mặc định nằm góc phải dưới; điện thoại nằm trên thanh điều hướng đáy và hộp nhạc.
export function PomodoroMini({ onExpand, onFloat }: Omit<CompactProps, 'className'>) {
  const started = usePomodoro((s) => s.endsAt !== null || s.pausedMs !== null)
  if (!started) return null
  return (
    <PomodoroCompact
      onExpand={onExpand}
      onFloat={onFloat}
      className="sketch fixed bottom-[calc(8.75rem+env(safe-area-inset-bottom))] left-2 z-30 flex items-center gap-1 py-1 pr-1 pl-2.5 md:bottom-7 md:left-[108px] lg:left-[266px]"
    />
  )
}

// Dùng chung cho thanh nhỏ trong trang và cửa sổ nổi, nên hai nơi luôn cùng nút và cùng số.
export function PomodoroCompact({ className, onExpand, onFloat }: CompactProps) {
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
    <section aria-label={t('pomodoro.title')} className={className}>
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
