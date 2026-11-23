import { SlidersHorizontal } from 'lucide-react'
import { useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import type { TodayDashboardDto } from '../../api/types'
import { ProgressRing } from '../../components/ProgressRing'
import { INTL_LOCALE } from '../../i18n/languages'
import { parseDateKey } from '../../lib/dates'
import { useSettings } from '../../store/settings'

const MOTIVATION_KEYS = [
  'today.motivations.m0',
  'today.motivations.m1',
  'today.motivations.m2',
  'today.motivations.m3',
] as const

function formatHeaderDate(value: string, locale: string) {
  const dateObj = parseDateKey(value)
  const raw = new Intl.DateTimeFormat(locale, {
    weekday: 'long',
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
  }).format(dateObj)
  if (!locale.toLowerCase().startsWith('vi')) return raw
  const [weekday, rest] = raw.split(', ')
  if (!weekday || !rest) return raw
  const normalizedWeekday = weekday.charAt(0).toUpperCase() + weekday.slice(1).toLowerCase()
  return `${normalizedWeekday}, ${rest}`
}

function dailyMotivationKey(date: string) {
  const seed = [...date].reduce((sum, char) => sum + char.charCodeAt(0), 0)
  return MOTIVATION_KEYS[seed % MOTIVATION_KEYS.length]
}

export function TodayHeader({
  dashboard,
  onArrangeBlocks,
}: {
  dashboard: TodayDashboardDto
  onArrangeBlocks?: () => void
}) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const numFmt = useMemo(() => new Intl.NumberFormat(locale), [locale])

  return (
    <header className="mb-4 lg:mb-5 grid gap-4 lg:grid-cols-[minmax(180px,1fr)_auto_minmax(260px,1.4fr)_auto] lg:items-center">
      <div>
        <h1 className="font-display text-2xl leading-none font-extrabold text-primary-ink lg:text-3xl">
          {t('today.title')}
        </h1>
        <p className="mt-1 text-sm font-medium text-ink-muted">
          {formatHeaderDate(dashboard.date, locale)}
        </p>
      </div>

      <div className="flex items-center gap-3">
        <ProgressRing value={dashboard.percent} label={t('today.progressLabel')} />
        <div className="space-y-1 font-display text-lg leading-tight font-extrabold">
          <p>
            {numFmt.format(dashboard.tasksDone)}/{numFmt.format(dashboard.tasksTotal)}{' '}
            <span className="text-ink-muted">{t('today.tasksSummary', { count: dashboard.tasksTotal })}</span>
          </p>
          <p>
            {numFmt.format(dashboard.habitsDone)}/{numFmt.format(dashboard.habitsTotal)}{' '}
            <span className="text-ink-muted">{t('today.habitsSummary', { count: dashboard.habitsTotal })}</span>
          </p>
        </div>
      </div>

      <p className="min-w-0 border-l-4 border-primary pl-3 text-sm leading-6 font-bold text-primary-ink lg:max-w-xl">
        {t(dailyMotivationKey(dashboard.date))}
      </p>

      <button
        type="button"
        onClick={onArrangeBlocks}
        disabled={!onArrangeBlocks}
        aria-haspopup="dialog"
        className="flex min-h-11 cursor-pointer items-center justify-center gap-2 rounded-xl px-3 text-sm font-bold text-primary-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-60"
      >
        <SlidersHorizontal size={17} aria-hidden="true" />
        {t('today.arrangeBlocks')}
      </button>
    </header>
  )
}
