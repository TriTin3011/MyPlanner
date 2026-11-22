import { useTranslation } from 'react-i18next'
import type { StatsGoalsDto } from '../../api/types'
import { GOAL_STATUS_LABEL, lifeArea } from '../goals/lifeAreas'
import { Bar, SimpleTable, StatsCard } from './StatsCard'

// Thẻ Mục tiêu: thanh trạng thái xếp chồng + danh sách theo lĩnh vực.
export function GoalsStats({ goals }: { goals: StatsGoalsDto }) {
  const { t } = useTranslation()
  const total = goals.total
  const statuses = [
    { key: 'done' as const, label: GOAL_STATUS_LABEL.done, color: 'var(--primary)' },
    { key: 'inProgress' as const, label: GOAL_STATUS_LABEL.in_progress, color: 'var(--warn)' },
    { key: 'notStarted' as const, label: GOAL_STATUS_LABEL.not_started, color: 'var(--muted-bar)' },
  ]
  return (
    <StatsCard
      id="stats-goals"
      title={t('stats.goals.title')}
      extra={
        <span className="rounded-full bg-accent-tint px-2 py-0.5 text-xs font-bold text-primary-ink">
          {t('stats.goals.doneBadge', { percent: goals.percentDone })}
        </span>
      }
      chart={
        total === 0 ? (
          <p className="text-sm text-ink-muted">{t('stats.goals.empty')}</p>
        ) : (
          <div className="space-y-4">
            <div>
              <div className="flex h-4 overflow-hidden rounded-full border border-ink/30" aria-hidden="true">
                {statuses.map((s) => (
                  <span key={s.key} style={{ width: `${(goals.byStatus[s.key] / total) * 100}%`, background: s.color }} />
                ))}
              </div>
              <ul className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-xs font-semibold text-ink">
                {statuses.map((s) => (
                  <li key={s.key} className="flex items-center gap-1.5">
                    <span className="inline-block size-2.5 rounded-full" style={{ background: s.color }} aria-hidden="true" />
                    {s.label}: {goals.byStatus[s.key]}
                  </li>
                ))}
              </ul>
            </div>
            <ul className="space-y-2.5">
              {goals.byArea.map((a) => {
                const info = lifeArea(a.area)
                const pct = a.total > 0 ? Math.round((a.done / a.total) * 100) : 0
                return (
                  <li key={a.area}>
                    <div className="mb-1 flex items-center justify-between gap-2 text-sm">
                      <span className="flex items-center gap-1.5 font-bold text-ink">
                        <info.Icon size={15} className="text-primary" aria-hidden="true" />
                        {info.chip}
                      </span>
                      <span className="text-xs font-bold text-ink-muted tabular-nums">
                        {a.done}/{a.total}
                      </span>
                    </div>
                    <Bar percent={pct} label={info.label} />
                  </li>
                )
              })}
            </ul>
          </div>
        )
      }
      table={
        <SimpleTable
          head={[t('stats.goals.colArea'), t('stats.goals.colDone'), t('stats.goals.colTotal')]}
          rows={goals.byArea.map((a) => [lifeArea(a.area).label, a.done, a.total])}
        />
      }
    />
  )
}