import { Calendar, LoaderCircle, RotateCcw } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { ChartCard } from '../../components/ChartCard'
import { Select } from '../../components/Select'
import { toLocalDateKey } from '../../lib/dates'
import { type StatsRange, useSettings } from '../../store/settings'
import { GoalsStats } from './GoalsStats'
import { HabitConsistency } from './HabitConsistency'
import { useStats } from './hooks'
import { StatsHeatmap } from './StatsHeatmap'
import { StatsHero } from './StatsHero'
import { formatDm, STATS_RANGES, toChartPoints } from './statsFormat'
import { WeekdayBars } from './WeekdayBars'

// Màn hình Thống kê (route "/stats", SPEC §11). Một query GET /stats cấp số cho mọi thẻ;
// khoảng thời gian chọn ở header, nhớ trong settings.statsRange. FE không tự tính số nào.
export function StatsPage() {
  const { t } = useTranslation()
  const [today] = useState(() => toLocalDateKey(new Date()))
  const range = useSettings((s) => s.statsRange)
  const setRange = useSettings((s) => s.setStatsRange)
  const trendMode = useSettings((s) => s.chartModes['stats-trend'] ?? 'line')
  const setChartMode = useSettings((s) => s.setChartMode)
  const stats = useStats(range, today)

  const header = (
    <header className="mb-4 flex flex-wrap items-end justify-between gap-3">
      <div>
        <h1 className="font-display text-2xl leading-none font-extrabold text-primary-ink lg:text-3xl">{t('stats.title')}</h1>
        {stats.data && (
          <p className="text-sm font-semibold text-ink-muted">
            {t('stats.subtitle', {
              from: formatDm(stats.data.from),
              to: formatDm(stats.data.to),
              prevFrom: formatDm(stats.data.previousFrom),
              prevTo: formatDm(stats.data.previousTo),
            })}
          </p>
        )}
      </div>
      <Select<StatsRange>
        ariaLabel={t('stats.rangeAria')}
        value={range}
        options={STATS_RANGES}
        onChange={setRange}
        icon={<Calendar size={15} className="shrink-0 text-primary" aria-hidden="true" />}
        className="min-h-11 min-w-36 rounded-lg border-2 border-ink bg-surface px-3 text-sm shadow-[2px_2px_0_0_var(--ink)] hover:bg-accent-tint"
      />
    </header>
  )

  if (stats.isPending) {
    return (
      <div className="mx-auto w-full max-w-[1320px]">
        {header}
        <div role="status" aria-live="polite" className="flex min-h-64 items-center justify-center gap-3 text-primary-ink">
          <LoaderCircle className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
          <span className="font-bold">{t('stats.loading')}</span>
        </div>
      </div>
    )
  }

  if (stats.isError) {
    return (
      <div className="mx-auto w-full max-w-[1320px]">
        {header}
        <div role="alert" className="sketch mx-auto flex min-h-44 max-w-2xl flex-col items-center justify-center gap-3 p-6 text-center">
          <p className="font-bold">
            {t('stats.loadErrorPrefix')} {stats.error.message}
          </p>
          <button
            type="button"
            onClick={() => stats.refetch()}
            className="flex min-h-11 cursor-pointer items-center gap-2 rounded-xl bg-primary px-4 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
          >
            <RotateCcw size={17} aria-hidden="true" />
            {t('common.retry')}
          </button>
        </div>
      </div>
    )
  }

  const data = stats.data
  return (
    <div
      className={`mx-auto w-full max-w-[1320px] transition-opacity ${stats.isPlaceholderData ? 'opacity-60' : ''}`}
      aria-busy={stats.isPlaceholderData}
    >
      {header}
      <div className="space-y-4">
        <StatsHero data={data} />

        <ChartCard
          title={t('stats.trend.title')}
          infoTooltip={t('stats.trend.infoTooltip')}
          badge={
            <span className="rounded-full bg-accent-tint px-2 py-0.5 text-xs font-bold text-primary-ink">
              {t('stats.trend.avgBadge', { percent: data.trend.averagePercent })}
            </span>
          }
          data={toChartPoints(data.trend.points)}
          mode={trendMode}
          onModeChange={(m) => setChartMode('stats-trend', m)}
        />

        <div className="grid gap-4 lg:grid-cols-[1.4fr_1fr]">
          <StatsHeatmap days={data.heatmap} today={today} />
          <WeekdayBars items={data.weekdayProductivity} />
        </div>

        <div className="grid gap-4 lg:grid-cols-2">
          <HabitConsistency items={data.habitConsistency} />
          <GoalsStats goals={data.goals} />
        </div>
      </div>
    </div>
  )
}