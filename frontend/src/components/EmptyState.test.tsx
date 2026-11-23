// @vitest-environment jsdom

import { cleanup, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it } from 'vitest'
import { EmptyState } from './EmptyState'

afterEach(cleanup)

describe('EmptyState', () => {
  it('shows only the guidance text, without an image', () => {
    const { container } = render(<EmptyState text="Chưa có việc nào" />)

    expect(screen.getByText('Chưa có việc nào')).not.toBeNull()
    expect(container.querySelector('img')).toBeNull()
  })
})
