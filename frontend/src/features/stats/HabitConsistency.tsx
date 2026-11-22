import type { StatsHabitDto } from '../../api/types'
import { Bar, SimpleTable, StatsCard } from './StatsCard'

// "Độ đều đặn thói quen": % ngày đã tick trên số ngày có thể tick trong khoảng đang xem.
export function HabitConsistency({ items }: { items: StatsHabitDto[] }) {
  return (
    <StatsCard
      id="stats-habits"
      title="Độ đều đặn thói quen"
      chart={
        items.length === 0 ? (
          <p className="text-sm text-ink-muted">Chưa có thói quen nào.</p>
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
                  {h.doneDays}/{h.possibleDays} ngày · chuỗi hiện tại {h.currentStreak} · dài nhất {h.longestStreak}
                </p>
              </li>
            ))}
          </ul>
        )
      }
      table={
        <SimpleTable
          head={['Thói quen', '%', 'Ngày', 'Chuỗi', 'Dài nhất']}
          rows={items.map((h) => [h.title, `${h.percent}%`, `${h.doneDays}/${h.possibleDays}`, h.currentStreak, h.longestStreak])}
        />
      }
    />
  )
}