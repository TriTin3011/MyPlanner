export interface RadarPoint {
  x: number
  y: number
}

// Tính toạ độ đỉnh biểu đồ radar (SPEC §7.3).
// Trục 0 nằm ở đỉnh trên cùng (-90 độ) và quay thuận chiều kim đồng hồ.
// Mỗi giá trị đầu vào thuộc thang 0..100 (phần trăm).
export function radarPoints(values: number[], cx: number, cy: number, r: number): RadarPoint[] {
  const n = values.length
  if (n === 0) return []

  return values.map((val, i) => {
    const clamped = Math.max(0, Math.min(100, val))
    const ratio = clamped / 100
    const angle = (2 * Math.PI * i) / n - Math.PI / 2
    return {
      x: cx + r * ratio * Math.cos(angle),
      y: cy + r * ratio * Math.sin(angle),
    }
  })
}
