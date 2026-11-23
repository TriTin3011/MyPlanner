// @vitest-environment jsdom

import { cleanup, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it } from 'vitest'
import { Mascot } from './Mascot'

afterEach(cleanup)

describe('Mascot', () => {
  it('renders the idle motion with a stable square footprint', () => {
    render(<Mascot motion="idle" label="Mầm đang đồng hành" size={160} />)

    const image = screen.getByRole('img', { name: 'Mầm đang đồng hành' })
    const root = image.parentElement
    expect(image.getAttribute('src')).toBe('/mascot/mam-companion.webp')
    expect(root?.classList.contains('mascot')).toBe(true)
    expect(root?.classList.contains('mascot--idle')).toBe(true)
    expect(root?.getAttribute('style')).toContain('width: 160px')
    expect(root?.getAttribute('style')).toContain('height: 160px')
  })

  it('uses the success motion and stays decorative when no label is supplied', () => {
    const { container } = render(<Mascot motion="success" />)

    const image = container.querySelector('img')
    expect(image?.getAttribute('alt')).toBe('')
    expect(image?.parentElement?.classList.contains('mascot--success')).toBe(true)
  })
})
