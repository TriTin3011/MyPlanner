import type { MascotMotion } from '../../components/Mascot'

export type TourStepId =
  | 'welcome'
  | 'nav'
  | 'todayAdd'
  | 'todayHabits'
  | 'goalsAdd'
  | 'habitsGrid'
  | 'weekBoard'
  | 'yearBoard'
  | 'statsHero'
  | 'finish'

export interface TourStep {
  id: TourStepId
  // Trang cần mở cho bước này; null là ở nguyên trang hiện tại (phần tử nằm trong khung chung).
  path: string | null
  // Giá trị thuộc tính data-tour của phần tử cần chỉ; null là thẻ nằm giữa màn hình.
  target: string | null
  motion: MascotMotion
}

// Kịch bản tour là dữ liệu thuần: thêm hoặc đổi bước không phải sửa component.
// Chữ không nằm ở đây mà đọc qua t(`tour.steps.${id}.title`) và t(`tour.steps.${id}.body`).
export const TOUR_STEPS: TourStep[] = [
  { id: 'welcome', path: null, target: null, motion: 'idle' },
  { id: 'nav', path: null, target: 'nav', motion: 'idle' },
  { id: 'todayAdd', path: '/', target: 'today-add', motion: 'idle' },
  { id: 'todayHabits', path: '/', target: 'today-habits', motion: 'idle' },
  { id: 'goalsAdd', path: '/goals', target: 'goals-add', motion: 'idle' },
  { id: 'habitsGrid', path: '/habits', target: 'habits-grid', motion: 'idle' },
  { id: 'weekBoard', path: '/week', target: 'week-board', motion: 'idle' },
  { id: 'yearBoard', path: '/year', target: 'year-board', motion: 'idle' },
  { id: 'statsHero', path: '/stats', target: 'stats-hero', motion: 'idle' },
  { id: 'finish', path: null, target: 'help', motion: 'success' },
]
