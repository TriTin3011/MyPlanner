import { createBrowserRouter } from 'react-router'
import {
  CalendarDays,
  ChartColumn,
  CircleCheck,
  Mountain,
  Sparkles,
  Target,
  type LucideIcon,
} from 'lucide-react'
import { AppShell } from './AppShell'
import { TodayPage } from '../features/today/TodayPage'
import { GoalsPage } from '../features/goals/GoalsPage'
import { HabitsPage } from '../features/habits/HabitsPage'
import { WeekPage } from '../features/week/WeekPage'
import { YearPage } from '../features/year/YearPage'
import { StatsPage } from '../features/stats/StatsPage'
import { LoginPage } from '../features/auth/LoginPage'
import { RequireAuth } from '../features/auth/RequireAuth'

import type { vi } from '../i18n/vi'

// Một nguồn duy nhất cho 6 mục điều hướng: sidebar, thanh đáy và router cùng đọc từ đây.
// Không giữ chữ ở đây, chỉ giữ khoá: nhãn đọc lúc render bằng t(`nav.${key}.label`) / t(`nav.${key}.short`)
// (short là nhãn ngắn cho thanh đáy trên điện thoại), nên đổi ngôn ngữ là menu đổi theo.
export interface NavItem {
  path: string
  key: keyof typeof vi.nav
  icon: LucideIcon
}

export const NAV_ITEMS: NavItem[] = [
  { path: '/', key: 'today', icon: Sparkles },
  { path: '/goals', key: 'goals', icon: Target },
  { path: '/habits', key: 'habits', icon: CircleCheck },
  { path: '/week', key: 'week', icon: CalendarDays },
  { path: '/year', key: 'year', icon: Mountain },
  { path: '/stats', key: 'stats', icon: ChartColumn },
]

// /login đứng riêng, ngoài AppShell. Mọi trang còn lại nằm trong RequireAuth:
// chưa đăng nhập hoặc token hết hạn thì guard chuyển về /login.
// AppShell là layout route: các trang con hiện vào <Outlet /> bên trong main panel.
export const router = createBrowserRouter([
  { path: '/login', element: <LoginPage /> },
  {
    path: '/',
    element: (
      <RequireAuth>
        <AppShell />
      </RequireAuth>
    ),
    children: [
      { index: true, element: <TodayPage /> },
      { path: 'goals', element: <GoalsPage /> },
      { path: 'habits', element: <HabitsPage /> },
      { path: 'week', element: <WeekPage /> },
      { path: 'year', element: <YearPage /> },
      { path: 'stats', element: <StatsPage /> },
      { path: '*', element: <TodayPage /> },
    ],
  },
])
