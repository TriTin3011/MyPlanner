import type { StatsHeatmapDayDto, StatsWeekPointDto } from '../../api/types'
import i18n from '../../i18n'
import { INTL_LOCALE } from '../../i18n/languages'
import type { ChartPoint } from '../../lib/chartSvg'
import type { StatsRange } from '../../store/settings'

// Hàm thuần cho trang Thống kê: chỉ đổi hình dạng dữ liệu BE đã tính sẵn sang dạng dễ vẽ.
// Không tính lại %, chuỗi hay trung bình (quy tắc "BE tính mọi số liệu").

const RANGE_VALUES: readonly StatsRange[] = ['4w', '8w', '12w', '6m', '1y']

export const STATS_RANGES: { value: StatsRange; label: string }[] = RANGE_VALUES.map((value) => ({
  value,
  get label() {
    return i18n.t(`stats.ranges.${value}`)
  },
}))

function activeLocale(locale?: string): string {
  if (locale) return locale
  const lang = i18n.language === 'en' ? 'en' : 'vi'
  return INTL_LOCALE[lang]
}

// weekday theo ISO: 1 = Thứ 2 … 7 = Chủ nhật.
export function weekdayLabel(weekday: number, short = false, locale?: string): string {
  const loc = activeLocale(locale)
  if (loc.toLowerCase().startsWith('vi')) {
    if (weekday === 7) return short ? 'CN' : 'Chủ nhật'
    return short ? `T${weekday + 1}` : `Thứ ${weekday + 1}`
  }
  // 2026-11-16 là Thứ 2 (weekday = 1)
  const d = new Date(Date.UTC(2026, 10, 15 + weekday))
  return new Intl.DateTimeFormat(loc, { weekday: short ? 'short' : 'long', timeZone: 'UTC' }).format(d)
}

// "2026-11-16" → "16/11"
export function formatDm(date: string): string {
  const [, m, d] = date.split('-')
  return `${d}/${m}`
}

// Số thập phân kiểu Việt: 2.5 → "2,5", kiểu Anh: "2.5".
export function formatDecimal(value: number, digits = 1, locale?: string): string {
  const loc = activeLocale(locale)
  if (loc.toLowerCase().startsWith('vi')) {
    return value.toFixed(digits).replace('.', ',')
  }
  return new Intl.NumberFormat(loc, { minimumFractionDigits: digits, maximumFractionDigits: digits }).format(value)
}

export function toChartPoints(points: StatsWeekPointDto[]): ChartPoint[] {
  return points.map((p) => ({
    date: p.monday,
    label: formatDm(p.monday),
    done: p.done,
    total: p.total,
    percent: p.percent,
  }))
}

function parse(date: string): Date {
  const [y, m, d] = date.split('-').map(Number)
  return new Date(Date.UTC(y, m - 1, d))
}

const DAY_MS = 86_400_000

export interface HeatmapCell extends StatsHeatmapDayDto {
  row: number // 0 = Thứ 2 … 6 = Chủ nhật
  col: number // cột tuần, 0 = tuần chứa ngày đầu tiên
}

export interface HeatmapGrid {
  cells: HeatmapCell[]
  columns: number
  monthLabels: { col: number; label: string }[]
}

// Xếp các ngày (liên tiếp, tăng dần) vào lưới cột = tuần (bắt đầu Thứ 2), hàng = thứ.
// Nhãn tháng đặt ở cột chứa ngày mùng 1 của tháng (và cột đầu tiên).
export function buildHeatmapGrid(days: StatsHeatmapDayDto[], locale?: string): HeatmapGrid {
  if (days.length === 0) return { cells: [], columns: 0, monthLabels: [] }
  const loc = activeLocale(locale)
  const isVi = loc.toLowerCase().startsWith('vi')
  const first = parse(days[0].date)
  const firstRow = (first.getUTCDay() + 6) % 7
  const origin = first.getTime() - firstRow * DAY_MS

  const cells: HeatmapCell[] = []
  const monthLabels: { col: number; label: string }[] = []
  for (const day of days) {
    const t = parse(day.date)
    const offset = Math.round((t.getTime() - origin) / DAY_MS)
    const col = Math.floor(offset / 7)
    const row = offset % 7
    cells.push({ ...day, row, col })
    const isFirstCell = cells.length === 1
    if (isFirstCell || t.getUTCDate() === 1) {
      const label = isVi
        ? `Th${t.getUTCMonth() + 1}`
        : new Intl.DateTimeFormat(loc, { month: 'short', timeZone: 'UTC' }).format(t)
      const last = monthLabels[monthLabels.length - 1]
      if (last && last.col === col) last.label = label
      else monthLabels.push({ col, label })
    }
  }
  const columns = cells[cells.length - 1].col + 1
  return { cells, columns, monthLabels }
}