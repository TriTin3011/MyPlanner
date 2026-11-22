import { CheckCheck, Droplet, Trophy } from 'lucide-react'
import type { HabitMonthDto } from '../../api/types'
import { PeriodNav } from '../../components/PeriodNav'
import { StatStrip } from '../../components/StatStrip'

interface HabitsHeaderProps {
  month: HabitMonthDto
  isCurrentMonth: boolean
  onPrev: () => void
  onNext: () => void
  onCurrent: () => void
}

// "Tháng 11/2026" dựng thẳng từ khoá tháng "2026-11" BE trả về.
function subtitle(monthKey: string) {
  const [year, month] = monthKey.split('-')
  return `Tháng ${Number(month)}/${year}`
}

// Đầu trang Theo dõi thói quen (SPEC §8.1). Mọi chỉ số đều do BE tính sẵn trong HabitMonthDto.
export function HabitsHeader({
  month,
  isCurrentMonth,
  onPrev,
  onNext,
  onCurrent,
}: HabitsHeaderProps) {
  const { longestStreak, mostConsistent } = month

  return (
    <header className="mb-4 lg:mb-5 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
      <div>
        <h1 className="font-display text-2xl leading-none font-extrabold text-primary-ink lg:text-3xl">
          Theo dõi thói quen
        </h1>
        <p className="mt-1 text-sm font-medium text-ink-muted">{subtitle(month.month)}</p>
        <div className="mt-3">
          <PeriodNav
            currentLabel="Tháng này"
            unit="tháng"
            isCurrent={isCurrentMonth}
            onPrev={onPrev}
            onNext={onNext}
            onCurrent={onCurrent}
          />
        </div>
      </div>

      <div className="w-full lg:max-w-md">
        <StatStrip
          items={[
            {
              label: 'Cả tháng',
              icon: <CheckCheck size={12} aria-hidden="true" />,
              value: `${month.percent}%`,
            },
            {
              label: 'Chuỗi dài nhất',
              icon: <Droplet size={12} aria-hidden="true" />,
              value: longestStreak ? longestStreak.value : '—',
              suffix: longestStreak ? 'ngày' : undefined,
            },
            {
              label: 'Đều đặn nhất',
              icon: <Trophy size={12} aria-hidden="true" />,
              // Tên dài co lại bằng "…" còn phần % luôn hiện: gói cả hai trong một hàng flex
              // vì <dd> của StatStrip không xuống dòng, dùng `suffix` thì % bị đẩy tràn khỏi ô.
              value: mostConsistent ? (
                <span className="flex min-w-0 items-baseline gap-1" title={mostConsistent.title}>
                  <span className="min-w-0 truncate text-base">{mostConsistent.title}</span>
                  <span className="shrink-0 text-sm text-ink-muted">{mostConsistent.value}%</span>
                </span>
              ) : (
                '—'
              ),
            },
          ]}
        />
        {longestStreak && (
          <p className="mt-1.5 text-xs font-medium text-ink-muted">
            Chuỗi dài nhất: {longestStreak.title}
          </p>
        )}
      </div>
    </header>
  )
}
