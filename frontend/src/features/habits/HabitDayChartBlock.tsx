import { useMemo } from 'react'
import type { HabitMonthDto } from '../../api/types'
import { ChartCard, type ChartDisplayMode, type RangeOption } from '../../components/ChartCard'
import { useSettings } from '../../store/settings'
import { toHabitDayPoints } from './habitChartData'

const RANGE_OPTIONS: RangeOption[] = [{ value: '1', label: '1 tháng' }]

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
  const chartModes = useSettings((s) => s.chartModes)
  const setChartMode = useSettings((s) => s.setChartMode)
  const setChartRange = useSettings((s) => s.setChartRange)

  const mode = (chartModes[CHART_ID] as ChartDisplayMode) ?? 'line'
  const points = useMemo(() => toHabitDayPoints(data?.days ?? []), [data?.days])

  return (
    <ChartCard
      title="Mức hoàn thành theo ngày"
      infoTooltip="Số thói quen đã tick và tổng số thói quen của từng ngày trong tháng, tính tới hôm nay."
      totalLabel="Tổng thói quen"
      data={points}
      range="1"
      rangeOptions={RANGE_OPTIONS}
      onRangeChange={(value) => setChartRange(CHART_ID, value)}
      mode={mode}
      onModeChange={(value) => setChartMode(CHART_ID, value)}
      isLoading={isLoading}
      errorMessage={isError ? 'Chưa tải được số liệu biểu đồ.' : undefined}
      onRetry={onRetry}
      className={className}
    />
  )
}
