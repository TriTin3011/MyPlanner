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
import { LoginPage } from '../features/auth/LoginPage'
import { RegisterPage } from '../features/auth/RegisterPage'
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

// /login và /register đứng riêng, ngoài AppShell. Mọi trang còn lại nằm trong RequireAuth:
// chưa đăng nhập hoặc token hết hạn thì guard chuyển về /login.
// AppShell là layout route: các trang con hiện vào <Outlet /> bên trong main panel.
// Hôm nay và Đăng nhập nạp sẵn (trang mở đầu tiên). Năm trang còn lại tách chunk riêng qua `lazy`:
// router tải file JS của trang khi người dùng vào route đó, nên lần tải đầu nhẹ hơn.
export const router = createBrowserRouter([
  { path: '/login', element: <LoginPage /> },
  { path: '/register', element: <RegisterPage /> },
  {
    path: '/',
    element: (
      <RequireAuth>
        <AppShell />
      </RequireAuth>
    ),
    children: [
      { index: true, element: <TodayPage /> },
      {
        path: 'goals',
        lazy: () => import('../features/goals/GoalsPage').then((m) => ({ Component: m.GoalsPage })),
      },
      {
        path: 'habits',
        lazy: () => import('../features/habits/HabitsPage').then((m) => ({ Component: m.HabitsPage })),
      },
      {
        path: 'week',
        lazy: () => import('../features/week/WeekPage').then((m) => ({ Component: m.WeekPage })),
      },
      {
        path: 'year',
        lazy: () => import('../features/year/YearPage').then((m) => ({ Component: m.YearPage })),
      },
      {
        path: 'stats',
        lazy: () => import('../features/stats/StatsPage').then((m) => ({ Component: m.StatsPage })),
      },
      { path: '*', element: <TodayPage /> },
    ],
  },
])
