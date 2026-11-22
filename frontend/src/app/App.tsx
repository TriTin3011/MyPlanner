import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { RouterProvider } from 'react-router'
import { router } from './routes'

// QueryClient là "cache tầng ứng dụng" phía client: giữ kết quả các lần gọi API theo query key.
// staleTime 30s: trong 30 giây dữ liệu coi là còn mới, đổi trang qua lại không gọi lại API.
const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 30_000, retry: 1, refetchOnWindowFocus: true },
  },
})

// Gốc của cây component: bọc cache (TanStack Query) rồi tới router.
export function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>
  )
}
