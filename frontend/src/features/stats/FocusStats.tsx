import { useTranslation } from 'react-i18next'
import type { StatsFocusDto } from '../../api/types'
import { formatFocusMinutes } from '../focus/focusFormat'
import { formatDm } from './statsFormat'
import { SimpleTable, StatsCard } from './StatsCard'

// "Thời gian tập trung" (SPEC §11A, bước F.7): tổng phút trong kỳ, so với kỳ trước, số chậu và
// phút theo tuần. Mọi số do BE tính trong GET /stats; FE chỉ đổi phút sang "1 giờ 30".
export function FocusStats({ focus }: { focus: StatsFocusDto }) {
  const { t } = useTranslation()
  const max = Math.max(0, ...focus.weeks.map((w) => w.minutes))
  const change = focus.minutesPercentChange

  return (
    <StatsCard
      id="stats-focus"
      title={t('stats.focus.title')}
      chart={
        <div className="flex flex-col gap-3">
          <dl className="grid grid-cols-2 gap-3">
            <div>
              <dt className="text-xs font-bold text-ink-muted uppercase">{t('stats.focus.total')}</dt>
              <dd className="font-display text-2xl font-extrabold text-primary-ink">
                {formatFocusMinutes(t, focus.minutes)}
              </dd>
              <dd className="text-xs font-semibold text-ink-muted">
                {change == null
                  ? t('stats.focus.noPrevious')
                  : t('stats.focus.change', { sign: change > 0 ? '+' : '', percent: change })}
              </dd>
            </div>
            <div>
              <dt className="text-xs font-bold text-ink-muted uppercase">{t('stats.focus.pots')}</dt>
              <dd className="font-display text-2xl font-extrabold text-primary-ink">{focus.pots}</dd>
            </div>
          </dl>
          {/* Cột theo tuần; tuần nhiều phút nhất cao 100%. role="img" vì đã có bảng cho trình đọc màn hình. */}
          <div
            role="img"
            aria-label={t('stats.focus.chartAria')}
            className="flex h-24 items-end gap-1"
          >
            {focus.weeks.map((w) => (
              <span
                key={w.weekKey}
                title={`${formatDm(w.monday)}: ${formatFocusMinutes(t, w.minutes)}`}
                className="min-h-0.5 flex-1 rounded-t-[4px]"
                style={{
                  height: `${max > 0 ? (w.minutes / max) * 100 : 0}%`,
                  background: w.minutes === max && max > 0 ? 'var(--primary)' : 'var(--muted-bar)',
                }}
              />
            ))}
          </div>
        </div>
      }
      table={
        <SimpleTable
          head={[t('stats.focus.colWeek'), t('stats.focus.colMinutes')]}
          rows={focus.weeks.map((w) => [formatDm(w.monday), formatFocusMinutes(t, w.minutes)])}
        />
      }
    />
  )
}
