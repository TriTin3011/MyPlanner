export interface ChartPoint {
  date: string // YYYY-MM-DD
  label: string // T2, T3... hoặc 16/11
  done: number
  total: number
  percent: number
}

export function buildSmoothCurvePath(points: { x: number; y: number }[]): string {
  if (points.length === 0) return ''
  if (points.length === 1) return `M ${points[0].x} ${points[0].y}`

  let path = `M ${points[0].x} ${points[0].y}`
  for (let i = 1; i < points.length; i++) {
    const prev = points[i - 1]
    const curr = points[i]
    const dx = curr.x - prev.x
    const cp1x = prev.x + dx / 2
    const cp1y = prev.y
    const cp2x = prev.x + dx / 2
    const cp2y = curr.y
    path += ` C ${cp1x.toFixed(1)} ${cp1y.toFixed(1)}, ${cp2x.toFixed(1)} ${cp2y.toFixed(1)}, ${curr.x.toFixed(1)} ${curr.y.toFixed(1)}`
  }
  return path
}

export function buildAreaPath(points: { x: number; y: number }[], baseY: number): string {
  if (points.length === 0) return ''
  const curve = buildSmoothCurvePath(points)
  const last = points[points.length - 1]
  const first = points[0]
  return `${curve} L ${last.x.toFixed(1)} ${baseY.toFixed(1)} L ${first.x.toFixed(1)} ${baseY.toFixed(1)} Z`
}
