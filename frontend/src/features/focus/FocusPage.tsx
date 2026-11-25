import { CalendarDays, Flame, LoaderCircle, Lock, RotateCcw, Timer } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { FocusUnlockDto, PlantKind, PotColor } from '../../api/types'
import { StatStrip } from '../../components/StatStrip'
import { toLocalDateKey } from '../../lib/dates'
import { formatFocusMinutes } from './focusFormat'
import { phaseOf } from './focusSession'
import { useFocusBoard } from './hooks'
import { PlantStage } from './PlantStage'
import { SessionPicker } from './SessionPicker'
import { Shelf } from './Shelf'
import { useFocus } from './store'

// Màn hình Tập trung (route "/focus", SPEC §11A). Một query GET /dashboard/focus cấp dải số, kệ và
// mở khoá; lượt đang trồng nằm ở store useFocus (localStorage) để tải lại trang không mất phiên.
export function FocusPage() {
  const { t } = useTranslation()
  const [today] = useState(() => toLocalDateKey(new Date()))
  const board = useFocusBoard(today)
  const run = useFocus((s) => s.run)
  const queued = useFocus((s) => s.queue.length)
  const phase = phaseOf(run)

  if (board.isPending) {
    return (
      <div
        role="status"
        aria-live="polite"
        className="mx-auto flex min-h-64 w-full max-w-[1320px] items-center justify-center gap-3 text-primary-ink"
      >
        <LoaderCircle className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
      </div>
    )
  }

  if (board.isError) {
    return (
      <div
        role="alert"
        className="sketch mx-auto flex min-h-44 w-full max-w-2xl flex-col items-center justify-center gap-3 p-6 text-center"
      >
        <p className="font-bold">{t('focus.loadError')}</p>
        <button
          type="button"
          onClick={() => board.refetch()}
          className="flex min-h-11 cursor-pointer items-center gap-2 rounded-xl bg-primary px-4 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          <RotateCcw size={17} aria-hidden="true" />
          {t('common.retry')}
        </button>
      </div>
    )
  }

  const data = board.data

  return (
    <div className="mx-auto flex w-full max-w-[1320px] flex-col gap-3 lg:gap-4">
      <header className="flex flex-col gap-3 lg:flex-row lg:items-end lg:justify-between">
        <div className="flex flex-col gap-1">
          <h1 className="font-display text-2xl leading-none font-extrabold text-primary-ink lg:text-3xl">
            {t('focus.title')}
          </h1>
          <p className="text-sm text-ink-muted">{t('focus.subtitle')}</p>
        </div>
        <div className="w-full lg:max-w-md">
          <StatStrip
            items={[
              { label: t('focus.strip.today'), icon: <Timer size={12} />, value: formatFocusMinutes(t, data.minutesToday) },
              {
                label: t('focus.strip.week'),
                icon: <CalendarDays size={12} />,
                value: formatFocusMinutes(t, data.minutesThisWeek),
              },
              {
                label: t('focus.strip.streak'),
                icon: <Flame size={12} />,
                value: t('focus.strip.streakDays', { count: data.streak }),
              },
            ]}
          />
        </div>
      </header>

      {queued > 0 && (
        <p role="status" className="rounded-lg bg-accent-soft px-3 py-2 text-sm font-bold text-primary-ink">
          {t('focus.queued', { count: queued })}
        </p>
      )}

      <div className="grid gap-3 lg:grid-cols-[minmax(0,1.15fr)_minmax(0,1fr)] lg:gap-4">
        {phase === 'pick' || !run ? (
          <SessionPicker today={today} unlocks={data.unlocks} />
        ) : (
          <PlantStage run={run} />
        )}
        <div className="flex flex-col gap-3 lg:gap-4">
          <Shelf shelves={data.shelves} potCount={data.potCount} />
          <Unlocks unlocks={data.unlocks} />
        </div>
      </div>
    </div>
  )
}

// Món khoá gần mở nhất (ít giờ còn lại nhất), hoặc câu "đã mở hết".
function Unlocks({ unlocks }: { unlocks: FocusUnlockDto[] }) {
  const { t } = useTranslation()
  const next = unlocks.filter((u) => !u.unlocked).sort((a, b) => a.hoursRemaining - b.hoursRemaining)[0]
  // key là chuỗi từ API; ép về kiểu enum để t() kiểm được khoá (BE chỉ trả giá trị enum hợp lệ).
  const name = !next
    ? ''
    : next.kind === 'plant'
      ? t(`focus.plants.${next.key as PlantKind}`)
      : t(`focus.pots.${next.key as PotColor}`)
  return (
    <section aria-labelledby="focus-unlocks-title" className="sketch flex items-start gap-3 p-3.5 lg:p-5">
      <Lock size={18} className="mt-0.5 shrink-0 text-primary" aria-hidden />
      <div className="flex flex-col gap-1">
        <h2 id="focus-unlocks-title" className="font-display text-lg font-extrabold">
          {t('focus.unlocks.title')}
        </h2>
        <p className="text-sm text-ink-muted">
          {next ? t('focus.unlocks.next', { hours: Math.ceil(next.hoursRemaining), name }) : t('focus.unlocks.all')}
        </p>
      </div>
    </section>
  )
}
