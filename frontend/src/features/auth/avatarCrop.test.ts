import { describe, expect, it } from 'vitest'
import { clampOffset, cropScale, cropSource } from './avatarCrop'

const landscape = { width: 1000, height: 500 }

describe('avatarCrop', () => {
  it('zoom 1 cho cạnh ngắn vừa khít khung', () => {
    expect(cropScale(landscape, 250, 1)).toBe(0.5)
  })

  it('không cho kéo lộ vùng trống', () => {
    expect(clampOffset({ x: 999, y: 999 }, landscape, 250, 1)).toEqual({ x: 125, y: 0 })
    expect(clampOffset({ x: -999, y: 0 }, landscape, 250, 1).x).toBe(-125)
  })

  it('giữa ảnh khi chưa kéo', () => {
    expect(cropSource(landscape, 250, 1, { x: 0, y: 0 })).toEqual({ x: 250, y: 0, size: 500 })
  })

  it('kéo ảnh sang phải hết cỡ thì cắt mép trái', () => {
    expect(cropSource(landscape, 250, 1, { x: 125, y: 0 }).x).toBe(0)
  })

  it('phóng to thì vùng cắt nhỏ lại quanh tâm', () => {
    expect(cropSource(landscape, 250, 2, { x: 0, y: 0 })).toEqual({ x: 375, y: 125, size: 250 })
  })
})
