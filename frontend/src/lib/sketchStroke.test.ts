import { describe, expect, it } from 'vitest'
import { buildSketchSvg, SKETCH_OUTSET, sketchImageUrl } from './sketchStroke'

function coordinates(svg: string): number[] {
  return [...svg.matchAll(/ d="([^"]+)"/g)].flatMap((match) =>
    match[1].split(/[MLZ ]+/).filter(Boolean).map(Number),
  )
}

describe('buildSketchSvg', () => {
  it('cùng kích thước luôn ra cùng hình', () => {
    expect(buildSketchSvg(320, 140, '#1c2b24')).toBe(buildSketchSvg(320, 140, '#1c2b24'))
  })

  it('kích thước khác nhau cho nét khác nhau', () => {
    expect(buildSketchSvg(320, 140, '#000')).not.toBe(buildSketchSvg(321, 140, '#000'))
  })

  it.each([
    [1200, 900],
    [320, 140],
    [200, 44],
    [18, 18],
  ])('nét %ix%i không vượt ra ngoài vùng ảnh', (width, height) => {
    const values = coordinates(buildSketchSvg(width, height, '#000'))
    expect(values.every(Number.isFinite)).toBe(true)
    expect(Math.min(...values)).toBeGreaterThanOrEqual(-SKETCH_OUTSET)
    expect(Math.max(...values)).toBeLessThanOrEqual(Math.max(width, height) + SKETCH_OUTSET)
  })

  it('mã hoá được thành data URL cho CSS', () => {
    const url = sketchImageUrl(100, 40, '#1c2b24')
    expect(url.startsWith('url("data:image/svg+xml,')).toBe(true)
    expect(url).toContain('%231c2b24')
  })
})
