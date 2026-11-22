import { QueryClient } from '@tanstack/react-query'

// QueryClient là "cache tầng ứng dụng" phía client: giữ kết quả các lần gọi API theo query key.
// staleTime 30s: trong 30 giây dữ liệu coi là còn mới, đổi trang qua lại không gọi lại API.
// Tách ra module riêng để chỗ không phải component (đăng xuất trong store phiên) cũng xoá được cache.
export const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 30_000, retry: 1, refetchOnWindowFocus: true },
  },
})
