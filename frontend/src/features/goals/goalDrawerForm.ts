import type { GoalStatus, GoalStepDto, LifeArea, SaveGoalRequest } from '../../api/types'

export interface GoalFormValues {
  title: string
  area: LifeArea
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

export function toSaveRequest(form: GoalFormValues): SaveGoalRequest {
  return {
    title: form.title.trim(),
    area: form.area,
    status: form.status,
    startDate: form.startDate,
    deadline: form.deadline,
    reward: form.reward.trim() || null,
    why: form.why.trim() || null,
  }
}

export function isStepOverdue(step: GoalStepDto, today: string): boolean {
  return !step.done && Boolean(step.deadline && step.deadline < today)
}
