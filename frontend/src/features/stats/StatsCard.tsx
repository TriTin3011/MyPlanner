import { type ReactNode } from 'react'
import { useTranslation } from 'react-i18next'
import { useSettings } from '../../store/settings'

// Khung chung cho mỗi thẻ ở màn Thống kê: tiêu đề, phần phụ (huy hiệu), nút "Bảng" bật/tắt
// chế độ bảng (SPEC §11: mọi thẻ đều có Bảng, cho người đọc màn hình và người thích số).
// Lựa chọn Biểu đồ/Bảng nhớ theo id thẻ trong settings.chartModes (localStorage).
export function StatsCard({
  id,
  title,
  extra,
  chart,
  table,
  className = '',
}: {
  id: string
  title: string
  extra?: ReactNode
  chart: ReactNode
  table: ReactNode
  className?: string
}) {
  const { t } = useTranslation()
  const mode = useSettings((s) => s.chartModes[id])
  const setChartMode = useSettings((s) => s.setChartMode)
  const showTable = mode === 'table'

  return (
    <section aria-label={title} className={`sketch bg-[var(--surface)] p-3.5 lg:p-5 ${className}`}>
      <div className="mb-3 flex flex-wrap items-center justify-between gap-2">
        <div className="flex flex-wrap items-center gap-2">
          <h2 className="font-display text-xl font-extrabold text-ink">{title}</h2>
          {extra}
        </div>
        <button
          type="button"
          aria-pressed={showTable}
          onClick={() => setChartMode(id, showTable ? 'line' : 'table')}
          className={`min-h-9 cursor-pointer rounded-lg px-3 text-xs font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none ${
            showTable ? 'bg-accent-soft text-primary-ink' : 'text-ink-muted hover:bg-accent-tint hover:text-ink'
          }`}
        >
          {t('stats.tableBtn')}
        </button>
      </div>
      {showTable ? table : chart}
    </section>
  )
}

// Bảng đơn giản dùng chung cho chế độ Bảng.
export function SimpleTable({ head, rows }: { head: string[]; rows: (string | number)[][] }) {
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-left text-sm">
        <thead>
          <tr className="border-b-2 border-[var(--line)] text-xs text-ink-muted uppercase">
            {head.map((h, i) => (
              <th key={h} scope="col" className={`py-1.5 pr-3 font-extrabold ${i > 0 ? 'text-right' : ''}`}>
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r, ri) => (
            <tr key={ri} className="border-b border-dashed border-[var(--line)]">
              {r.map((c, ci) =>
                ci === 0 ? (
                  <th key={ci} scope="row" className="py-1.5 pr-3 font-semibold text-ink">
                    {c}
                  </th>
                ) : (
                  <td key={ci} className="py-1.5 pr-3 text-right font-semibold tabular-nums text-ink">
                    {c}
                  </td>
                ),
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

// Thanh tiến độ ngang dùng cho thói quen và mục tiêu theo lĩnh vực.
export function Bar({ percent, label }: { percent: number; label: string }) {
  return (
    <div
      role="progressbar"
      aria-label={label}
      aria-valuenow={percent}
      aria-valuemin={0}
      aria-valuemax={100}
      className="h-2.5 w-full overflow-hidden rounded-full border border-ink/30 bg-[var(--accent-tint)]"
    >
      <div className="h-full rounded-full bg-primary" style={{ width: `${Math.max(0, Math.min(100, percent))}%` }} />
    </div>
  )
}