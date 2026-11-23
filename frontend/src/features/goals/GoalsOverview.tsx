import { useTranslation } from 'react-i18next'
import type { GoalBoardDto, LifeArea } from '../../api/types'
import { ProgressRing } from '../../components/ProgressRing'
import { lifeArea } from './lifeAreas'

export interface GoalsOverviewProps {
  board: GoalBoardDto
  selectedArea: LifeArea | null
  onSelectArea(area: LifeArea | null): void
}

// Khối tổng quan mục tiêu (SPEC §7.2). Mọi số phần trăm và số lượng do BE tính sẵn trong GoalBoardDto.
export function GoalsOverview({ board, selectedArea, onSelectArea }: GoalsOverviewProps) {
  const { t } = useTranslation()
  return (
    <section
      aria-label={t('goals.overview.sectionAria')}
      className="sketch flex flex-col items-center justify-center gap-4 bg-surface p-3.5 lg:p-5"
    >
      <div className="flex items-center gap-4">
        <ProgressRing value={board.percent} label={t('goals.overview.ringLabel')} />
        <p className="font-display text-2xl leading-tight font-extrabold text-ink sm:text-3xl">
          <span>
            {board.done}/{board.total}
          </span>{' '}
          <span className="text-ink-muted">{t('goals.overview.goalsUnit', { count: board.total })}</span>
        </p>
      </div>

      {/* Dãy 8 chip lọc theo lĩnh vực; bấm lại chip đang chọn để bỏ lọc */}
      <div className="flex flex-wrap justify-center gap-2 sm:gap-2.5" role="group" aria-label={t('goals.overview.filterGroupAria')}>
        {board.areas.map((item) => {
          const info = lifeArea(item.area)
          const Icon = info.Icon
          const isSelected = selectedArea === item.area

          return (
            <button
              key={item.area}
              type="button"
              aria-pressed={isSelected}
              onClick={() => onSelectArea(isSelected ? null : item.area)}
              className={`inline-flex min-h-11 cursor-pointer items-center gap-1.5 rounded-xl px-3.5 py-1.5 text-sm transition-colors focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none sm:min-h-9 ${
                isSelected
                  ? 'border-2 border-primary-ink bg-accent-soft font-extrabold text-primary-ink shadow-[1px_2px_0_0_var(--ink)]'
                  : 'border border-transparent bg-accent-tint/70 font-bold text-ink hover:bg-accent-soft/70'
              }`}
            >
              <Icon size={15} className="shrink-0 text-primary" aria-hidden="true" />
              <span>{info.chip}</span>
              <span className="text-ink-muted">{item.count}</span>
            </button>
          )
        })}
      </div>
    </section>
  )
}
