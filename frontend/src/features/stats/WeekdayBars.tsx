import { useTranslation } from 'react-i18next'
import type { StatsWeekdayDto } from '../../api/types'
import { formatDecimal, weekdayLabel } from './statsFormat'
import { SimpleTable, StatsCard } from './StatsCard'

// "Năng suất theo thứ": số việc xong trung bình mỗi thứ. Thanh cao nhất tô màu chính, còn lại màu nhạt.
export function WeekdayBars({ items }: { items: StatsWeekdayDto[] }) {
  const { t } = useTranslation()
  const max = Math.max(0, ...items.map((i) => i.averageDone))
  return (
    <StatsCard
      id="stats-weekday"
      title={t('stats.weekday.title')}
      chart={
        <ul className="space-y-2">
          {items.map((i) => {
            const isTop = max > 0 && i.averageDone === max
            return (
              <li key={i.weekday} className="grid grid-cols-[2.25rem_1fr_2.5rem] items-center gap-2 text-sm">
                <span className="font-bold text-ink">{weekdayLabel(i.weekday, true)}</span>
                <span className="h-4 overflow-hidden rounded-full bg-[var(--accent-tint)]/50">
                  <span
                    className="block h-full rounded-full"
                    style={{
                      width: `${max > 0 ? (i.averageDone / max) * 100 : 0}%`,
                      background: isTop ? 'var(--primary)' : 'var(--muted-bar)',
                    }}
                  />
                </span>
                <span className={`text-right font-bold tabular-nums ${isTop ? 'text-primary-ink' : 'text-ink-muted'}`}>
                  {formatDecimal(i.averageDone)}
                </span>
              </li>
            )
          })}
        </ul>
      }
      table={
        <SimpleTable
          head={[t('stats.weekday.colDay'), t('stats.weekday.colAvgDone')]}
          rows={items.map((i) => [weekdayLabel(i.weekday), formatDecimal(i.averageDone)])}
        />
      }
    />
  )
}