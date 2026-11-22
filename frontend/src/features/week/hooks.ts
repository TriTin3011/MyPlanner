import { keepPreviousData, useMutation, useQueries, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import type {
  CountDto,
  DayNoteDto,
  DeadlineDto,
  MaterializeRequest,
  TaskDto,
  WeekDashboardDto,
  WeekProgressDto,
} from '../../api/types'
import { getTasksRange, reorderTasks } from '../today/hooks'

// Số liệu đầu trang Kế hoạch tuần (SPEC §9.1): StatStrip, câu nhận xét, insights. BE tính hết, FE chỉ hiện.
// `today` gửi kèm vì THÓI QUEN chỉ tính tới hôm nay và HÔM NAY chỉ khác 0 khi tuần chứa hôm nay.
export async function getWeekDashboard(weekKey: string, today: string) {
  const response = await api.get<WeekDashboardDto>('/dashboard/week', { params: { weekKey, today } })
  return response.data
}

export function useWeekDashboard(weekKey: string, today: string) {
  return useQuery({
    queryKey: keys.dashboard.week(weekKey, today),
    queryFn: () => getWeekDashboard(weekKey, today),
    // Bấm ‹ › đổi key nên cache trống; giữ số của tuần cũ trên màn hình tới khi tuần mới về
    // để header không nhấp nháy thành "Đang tải…" mỗi lần chuyển tuần.
    placeholderData: keepPreviousData,
  })
}

// Tiến độ theo tuần cho biểu đồ "12 tuần" (SPEC §9.2): `count` tuần kết thúc ở tuần `to` (weekKey).
export async function getWeekProgress(to: string, count: number) {
  const response = await api.get<WeekProgressDto[]>('/dashboard/weeks', { params: { to, count } })
  return response.data
}

export function useWeekProgress(to: string, count: number, enabled = true) {
  return useQuery({
    queryKey: keys.dashboard.weeks(to, count),
    queryFn: () => getWeekProgress(to, count),
    enabled,
    placeholderData: keepPreviousData,
  })
}

// Dòng hạn (bước + mục tiêu) trong tuần, SPEC §9.4. "Quá hạn" do BE tính theo `today` client gửi.
export async function getDeadlines(from: string, to: string, today: string) {
  const response = await api.get<DeadlineDto[]>('/deadlines', { params: { from, to, today } })
  return response.data
}

export function useDeadlines(from: string, to: string, today: string) {
  return useQuery({
    queryKey: [...keys.deadlines(from, to), today],
    queryFn: () => getDeadlines(from, to, today),
    placeholderData: keepPreviousData,
  })
}

export async function getDayNote(date: string) {
  const response = await api.get<DayNoteDto>(`/notes/day/${date}`)
  return response.data
}

// Ghi chú của 7 ngày: mỗi ngày một query riêng, dùng đúng key keys.notes.day(date) mà màn Hôm nay đang dùng.
// Nhờ vậy ghi chú sửa ở Hôm nay hay ở Tuần đều invalidate chung một chỗ (useSaveDayNote), không cần endpoint mới.
export function useDayNotes(dates: string[]) {
  return useQueries({
    queries: dates.map((date) => ({ queryKey: keys.notes.day(date), queryFn: () => getDayNote(date) })),
  })
}

// Việc của cả tuần (một request GET /tasks?from&to), FE chỉ chia theo ngày để vẽ cột.
export function groupTasksByDate(tasks: TaskDto[], dates: string[]) {
  const byDate: Record<string, TaskDto[]> = Object.fromEntries(dates.map((d) => [d, []]))
  for (const task of tasks) byDate[task.date]?.push(task)
  for (const date of dates) byDate[date].sort((a, b) => a.order - b.order)
  return byDate
}

export interface ArrangeDayInput {
  date: string
  // Thứ tự mới của cột `date`, có thể chứa việc vừa kéo từ cột khác sang.
  ids: string[]
}

// Kéo thả trên màn Tuần (sắp xếp trong cột hoặc chuyển sang cột khác) chỉ cần MỘT request:
// PUT /tasks/reorder {date, ids} gán Date = date và Order = vị trí cho mọi id (BE làm trong một SaveChanges).
// Optimistic: sửa ngay cache GET /tasks của tuần để thẻ nằm yên ở chỗ mới, lỗi thì trả lại bản cũ.
export function useArrangeWeekTasks(from: string, to: string) {
  const queryClient = useQueryClient()
  const queryKey = keys.tasks.range(from, to)

  return useMutation({
    // Cùng scope → TanStack Query chạy các lần kéo thả nối tiếp, không song song: request sau không về trước
    // request trước, và snapshot rollback của lần sau luôn chụp sau khi lần trước đã ghi.
    scope: { id: `arrange-week-${from}` },
    mutationFn: ({ date, ids }: ArrangeDayInput) => reorderTasks({ date, ids }),
    onMutate: async ({ date, ids }) => {
      await queryClient.cancelQueries({ queryKey })
      const previous = queryClient.getQueryData<TaskDto[]>(queryKey)
      if (previous) {
        const position = new Map(ids.map((id, index) => [id, index]))
        queryClient.setQueryData<TaskDto[]>(
          queryKey,
          previous.map((t) => (position.has(t.id) ? { ...t, date, order: position.get(t.id)! } : t)),
        )
      }
      return { previous }
    },
    onError: (_error, _input, context) => {
      if (context?.previous) queryClient.setQueryData(queryKey, context.previous)
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: keys.tasks.all }),
        queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
        queryClient.invalidateQueries({ queryKey: keys.stats.all }),
      ]),
  })
}

export function useWeekTasks(from: string, to: string) {
  return useQuery({
    queryKey: keys.tasks.range(from, to),
    queryFn: () => getTasksRange(from, to),
    // Như header: giữ cột của tuần cũ trong lúc chờ tuần mới, tránh nhấp nháy.
    placeholderData: keepPreviousData,
  })
}

// SPEC §14.3: trước khi đọc một khoảng ngày, nhờ BE sinh Task từ Việc lặp lại cho khoảng đó.
// Chỉ sinh từ hôm nay trở đi (quá khứ không tự mọc thêm việc), nên tuần đã qua thì bỏ qua.
export function materializeWeek(monday: string, sunday: string, today: string) {
  const from = monday > today ? monday : today
  const request: MaterializeRequest = { from, to: sunday, today }
  return api.post<CountDto>('/recurring/materialize', request).then((r) => r.data)
}

export function useMaterializeWeek() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ monday, sunday, today }: { monday: string; sunday: string; today: string }) =>
      materializeWeek(monday, sunday, today),
    onSuccess: async (result) => {
      if (result.count > 0) {
        await Promise.all([
          queryClient.invalidateQueries({ queryKey: keys.tasks.all }),
          queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
          queryClient.invalidateQueries({ queryKey: keys.stats.all }),
        ])
      }
    },
  })
}
