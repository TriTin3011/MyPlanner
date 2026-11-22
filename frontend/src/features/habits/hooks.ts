import { keepPreviousData, queryOptions, useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import type { HabitDto, HabitMonthDto } from '../../api/types'
import { toggleHabit } from '../today/hooks'

// Hooks của trang Theo dõi thói quen (SPEC §8). Số liệu (%, chuỗi, đều đặn nhất, đếm theo ngày) do BE tính
// ở GET /dashboard/habits; FE chỉ hiển thị. Tick/bỏ tick dùng lại useToggleHabit của trang Hôm nay.

// "2026-11-22" → "2026-11"
export function monthOf(date: string) {
  return date.slice(0, 7)
}

// Cộng/trừ tháng trên khoá "yyyy-MM" (không dùng Date để khỏi lệch múi giờ).
export function addMonths(month: string, delta: number) {
  const [y, m] = month.split('-').map(Number)
  const index = y * 12 + (m - 1) + delta
  const year = Math.floor(index / 12)
  return `${String(year).padStart(4, '0')}-${String((index % 12) + 1).padStart(2, '0')}`
}

export async function getHabitMonth(month: string, today: string) {
  const { data } = await api.get<HabitMonthDto>('/dashboard/habits', { params: { month, today } })
  return data
}

export const habitMonthQuery = (month: string, today: string) =>
  queryOptions({
    queryKey: keys.dashboard.habits(month, today),
    queryFn: () => getHabitMonth(month, today),
    // Giữ số tháng cũ trong lúc tải tháng mới, trang không nháy về trạng thái "đang tải".
    placeholderData: keepPreviousData,
  })

export function useHabitMonth(month: string, today: string) {
  return useQuery(habitMonthQuery(month, today))
}

// Mọi thay đổi habit ảnh hưởng: danh sách habit, các dashboard (Hôm nay, Tuần, Thói quen) và thống kê.
function useInvalidateHabits() {
  const queryClient = useQueryClient()
  return () =>
    Promise.all([
      queryClient.invalidateQueries({ queryKey: keys.habits }),
      queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
      queryClient.invalidateQueries({ queryKey: keys.stats.all }),
    ])
}

interface CreateHabitInput {
  title: string
  // Ngày địa phương của client; BE mặc định ngày server nếu thiếu (SPEC: "hôm nay" do client gửi).
  startDate: string
}

export async function createHabit({ title, startDate }: CreateHabitInput) {
  const { data } = await api.post<HabitDto>('/habits', { title, active: true, startDate })
  return data
}

export function useCreateHabit() {
  const invalidate = useInvalidateHabits()
  return useMutation({ mutationFn: createHabit, onSuccess: invalidate })
}

export async function deleteHabit(id: string) {
  await api.delete(`/habits/${id}`)
}

export function useDeleteHabit() {
  const invalidate = useInvalidateHabits()
  return useMutation({ mutationFn: deleteHabit, onSuccess: invalidate })
}

interface ReorderHabitsInput {
  ids: string[]
  // Key của tháng đang xem, để cập nhật lạc quan đúng mục cache.
  month: string
  today: string
}

export async function reorderHabits({ ids }: ReorderHabitsInput) {
  await api.put('/habits/reorder', { ids })
}

// Kéo thả đổi thứ tự: xếp lại ngay trong cache (optimistic), lỗi thì trả lại bản cũ, xong thì làm mới từ BE.
export function useReorderHabits() {
  const queryClient = useQueryClient()
  const invalidate = useInvalidateHabits()
  return useMutation({
    mutationFn: reorderHabits,
    onMutate: async ({ ids, month, today }) => {
      const key = keys.dashboard.habits(month, today)
      await queryClient.cancelQueries({ queryKey: key })
      const previous = queryClient.getQueryData<HabitMonthDto>(key)
      if (previous) {
        const byId = new Map(previous.habits.map((h) => [h.id, h]))
        const habits = ids.flatMap((id, order) => {
          const h = byId.get(id)
          return h ? [{ ...h, order }] : []
        })
        queryClient.setQueryData<HabitMonthDto>(key, { ...previous, habits })
      }
      return { key, previous }
    },
    onError: (_error, _input, context) => {
      if (context?.previous) queryClient.setQueryData(context.key, context.previous)
    },
    onSettled: invalidate,
  })
}

interface ToggleCellInput {
  habitId: string
  date: string
  done: boolean
}

// Tick một ô trên lưới. Khác useToggleHabit của Hôm nay ở chỗ cập nhật lạc quan: ô đổi màu ngay,
// còn % và chuỗi chờ BE tính lại (FE không tự tính số). Cùng scope để các lần tick nhanh chạy nối tiếp.
export function useToggleHabitCell(month: string, today: string) {
  const queryClient = useQueryClient()
  const invalidate = useInvalidateHabits()
  const key = keys.dashboard.habits(month, today)
  return useMutation({
    scope: { id: `habit-cells-${month}` },
    mutationFn: (input: ToggleCellInput) => toggleHabit(input),
    onMutate: async ({ habitId, date, done }) => {
      await queryClient.cancelQueries({ queryKey: key })
      const previous = queryClient.getQueryData<HabitMonthDto>(key)
      if (previous) {
        const habits = previous.habits.map((h) => {
          if (h.id !== habitId) return h
          const rest = h.doneDates.filter((d) => d !== date)
          return { ...h, doneDates: done ? [...rest, date] : rest }
        })
        queryClient.setQueryData<HabitMonthDto>(key, { ...previous, habits })
      }
      return { previous }
    },
    onError: (_error, _input, context) => {
      if (context?.previous) queryClient.setQueryData(key, context.previous)
    },
    onSettled: invalidate,
  })
}