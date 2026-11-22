import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import type {
  CreateYearItemRequest,
  SaveYearMetaRequest,
  UpdateYearItemRequest,
  YearDashboardDto,
  YearMetaDto,
  YearPlanItemDto,
} from '../../api/types'

// Hooks của trang Kế hoạch năm (SPEC §10). Một nguồn đọc duy nhất: GET /dashboard/year?year=&today=
// trả từ khoá, tầm nhìn, % cả năm và 12 tháng (đã đếm sẵn, kèm dòng hạn). FE không tự đếm x/y.

export async function getYearBoard(year: number, today: string) {
  const { data } = await api.get<YearDashboardDto>('/dashboard/year', { params: { year, today } })
  return data
}

// keepPreviousData: bấm ‹ › đổi năm thì giữ năm cũ trên màn hình tới khi năm mới về (không nháy trắng).
export function useYearBoard(year: number, today: string) {
  return useQuery({
    queryKey: keys.dashboard.year(year, today),
    queryFn: () => getYearBoard(year, today),
    placeholderData: keepPreviousData,
  })
}

// Kế hoạch năm ảnh hưởng: board năm, cache /years, thống kê.
function useInvalidateYear() {
  const queryClient = useQueryClient()
  return () =>
    Promise.all([
      queryClient.invalidateQueries({ queryKey: ['dashboard', 'year'] }),
      queryClient.invalidateQueries({ queryKey: ['years'] }),
      queryClient.invalidateQueries({ queryKey: keys.stats.all }),
    ])
}

// Ghi từ khoá + tầm nhìn (autosave). Không invalidate board để ô đang gõ không bị ghi đè giữa chừng;
// chỉ vá trường tương ứng trong mọi cache board của năm đó.
export function useSaveYearMeta(year: number) {
  const queryClient = useQueryClient()
  return useMutation({
    scope: { id: `year-meta-${year}` },
    mutationFn: async (req: SaveYearMetaRequest) => (await api.put<YearMetaDto>(`/years/${year}`, req)).data,
    onSuccess: (meta) => {
      queryClient.setQueriesData<YearDashboardDto>({ queryKey: ['dashboard', 'year', year] }, (old) =>
        old ? { ...old, keyword: meta.keyword, vision: meta.vision } : old,
      )
      queryClient.setQueryData(keys.years.meta(year), meta)
    },
  })
}

export function useCreateYearItem(year: number) {
  const invalidate = useInvalidateYear()
  return useMutation({
    mutationFn: async (req: CreateYearItemRequest) =>
      (await api.post<YearPlanItemDto>(`/years/${year}/items`, req)).data,
    onSuccess: invalidate,
  })
}

// Tick / sửa tên: vá ngay trong cache (optimistic) để checkbox phản hồi tức thì, server đếm lại x/y sau.
export function useUpdateYearItem(year: number, today: string) {
  const queryClient = useQueryClient()
  const invalidate = useInvalidateYear()
  const key = keys.dashboard.year(year, today)
  return useMutation({
    mutationFn: async ({ id, req }: { id: string; req: UpdateYearItemRequest }) =>
      (await api.put<YearPlanItemDto>(`/year-items/${id}`, req)).data,
    onMutate: async ({ id, req }) => {
      await queryClient.cancelQueries({ queryKey: key })
      const previous = queryClient.getQueryData<YearDashboardDto>(key)
      if (previous) {
        queryClient.setQueryData<YearDashboardDto>(key, {
          ...previous,
          months: previous.months.map((m) => ({
            ...m,
            items: m.items.map((it) => (it.id === id ? { ...it, title: req.title, done: req.done } : it)),
          })),
        })
      }
      return { previous }
    },
    onError: (_error, _input, context) => {
      if (context?.previous) queryClient.setQueryData(key, context.previous)
    },
    onSettled: invalidate,
  })
}

export function useDeleteYearItem(year: number, today: string) {
  const queryClient = useQueryClient()
  const invalidate = useInvalidateYear()
  const key = keys.dashboard.year(year, today)
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(`/year-items/${id}`)
    },
    onMutate: async (id) => {
      await queryClient.cancelQueries({ queryKey: key })
      const previous = queryClient.getQueryData<YearDashboardDto>(key)
      if (previous) {
        queryClient.setQueryData<YearDashboardDto>(key, {
          ...previous,
          months: previous.months.map((m) => ({ ...m, items: m.items.filter((it) => it.id !== id) })),
        })
      }
      return { previous }
    },
    onError: (_error, _id, context) => {
      if (context?.previous) queryClient.setQueryData(key, context.previous)
    },
    onSettled: invalidate,
  })
}

// Hàm thuần: đưa danh sách `ids` vào tháng `month` theo đúng thứ tự, gỡ chúng khỏi tháng cũ.
// Tách riêng để test được mà không cần React.
export function applyYearReorder(board: YearDashboardDto, month: number, ids: string[]): YearDashboardDto {
  const byId = new Map(board.months.flatMap((m) => m.items).map((it) => [it.id, it]))
  const moving = new Set(ids)
  return {
    ...board,
    months: board.months.map((m) => {
      if (m.month === month) {
        const items = ids.flatMap((id, order) => {
          const it = byId.get(id)
          return it ? [{ ...it, month, order }] : []
        })
        return { ...m, items }
      }
      return { ...m, items: m.items.filter((it) => !moving.has(it.id)) }
    }),
  }
}

// Kéo thả trong một tháng hoặc sang tháng khác: một lệnh PUT {month, ids} là thứ tự mới của tháng đích.
// scope xếp hàng các lần kéo liên tiếp để server nhận đúng thứ tự.
export function useReorderYearItems(year: number, today: string) {
  const queryClient = useQueryClient()
  const invalidate = useInvalidateYear()
  const key = keys.dashboard.year(year, today)
  return useMutation({
    scope: { id: `year-reorder-${year}` },
    mutationFn: async ({ month, ids }: { month: number; ids: string[] }) => {
      await api.put(`/years/${year}/items/reorder`, { month, ids })
    },
    onMutate: async ({ month, ids }) => {
      await queryClient.cancelQueries({ queryKey: key })
      const previous = queryClient.getQueryData<YearDashboardDto>(key)
      if (previous) queryClient.setQueryData(key, applyYearReorder(previous, month, ids))
      return { previous }
    },
    onError: (_error, _input, context) => {
      if (context?.previous) queryClient.setQueryData(key, context.previous)
    },
    onSettled: invalidate,
  })
}
