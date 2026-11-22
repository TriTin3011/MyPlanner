import { useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import { ChartCard, type ChartDisplayMode, type RangeOption } from '../../components/ChartCard'
import { INTL_LOCALE } from '../../i18n/languages'
import { isoWeekKey } from '../../lib/dates'
import { useSettings } from '../../store/settings'
import { toProgressPoints } from '../today/chartData'
import { useDayProgress } from '../today/hooks'
import { useWeekProgress } from './hooks'
import { dayRangeForWeeks, parseWeekRange, toWeekPoints } from './weekChartData'

const CHART_ID = 'week_progress'

// Biểu đồ đầu trang Kế hoạch tuần (SPEC §9.2). Hai nguồn số liệu, cả hai đều do BE tính:
// 1 và 4 tuần đọc /dashboard/days (theo ngày), 12 tuần đọc /dashboard/weeks (mỗi điểm một tuần).
export function WeekProgressChartBlock({ monday, className }: { monday: string; className?: string }) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const chartModes = useSettings((s) => s.chartModes)
  const chartRanges = useSettings((s) => s.chartRanges)
  const setChartMode = useSettings((s) => s.setChartMode)
  const setChartRange = useSettings((s) => s.setChartRange)

  const rangeOptions: RangeOption[] = [
    { value: '1', label: t('week.chart.rangeWeeks', { count: 1 }) },
    { value: '4', label: t('week.chart.rangeWeeks', { count: 4 }) },
    { value: '12', label: t('week.chart.rangeWeeks', { count: 12 }) },
  ]

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
    () => (byWeek ? toWeekPoints(weekData ?? []) : toProgressPoints(dayData ?? [], locale)),
    [byWeek, weekData, dayData, locale],
  )

  return (
    <ChartCard
      title={byWeek ? t('week.chart.titleByWeek') : t('week.chart.titleByDay')}
      infoTooltip={byWeek ? t('week.chart.infoByWeek') : t('week.chart.infoByDay')}
      data={points}
      range={range}
      rangeOptions={rangeOptions}
      onRangeChange={(value) => setChartRange(CHART_ID, value)}
      mode={mode}
      onModeChange={(value) => setChartMode(CHART_ID, value)}
      isLoading={active.isPending}
      errorMessage={active.isError ? t('week.chart.loadError') : undefined}
      onRetry={() => active.refetch()}
      className={className}
    />
  )
}
