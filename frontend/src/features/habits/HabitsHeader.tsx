import { CheckCheck, Droplet, Trophy } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import type { HabitMonthDto } from '../../api/types'
import { PeriodNav } from '../../components/PeriodNav'
import { StatStrip } from '../../components/StatStrip'
import { INTL_LOCALE } from '../../i18n/languages'
import { useSettings } from '../../store/settings'

interface HabitsHeaderProps {
  month: HabitMonthDto
  isCurrentMonth: boolean
  onPrev: () => void
  onNext: () => void
  onCurrent: () => void
}

// Đầu trang Theo dõi thói quen (SPEC §8.1). Mọi chỉ số đều do BE tính sẵn trong HabitMonthDto.
export function HabitsHeader({
  month,
  isCurrentMonth,
  onPrev,
  onNext,
  onCurrent,
}: HabitsHeaderProps) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const { longestStreak, mostConsistent } = month

  const [yearPart, monthPart] = month.month.split('-')
  const subtitle = language === 'vi'
    ? t('habits.subtitle', { month: Number(monthPart), year: yearPart })
    : new Intl.DateTimeFormat(locale, { month: 'long', year: 'numeric' }).format(
        new Date(Number(yearPart), Number(monthPart) - 1, 1),
      )

  return (
    <header className="mb-4 lg:mb-5 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
      <div>
        <h1 className="font-display text-2xl leading-none font-extrabold text-primary-ink lg:text-3xl">
          {t('habits.title')}
        </h1>
        <p className="mt-1 text-sm font-medium text-ink-muted">{subtitle}</p>
        <div className="mt-3">
          <PeriodNav
            currentLabel={t('habits.currentMonth')}
            unit={t('habits.unit')}
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
              label: t('habits.stats.wholeMonth'),
              icon: <CheckCheck size={12} aria-hidden="true" />,
              value: `${month.percent}%`,
            },
            {
              label: t('habits.stats.longestStreak'),
              icon: <Droplet size={12} aria-hidden="true" />,
              value: longestStreak ? longestStreak.value : '—',
              suffix: longestStreak ? t('habits.stats.daysSuffix', { count: longestStreak.value }) : undefined,
            },
            {
              label: t('habits.stats.mostConsistent'),
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
            {t('habits.longestStreakCaption', { title: longestStreak.title })}
          </p>
        )}
      </div>
    </header>
  )
}
