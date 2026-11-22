import { useMemo } from 'react'
import { ChartCard, type ChartDisplayMode, type RangeOption } from '../../components/ChartCard'
import { useSettings } from '../../store/settings'
import { computeDateRange, toProgressPoints } from './chartData'
import { useDayProgress } from './hooks'

interface TodayProgressChartBlockProps {
  today: string
}

const RANGE_OPTIONS: RangeOption[] = [
  { value: '7', label: '7 ngày' },
  { value: '14', label: '14 ngày' },
  { value: '30', label: '30 ngày' },
]

const CHART_ID = 'today_progress'

export function TodayProgressChartBlock({ today }: TodayProgressChartBlockProps) {
  const chartModes = useSettings((s) => s.chartModes)
  const chartRanges = useSettings((s) => s.chartRanges)
  const setChartMode = useSettings((s) => s.setChartMode)
  const setChartRange = useSettings((s) => s.setChartRange)

  const mode = (chartModes[CHART_ID] as ChartDisplayMode) ?? 'line'
  const rangeStr = chartRanges[CHART_ID] ?? '7'
  const daysCount = Number(rangeStr) || 7

  const { from, to } = useMemo(
    () => computeDateRange(today, daysCount),
    [today, daysCount],
  )

  const { data: days = [], isPending } = useDayProgress(from, to)

  const dataPoints = useMemo(() => toProgressPoints(days), [days])

  return (
    <div>
      <ChartCard
        title="Tiến độ gần đây"
        infoTooltip="Thống kê số việc đã hoàn thành và tổng số việc được giao theo từng ngày."
        data={dataPoints}
        range={rangeStr}
        rangeOptions={RANGE_OPTIONS}
        onRangeChange={(newRange) => setChartRange(CHART_ID, newRange)}
        mode={mode}
        onModeChange={(newMode) => setChartMode(CHART_ID, newMode)}
        isLoading={isPending}
      />
    </div>
  )
}
