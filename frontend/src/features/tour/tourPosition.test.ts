import { describe, expect, it } from 'vitest'
import { placeCard, spotlightBox } from './tourPosition'

const desktop = { width: 1440, height: 900 }
const phone = { width: 375, height: 812 }
const card = { width: 340, height: 200 }

describe('spotlightBox', () => {
  it('nới phần tử ra và cắt theo màn hình', () => {
    expect(spotlightBox({ left: 0, top: 700, width: 500, height: 400 }, { width: 375, height: 812 })).toEqual({
      left: 0,
      top: 694,
      width: 375,
      height: 118,
    })
  })
})

describe('placeCard', () => {
  it('không có phần tử thì nằm giữa màn hình', () => {
    expect(placeCard(null, card, desktop)).toEqual({ x: 550, y: 350 })
  })

  it('ưu tiên đặt dưới phần tử', () => {
    expect(placeCard({ left: 300, top: 100, width: 200, height: 50 }, card, desktop)).toEqual({ x: 300, y: 162 })
  })

  it('sát đáy thì đặt lên trên', () => {
    expect(placeCard({ left: 0, top: 756, width: 375, height: 56 }, card, phone)).toEqual({ x: 12, y: 544 })
  })

  it('sidebar cao thì đặt sang phải', () => {
    expect(placeCard({ left: 16, top: 20, width: 230, height: 860 }, card, desktop)).toEqual({ x: 258, y: 20 })
  })

  it('phần tử phủ gần hết màn hình thì ghim thẻ vào trong khung nhìn', () => {
    const { x, y } = placeCard({ left: 0, top: 0, width: 375, height: 812 }, card, phone)
    expect(x).toBeGreaterThanOrEqual(12)
    expect(x + card.width).toBeLessThanOrEqual(375)
    expect(y + card.height).toBeLessThanOrEqual(812)
  })
})
