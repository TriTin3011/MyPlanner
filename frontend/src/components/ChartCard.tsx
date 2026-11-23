import { Calendar, Info } from 'lucide-react'
import { type ReactNode, useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { INTL_LOCALE } from '../i18n/languages'
import { buildAreaPath, buildSmoothCurvePath, type ChartPoint } from '../lib/chartSvg'
import { useElementWidth } from '../lib/useElementWidth'
import { useSettings, type ChartMode } from '../store/settings'
import { Select } from './Select'

export type ChartDisplayMode = ChartMode

export interface RangeOption {
  value: string
  label: string
}

export interface ChartCardProps {
  title: string
  infoTooltip?: string
  data: ChartPoint[]
  // Bỏ trống rangeOptions khi trang đã có bộ chọn khoảng chung (màn Thống kê): ẩn dropdown trong thẻ.
  range?: string
  rangeOptions?: RangeOption[]
  onRangeChange?: (range: string) => void
  // Phần phụ cạnh tiêu đề, ví dụ huy hiệu "TB 72%" ở Thống kê.
  badge?: ReactNode
  mode: ChartDisplayMode
  onModeChange: (mode: ChartDisplayMode) => void
  isLoading?: boolean
  // Có lỗi thì phủ thông báo + nút thử lại lên vùng biểu đồ, thay vì hiện một biểu đồ trống khó hiểu.
  errorMessage?: string
  onRetry?: () => void
  // Nhãn chuỗi xám (mặc định 'Tổng việc'); màn Thói quen dùng 'Tổng thói quen'.
  totalLabel?: string
  className?: string
}

export function ChartCard({
  title,
  infoTooltip,
  data,
  range = '',
  rangeOptions = [],
  onRangeChange,
  badge,
  mode,
  onModeChange,
  isLoading = false,
  errorMessage,
  onRetry,
  totalLabel,
  className = '',
}: ChartCardProps) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const numFmt = useMemo(() => new Intl.NumberFormat(INTL_LOCALE[language]), [language])
  const resolvedTotalLabel = totalLabel ?? t('common.chart.defaultTotalLabel')
  const [showInfo, setShowInfo] = useState(false)
  const [hoveredIndex, setHoveredIndex] = useState<number | null>(null)

  // viewBox rộng đúng bằng bề rộng thật của vùng vẽ và cao cố định 150px (như bản tham chiếu),
  // nên chữ trục luôn đúng 11px, biểu đồ không phình to khi thẻ rộng ra.
  const [plotRef, svgWidth] = useElementWidth<HTMLDivElement>(640)
  // Nhiều ngày thì chỉ hiện nhãn trục X cách quãng (luôn giữ nhãn cuối) để không chồng chữ
  const labelStep = Math.max(1, Math.ceil(data.length / Math.max(4, Math.floor(svgWidth / 44))))
  const showLabel = (i: number) => i === data.length - 1 || (data.length - 1 - i) % labelStep === 0
  const svgHeight = 150
  const padding = { top: 18, right: 22, bottom: 24, left: 28 }
  const plotWidth = svgWidth - padding.left - padding.right
  const plotHeight = svgHeight - padding.top - padding.bottom
  const baseY = svgHeight - padding.bottom

  // Tính giá trị Y lớn nhất để vẽ tỉ lệ mốc Y
  const maxDataValue = useMemo(() => {
    let max = 0
    for (const d of data) {
      if (d.total > max) max = d.total
      if (d.done > max) max = d.done
    }
    // Mốc tối thiểu là 10 (theo ảnh mẫu có mốc 0, 5, 10)
    return Math.max(10, Math.ceil(max / 5) * 5)
  }, [data])

  const yTicks = [0, Math.round(maxDataValue / 2), maxDataValue]

  // Tính toạ độ các điểm trên SVG
  const { totalPoints, donePoints } = useMemo(() => {
    if (data.length === 0) return { totalPoints: [], donePoints: [] }
    const n = data.length
    const tPts: { x: number; y: number }[] = []
    const dPts: { x: number; y: number }[] = []

    data.forEach((p, i) => {
      const x = n === 1 ? padding.left + plotWidth / 2 : padding.left + (i * plotWidth) / (n - 1)
      const yt = padding.top + (1 - p.total / maxDataValue) * plotHeight
      const yd = padding.top + (1 - p.done / maxDataValue) * plotHeight
      tPts.push({ x, y: yt })
      dPts.push({ x, y: yd })
    })

    return { totalPoints: tPts, donePoints: dPts }
  }, [data, maxDataValue, padding.left, padding.top, plotHeight, plotWidth])

  const totalCurvePath = useMemo(() => buildSmoothCurvePath(totalPoints), [totalPoints])
  const doneCurvePath = useMemo(() => buildSmoothCurvePath(donePoints), [donePoints])
  const areaPath = useMemo(() => buildAreaPath(donePoints, baseY), [donePoints, baseY])

  const totals = useMemo(() => {
    const totalDone = data.reduce((sum, d) => sum + d.done, 0)
    const totalAll = data.reduce((sum, d) => sum + d.total, 0)
    const avgPercent = totalAll > 0 ? Math.round((totalDone / totalAll) * 100) : 0
    return { totalDone, totalAll, avgPercent }
  }, [data])

  return (
    <section
      aria-label={title}
      className={`sketch bg-[var(--surface)] p-3.5 lg:p-5 transition-shadow ${className}`}
    >
      {/* Header của ChartCard */}
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-[var(--line)]/60 pb-3">
        <div className="flex flex-wrap items-center gap-3">
          <div className="flex items-center gap-1.5">
            <h2 className="font-display text-lg sm:text-xl font-extrabold text-ink">{title}</h2>
            {infoTooltip && (
              <div className="relative">
                <button
                  type="button"
                  aria-label={t('common.chart.infoAria')}
                  aria-expanded={showInfo}
                  onClick={() => setShowInfo((v) => !v)}
                  className="text-ink-muted hover:text-ink focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary rounded-full p-0.5"
                >
                  <Info size={16} aria-hidden="true" />
                </button>
                {showInfo && (
                  <div
                    role="tooltip"
                    className="absolute left-0 top-full z-20 mt-1 w-64 rounded-lg border border-[var(--line)] bg-[var(--surface)] p-2.5 text-xs text-ink shadow-lg"
                  >
                    {infoTooltip}
                  </div>
                )}
              </div>
            )}
          </div>

          {badge}

          {/* Dropdown chọn khoảng thời gian */}
          {rangeOptions.length > 0 && (
            <Select
              ariaLabel={t('common.chart.rangeLabel')}
              value={range}
              options={rangeOptions}
              onChange={(next) => onRangeChange?.(next)}
              icon={<Calendar size={14} className="shrink-0 text-primary" aria-hidden="true" />}
              className="min-h-9 min-w-28 rounded-lg border-2 border-ink bg-surface px-2.5 text-xs hover:bg-accent-tint"
            />
          )}
        </div>

        {/* Legend & Chuyển chế độ xem (Đường / Cột / Bảng) */}
        <div className="flex flex-wrap items-center gap-4">
          <div className="hidden sm:flex items-center gap-3 text-xs font-medium text-ink-muted">
            <span className="flex items-center gap-1.5">
              <span className="inline-block h-1 w-3.5 rounded-full bg-primary" />
              <span className="text-ink font-semibold">{t('common.chart.doneLabel')}</span>
            </span>
            <span className="flex items-center gap-1.5">
              <span className="inline-block h-1 w-3.5 rounded-full bg-gray-400" />
              <span>{resolvedTotalLabel}</span>
            </span>
          </div>

          <div
            role="radiogroup"
            aria-label={t('common.chart.displayModeAria')}
            className="flex items-center gap-0.5"
          >
            {(['line', 'bar', 'table'] as const).map((m) => {
              const label = t(m === 'line' ? 'common.chart.modeLine' : m === 'bar' ? 'common.chart.modeBar' : 'common.chart.modeTable')
              const isSelected = mode === m
              return (
                <button
                  key={m}
                  type="button"
                  role="radio"
                  aria-checked={isSelected}
                  onClick={() => onModeChange(m)}
                  className={`min-h-9 cursor-pointer rounded-lg px-3 text-xs font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none transition-colors ${
                    isSelected ? 'bg-accent-soft text-primary-ink' : 'text-ink-muted hover:bg-accent-tint hover:text-ink'
                  }`}
                >
                  {label}
                </button>
              )
            })}
          </div>
        </div>
      </div>

      {/* Nội dung biểu đồ */}
      <div ref={plotRef} className="relative mt-3 min-h-[150px]">
        {errorMessage && !isLoading && (
          <div
            role="alert"
            className="absolute inset-0 z-10 flex flex-col items-center justify-center gap-2 bg-[var(--surface)]/85 text-center"
          >
            <span className="text-sm font-bold text-danger">{errorMessage}</span>
            {onRetry && (
              <button
                type="button"
                onClick={onRetry}
                className="min-h-11 rounded-xl bg-primary px-4 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
              >
                {t('common.retry')}
              </button>
            )}
          </div>
        )}
        {isLoading && (
          <div
            role="status"
            className="absolute inset-0 z-10 flex items-center justify-center bg-[var(--surface)]/70 backdrop-blur-xs"
          >
            <span className="text-xs font-bold text-primary">{t('common.chart.loading')}</span>
          </div>
        )}

        {/* Chế độ Đường (Area Chart) */}
        {mode === 'line' && (
          <div className="w-full overflow-x-auto">
            <svg
              viewBox={`0 0 ${svgWidth} ${svgHeight}`}
              className="w-full overflow-visible font-sans"
              aria-label={t('common.chart.lineChartAria')}
              role="img"
            >
              <defs>
                <linearGradient id="primaryAreaGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor="var(--primary)" stopOpacity="0.28" />
                  <stop offset="90%" stopColor="var(--primary)" stopOpacity="0.02" />
                </linearGradient>
              </defs>

              {/* Lưới ngang trục Y */}
              {yTicks.map((val) => {
                const y = padding.top + (1 - val / maxDataValue) * plotHeight
                return (
                  <g key={val}>
                    <line
                      x1={padding.left}
                      y1={y}
                      x2={svgWidth - padding.right}
                      y2={y}
                      stroke="var(--line)"
                      strokeWidth="1"
                      strokeDasharray="4 3"
                      strokeOpacity="0.7"
                    />
                    <text
                      x={padding.left - 8}
                      y={y + 3.5}
                      textAnchor="end"
                      className="fill-ink-muted text-[10px] sm:text-[11px] font-medium"
                    >
                      {numFmt.format(val)}
                    </text>
                  </g>
                )
              })}

              {/* Vùng fill của đường Đã xong */}
              {areaPath && <path d={areaPath} fill="url(#primaryAreaGrad)" />}

              {/* Đường Tổng việc (xám mờ) */}
              {totalCurvePath && (
                <path
                  d={totalCurvePath}
                  fill="none"
                  stroke="#94a3b8"
                  strokeWidth="1.8"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              )}

              {/* Đường Đã xong (xanh lá) */}
              {doneCurvePath && (
                <path
                  d={doneCurvePath}
                  fill="none"
                  stroke="var(--primary)"
                  strokeWidth="2.8"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              )}

              {/* Các điểm dữ liệu & nhãn trục X */}
              {data.map((p, i) => {
                const ptTotal = totalPoints[i]
                const ptDone = donePoints[i]
                const isHovered = hoveredIndex === i
                const isLast = i === data.length - 1
                const isFirst = i === 0

                return (
                  <g key={p.date} className="cursor-pointer" onMouseEnter={() => setHoveredIndex(i)} onMouseLeave={() => setHoveredIndex(null)}>
                    {/* Đường gióng dọc khi hover */}
                    {isHovered && (
                      <line
                        x1={ptDone.x}
                        y1={padding.top}
                        x2={ptDone.x}
                        y2={baseY}
                        stroke="var(--primary)"
                        strokeWidth="1.5"
                        strokeDasharray="2 2"
                      />
                    )}

                    {/* Nhãn số trên đỉnh đường đầu và đường cuối (khớp ảnh chụp) */}
                    {(isFirst || isHovered) && p.total > 0 && (
                      <text
                        x={ptTotal.x}
                        y={ptTotal.y - 7}
                        textAnchor="middle"
                        className="fill-ink text-[11px] font-bold"
                      >
                        {numFmt.format(p.total)}
                      </text>
                    )}

                    {/* Điểm tròn của Đã xong */}
                    {(isLast || isHovered) && (
                      <g>
                        <circle
                          cx={ptDone.x}
                          cy={ptDone.y}
                          r={isHovered ? 5.5 : 4.5}
                          fill="var(--primary)"
                          stroke="var(--surface)"
                          strokeWidth="2"
                        />
                        <text
                          x={ptDone.x}
                          y={ptDone.y - 7}
                          textAnchor="middle"
                          className="fill-primary font-extrabold text-[11px]"
                        >
                          {numFmt.format(p.done)}
                        </text>
                      </g>
                    )}

                    {/* Nhãn trục X */}
                    {(showLabel(i) || isHovered) && (
                      <text
                        x={ptDone.x}
                        y={baseY + 16}
                        textAnchor="middle"
                        className={`text-[10px] sm:text-[11px] font-bold ${
                          isLast ? 'fill-primary' : 'fill-ink-muted'
                        }`}
                      >
                        {p.label}
                      </text>
                    )}

                    {/* Hit area vô hình bẫy sự kiện hover/touch */}
                    <rect
                      x={ptDone.x - plotWidth / (data.length * 2)}
                      y={padding.top}
                      width={plotWidth / data.length}
                      height={plotHeight + padding.bottom}
                      fill="transparent"
                    />
                  </g>
                )
              })}
            </svg>

            {/* Tooltip khi hover điểm bất kỳ */}
            {hoveredIndex !== null && data[hoveredIndex] && (
              <div
                role="status"
                aria-live="polite"
                className="mt-1 flex items-center justify-center gap-2 text-xs font-bold text-ink"
              >
                <span className="text-primary">{data[hoveredIndex].date} ({data[hoveredIndex].label}):</span>
                <span>
                  {t('common.chart.hoverTasks', {
                    count: data[hoveredIndex].total,
                    done: numFmt.format(data[hoveredIndex].done),
                    total: numFmt.format(data[hoveredIndex].total),
                    percent: numFmt.format(data[hoveredIndex].percent),
                  })}
                </span>
              </div>
            )}
          </div>
        )}

        {/* Chế độ Cột (Bar Chart) */}
        {mode === 'bar' && (
          <div className="w-full overflow-x-auto">
            <svg
              viewBox={`0 0 ${svgWidth} ${svgHeight}`}
              className="w-full font-sans"
              aria-label={t('common.chart.barChartAria')}
              role="img"
            >
              {/* Lưới ngang */}
              {yTicks.map((val) => {
                const y = padding.top + (1 - val / maxDataValue) * plotHeight
                return (
                  <g key={val}>
                    <line
                      x1={padding.left}
                      y1={y}
                      x2={svgWidth - padding.right}
                      y2={y}
                      stroke="var(--line)"
                      strokeWidth="1"
                      strokeDasharray="4 3"
                    />
                    <text
                      x={padding.left - 8}
                      y={y + 3.5}
                      textAnchor="end"
                      className="fill-ink-muted text-[10px] font-medium"
                    >
                      {numFmt.format(val)}
                    </text>
                  </g>
                )
              })}

              {/* Các cặp cột */}
              {data.map((p, i) => {
                const pt = donePoints[i]
                const barWidth = Math.max(6, Math.min(22, plotWidth / (data.length * 2.2)))
                const totalHeight = (p.total / maxDataValue) * plotHeight
                const doneHeight = (p.done / maxDataValue) * plotHeight

                return (
                  <g key={p.date} className="cursor-pointer">
                    {/* Cột Tổng việc */}
                    <rect
                      x={pt.x - barWidth - 1}
                      y={baseY - totalHeight}
                      width={barWidth}
                      height={totalHeight}
                      rx="3"
                      fill="#cbd5e1"
                    />
                    {/* Cột Đã xong */}
                    <rect
                      x={pt.x + 1}
                      y={baseY - doneHeight}
                      width={barWidth}
                      height={doneHeight}
                      rx="3"
                      fill="var(--primary)"
                    />
                    {/* Nhãn trục X */}
                    {showLabel(i) && (
                      <text
                        x={pt.x}
                        y={baseY + 16}
                        textAnchor="middle"
                        className="fill-ink-muted text-[10px] font-bold"
                      >
                        {p.label}
                      </text>
                    )}
                  </g>
                )
              })}
            </svg>
          </div>
        )}

        {/* Chế độ Bảng */}
        {mode === 'table' && (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs sm:text-sm">
              <thead className="border-b border-[var(--line)] text-ink-muted font-bold">
                <tr>
                  <th scope="col" className="py-2 px-3">{t('common.chart.tableTime')}</th>
                  <th scope="col" className="py-2 px-3 text-right">{t('common.chart.doneLabel')}</th>
                  <th scope="col" className="py-2 px-3 text-right">{resolvedTotalLabel}</th>
                  <th scope="col" className="py-2 px-3 text-right">{t('common.chart.tableRate')}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[var(--line)]/50">
                {data.map((d) => (
                  <tr key={d.date} className="hover:bg-accent-tint/40 transition-colors">
                    <td className="py-2 px-3 font-semibold text-ink">
                      {d.label} <span className="text-xs text-ink-muted">({d.date})</span>
                    </td>
                    <td className="py-2 px-3 text-right font-bold text-primary">{numFmt.format(d.done)}</td>
                    <td className="py-2 px-3 text-right text-ink">{numFmt.format(d.total)}</td>
                    <td className="py-2 px-3 text-right font-bold text-ink">{numFmt.format(d.percent)}%</td>
                  </tr>
                ))}
              </tbody>
              <tfoot className="border-t-2 border-[var(--ink)] font-bold text-ink">
                <tr>
                  <td className="py-2 px-3">{t('common.chart.tableTotal')}</td>
                  <td className="py-2 px-3 text-right text-primary">{numFmt.format(totals.totalDone)}</td>
                  <td className="py-2 px-3 text-right">{numFmt.format(totals.totalAll)}</td>
                  <td className="py-2 px-3 text-right">{numFmt.format(totals.avgPercent)}%</td>
                </tr>
              </tfoot>
            </table>
          </div>
        )}
      </div>
    </section>
  )
}
