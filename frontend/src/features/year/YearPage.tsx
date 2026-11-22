import { AlertCircle, Info, LoaderCircle, RotateCcw } from 'lucide-react'
import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { YearDashboardDto } from '../../api/types'
import { ChartCard, type ChartDisplayMode, type RangeOption } from '../../components/ChartCard'
import { PeriodNav } from '../../components/PeriodNav'
import { ProgressRing } from '../../components/ProgressRing'
import type { ChartPoint } from '../../lib/chartSvg'
import { toLocalDateKey } from '../../lib/dates'
import { useSettings } from '../../store/settings'
import {
  useCreateYearItem,
  useDeleteYearItem,
  useReorderYearItems,
  useSaveYearMeta,
  useUpdateYearItem,
  useYearBoard,
} from './hooks'
import { YearMetaBlock } from './YearMetaBlock'
import { YearMonthsBoard } from './YearMonthsBoard'

// Màn hình Kế hoạch năm (route "/year", SPEC §10). Trang giữ "năm đang xem", mọi con số
// (% cả năm, x/y từng tháng, dòng hạn) đến từ GET /dashboard/year.
export function YearPage() {
  const { t } = useTranslation()
  const [today] = useState(() => toLocalDateKey(new Date()))
  const thisYear = Number(today.slice(0, 4))
  const [year, setYear] = useState(thisYear)
  const board = useYearBoard(year, today)

  if (board.isPending) {
    return (
      <div
        role="status"
        aria-live="polite"
        className="mx-auto flex min-h-64 w-full max-w-[1320px] items-center justify-center gap-3 text-primary-ink"
      >
        <LoaderCircle className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
        <span className="font-bold">{t('year.loading')}</span>
      </div>
    )
  }

  if (board.isError) {
    return (
      <div
        role="alert"
        className="sketch mx-auto flex min-h-44 w-full max-w-2xl flex-col items-center justify-center gap-3 p-6 text-center"
      >
        <AlertCircle className="text-danger" aria-hidden="true" />
        <p className="font-bold">{board.error.message}</p>
        <button
          type="button"
          onClick={() => board.refetch()}
          className="flex min-h-11 items-center gap-2 rounded-full bg-primary px-4 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
        >
          <RotateCcw size={17} aria-hidden="true" />
          {t('common.retry')}
        </button>
      </div>
    )
  }

  const data = board.data
  return (
    <div className="mx-auto w-full max-w-[1320px]" aria-busy={board.isPlaceholderData}>
      <header className="mb-4 lg:mb-5 flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
        <div>
          <h1 className="font-display text-2xl leading-none font-extrabold text-primary-ink lg:text-3xl">
            {t('year.title')}
          </h1>
          <p className="mt-1 text-sm font-medium text-ink-muted">{t('year.subtitle', { year: data.year })}</p>
          <div className="mt-3">
            <PeriodNav
              currentLabel={t('year.currentYear')}
              unit={t('year.unit')}
              isCurrent={year === thisYear}
              onPrev={() => setYear((y) => y - 1)}
              onNext={() => setYear((y) => y + 1)}
              onCurrent={() => setYear(thisYear)}
            />
          </div>
        </div>
        <div className="flex items-center gap-3">
          <ProgressRing value={data.percent} label={t('year.ringLabel', { year: data.year })} />
          <p className="font-display text-lg leading-tight font-extrabold text-primary-ink">
            {data.done}/{data.total}{' '}
            <span className="text-ink-muted">{t('year.plansUnit', { count: data.total })}</span>
            <span className="block text-sm font-bold text-ink-muted">{t('year.doneSuffix')}</span>
          </p>
        </div>
      </header>

      {/* Placeholder (năm cũ) đang hiện thì data.year khác year: key theo data.year để khối nhập không lẫn năm. */}
      <div className="grid gap-3 lg:grid-cols-2 lg:gap-4">
        <YearMetaSection key={data.year} board={data} />
        <YearProgressChart board={data} currentMonth={data.currentMonth ?? null} />
      </div>

      <YearMonthsSection key={`months-${data.year}`} board={data} today={today} />
    </div>
  )
}

function YearMetaSection({ board }: { board: YearDashboardDto }) {
  const saveMeta = useSaveYearMeta(board.year)
  return <YearMetaBlock keyword={board.keyword} vision={board.vision} onSave={(req) => saveMeta.mutateAsync(req)} />
}

const CHART_ID = 'year_progress'

// Biểu đồ "Tiến độ 12 tháng" (SPEC §10.3): mỗi điểm một tháng, số do BE đếm.
function YearProgressChart({ board, currentMonth }: { board: YearDashboardDto; currentMonth: number | null }) {
  const { t } = useTranslation()
  const chartModes = useSettings((s) => s.chartModes)
  const setChartMode = useSettings((s) => s.setChartMode)
  const mode = (chartModes[CHART_ID] as ChartDisplayMode) ?? 'line'
  const rangeOptions: RangeOption[] = [{ value: '12m', label: t('year.chart.range12m') }]

  const points = useMemo<ChartPoint[]>(
    () =>
      board.months.map((m) => {
        const base = t('year.chart.monthLabel', { month: m.month })
        return {
          date: `${board.year}-${String(m.month).padStart(2, '0')}-01`,
          // Tháng hiện tại gắn dấu • để nổi bật trên trục X (ChartCard chỉ nhận chữ).
          label: m.month === currentMonth ? `•${base}` : base,
          done: m.done,
          total: m.total,
          percent: m.percent,
        }
      }),
    [board, currentMonth, t],
  )

  return (
    <ChartCard
      title={t('year.chart.title')}
      infoTooltip={t('year.chart.infoTooltip')}
      data={points}
      range="12m"
      rangeOptions={rangeOptions}
      onRangeChange={() => undefined}
      mode={mode}
      onModeChange={(value) => setChartMode(CHART_ID, value)}
      totalLabel={t('year.chart.totalLabel')}
    />
  )
}

function YearMonthsSection({ board, today }: { board: YearDashboardDto; today: string }) {
  const { t } = useTranslation()
  const year = board.year
  const createItem = useCreateYearItem(year)
  const updateItem = useUpdateYearItem(year, today)
  const deleteItem = useDeleteYearItem(year, today)
  const reorder = useReorderYearItems(year, today)
  const error = updateItem.isError || deleteItem.isError || reorder.isError

  return (
    <section aria-labelledby="year-months-title" className="mt-3 lg:mt-4">
      <h2
        id="year-months-title"
        className="mb-3 flex items-center gap-1.5 font-display text-xl font-extrabold text-primary-ink"
      >
        {t('year.months.title')}
        <span title={t('year.months.infoTitle')} className="text-ink-muted">
          <Info size={16} aria-hidden="true" />
          <span className="sr-only">{t('year.months.infoSr')}</span>
        </span>
      </h2>

      {error && (
        <p role="alert" className="mb-3 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          {t('year.months.updateError')}
        </p>
      )}

      <YearMonthsBoard
        months={board.months}
        currentMonth={board.currentMonth ?? null}
        onReorder={(input) => {
          reorder.reset()
          reorder.mutate(input)
        }}
        onToggle={(item, done) => {
          updateItem.reset()
          updateItem.mutate({ id: item.id, req: { month: item.month, title: item.title, done } })
        }}
        onDelete={(item) => {
          deleteItem.reset()
          deleteItem.mutate(item.id)
        }}
        addPendingMonth={createItem.isPending ? createItem.variables.month : undefined}
        onAdd={async (month, title) => {
          await createItem.mutateAsync({ month, title })
        }}
      />
    </section>
  )
}
