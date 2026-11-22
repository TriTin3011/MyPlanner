import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import type { GoalBoardDto, GoalDto, SaveGoalRequest, SaveGoalStepRequest } from '../../api/types'

// Hooks của trang Mục tiêu (SPEC §7). Hai nguồn dữ liệu:
// - GET /dashboard/goals?today=: read model đã tính sẵn mọi số trên thẻ, chip, radar (FE không tự tính %).
// - GET /goals/{id}: bản đầy đủ (why, các bước) để sửa trong Goal Drawer.
// Mọi lệnh ghi bước trả về cả GoalDto mới: ghi thẳng vào cache chi tiết, rồi làm mới board.

export async function getGoalBoard(today: string) {
  const { data } = await api.get<GoalBoardDto>('/dashboard/goals', { params: { today } })
  return data
}

export function useGoalBoard(today: string) {
  return useQuery({ queryKey: keys.dashboard.goals(today), queryFn: () => getGoalBoard(today) })
}

export async function getGoal(id: string) {
  const { data } = await api.get<GoalDto>(`/goals/${id}`)
  return data
}

// id null = drawer đóng, không gọi API (enabled: false).
export function useGoal(id: string | null) {
  return useQuery({
    queryKey: keys.goals.detail(id ?? ''),
    queryFn: () => getGoal(id!),
    enabled: id !== null,
  })
}

// Mục tiêu ảnh hưởng: board Mục tiêu, dòng hạn ở Tuần/Năm, cờ ⚑ trên lịch Hôm nay, thống kê.
function useInvalidateGoals() {
  const queryClient = useQueryClient()
  return () =>
    Promise.all([
      queryClient.invalidateQueries({ queryKey: keys.goals.all }),
      queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
      queryClient.invalidateQueries({ queryKey: ['deadlines'] }),
      queryClient.invalidateQueries({ queryKey: keys.stats.all }),
    ])
}

// Sau một lệnh ghi trả GoalDto: cập nhật cache chi tiết ngay (drawer không nháy), rồi làm mới phần còn lại.
function useGoalWrite<TInput>(mutationFn: (input: TInput) => Promise<GoalDto>) {
  const queryClient = useQueryClient()
  const invalidate = useInvalidateGoals()
  return useMutation({
    mutationFn,
    onSuccess: (goal) => {
      queryClient.setQueryData(keys.goals.detail(goal.id), goal)
      return invalidate()
    },
  })
}

export function useCreateGoal() {
  return useGoalWrite(async (req: SaveGoalRequest) => (await api.post<GoalDto>('/goals', req)).data)
}

export function useUpdateGoal() {
  return useGoalWrite(
    async ({ id, req }: { id: string; req: SaveGoalRequest }) => (await api.put<GoalDto>(`/goals/${id}`, req)).data,
  )
}

export function useDeleteGoal() {
  const queryClient = useQueryClient()
  const invalidate = useInvalidateGoals()
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(`/goals/${id}`)
      return id
    },
    onSuccess: (id) => {
      queryClient.removeQueries({ queryKey: keys.goals.detail(id) })
      return invalidate()
    },
  })
}

export function useAddStep() {
  return useGoalWrite(
    async ({ goalId, req }: { goalId: string; req: SaveGoalStepRequest }) =>
      (await api.post<GoalDto>(`/goals/${goalId}/steps`, req)).data,
  )
}

export function useUpdateStep() {
  return useGoalWrite(
    async ({ goalId, stepId, req }: { goalId: string; stepId: string; req: SaveGoalStepRequest }) =>
      (await api.put<GoalDto>(`/goals/${goalId}/steps/${stepId}`, req)).data,
  )
}

export function useDeleteStep() {
  return useGoalWrite(
    async ({ goalId, stepId }: { goalId: string; stepId: string }) =>
      (await api.delete<GoalDto>(`/goals/${goalId}/steps/${stepId}`)).data,
  )
}

// Kéo thả bước: xếp lại ngay trong cache chi tiết (optimistic), lỗi thì trả lại bản cũ.
export function useReorderSteps() {
  const queryClient = useQueryClient()
  const invalidate = useInvalidateGoals()
  return useMutation({
    scope: { id: 'goal-steps-reorder' },
    mutationFn: async ({ goalId, ids }: { goalId: string; ids: string[] }) =>
      (await api.put<GoalDto>(`/goals/${goalId}/steps/reorder`, { ids })).data,
    onMutate: async ({ goalId, ids }) => {
      const key = keys.goals.detail(goalId)
      await queryClient.cancelQueries({ queryKey: key })
      const previous = queryClient.getQueryData<GoalDto>(key)
      if (previous) {
        const byId = new Map(previous.steps.map((s) => [s.id, s]))
        const steps = ids.flatMap((id, order) => {
          const s = byId.get(id)
          return s ? [{ ...s, order }] : []
        })
        queryClient.setQueryData<GoalDto>(key, { ...previous, steps })
      }
      return { key, previous }
    },
    onError: (_error, _input, context) => {
      if (context?.previous) queryClient.setQueryData(context.key, context.previous)
    },
    onSuccess: (goal) => {
      queryClient.setQueryData(keys.goals.detail(goal.id), goal)
    },
    onSettled: invalidate,
  })
}

// Tick checkbox trên GoalCard: PUT lại mục tiêu với status done / in_progress. Card chỉ có GoalCardDto
// (thiếu why), nên đọc bản đầy đủ trước rồi mới gửi để không xoá mất "vì sao".
export function useToggleGoalDone() {
  const queryClient = useQueryClient()
  return useGoalWrite(async ({ id, done }: { id: string; done: boolean }) => {
    const goal = await queryClient.fetchQuery({ queryKey: keys.goals.detail(id), queryFn: () => getGoal(id) })
    const req: SaveGoalRequest = {
      title: goal.title,
      area: goal.area,
      status: done ? 'done' : goal.steps.some((s) => s.done) ? 'in_progress' : 'not_started',
      startDate: goal.startDate,
      deadline: goal.deadline,
      reward: goal.reward,
      why: goal.why,
    }
    return (await api.put<GoalDto>(`/goals/${id}`, req)).data
  })
}
