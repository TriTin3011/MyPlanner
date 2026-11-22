import { keepPreviousData, useQuery } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import type { StatsDto } from '../../api/types'
import type { StatsRange } from '../../store/settings'

// GET /api/stats?range=&today= (SPEC §11, §14.2): một read model cho cả trang.
// keepPreviousData: đổi khoảng thời gian thì số cũ vẫn hiện (mờ đi) tới khi số mới về, không nháy trắng.
export async function getStats(range: StatsRange, today: string) {
  const { data } = await api.get<StatsDto>('/stats', { params: { range, today } })
  return data
}

export function useStats(range: StatsRange, today: string) {
  return useQuery({
    queryKey: keys.stats.range(range, today),
    queryFn: () => getStats(range, today),
    placeholderData: keepPreviousData,
  })
}