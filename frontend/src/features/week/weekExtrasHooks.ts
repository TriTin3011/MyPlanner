import { queryOptions, useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import type { SaveNoteRequest, WeekDeleteResultDto, WeekNoteDto } from '../../api/types'

interface SaveWeekNoteInput {
  weekKey: string
  content: string
}

export async function getWeekNote(weekKey: string) {
  const response = await api.get<WeekNoteDto>(`/notes/week/${weekKey}`)
  return response.data
}

export function weekNoteQueryOptions(weekKey: string) {
  return queryOptions({
    queryKey: keys.notes.week(weekKey),
    queryFn: () => getWeekNote(weekKey),
    enabled: Boolean(weekKey),
  })
}

export function useWeekNote(weekKey: string) {
  return useQuery(weekNoteQueryOptions(weekKey))
}

export async function saveWeekNote({ weekKey, content }: SaveWeekNoteInput) {
  const request: SaveNoteRequest = { content }
  const response = await api.put<WeekNoteDto>(`/notes/week/${weekKey}`, request)
  return response.data
}

export function useSaveWeekNote() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: saveWeekNote,
    onSuccess: async (_data, variables) => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: keys.notes.week(variables.weekKey) }),
        queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
      ])
    },
  })
}

export async function deleteWeekData(weekKey: string) {
  const response = await api.delete<WeekDeleteResultDto>(`/weeks/${weekKey}`)
  return response.data
}

export function useDeleteWeek() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: deleteWeekData,
    onSuccess: async () => {
      // Xóa tuần ảnh hưởng dữ liệu tổng hợp ở nhiều màn hình.
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: keys.tasks.all }),
        queryClient.invalidateQueries({ queryKey: ['notes'] }),
        queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
        queryClient.invalidateQueries({ queryKey: keys.stats.all }),
        queryClient.invalidateQueries({ queryKey: ['deadlines'] }),
      ])
    },
  })
}
