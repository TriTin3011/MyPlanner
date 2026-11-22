import { useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import type { HabitMonthDto } from '../../api/types'
import { ChartCard, type ChartDisplayMode, type RangeOption } from '../../components/ChartCard'
import { useSettings } from '../../store/settings'
import { toHabitDayPoints } from './habitChartData'

const CHART_ID = 'habit_days'

interface HabitDayChartBlockProps {
  data: HabitMonthDto | undefined
  isLoading: boolean
  isError: boolean
  onRetry: () => void
  className?: string
}

// Biểu đồ Mức hoàn thành theo ngày ở trang Thói quen (SPEC §8.2).
// Dữ liệu dùng chung từ HabitMonthDto của trang để không phải gọi API lần hai.
export function HabitDayChartBlock({
  data,
  isLoading,
  isError,
  onRetry,
  className,
}: HabitDayChartBlockProps) {
  const { t } = useTranslation()
  const chartModes = useSettings((s) => s.chartModes)
  const setChartMode = useSettings((s) => s.setChartMode)
  const setChartRange = useSettings((s) => s.setChartRange)

  const rangeOptions: RangeOption[] = [{ value: '1', label: t('habits.chart.rangeMonth') }]
  const mode = (chartModes[CHART_ID] as ChartDisplayMode) ?? 'line'
  const points = useMemo(() => toHabitDayPoints(data?.days ?? []), [data?.days])

  return (
    <ChartCard
      title={t('habits.chart.title')}
      infoTooltip={t('habits.chart.infoTooltip')}
      totalLabel={t('habits.chart.totalLabel')}
      data={points}
      range="1"
      rangeOptions={rangeOptions}
      onRangeChange={(value) => setChartRange(CHART_ID, value)}
      mode={mode}
      onModeChange={(value) => setChartMode(CHART_ID, value)}
      isLoading={isLoading}
      errorMessage={isError ? t('habits.chart.loadError') : undefined}
      onRetry={onRetry}
      className={className}
    />
  )
}
