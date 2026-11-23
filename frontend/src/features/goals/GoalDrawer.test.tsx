// @vitest-environment jsdom
import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import type { GoalDto } from '../../api/types'
import { GoalDrawer, type GoalDrawerProps } from './GoalDrawer'

afterEach(cleanup)

const goal: GoalDto = {
  id: 'goal-1',
  title: 'Học React',
  area: 'learning',
  status: 'in_progress',
  startDate: '2026-11-01',
  deadline: '2026-12-31',
  reward: null,
  why: 'Làm frontend tốt hơn',
  steps: [
    {
      id: 'step-1',
      title: 'Đọc tài liệu',
      deadline: '2026-11-20',
      done: false,
      doneAt: null,
      order: 0,
    },
    {
      id: 'step-2',
      title: 'Làm bài tập',
      deadline: null,
      done: true,
      doneAt: '2026-11-18T08:00:00Z',
      order: 1,
    },
  ],
  createdAt: '2026-11-01T08:00:00Z',
  completedAt: null,
}

function renderDrawer(overrides: Partial<GoalDrawerProps> = {}) {
  const props: GoalDrawerProps = {
    open: true,
    mode: 'create',
    goal: undefined,
    today: '2026-11-22',
    isSaving: false,
    error: null,
    onClose: vi.fn(),
    onSave: vi.fn(),
    onDelete: vi.fn(),
    onAddStep: vi.fn(),
    onUpdateStep: vi.fn(),
    onDeleteStep: vi.fn(),
    onReorderSteps: vi.fn(),
    ...overrides,
  }
  render(<GoalDrawer {...props} />)
  return props
}

describe('GoalDrawer', () => {
  it('hiển thị lỗi bằng alert kể cả khi mục tiêu đang tải', () => {
    renderDrawer({ mode: 'edit', goal: undefined, error: 'Không tải được mục tiêu.' })

    expect(screen.getByRole('alert').textContent).toContain('Không tải được mục tiêu.')
  })

  it('gửi payload tạo mới và đổi phần thưởng, lý do rỗng thành null', () => {
    const props = renderDrawer()

    fireEvent.change(screen.getByLabelText('Tên mục tiêu'), { target: { value: '  Học React  ' } })
    fireEvent.click(screen.getByLabelText('Lĩnh vực'))
    fireEvent.click(screen.getByRole('option', { name: 'Học tập' }))
    fireEvent.submit(screen.getByLabelText('Tên mục tiêu').closest('form')!)

    expect(props.onSave).toHaveBeenCalledWith({
      title: 'Học React',
      area: 'learning',
      status: 'not_started',
      startDate: '2026-11-22',
      deadline: '2026-12-22',
      reward: null,
      why: null,
    })
  })

  it('vô hiệu hoá lưu khi hạn chót trước ngày bắt đầu', () => {
    renderDrawer()

    fireEvent.change(screen.getByLabelText('Tên mục tiêu'), { target: { value: 'Học React' } })
    fireEvent.change(screen.getByLabelText('Hạn chót'), { target: { value: '2026-11-21' } })

    expect(screen.getByText('Hạn chót phải sau ngày bắt đầu.')).toBeTruthy()
    expect((screen.getByRole('button', { name: 'Lưu' }) as HTMLButtonElement).disabled).toBe(true)
  })

  it('đổi trạng thái hoàn thành của bước', () => {
    const props = renderDrawer({ mode: 'edit', goal })

    fireEvent.click(screen.getByRole('checkbox', { name: 'Hoàn thành bước: Đọc tài liệu' }))

    expect(props.onUpdateStep).toHaveBeenCalledWith('step-1', {
      title: 'Đọc tài liệu',
      deadline: '2026-11-20',
      done: true,
    })
  })

  it('chỉ xoá mục tiêu sau bước xác nhận', () => {
    const props = renderDrawer({ mode: 'edit', goal })

    fireEvent.click(screen.getByRole('button', { name: 'Xoá mục tiêu' }))
    expect(props.onDelete).not.toHaveBeenCalled()
    expect(screen.getByText('Xoá mục tiêu này? Các bước cũng bị xoá.')).toBeTruthy()

    fireEvent.click(screen.getByRole('button', { name: 'Xoá' }))
    expect(props.onDelete).toHaveBeenCalledTimes(1)
  })

  it('thêm bước đã cắt khoảng trắng rồi xoá nội dung nhập', () => {
    const props = renderDrawer({ mode: 'edit', goal })
    const input = screen.getByPlaceholderText('Thêm bước…') as HTMLInputElement

    fireEvent.change(input, { target: { value: '  Xây ứng dụng nhỏ  ' } })
    fireEvent.submit(input.closest('form')!)

    expect(props.onAddStep).toHaveBeenCalledWith({ title: 'Xây ứng dụng nhỏ', deadline: null, done: false })
    expect(input.value).toBe('')
  })

  it('lưu tên bước sửa bằng phím Enter', () => {
    const props = renderDrawer({ mode: 'edit', goal })

    fireEvent.click(screen.getByRole('button', { name: 'Đọc tài liệu' }))
    const input = screen.getByRole('textbox', { name: 'Sửa tên bước: Đọc tài liệu' })
    fireEvent.change(input, { target: { value: '  Đọc React docs  ' } })
    fireEvent.keyDown(input, { key: 'Enter' })

    expect(props.onUpdateStep).toHaveBeenCalledWith('step-1', {
      title: 'Đọc React docs',
      deadline: '2026-11-20',
      done: false,
    })
  })

  it('sắp xếp bước bằng phím mũi tên trên tay nắm', () => {
    const props = renderDrawer({ mode: 'edit', goal })

    fireEvent.keyDown(screen.getByRole('button', { name: 'Kéo để sắp xếp: Đọc tài liệu' }), { key: 'ArrowDown' })

    expect(props.onReorderSteps).toHaveBeenCalledWith(['step-2', 'step-1'])
  })
})
