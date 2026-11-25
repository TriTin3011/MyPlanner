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

  // Một NaN trong path làm trình duyệt bỏ phần còn lại của đường, nên viền mất cả 4 góc.
  it('không sinh NaN ở bất kỳ kích thước nào (viền đồng hồ đổi rộng mỗi giây)', () => {
    const broken: string[] = []
    for (let width = 20; width <= 400; width++) {
      for (let height = 20; height <= 140; height += 3) {
        if (/NaN|Infinity/.test(buildSketchSvg(width, height, '#000'))) broken.push(`${width}x${height}`)
      }
    }
    expect(broken).toEqual([])
  })

  it('mã hoá được thành data URL cho CSS', () => {
    const url = sketchImageUrl(100, 40, '#1c2b24')
    expect(url.startsWith('url("data:image/svg+xml,')).toBe(true)
    expect(url).toContain('%231c2b24')
  })
})
