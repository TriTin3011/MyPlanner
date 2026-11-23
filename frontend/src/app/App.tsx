import { QueryClientProvider } from '@tanstack/react-query'
import { RouterProvider } from 'react-router'
import { ClickEffect } from '../components/ClickEffect'
import { SketchBorders } from '../components/SketchBorders'
import { queryClient } from './queryClient'
import { router } from './routes'

// Gốc của cây component: bọc cache (TanStack Query) rồi tới router.
export function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ClickEffect />
      <SketchBorders />
      <RouterProvider router={router} />
    </QueryClientProvider>
  )
}
