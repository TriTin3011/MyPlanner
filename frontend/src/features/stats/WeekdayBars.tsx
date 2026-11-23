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
        <ul className="flex flex-col gap-2">
          {items.map((i) => {
            const isTop = max > 0 && i.averageDone === max
            return (
              <li key={i.weekday} className="grid h-7 grid-cols-[5rem_minmax(0,1fr)] items-center gap-2 text-sm">
                <span className={`truncate font-bold ${isTop ? 'text-ink' : 'text-ink-muted'}`}>{weekdayLabel(i.weekday)}</span>
                <span className="flex min-w-0 items-center gap-2">
                  {/* Chừa 3rem cho con số để thanh dài nhất vẫn không đẩy số ra ngoài thẻ. */}
                  <span
                    className="block h-4 rounded-r-[4px]"
                    style={{
                      width: `calc((100% - 3rem) * ${max > 0 ? i.averageDone / max : 0})`,
                      background: isTop ? 'var(--primary)' : 'var(--muted-bar)',
                    }}
                  />
                  <span className={`font-bold tabular-nums ${isTop ? 'text-primary-ink' : 'text-ink-muted'}`}>
                    {formatDecimal(i.averageDone)}
                  </span>
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