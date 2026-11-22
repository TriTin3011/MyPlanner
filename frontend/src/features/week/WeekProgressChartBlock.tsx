import { useMemo } from 'react'
import { ChartCard, type ChartDisplayMode, type RangeOption } from '../../components/ChartCard'
import { isoWeekKey } from '../../lib/dates'
import { useSettings } from '../../store/settings'
import { toProgressPoints } from '../today/chartData'
import { useDayProgress } from '../today/hooks'
import { useWeekProgress } from './hooks'
import { dayRangeForWeeks, parseWeekRange, toWeekPoints } from './weekChartData'

const RANGE_OPTIONS: RangeOption[] = [
  { value: '1', label: '1 tuần' },
  { value: '4', label: '4 tuần' },
  { value: '12', label: '12 tuần' },
]

const CHART_ID = 'week_progress'

// Biểu đồ đầu trang Kế hoạch tuần (SPEC §9.2). Hai nguồn số liệu, cả hai đều do BE tính:
// 1 và 4 tuần đọc /dashboard/days (theo ngày), 12 tuần đọc /dashboard/weeks (mỗi điểm một tuần).
export function WeekProgressChartBlock({ monday, className }: { monday: string; className?: string }) {
  const chartModes = useSettings((s) => s.chartModes)
  const chartRanges = useSettings((s) => s.chartRanges)
  const setChartMode = useSettings((s) => s.setChartMode)
  const setChartRange = useSettings((s) => s.setChartRange)

  const mode = (chartModes[CHART_ID] as ChartDisplayMode) ?? 'line'
  const range = parseWeekRange(chartRanges[CHART_ID])
  const byWeek = range === '12'

  const { from, to } = dayRangeForWeeks(monday, Number(range))
  // Luật của hook: luôn gọi cả hai, dùng `enabled` để chỉ hook đang cần mới gửi request.
  const days = useDayProgress(from, to, !byWeek)
  const weeks = useWeekProgress(isoWeekKey(monday), 12, byWeek)

  const active = byWeek ? weeks : days
  const dayData = days.data
  const weekData = weeks.data
  const points = useMemo(
    () => (byWeek ? toWeekPoints(weekData ?? []) : toProgressPoints(dayData ?? [])),
    [byWeek, weekData, dayData],
  )

  return (
    <ChartCard
      title={byWeek ? 'Tiến độ từng tuần' : 'Tiến độ từng ngày'}
      infoTooltip={
        byWeek
          ? 'Số việc đã xong và tổng số việc của từng tuần, tính tới tuần đang xem.'
          : 'Số việc đã xong và tổng số việc của từng ngày, tính tới Chủ nhật của tuần đang xem.'
      }
      data={points}
      range={range}
      rangeOptions={RANGE_OPTIONS}
      onRangeChange={(value) => setChartRange(CHART_ID, value)}
      mode={mode}
      onModeChange={(value) => setChartMode(CHART_ID, value)}
      isLoading={active.isPending}
      errorMessage={active.isError ? 'Chưa tải được số liệu biểu đồ.' : undefined}
      onRetry={() => active.refetch()}
      className={className}
    />
  )
}
