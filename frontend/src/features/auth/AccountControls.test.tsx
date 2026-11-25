// @vitest-environment jsdom
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { MemoryRouter } from 'react-router'
import { afterEach, beforeEach, describe, expect, it } from 'vitest'
import { keys } from '../../api/keys'
import { useTour } from '../tour/store'
import { AccountControls } from './AccountControls'
import { useSession } from './session'

function renderControls(avatarUrl: string | null = null) {
  const client = new QueryClient()
  // Dữ liệu còn mới nên test không gọi mạng.
  client.setQueryData(keys.me, { userName: 'đan', avatarUrl })
  return render(
    <QueryClientProvider client={client}>
      <MemoryRouter initialEntries={['/week']}>
        <AccountControls />
      </MemoryRouter>
    </QueryClientProvider>,
  )
}

describe('AccountControls', () => {
  beforeEach(() => {
    useSession.setState({ token: 'test', userName: 'đan', expiresAt: '2030-01-01T00:00:00Z' })
  })
  afterEach(cleanup)

  const openMenu = () => fireEvent.click(screen.getByRole('button', { name: /đan/ }))

  it('hiện chữ cái đầu và giấu menu cho tới khi bấm avatar', () => {
    renderControls()
    expect(screen.getByText('Đ')).toBeTruthy()
    expect(screen.queryByRole('button', { name: 'Đăng xuất' })).toBeNull()
    openMenu()
    expect(screen.getByRole('button', { name: 'Đăng xuất' })).toBeTruthy()
  })

  it('hiện ảnh khi có link và quay về chữ cái đầu nếu ảnh tải lỗi', () => {
    const { container } = renderControls('http://storage.test/a.webp')
    const image = container.querySelector('img')
    expect(image?.getAttribute('src')).toBe('http://storage.test/a.webp')
    fireEvent.error(image!)
    expect(container.querySelector('img')).toBeNull()
    expect(screen.getByText('Đ')).toBeTruthy()
  })

  it('đóng menu khi nhấn Esc', () => {
    renderControls()
    openMenu()
    fireEvent.keyDown(document, { key: 'Escape' })
    expect(screen.queryByRole('button', { name: 'Đăng xuất' })).toBeNull()
  })

  it('mục Hướng dẫn sử dụng đóng menu và mở tour từ trang hiện tại', () => {
    useTour.getState().stop()
    renderControls()
    openMenu()
    fireEvent.click(screen.getByRole('button', { name: 'Hướng dẫn sử dụng' }))
    expect(screen.queryByRole('button', { name: 'Đăng xuất' })).toBeNull()
    expect(useTour.getState().active).toBe(true)
    expect(useTour.getState().origin).toBe('/week')
    useTour.getState().stop()
  })

  it('đăng xuất xoá token', () => {
    renderControls()
    openMenu()
    fireEvent.click(screen.getByRole('button', { name: 'Đăng xuất' }))
    expect(useSession.getState().token).toBeNull()
  })
})
