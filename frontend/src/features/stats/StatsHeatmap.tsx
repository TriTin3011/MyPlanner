import { useMemo } from 'react'
import type { StatsHeatmapDayDto } from '../../api/types'
import { buildHeatmapGrid, formatDm, weekdayLabel } from './statsFormat'
import { SimpleTable, StatsCard } from './StatsCard'

// Màu 5 mức (level do BE tính): 0 là nền nhạt, 1–4 đậm dần theo màu chính của theme.
const LEVEL_BG = [
  'var(--accent-tint)',
  'color-mix(in srgb, var(--primary) 30%, var(--surface))',
  'color-mix(in srgb, var(--primary) 55%, var(--surface))',
  'color-mix(in srgb, var(--primary) 80%, var(--surface))',
  'var(--primary)',
]

const CELL = 14
const GAP = 3
const LEFT = 26
const TOP = 16
// Chỉ ghi nhãn T2, T4, T6, CN để đỡ rối (SPEC §11).
const ROW_LABELS: Record<number, string> = { 0: 'T2', 2: 'T4', 4: 'T6', 6: 'CN' }

export function StatsHeatmap({ days, today }: { days: StatsHeatmapDayDto[]; today: string }) {
  const grid = useMemo(() => buildHeatmapGrid(days), [days])
  const width = LEFT + grid.columns * (CELL + GAP)
  const height = TOP + 7 * (CELL + GAP)

  return (
    <StatsCard
      id="stats-heatmap"
      title="Lịch hoạt động"
      chart={
        <div className="overflow-x-auto">
          <svg viewBox={`0 0 ${width} ${height}`} width={width} height={height} role="img" aria-label="Lịch hoạt động: số việc xong mỗi ngày" className="max-w-none">
            {grid.monthLabels.map((m) => (
              <text key={`${m.col}-${m.label}`} x={LEFT + m.col * (CELL + GAP)} y={10} className="fill-ink-muted text-[10px] font-bold">
                {m.label}
              </text>
            ))}
            {Object.entries(ROW_LABELS).map(([row, label]) => (
              <text key={row} x={0} y={TOP + Number(row) * (CELL + GAP) + CELL - 3} className="fill-ink-muted text-[10px] font-bold">
                {label}
              </text>
            ))}
            {grid.cells.map((c) => (
              <rect
                key={c.date}
                x={LEFT + c.col * (CELL + GAP)}
                y={TOP + c.row * (CELL + GAP)}
                width={CELL}
                height={CELL}
                rx={3}
                fill={LEVEL_BG[Math.max(0, Math.min(4, c.level))]}
                stroke={c.date === today ? 'var(--ink)' : 'none'}
                strokeWidth={c.date === today ? 2 : 0}
              >
                <title>{`${formatDm(c.date)}: ${c.done} việc`}</title>
              </rect>
            ))}
          </svg>
          <div className="mt-2 flex items-center justify-end gap-1 text-[11px] font-semibold text-ink-muted" aria-hidden="true">
            Ít
            {LEVEL_BG.map((bg) => (
              <span key={bg} className="inline-block size-3 rounded-[3px]" style={{ background: bg }} />
            ))}
            Nhiều
          </div>
        </div>
      }
      table={
        <SimpleTable
          head={['Ngày', 'Việc xong']}
          rows={days
            .filter((d) => d.done > 0)
            .map((d) => [`${weekdayLabel(((new Date(`${d.date}T00:00:00`).getDay() + 6) % 7) + 1, true)} ${formatDm(d.date)}`, d.done])}
        />
      }
    />
  )
}