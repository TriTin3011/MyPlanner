import { useSyncExternalStore } from 'react'

// Theo dõi một media query CSS (ví dụ '(min-width: 640px)') và render lại khi nó đổi.
// useSyncExternalStore là cách React khuyên dùng để đọc một nguồn dữ liệu bên ngoài React
// (ở đây là trình duyệt) mà không bị lệch giữa các lần render.
export function useMediaQuery(query: string, fallback = true) {
  return useSyncExternalStore(
    (onChange) => {
      if (typeof window === 'undefined' || !window.matchMedia) return () => {}
      const mql = window.matchMedia(query)
      mql.addEventListener('change', onChange)
      return () => mql.removeEventListener('change', onChange)
    },
    () => (typeof window !== 'undefined' && window.matchMedia ? window.matchMedia(query).matches : fallback),
    () => fallback,
  )
}
