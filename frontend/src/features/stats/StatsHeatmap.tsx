import { useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import type { StatsHeatmapDayDto } from '../../api/types'
import { INTL_LOCALE } from '../../i18n/languages'
import { useSettings } from '../../store/settings'
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
const ROW_INDICES = [0, 2, 4, 6] as const

export function StatsHeatmap({ days, today }: { days: StatsHeatmapDayDto[]; today: string }) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const grid = useMemo(() => buildHeatmapGrid(days, locale), [days, locale])
  const width = LEFT + grid.columns * (CELL + GAP)
  const height = TOP + 7 * (CELL + GAP)

  return (
    <StatsCard
      id="stats-heatmap"
      title={t('stats.heatmap.title')}
      chart={
        <div className="overflow-x-auto">
          <svg viewBox={`0 0 ${width} ${height}`} width={width} height={height} role="img" aria-label={t('stats.heatmap.svgAria')} className="max-w-none">
            {grid.monthLabels.map((m) => (
              <text key={`${m.col}-${m.label}`} x={LEFT + m.col * (CELL + GAP)} y={10} className="fill-ink-muted text-[10px] font-bold">
                {m.label}
              </text>
            ))}
            {ROW_INDICES.map((row) => (
              <text key={row} x={0} y={TOP + row * (CELL + GAP) + CELL - 3} className="fill-ink-muted text-[10px] font-bold">
                {weekdayLabel(row + 1, true, locale)}
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
                <title>{t('stats.heatmap.cellTitle', { date: formatDm(c.date), count: c.done })}</title>
              </rect>
            ))}
          </svg>
          <div className="mt-2 flex items-center justify-end gap-1 text-[11px] font-semibold text-ink-muted" aria-hidden="true">
            {t('stats.heatmap.less')}
            {LEVEL_BG.map((bg) => (
              <span key={bg} className="inline-block size-3 rounded-[3px]" style={{ background: bg }} />
            ))}
            {t('stats.heatmap.more')}
          </div>
        </div>
      }
      table={
        <SimpleTable
          head={[t('stats.heatmap.colDate'), t('stats.heatmap.colDone')]}
          rows={days
            .filter((d) => d.done > 0)
            .map((d) => [`${weekdayLabel(((new Date(`${d.date}T00:00:00`).getDay() + 6) % 7) + 1, true, locale)} ${formatDm(d.date)}`, d.done])}
        />
      }
    />
  )
}