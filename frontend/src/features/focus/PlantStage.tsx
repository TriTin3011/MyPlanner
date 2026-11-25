import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { formatFocusMinutes } from './focusFormat'
import {
  actualMinutes,
  formatCountdown,
  isWatering,
  OPENING_STEPS,
  openingStepIndex,
  phaseOf,
  progress,
  remainingMs,
  SCENE_DAYS,
  sceneDay,
  shouldRecordAbandon,
  type FocusRun,
} from './focusSession'
import { flushFocusQueue } from './hooks'
import { endScene, growingScene, openingScene } from './sceneSvg'
import { FocusScene } from './FocusScene'
import { useFocus } from './store'

const BTN =
  'flex min-h-11 cursor-pointer items-center justify-center rounded-xl border-2 px-4 text-sm font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none'
const BTN_PRIMARY = `${BTN} border-ink bg-primary text-white shadow-[3px_3px_0_var(--ink)] active:translate-x-0.5 active:translate-y-0.5 active:shadow-none`
const BTN_GHOST = `${BTN} border-line bg-surface hover:border-ink`

// Đồng hồ cục bộ của component: chỉ dùng để vẽ lại, mốc thật nằm trong store (endsAt).
function useNow(intervalMs: number) {
  const [now, setNow] = useState(() => Date.now())
  useEffect(() => {
    const id = setInterval(() => setNow(Date.now()), intervalMs)
    return () => clearInterval(id)
  }, [intervalMs])
  return now
}

// Sân khấu của một lượt trồng: mở đầu → đang lớn → xong/héo (SPEC §11A.3–11A.5).
// Việc chuyển pha (hết mở đầu, hết giờ) do useFocusTicker ở AppShell làm, component này chỉ vẽ.
export function PlantStage({ run }: { run: FocusRun }) {
  const { t } = useTranslation()
  const phase = phaseOf(run)
  const look = { plantKind: run.plantKind, potColor: run.potColor }
  const label = t('focus.scene.aria', {
    plant: t(`focus.plants.${run.plantKind}`),
    pot: t(`focus.pots.${run.potColor}`),
  })

  return (
    <section className="sketch flex flex-col gap-3 overflow-hidden p-3.5 lg:p-5">
      {phase === 'opening' && <Opening run={run} look={look} label={label} />}
      {phase === 'growing' && <Growing run={run} look={look} label={label} />}
      {(phase === 'done' || phase === 'wilted') && <Ending run={run} look={look} label={label} />}
    </section>
  )
}

interface PartProps {
  run: FocusRun
  look: { plantKind: FocusRun['plantKind']; potColor: FocusRun['potColor'] }
  label: string
}

function Opening({ run, look, label }: PartProps) {
  const { t } = useTranslation()
  const now = useNow(250)
  const startGrowing = useFocus((s) => s.startGrowing)
  const giveUp = useFocus((s) => s.giveUp)
  const index = Math.min(OPENING_STEPS.length - 1, openingStepIndex(now, run.openingStartedAt, run.stepMs))
  const step = OPENING_STEPS[index]

  return (
    <>
      {/* key theo bước: mỗi bước gắn SVG mới để hoạt ảnh CSS chạy lại từ đầu. */}
      <div key={step} className="overflow-hidden rounded-xl border-2 border-ink">
        <FocusScene markup={openingScene(step, look)} label={label} />
      </div>
      <div className="flex flex-wrap items-center justify-between gap-3">
        <p className="flex flex-col" aria-live="polite">
          <span className="text-xs font-bold text-ink-muted">
            {t('focus.opening.stepOf', { n: index + 1, total: OPENING_STEPS.length })}
          </span>
          <span className="font-display text-lg font-extrabold">{t(`focus.opening.${step}`)}</span>
        </p>
        <div className="flex gap-2">
          <button type="button" className={BTN_GHOST} onClick={() => giveUp(Date.now())}>
            {t('common.cancel')}
          </button>
          <button type="button" className={BTN_PRIMARY} onClick={() => startGrowing(Date.now())}>
            {t('focus.opening.skip')}
          </button>
        </div>
      </div>
    </>
  )
}

function Growing({ run, look, label }: PartProps) {
  const { t } = useTranslation()
  const now = useNow(1000)
  const giveUp = useFocus((s) => s.giveUp)
  const [confirming, setConfirming] = useState(false)
  const startedAt = run.startedAt ?? now
  const endsAt = run.endsAt ?? now
  const p = progress(now, startedAt, endsAt)
  const watering = isWatering(now, startedAt, endsAt)

  const onGiveUp = () => {
    giveUp(Date.now())
    void flushFocusQueue()
  }

  return (
    <>
      <div className="overflow-hidden rounded-xl border-2 border-ink">
        <FocusScene markup={growingScene(p, SCENE_DAYS, watering, look)} label={label} />
      </div>
      <div className="flex flex-wrap items-end justify-between gap-3">
        <div className="flex flex-col gap-1">
          <span
            role="timer"
            aria-label={t('focus.growing.remainingAria')}
            className="font-display text-4xl leading-none font-extrabold tabular-nums text-primary-ink"
          >
            {formatCountdown(remainingMs(now, endsAt))}
          </span>
          <span className="text-sm font-bold text-ink-muted">{t('focus.growing.day', { day: sceneDay(p) })}</span>
          {run.link && (
            <span className="text-sm text-ink-muted">{t('focus.growing.linked', { title: run.link.title })}</span>
          )}
        </div>
        {confirming ? (
          <div role="alertdialog" aria-label={t('focus.growing.confirm')} className="flex flex-col gap-2">
            <p className="text-sm font-bold">{t('focus.growing.confirm')}</p>
            <div className="flex gap-2">
              <button type="button" className={BTN_GHOST} onClick={() => setConfirming(false)} autoFocus>
                {t('focus.growing.confirmNo')}
              </button>
              <button type="button" className={`${BTN} border-ink bg-danger-bg text-danger`} onClick={onGiveUp}>
                {t('focus.growing.confirmYes')}
              </button>
            </div>
          </div>
        ) : (
          <button type="button" className={BTN_GHOST} onClick={() => setConfirming(true)}>
            {t('focus.growing.giveUp')}
          </button>
        )}
      </div>
    </>
  )
}

function Ending({ run, look, label }: PartProps) {
  const { t } = useTranslation()
  const dismiss = useFocus((s) => s.dismiss)
  const done = run.outcome === 'completed'
  const startedAt = run.startedAt ?? 0
  const endedAt = run.endedAt ?? startedAt
  const grow = run.endsAt ? progress(endedAt, startedAt, run.endsAt) : 0
  const recorded = shouldRecordAbandon(startedAt, endedAt)

  return (
    <>
      <div className="overflow-hidden rounded-xl border-2 border-ink">
        <FocusScene markup={endScene(done ? 'done' : 'wilted', grow, look)} label={label} />
      </div>
      <div className="flex flex-wrap items-center justify-between gap-3" role="status">
        <div className="flex flex-col gap-1">
          <h2 className="font-display text-xl font-extrabold">{t(done ? 'focus.done.title' : 'focus.wilted.title')}</h2>
          {done ? (
            <p className="text-sm text-ink-muted">{formatFocusMinutes(t, run.plannedMinutes)}</p>
          ) : (
            <p className="text-sm text-ink-muted">
              {recorded
                ? t('focus.wilted.body', {
                    minutes: formatFocusMinutes(t, actualMinutes(startedAt, endedAt, run.plannedMinutes)),
                  })
                : t('focus.wilted.short')}
            </p>
          )}
        </div>
        <button type="button" className={BTN_PRIMARY} onClick={dismiss} autoFocus>
          {t(done ? 'focus.done.again' : 'focus.wilted.again')}
        </button>
      </div>
    </>
  )
}
