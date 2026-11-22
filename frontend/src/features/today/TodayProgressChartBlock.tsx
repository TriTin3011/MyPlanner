import { useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import { ChartCard, type ChartDisplayMode, type RangeOption } from '../../components/ChartCard'
import { INTL_LOCALE } from '../../i18n/languages'
import { useSettings } from '../../store/settings'
import { computeDateRange, toProgressPoints } from './chartData'
import { useDayProgress } from './hooks'

interface TodayProgressChartBlockProps {
  today: string
}

const CHART_ID = 'today_progress'

export function TodayProgressChartBlock({ today }: TodayProgressChartBlockProps) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const chartModes = useSettings((s) => s.chartModes)
  const chartRanges = useSettings((s) => s.chartRanges)
  const setChartMode = useSettings((s) => s.setChartMode)
  const setChartRange = useSettings((s) => s.setChartRange)

  const rangeOptions: RangeOption[] = useMemo(
    () => [
      { value: '7', label: t('today.progressChart.rangeDays', { count: 7 }) },
      { value: '14', label: t('today.progressChart.rangeDays', { count: 14 }) },
      { value: '30', label: t('today.progressChart.rangeDays', { count: 30 }) },
    ],
    [t],
  )

  const mode = (chartModes[CHART_ID] as ChartDisplayMode) ?? 'line'
  const rangeStr = chartRanges[CHART_ID] ?? '7'
  const daysCount = Number(rangeStr) || 7

  const { from, to } = useMemo(
    () => computeDateRange(today, daysCount),
    [today, daysCount],
  )

  const { data: days = [], isPending } = useDayProgress(from, to)

  const dataPoints = useMemo(() => toProgressPoints(days, locale), [days, locale])

  return (
    <div>
      <ChartCard
        title={t('today.progressChart.title')}
        infoTooltip={t('today.progressChart.infoTooltip')}
        data={dataPoints}
        range={rangeStr}
        rangeOptions={rangeOptions}
        onRangeChange={(newRange) => setChartRange(CHART_ID, newRange)}
        mode={mode}
        onModeChange={(newMode) => setChartMode(CHART_ID, newMode)}
        isLoading={isPending}
      />
    </div>
  )
}
