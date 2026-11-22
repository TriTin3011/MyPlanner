import { useQuery } from '@tanstack/react-query'
import { api } from './client'
import { keys } from './keys'
import type { HealthDto } from './types'

// Hook kiểm tra backend còn sống (GET /api/health). Gọi lại mỗi 60 giây.
export function useHealth() {
  return useQuery({
    queryKey: keys.health,
    queryFn: async () => (await api.get<HealthDto>('/health')).data,
    refetchInterval: 60_000,
    retry: false,
  })
}
