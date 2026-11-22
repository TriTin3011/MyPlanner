import { CheckCheck, ChevronDown, Sparkles, Target } from 'lucide-react'
import { useId, useState } from 'react'
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

// "Tuần 47 · 16/11 – 22/11/2026": số tuần lấy từ weekKey BE trả về, không tự tính lại.
function subtitle(week: WeekDashboardDto) {
  const weekNumber = Number(week.weekKey.split('-W')[1])
  return `Tuần ${weekNumber} · ${formatDayMonth(week.from)} – ${formatDayMonth(week.to)}/${week.to.slice(0, 4)}`
}

// Đầu trang Kế hoạch tuần (SPEC §9.1). Mọi số và câu chữ đến từ WeekDashboardDto.
export function WeekHeader({ week, isCurrentWeek, onPrev, onNext, onCurrent }: WeekHeaderProps) {
  // Mở/đóng "Xem thêm" là trạng thái giao diện thuần, sống trong component (không cần store hay server).
  const [expanded, setExpanded] = useState(false)
  const insightsId = useId()

  return (
    <header className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
      <div>
        <h1 className="font-display text-3xl leading-none font-extrabold text-primary-ink md:text-4xl">
          Kế hoạch tuần
        </h1>
        <p className="mt-1 text-sm font-medium text-ink-muted">{subtitle(week)}</p>
        <div className="mt-3">
          <PeriodNav
            currentLabel="Tuần này"
            unit="tuần"
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
              label: 'Đã xong',
              icon: <CheckCheck size={12} aria-hidden="true" />,
              value: week.tasksDone,
              suffix: `/ ${week.tasksTotal}`,
            },
            {
              label: 'Thói quen',
              icon: <Target size={12} aria-hidden="true" />,
              value: `${week.habitPercent}%`,
            },
            {
              label: 'Hôm nay',
              icon: <Sparkles size={12} aria-hidden="true" />,
              value: week.todayRemaining,
              suffix: 'việc',
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
              className="-ml-2 flex min-h-11 cursor-pointer items-center gap-1 rounded-full px-2 text-sm font-bold text-primary-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none sm:min-h-8"
            >
              {expanded ? 'Thu gọn' : 'Xem thêm'}
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
