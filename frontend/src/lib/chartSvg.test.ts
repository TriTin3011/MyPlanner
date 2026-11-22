import { describe, expect, it } from 'vitest'
import { buildAreaPath, buildSmoothCurvePath } from './chartSvg'

describe('chartSvg', () => {
  it('returns empty string for empty points', () => {
    expect(buildSmoothCurvePath([])).toBe('')
    expect(buildAreaPath([], 100)).toBe('')
  })

  it('builds path for single point', () => {
    expect(buildSmoothCurvePath([{ x: 10, y: 20 }])).toBe('M 10 20')
  })

  it('builds smooth cubic bezier curve for multiple points', () => {
    const points = [
      { x: 0, y: 10 },
      { x: 10, y: 20 },
      { x: 20, y: 5 },
    ]
    const path = buildSmoothCurvePath(points)
    expect(path).toContain('M 0 10')
    expect(path).toContain('C')
  })

  it('builds closed area path ending at baseY', () => {
    const points = [
      { x: 0, y: 10 },
      { x: 20, y: 20 },
    ]
    const area = buildAreaPath(points, 50)
    expect(area).toContain('L 20.0 50.0 L 0.0 50.0 Z')
  })
})
