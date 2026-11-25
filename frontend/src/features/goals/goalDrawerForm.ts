import type { GoalStatus, GoalStepDto, SaveGoalRequest } from '../../api/types'

export interface GoalFormValues {
  title: string
  areaId: string
  status: GoalStatus
  startDate: string
  deadline: string
  reward: string
  why: string
}

export function defaultDeadline(today: string): string {
  const date = new Date(`${today}T00:00:00Z`)
  date.setUTCDate(date.getUTCDate() + 30)
  return date.toISOString().slice(0, 10)
}

// Ngày bắt đầu để trống nghĩa là tính từ hôm nay (ngày tạo mục tiêu).
export function effectiveStartDate(form: Pick<GoalFormValues, 'startDate'>, today: string): string {
  return form.startDate || today
}

export function toSaveRequest(form: GoalFormValues, today: string): SaveGoalRequest {
  return {
    title: form.title.trim(),
    areaId: form.areaId,
    status: form.status,
    startDate: effectiveStartDate(form, today),
    deadline: form.deadline,
    reward: form.reward.trim() || null,
    why: form.why.trim() || null,
  }
}

export function isStepOverdue(step: GoalStepDto, today: string): boolean {
  return !step.done && Boolean(step.deadline && step.deadline < today)
}
