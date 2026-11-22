import { useTranslation } from 'react-i18next'
import type { StatsHabitDto } from '../../api/types'
import { Bar, SimpleTable, StatsCard } from './StatsCard'

// "Độ đều đặn thói quen": % ngày đã tick trên số ngày có thể tick trong khoảng đang xem.
export function HabitConsistency({ items }: { items: StatsHabitDto[] }) {
  const { t } = useTranslation()
  return (
    <StatsCard
      id="stats-habits"
      title={t('stats.habits.title')}
      chart={
        items.length === 0 ? (
          <p className="text-sm text-ink-muted">{t('stats.habits.empty')}</p>
        ) : (
          <ul className="space-y-3">
            {items.map((h) => (
              <li key={h.habitId}>
                <div className="mb-1 flex items-baseline justify-between gap-2 text-sm">
                  <span className="truncate font-bold text-ink">{h.title}</span>
                  <span className="font-extrabold text-primary-ink tabular-nums">{h.percent}%</span>
                </div>
                <Bar percent={h.percent} label={h.title} />
                <p className="mt-1 text-xs text-ink-muted">
                  {t('stats.habits.itemMeta', {
                    done: h.doneDays,
                    possible: h.possibleDays,
                    current: h.currentStreak,
                    longest: h.longestStreak,
                  })}
                </p>
              </li>
            ))}
          </ul>
        )
      }
      table={
        <SimpleTable
          head={[
            t('stats.habits.colHabit'),
            '%',
            t('stats.habits.colDays'),
            t('stats.habits.colStreak'),
            t('stats.habits.colLongest'),
          ]}
          rows={items.map((h) => [h.title, `${h.percent}%`, `${h.doneDays}/${h.possibleDays}`, h.currentStreak, h.longestStreak])}
        />
      }
    />
  )
}