import { CheckCircle2, Flame, Repeat, TrendingDown, TrendingUp } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import type { StatsDto } from '../../api/types'
import { StatStrip } from '../../components/StatStrip'
import { weekdayLabel } from './statsFormat'

// Dấu ▲/▼ của mức thay đổi. Số do BE tính (so với kỳ trước cùng độ dài).
function Delta({ value, unit }: { value: number | null | undefined; unit: string }) {
  if (value === null || value === undefined) return <span className="text-ink-muted">–</span>
  const up = value >= 0
  const Icon = up ? TrendingUp : TrendingDown
  return (
    <span className={`inline-flex items-center gap-0.5 font-bold ${up ? 'text-primary' : 'text-danger'}`}>
      <Icon size={14} aria-hidden="true" />
      {up ? '+' : ''}
      {value}
      {unit}
    </span>
  )
}

// Sparkline nhỏ: % hoàn thành từng tuần trong khoảng đang xem.
function Sparkline({ values }: { values: number[] }) {
  if (values.length < 2) return null
  const w = 160
  const h = 44
  const pts = values.map((v, i) => `${((i / (values.length - 1)) * w).toFixed(1)},${(h - 4 - (v / 100) * (h - 8)).toFixed(1)}`)
  return (
    <svg viewBox={`0 0 ${w} ${h}`} className="h-11 w-40" aria-hidden="true">
      <polyline points={`0,${h} ${pts.join(' ')} ${w},${h}`} fill="var(--accent-tint)" stroke="none" />
      <polyline points={pts.join(' ')} fill="none" stroke="var(--primary)" strokeWidth="2.5" strokeLinejoin="round" strokeLinecap="round" />
    </svg>
  )
}

export function StatsHero({ data }: { data: StatsDto }) {
  const { t } = useTranslation()
  const { hero, kpis } = data
  const pointsUnit = t('stats.hero.pointsUnit')
  return (
    <div className="grid gap-4 lg:grid-cols-[1.1fr_1fr]">
      <section aria-label={t('stats.hero.title')} className="sketch flex flex-wrap items-center justify-between gap-4 bg-primary p-4 text-white lg:p-5">
        <div>
          <p className="text-xs font-extrabold tracking-wide uppercase opacity-90">{t('stats.hero.title')}</p>
          <p className="mt-1 flex items-baseline gap-3 font-display text-5xl font-extrabold">
            {hero.completionPercent}%
            <span className="rounded-full bg-white px-2 py-0.5 text-sm">
              <Delta value={hero.deltaPoints} unit={pointsUnit} />
            </span>
          </p>
          <p className="mt-1 text-sm font-semibold opacity-95">
            {t('stats.hero.tasksSummary', { done: hero.tasksDone, total: hero.tasksTotal, count: hero.tasksTotal })}
            {hero.bestWeekday ? t('stats.hero.bestWeekday', { day: weekdayLabel(hero.bestWeekday) }) : ''}
          </p>
        </div>
        <div className="rounded-xl bg-white/95 p-1.5">
          <Sparkline values={hero.weeklySparkline.map((p) => p.percent)} />
        </div>
      </section>

      <StatStrip
        items={[
          {
            label: t('stats.hero.kpiTasksDone'),
            icon: <CheckCircle2 size={13} aria-hidden="true" />,
            value: kpis.tasksDone,
            suffix: <Delta value={kpis.tasksDonePercentChange} unit="%" />,
          },
          {
            label: t('stats.hero.kpiActivityStreak'),
            icon: <Flame size={13} aria-hidden="true" />,
            value: t('stats.hero.streakDays', { count: kpis.activityCurrentStreak }),
            suffix: t('stats.hero.longestStreak', { count: kpis.activityLongestStreak }),
          },
          {
            label: t('stats.hero.kpiHabits'),
            icon: <Repeat size={13} aria-hidden="true" />,
            value: `${kpis.habitPercent}%`,
            suffix: <Delta value={kpis.habitDeltaPoints} unit={pointsUnit} />,
          },
        ]}
      />
    </div>
  )
}