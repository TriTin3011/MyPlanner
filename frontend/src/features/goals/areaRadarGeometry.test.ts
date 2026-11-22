import { describe, expect, it } from 'vitest'
import { radarPoints } from './areaRadarGeometry'

describe('radarPoints', () => {
  it('places axis 0 at the top and proceeds clockwise', () => {
    const cx = 180
    const cy = 150
    const r = 90
    const pts = radarPoints([100, 100, 100, 100, 100, 100, 100, 100], cx, cy, r)

    expect(pts.length).toBe(8)
    // Trục 0 ở chính giữa đỉnh trên (x = cx, y = cy - r)
    expect(pts[0].x).toBeCloseTo(180, 5)
    expect(pts[0].y).toBeCloseTo(60, 5)

    // Trục 2 (góc 90 độ thuận chiều kim đồng hồ) ở bên phải (x = cx + r, y = cy)
    expect(pts[2].x).toBeCloseTo(270, 5)
    expect(pts[2].y).toBeCloseTo(150, 5)

    // Trục 4 ở đáy dưới (x = cx, y = cy + r)
    expect(pts[4].x).toBeCloseTo(180, 5)
    expect(pts[4].y).toBeCloseTo(240, 5)

    // Trục 6 ở bên trái (x = cx - r, y = cy)
    expect(pts[6].x).toBeCloseTo(90, 5)
    expect(pts[6].y).toBeCloseTo(150, 5)
  })

  it('scales radius proportionally to percentage and clamps to 0..100', () => {
    const pts = radarPoints([0, 50, 150, -20], 100, 100, 80)

    // 0% nằm tại tâm
    expect(pts[0].x).toBeCloseTo(100, 5)
    expect(pts[0].y).toBeCloseTo(100, 5)

    // 50% ở trục 1 (bên phải vì có 4 trục) cách tâm r * 0.5 = 40
    expect(pts[1].x).toBeCloseTo(140, 5)
    expect(pts[1].y).toBeCloseTo(100, 5)

    // 150% bị kẹp ở 100% (trục 2 ở đáy: y = 100 + 80 = 180)
    expect(pts[2].x).toBeCloseTo(100, 5)
    expect(pts[2].y).toBeCloseTo(180, 5)

    // -20% bị kẹp về 0% (tại tâm)
    expect(pts[3].x).toBeCloseTo(100, 5)
    expect(pts[3].y).toBeCloseTo(100, 5)
  })
})
