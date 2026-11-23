import { Info } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { AreaSummaryDto } from '../../api/types'
import { radarPoints } from './areaRadarGeometry'
import { lifeArea } from './lifeAreas'

export interface AreaRadarProps {
  areas: AreaSummaryDto[]
}

const CX = 180
const CY = 140
const R = 86
const LABEL_R = 104

function toPolygonPoints(points: { x: number; y: number }[]) {
  return points.map((p) => `${p.x.toFixed(2)},${p.y.toFixed(2)}`).join(' ')
}

// Khối radar "Cân bằng các lĩnh vực" kèm chế độ chuyển sang Bảng (SPEC §7.3).
export function AreaRadar({ areas }: AreaRadarProps) {
  const { t } = useTranslation()
  const [mode, setMode] = useState<'chart' | 'table'>('chart')
  // ⓘ là nút thật (bấm được bằng chạm và bàn phím), không chỉ dựa vào `title` vốn chỉ hiện khi rê chuột.
  const [showHelp, setShowHelp] = useState(false)

  const n = areas.length || 8
  const outerRing = radarPoints(Array(n).fill(100), CX, CY, R)
  const midRing = radarPoints(Array(n).fill(50), CX, CY, R)
  const labelRing = radarPoints(Array(n).fill(100), CX, CY, LABEL_R)
  const dataVertices = radarPoints(
    areas.map((a) => a.percent),
    CX,
    CY,
    R,
  )

  const ariaSummary = areas
    .map((a) => `${lifeArea(a.area).chip} ${a.percent}%`)
    .join(', ')

  return (
    <section aria-label={t('goals.radar.title')} className="sketch flex flex-col bg-surface p-3.5 lg:p-5">
      <div className="mb-3 flex items-center justify-between gap-2">
        <div className="flex items-center gap-1.5">
          <h2 className="font-display text-lg font-extrabold text-ink sm:text-xl">
            {t('goals.radar.title')}
          </h2>
          <button
            type="button"
            title={t('goals.radar.helpTitle')}
            aria-label={t('goals.radar.helpAria')}
            aria-expanded={showHelp}
            aria-controls="area-radar-help"
            onClick={() => setShowHelp((v) => !v)}
            className="grid min-h-11 min-w-11 cursor-pointer place-items-center rounded-xl text-ink-muted hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none sm:min-h-8 sm:min-w-8"
          >
            <Info size={16} aria-hidden="true" />
          </button>
        </div>

        <button
          type="button"
          aria-label={mode === 'chart' ? t('goals.radar.viewTableAria') : t('goals.radar.viewChartAria')}
          onClick={() => setMode((m) => (m === 'chart' ? 'table' : 'chart'))}
          className="min-h-11 sm:min-h-9 cursor-pointer rounded-lg px-3 text-xs font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none text-ink-muted hover:bg-accent-tint hover:text-ink"
        >
          {mode === 'chart' ? t('goals.radar.tableBtn') : t('goals.radar.chartBtn')}
        </button>
      </div>

      {showHelp && (
        <p id="area-radar-help" className="-mt-1 mb-2 text-xs text-ink-muted">
          {t('goals.radar.helpText')}
        </p>
      )}

      {mode === 'chart' ? (
        <div className="flex flex-1 items-center justify-center">
          <svg
            viewBox="0 0 360 280"
            role="img"
            aria-label={t('goals.radar.svgAria', { summary: ariaSummary })}
            className="w-full max-w-[380px] select-none font-sans"
          >
            {/* Các trục nối từ tâm ra đỉnh 100% */}
            {outerRing.map((pt, i) => (
              <line
                key={areas[i]?.area ?? i}
                x1={CX}
                y1={CY}
                x2={pt.x}
                y2={pt.y}
                stroke="var(--line)"
                strokeWidth="1"
              />
            ))}

            {/* Vòng bát giác mốc 50% và 100% */}
            {midRing.length > 0 && (
              <polygon
                points={toPolygonPoints(midRing)}
                fill="none"
                stroke="var(--line)"
                strokeWidth="1"
              />
            )}
            {outerRing.length > 0 && (
              <polygon
                points={toPolygonPoints(outerRing)}
                fill="none"
                stroke="var(--line)"
                strokeWidth="1"
              />
            )}

            {/* Nhãn mốc 100% nhỏ gần đỉnh trên */}
            <text
              x={CX + 4}
              y={CY - R + 11}
              className="fill-ink-muted text-[9px] font-medium"
            >
              100%
            </text>

            {/* Đa giác tiến độ thực tế của các lĩnh vực */}
            {dataVertices.length > 0 && (
              <polygon
                points={toPolygonPoints(dataVertices)}
                fill="var(--primary)"
                fillOpacity="0.25"
                stroke="var(--primary)"
                strokeWidth="2"
                strokeLinejoin="round"
              />
            )}

            {/* Chấm tròn trên từng đỉnh dữ liệu */}
            {dataVertices.map((pt, i) => (
              <circle
                key={areas[i]?.area ?? i}
                cx={pt.x}
                cy={pt.y}
                r="3.5"
                fill="var(--primary)"
                stroke="var(--surface)"
                strokeWidth="1.5"
              />
            ))}

            {/* Nhãn tên lĩnh vực (chip) đặt quanh bát giác, nằm gọn trong viewBox để không tràn ở 375px */}
            {areas.map((item, i) => {
              const pt = labelRing[i]
              if (!pt) return null
              const dx = pt.x - CX
              const dy = pt.y - CY
              const anchor = Math.abs(dx) < 10 ? 'middle' : dx > 0 ? 'start' : 'end'
              const yOffset = dy < -50 ? -2 : dy > 50 ? 8 : 4

              return (
                <text
                  key={item.area}
                  x={pt.x}
                  y={pt.y + yOffset}
                  textAnchor={anchor}
                  className="fill-ink text-[11px] font-bold"
                >
                  {lifeArea(item.area).chip}
                </text>
              )
            })}
          </svg>
        </div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs sm:text-sm">
            <thead className="border-b border-line font-bold text-ink-muted">
              <tr>
                <th scope="col" className="px-3 py-2">
                  {t('goals.radar.colArea')}
                </th>
                <th scope="col" className="px-3 py-2 text-right">
                  {t('goals.radar.colCount')}
                </th>
                <th scope="col" className="px-3 py-2 text-right">
                  {t('goals.radar.colAvg')}
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-line/60">
              {areas.map((item) => {
                const info = lifeArea(item.area)
                return (
                  <tr key={item.area} className="hover:bg-accent-tint/40">
                    <td className="px-3 py-2 font-semibold text-ink">{info.chip}</td>
                    <td className="px-3 py-2 text-right text-ink">{item.count}</td>
                    <td className="px-3 py-2 text-right font-bold text-primary-ink">
                      {item.percent}%
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      )}
    </section>
  )
}
