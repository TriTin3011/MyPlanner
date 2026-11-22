import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import type { RecurringTaskDto, SaveRecurringRequest } from '../../api/types'
import { materializeRecurring } from '../today/hooks'

// Việc lặp lại (SPEC §12.2). Quy tắc nằm ở BE; FE chỉ CRUD quy tắc và nhờ BE sinh Task qua materialize.

export async function getRecurring() {
  const response = await api.get<RecurringTaskDto[]>('/recurring')
  return response.data
}

export function useRecurring() {
  return useQuery({ queryKey: keys.recurring, queryFn: getRecurring })
}

export async function createRecurring(request: SaveRecurringRequest) {
  const response = await api.post<RecurringTaskDto>('/recurring', request)
  return response.data
}

export async function updateRecurring({ id, request }: { id: string; request: SaveRecurringRequest }) {
  const response = await api.put<RecurringTaskDto>(`/recurring/${id}`, request)
  return response.data
}

export async function deleteRecurring(id: string) {
  await api.delete(`/recurring/${id}`)
}

// Sau mỗi thay đổi quy tắc: sinh Task cho hôm nay..+7 rồi làm mới danh sách quy tắc và mọi màn có Task.
// Xoá hay tắt quy tắc không xoá các Task đã sinh (giữ lịch sử), chỉ ngừng sinh thêm.
function useRecurringMutation<TInput, TResult>(mutationFn: (input: TInput) => Promise<TResult>, today: string) {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (input: TInput) => {
      const result = await mutationFn(input)
      await materializeRecurring(today)
      return result
    },
    onSuccess: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: keys.recurring }),
        queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
        queryClient.invalidateQueries({ queryKey: keys.tasks.all }),
        queryClient.invalidateQueries({ queryKey: keys.stats.all }),
      ]),
  })
}

export function useCreateRecurring(today: string) {
  return useRecurringMutation(createRecurring, today)
}

export function useUpdateRecurring(today: string) {
  return useRecurringMutation(updateRecurring, today)
}

export function useDeleteRecurring(today: string) {
  return useRecurringMutation(deleteRecurring, today)
}
