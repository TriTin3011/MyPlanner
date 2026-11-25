import { create } from 'zustand'
import { TOUR_STEPS } from './tourSteps'

// Trạng thái đang chạy của tour, chỉ sống trong bộ nhớ. Việc "đã xem" là cài đặt lâu dài nên nằm ở useSettings.
// Dùng store thay vì useState vì mục mở tour (menu avatar) và overlay nằm ở các nhánh component khác nhau.
interface TourState {
  active: boolean
  index: number
  // Trang lúc mở tour, để kết thúc thì trả người dùng về đúng chỗ.
  origin: string
  start: (origin: string) => void
  next: () => void
  back: () => void
  stop: () => void
}

export const useTour = create<TourState>()((set) => ({
  active: false,
  index: 0,
  origin: '/',
  start: (origin) => set({ active: true, index: 0, origin }),
  next: () => set((s) => ({ index: Math.min(s.index + 1, TOUR_STEPS.length - 1) })),
  back: () => set((s) => ({ index: Math.max(s.index - 1, 0) })),
  stop: () => set({ active: false, index: 0 }),
}))
