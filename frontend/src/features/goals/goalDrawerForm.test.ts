import { describe, expect, it } from 'vitest'
import type { GoalStepDto } from '../../api/types'
import { defaultDeadline, isStepOverdue, toSaveRequest, type GoalFormValues } from './goalDrawerForm'

describe('defaultDeadline', () => {
  it('cộng 30 ngày kể cả khi đi qua cuối tháng', () => {
    expect(defaultDeadline('2026-11-22')).toBe('2026-12-22')
  })
})

describe('toSaveRequest', () => {
  it('cắt khoảng trắng và đổi phần thưởng, lý do rỗng thành null', () => {
    const form: GoalFormValues = {
      title: '  Học React  ',
      areaId: 'area-learning',
      status: 'not_started',
      startDate: '2026-11-22',
      deadline: '2026-12-22',
      reward: '   ',
      why: '',
    }

    expect(toSaveRequest(form, '2026-11-20')).toEqual({
      title: 'Học React',
      areaId: 'area-learning',
      status: 'not_started',
      startDate: '2026-11-22',
      deadline: '2026-12-22',
      reward: null,
      why: null,
    })
  })

  it('ngày bắt đầu để trống thì lấy hôm nay', () => {
    const form: GoalFormValues = {
      title: 'Học React',
      areaId: 'area-learning',
      status: 'in_progress',
      startDate: '',
      deadline: '2026-12-22',
      reward: '',
      why: '',
    }

    expect(toSaveRequest(form, '2026-11-24').startDate).toBe('2026-11-24')
  })
})

describe('isStepOverdue', () => {
  const step: GoalStepDto = {
    id: 'step-1',
    title: 'Đọc tài liệu',
    deadline: '2026-11-21',
    done: false,
    doneAt: null,
    order: 0,
  }

  it('chỉ báo quá hạn cho bước chưa xong có hạn trước hôm nay', () => {
    expect(isStepOverdue(step, '2026-11-22')).toBe(true)
    expect(isStepOverdue({ ...step, done: true }, '2026-11-22')).toBe(false)
    expect(isStepOverdue({ ...step, deadline: null }, '2026-11-22')).toBe(false)
    expect(isStepOverdue({ ...step, deadline: '2026-11-22' }, '2026-11-22')).toBe(false)
  })
})
