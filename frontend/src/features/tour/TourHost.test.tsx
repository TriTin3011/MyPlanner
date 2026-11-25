// @vitest-environment jsdom

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { act, cleanup, fireEvent, render, screen } from '@testing-library/react'
import { MemoryRouter, useLocation } from 'react-router'
import { afterEach, beforeEach, describe, expect, it } from 'vitest'
import { keys } from '../../api/keys'
import { vi as messages } from '../../i18n/vi'
import { useSettings } from '../../store/settings'
import { AccountControls } from '../auth/AccountControls'
import { useSession } from '../auth/session'
import { useTour } from './store'
import { TourHost } from './TourHost'
import { TOUR_STEPS } from './tourSteps'

const text = messages.tour

function Where() {
  return <output data-testid="path">{useLocation().pathname}</output>
}

function renderTour() {
  const client = new QueryClient()
  client.setQueryData(keys.me, { userName: 'an', avatarUrl: null })
  return render(
    <QueryClientProvider client={client}>
      <MemoryRouter initialEntries={['/']}>
        <TourHost />
        <AccountControls />
        <Where />
      </MemoryRouter>
    </QueryClientProvider>,
  )
}

const title = (name: string) => screen.queryByRole('heading', { name, hidden: true })
const press = (key: string) => fireEvent.keyDown(document.querySelector('dialog.tour')!, { key })
const path = () => screen.getByTestId('path').textContent
const useTourIndex = (index: number) => act(() => useTour.setState({ index }))

afterEach(cleanup)

describe('TourHost', () => {
  beforeEach(() => {
    useTour.getState().stop()
    useSettings.setState({ tourSeen: {} })
    useSession.setState({ token: 't', userName: 'an', expiresAt: '2099-01-01T00:00:00Z' })
  })

  it('tự mở cho tài khoản chưa xem', () => {
    renderTour()
    expect(title(text.steps.welcome.title)).not.toBeNull()
  })

  it('không tự mở lại với tài khoản đã xem, nhưng tài khoản khác vẫn được mở', () => {
    useSettings.setState({ tourSeen: { binh: true } })
    useSession.setState({ userName: 'binh' })
    const first = renderTour()
    expect(title(text.steps.welcome.title)).toBeNull()
    first.unmount()

    useSession.setState({ userName: 'an' })
    renderTour()
    expect(title(text.steps.welcome.title)).not.toBeNull()
  })

  it('"Để sau" đóng tour và ghi nhớ theo tài khoản', () => {
    renderTour()
    fireEvent.click(screen.getByRole('button', { name: text.later, hidden: true }))
    expect(title(text.steps.welcome.title)).toBeNull()
    expect(useSettings.getState().tourSeen).toEqual({ an: true })
  })

  it('phím mũi tên chuyển bước, Esc thoát và trả về trang ban đầu', () => {
    renderTour()
    press('ArrowRight')
    expect(title(text.steps.nav.title)).not.toBeNull()
    press('ArrowLeft')
    expect(title(text.steps.welcome.title)).not.toBeNull()

    for (let i = 0; i < 4; i += 1) press('ArrowRight')
    // Tới bước ở trang khác: chưa tự chuyển, chờ người dùng bấm tab (hoặc mũi tên phải).
    expect(path()).toBe('/')
    press('ArrowRight')
    expect(path()).toBe('/goals')
    expect(title(text.steps.goalsAdd.title)).not.toBeNull()

    press('Escape')
    expect(document.querySelector('dialog.tour')).toBeNull()
    expect(path()).toBe('/')
    expect(useSettings.getState().tourSeen).toEqual({ an: true })
  })

  it('bấm vào tab đang được chỉ thì sang đúng trang', () => {
    const { container } = render(<a data-tour="tab:/goals">tab</a>)
    const tab = container.querySelector('a')!
    tab.getClientRects = () => [{}] as unknown as DOMRectList
    renderTour()
    useTourIndex(TOUR_STEPS.findIndex((step) => step.id === 'goalsAdd'))

    const hit = screen.getByRole('button', { name: 'Bấm vào Mục tiêu', hidden: true })
    expect(path()).toBe('/')
    fireEvent.click(hit)
    expect(path()).toBe('/goals')
    expect(title(text.steps.goalsAdd.title)).not.toBeNull()
  })

  it('mở lại từ mục Hướng dẫn sử dụng trong menu avatar và đi hết 10 bước qua đủ các trang', () => {
    useSettings.setState({ tourSeen: { an: true } })
    renderTour()
    fireEvent.click(screen.getByRole('button', { name: messages.auth.accountMenu.replace('{{name}}', 'an') }))
    fireEvent.click(screen.getByRole('button', { name: text.open }))
    expect(screen.queryByRole('button', { name: text.open })).toBeNull() // menu đã đóng

    const visited = new Set<string>()
    // Mũi tên phải vừa sang bước mới, vừa thay cho cú bấm tab khi bước nằm ở trang khác.
    for (let i = 0; i < TOUR_STEPS.length * 2 && useTour.getState().index < TOUR_STEPS.length - 1; i += 1) {
      press('ArrowRight')
      visited.add(path() ?? '')
    }
    expect([...visited]).toEqual(expect.arrayContaining(['/', '/goals', '/habits', '/week', '/year', '/stats']))
    expect(title(text.steps.finish.title)).not.toBeNull()

    fireEvent.click(screen.getByRole('button', { name: text.done, hidden: true }))
    expect(document.querySelector('dialog.tour')).toBeNull()
    expect(path()).toBe('/')
  })
})
