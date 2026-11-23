import { Info, Minimize2, Minus, Pause, Play, Plus, RotateCcw, SkipForward, Volume2, VolumeX } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Modal } from '../../components/Modal'
import { toLocalDateKey } from '../../lib/dates'
import {
  durationMs,
  formatClock,
  MINUTE_LIMITS,
  minutesOf,
  type PomodoroMode,
  remainingMs,
  sessionsToday,
} from './pomodoro'
import { usePomodoro, usePomodoroNow } from './store'

const MODES: PomodoroMode[] = ['focus', 'break']
const RADIUS = 92
const CIRCUMFERENCE = 2 * Math.PI * RADIUS
const ICON_BUTTON =
  'grid size-12 shrink-0 cursor-pointer place-items-center rounded-xl border-2 border-ink bg-surface hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none'

export function PomodoroModal({ open, onClose }: { open: boolean; onClose: () => void }) {
  const { t } = useTranslation()
  const [showInfo, setShowInfo] = useState(false)
  const started = usePomodoro((s) => s.endsAt !== null || s.pausedMs !== null)
  return (
    <Modal
      open={open}
      size="sm"
      title={t('pomodoro.title')}
      onClose={onClose}
      titleAddon={
        <>
          <button
            type="button"
            aria-label={t('pomodoro.about')}
            aria-expanded={showInfo}
            onClick={() => setShowInfo((value) => !value)}
            className="grid size-8 shrink-0 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
          >
            <Info size={17} aria-hidden="true" />
          </button>
          {started && (
            <button
              type="button"
              aria-label={t('pomodoro.minimize')}
              title={t('pomodoro.minimize')}
              onClick={onClose}
              className="grid size-8 shrink-0 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
            >
              <Minimize2 size={17} aria-hidden="true" />
            </button>
          )}
        </>
      }
    >
      {showInfo && <p className="mb-3 rounded-xl bg-accent-tint p-3 text-sm text-ink">{t('pomodoro.info')}</p>}
      <PomodoroPanel />
    </Modal>
  )
}

function PomodoroPanel() {
  const { t } = useTranslation()
  const timer = usePomodoro()
  const running = timer.endsAt !== null
  const [now, setNow] = usePomodoroNow(running)

  const remaining = remainingMs(timer, now)
  const progress = remaining / durationMs(timer)
  const started = running || timer.pausedMs !== null
  const status = running
    ? t(`pomodoro.running.${timer.mode}`)
    : timer.pausedMs !== null
      ? t('pomodoro.paused')
      : t(`pomodoro.ready.${timer.mode}`)

  return (
    <div className="flex flex-col gap-4">
      <div role="group" aria-label={t('pomodoro.modeLabel')} className="grid grid-cols-2 gap-1 rounded-xl bg-accent-tint p-1">
        {MODES.map((mode) => (
          <button
            key={mode}
            type="button"
            aria-pressed={timer.mode === mode}
            disabled={running && timer.mode !== mode}
            onClick={() => timer.selectMode(mode)}
            className={`min-h-11 min-w-0 cursor-pointer rounded-lg px-2 text-sm font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:cursor-not-allowed ${
              timer.mode === mode ? 'bg-primary text-white' : 'text-ink-muted hover:text-ink'
            }`}
          >
            {t(`pomodoro.tab.${mode}`, { count: minutesOf(timer, mode) })}
          </button>
        ))}
      </div>

      <div className="relative mx-auto aspect-square w-full max-w-52">
        <svg viewBox="0 0 200 200" className="size-full -rotate-90" aria-hidden="true">
          <circle cx="100" cy="100" r={RADIUS} fill="none" stroke="var(--accent-tint)" strokeWidth="10" />
          <circle
            cx="100"
            cy="100"
            r={RADIUS}
            fill="none"
            stroke="var(--primary)"
            strokeWidth="10"
            strokeLinecap="round"
            strokeDasharray={CIRCUMFERENCE}
            strokeDashoffset={CIRCUMFERENCE * (1 - progress)}
            className="transition-[stroke-dashoffset] duration-200 motion-reduce:transition-none"
          />
        </svg>
        <div className="absolute inset-0 flex flex-col items-center justify-center px-6 text-center">
          <span role="timer" className="font-display text-5xl leading-none font-extrabold tabular-nums">
            {formatClock(remaining)}
          </span>
          <span className="mt-2 text-sm font-bold text-ink-muted">{status}</span>
        </div>
      </div>

      <div className="flex items-center justify-center gap-2">
        <button
          type="button"
          aria-label={t('pomodoro.reset')}
          title={t('pomodoro.reset')}
          disabled={!started}
          onClick={timer.reset}
          className={`${ICON_BUTTON} disabled:cursor-not-allowed disabled:opacity-40`}
        >
          <RotateCcw size={18} aria-hidden="true" />
        </button>
        <button
          type="button"
          onClick={() => {
            setNow(Date.now())
            if (running) timer.pause()
            else timer.start()
          }}
          className="flex min-h-12 min-w-36 cursor-pointer items-center justify-center gap-2 rounded-xl border-2 border-ink bg-primary px-5 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          {running ? <Pause size={18} aria-hidden="true" /> : <Play size={18} aria-hidden="true" />}
          {running ? t('pomodoro.pause') : timer.pausedMs !== null ? t('pomodoro.resume') : t('pomodoro.start')}
        </button>
        <button
          type="button"
          aria-label={t('pomodoro.skip')}
          title={t('pomodoro.skip')}
          onClick={timer.skip}
          className={ICON_BUTTON}
        >
          <SkipForward size={18} aria-hidden="true" />
        </button>
      </div>

      <div className="divide-y-2 divide-dashed divide-[var(--grid-line)] rounded-xl border-2 border-ink px-3">
        {MODES.map((mode) => {
          const label = t(`pomodoro.label.${mode}`)
          const minutes = minutesOf(timer, mode)
          const locked = running && timer.mode === mode
          const { min, max } = MINUTE_LIMITS[mode]
          return (
            <div key={mode} className="flex items-center justify-between gap-2 py-1">
              <span className="min-w-0 font-bold">{label}</span>
              <div className="flex shrink-0 items-center">
                <StepButton
                  label={t('pomodoro.decrease', { label })}
                  disabled={locked || minutes <= min}
                  onClick={() => timer.adjust(mode, -1)}
                >
                  <Minus size={16} aria-hidden="true" />
                </StepButton>
                <span className="w-16 text-center text-sm font-bold tabular-nums">
                  {t('pomodoro.minutes', { count: minutes })}
                </span>
                <StepButton
                  label={t('pomodoro.increase', { label })}
                  disabled={locked || minutes >= max}
                  onClick={() => timer.adjust(mode, 1)}
                >
                  <Plus size={16} aria-hidden="true" />
                </StepButton>
              </div>
            </div>
          )
        })}
      </div>

      <div className="flex flex-wrap items-center justify-between gap-x-3 gap-y-1 text-sm font-bold text-ink-muted">
        <span>{t('pomodoro.today', { count: sessionsToday(timer, toLocalDateKey(new Date(now))) })}</span>
        <button
          type="button"
          aria-pressed={timer.sound}
          onClick={timer.toggleSound}
          className="flex min-h-11 cursor-pointer items-center gap-1.5 rounded-lg px-2 hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
        >
          {timer.sound ? <Volume2 size={17} aria-hidden="true" /> : <VolumeX size={17} aria-hidden="true" />}
          {timer.sound ? t('pomodoro.soundOn') : t('pomodoro.soundOff')}
        </button>
      </div>
    </div>
  )
}

function StepButton({
  label,
  disabled,
  onClick,
  children,
}: {
  label: string
  disabled: boolean
  onClick: () => void
  children: React.ReactNode
}) {
  return (
    <button
      type="button"
      aria-label={label}
      disabled={disabled}
      onClick={onClick}
      className="grid size-11 cursor-pointer place-items-center rounded-lg hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-30"
    >
      {children}
    </button>
  )
}
