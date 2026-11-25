import { describe, expect, it } from 'vitest'
import {
  endScene,
  growingScene,
  openingScene,
  plant,
  sceneDefs,
  shelfScene,
  SHELF_SIZE,
  slotPosition,
  uniqueIds,
} from './sceneSvg'

const look = { plantKind: 'basil' as const, potColor: 'terra' as const }

describe('focus scene SVG', () => {
  it('prefixes every reusable definition and reference', () => {
    const markup = '<defs><filter id="soft"><feGaussianBlur/></filter></defs><g filter="url(#soft)"/>'
    expect(uniqueIds(markup, 'scene-a-')).toBe(
      '<defs><filter id="scene-a-soft"><feGaussianBlur/></filter></defs><g filter="url(#scene-a-soft)"/>',
    )
  })

  it('builds layered atmosphere with motion hooks', () => {
    const dawn = growingScene(0, 7, false, look)
    const day = growingScene(0.18, 7, false, look)
    const night = growingScene(0.55, 7, false, look)

    expect(dawn).toContain('focus-cloud')
    expect(dawn).toContain('focus-mote')
    expect(night).toContain('focus-firefly')
    expect(night).toContain('focus-star')
    expect(sceneDefs()).toContain('feTurbulence')

    const starOpacity = (scene: string) => Number(scene.match(/<g opacity="([^"]+)"><circle class="focus-star"/)?.[1])
    expect(starOpacity(day)).toBeLessThan(0.1)
    expect(starOpacity(night)).toBeGreaterThan(0.9)
  })

  it('draws distinct living plants and a clearly wilted state', () => {
    const basil = plant(0, 1, 'basil')
    const sunflower = plant(0, 1, 'sunflower')
    const cactus = plant(0, 1, 'cactus')
    const wilted = plant(0, 0.75, 'basil', true)

    expect(basil).toContain('plant-basil')
    expect(basil).toContain('leaf-midrib')
    expect(basil).toContain('focus-sway')
    expect(sunflower).toContain('plant-sunflower')
    expect(cactus).toContain('plant-cactus')
    expect(wilted).toContain('plant-wilted')
    expect(wilted).not.toContain('basil-flower')
  })

  it('keeps the 3 + 4 + 5 shelf hit-map aligned with twelve pot slots', () => {
    expect(SHELF_SIZE).toBe(12)
    expect(slotPosition(0)).toEqual({ x: 226.66666666666666, y: 84.4, baseY: 118 })
    expect(slotPosition(11)).toEqual({ x: 548, y: 274.4, baseY: 308 })

    const shelf = shelfScene([], 0)
    expect(shelf).toContain('shelf-lamp-glow')
    expect(shelf).toContain('wood-grain')
  })

  it('keeps every generated scene below the 40 KB rendering budget', () => {
    const fullShelf = shelfScene(
      Array.from({ length: 12 }, (_, slot) => ({
        slot,
        plantKind: (['basil', 'sunflower', 'cactus'] as const)[slot % 3],
        potColor: (['terra', 'cream', 'sage', 'blue'] as const)[slot % 4],
      })),
      null,
    )
    const scenes = [
      openingScene('soil', look),
      growingScene(0.5, 7, true, look),
      endScene('done', 1, look),
      endScene('wilted', 0.5, look),
      fullShelf,
    ]

    for (const scene of scenes) expect(new Blob([scene]).size).toBeLessThan(40_000)
  })
})
