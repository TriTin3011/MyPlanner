// @vitest-environment jsdom

import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { Select } from './Select'

afterEach(cleanup)

const options = [
  { value: '7', label: '7 ngày' },
  { value: '14', label: '14 ngày' },
  { value: '30', label: '30 ngày' },
]

describe('Select', () => {
  it('chọn bằng chuột rồi đóng menu', () => {
    const onChange = vi.fn()
    render(<Select ariaLabel="Khoảng" value="7" options={options} onChange={onChange} />)
    fireEvent.click(screen.getByRole('combobox', { name: 'Khoảng' }))
    fireEvent.click(screen.getByRole('option', { name: '14 ngày' }))
    expect(onChange).toHaveBeenCalledWith('14')
    expect(screen.queryByRole('listbox')).toBeNull()
  })

  it('chọn bằng phím mũi tên và Enter', () => {
    const onChange = vi.fn()
    render(<Select ariaLabel="Khoảng" value="7" options={options} onChange={onChange} />)
    const button = screen.getByRole('combobox')
    fireEvent.keyDown(button, { key: 'ArrowDown' })
    fireEvent.keyDown(button, { key: 'End' })
    fireEvent.keyDown(button, { key: 'Enter' })
    expect(onChange).toHaveBeenCalledWith('30')
  })

  it('Esc đóng menu mà không đổi giá trị', () => {
    const onChange = vi.fn()
    render(<Select ariaLabel="Khoảng" value="7" options={options} onChange={onChange} />)
    const button = screen.getByRole('combobox')
    fireEvent.click(button)
    fireEvent.keyDown(button, { key: 'Escape' })
    expect(screen.queryByRole('listbox')).toBeNull()
    expect(onChange).not.toHaveBeenCalled()
  })
})
