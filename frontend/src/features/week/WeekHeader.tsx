import { CheckCheck, ChevronDown, Sparkles, Target } from 'lucide-react'
import { useId, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { WeekDashboardDto } from '../../api/types'
import { PeriodNav } from '../../components/PeriodNav'
import { StatStrip } from '../../components/StatStrip'
import { formatDayMonth } from '../../lib/dates'

interface WeekHeaderProps {
  week: WeekDashboardDto
  isCurrentWeek: boolean
  onPrev: () => void
  onNext: () => void
  onCurrent: () => void
}

// Đầu trang Kế hoạch tuần (SPEC §9.1). Mọi số và câu chữ đến từ WeekDashboardDto.
export function WeekHeader({ week, isCurrentWeek, onPrev, onNext, onCurrent }: WeekHeaderProps) {
  const { t } = useTranslation()
  // Mở/đóng "Xem thêm" là trạng thái giao diện thuần, sống trong component (không cần store hay server).
  const [expanded, setExpanded] = useState(false)
  const insightsId = useId()
  const weekNumber = Number(week.weekKey.split('-W')[1])
  const subtitle = t('week.subtitle', {
    week: weekNumber,
    from: formatDayMonth(week.from),
    to: formatDayMonth(week.to),
    year: week.to.slice(0, 4),
  })

  return (
    <header className="mb-4 lg:mb-5 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
      <div>
        <h1 className="font-display text-2xl leading-none font-extrabold text-primary-ink lg:text-3xl">
          {t('week.title')}
        </h1>
        <p className="mt-1 text-sm font-medium text-ink-muted">{subtitle}</p>
        <div className="mt-3">
          <PeriodNav
            currentLabel={t('week.currentWeek')}
            unit={t('week.unit')}
            isCurrent={isCurrentWeek}
            onPrev={onPrev}
            onNext={onNext}
            onCurrent={onCurrent}
          />
        </div>
      </div>

      <div className="w-full lg:max-w-sm">
        <StatStrip
          items={[
            {
              label: t('week.stats.done'),
              icon: <CheckCheck size={12} aria-hidden="true" />,
              value: week.tasksDone,
              suffix: `/ ${week.tasksTotal}`,
            },
            {
              label: t('week.stats.habits'),
              icon: <Target size={12} aria-hidden="true" />,
              value: `${week.habitPercent}%`,
            },
            {
              label: t('week.stats.today'),
              icon: <Sparkles size={12} aria-hidden="true" />,
              value: week.todayRemaining,
              suffix: t('week.stats.todaySuffix', { count: week.todayRemaining }),
            },
          ]}
        />
        <p className="mt-2 text-sm font-extrabold text-primary-ink">{week.comment}</p>

        {week.insights.length > 0 && (
          <>
            <button
              type="button"
              onClick={() => setExpanded((v) => !v)}
              aria-expanded={expanded}
              aria-controls={insightsId}
              className="-ml-2 flex min-h-11 cursor-pointer items-center gap-1 rounded-xl px-2 text-sm font-bold text-primary-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none sm:min-h-8"
            >
              {expanded ? t('week.showLess') : t('week.showMore')}
              <ChevronDown
                size={15}
                aria-hidden="true"
                className={`transition-transform motion-reduce:transition-none ${expanded ? 'rotate-180' : ''}`}
              />
            </button>
            <ul id={insightsId} hidden={!expanded} className="list-disc space-y-1 pl-5 text-sm text-ink">
              {week.insights.map((line) => (
                <li key={line}>{line}</li>
              ))}
            </ul>
          </>
        )}
      </div>
    </header>
  )
}
