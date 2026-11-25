import { createBrowserRouter } from 'react-router'
import {
  CalendarDays,
  ChartColumn,
  CircleCheck,
  Mountain,
  Sprout,
  Sun,
  Target,
  type LucideIcon,
} from 'lucide-react'
import { AppShell } from './AppShell'
import { TodayPage } from '../features/today/TodayPage'
import { LoginPage } from '../features/auth/LoginPage'
import { RegisterPage } from '../features/auth/RegisterPage'
import { RequireAuth } from '../features/auth/RequireAuth'
import { FOCUS_ENABLED } from '../features/focus/flag'

import type { vi } from '../i18n/vi'

// Một nguồn duy nhất cho 7 mục điều hướng: sidebar, thanh đáy và router cùng đọc từ đây.
// Không giữ chữ ở đây, chỉ giữ khoá: nhãn đọc lúc render bằng t(`nav.${key}.label`) / t(`nav.${key}.short`)
// (short là nhãn ngắn cho thanh đáy trên điện thoại), nên đổi ngôn ngữ là menu đổi theo.
export interface NavItem {
  path: string
  key: keyof typeof vi.nav
  icon: LucideIcon
}

const ALL_NAV_ITEMS: NavItem[] = [
  { path: '/', key: 'today', icon: Sun },
  { path: '/goals', key: 'goals', icon: Target },
  { path: '/habits', key: 'habits', icon: CircleCheck },
  { path: '/week', key: 'week', icon: CalendarDays },
  { path: '/year', key: 'year', icon: Mountain },
  { path: '/stats', key: 'stats', icon: ChartColumn },
  { path: '/focus', key: 'focus', icon: Sprout },
]

// Tab Tập trung đang tạm ẩn qua FOCUS_ENABLED: lọc ở một chỗ này thì sidebar và thanh đáy cùng mất mục đó.
export const NAV_ITEMS = ALL_NAV_ITEMS.filter((item) => FOCUS_ENABLED || item.key !== 'focus')

// Thanh đáy điện thoại chỉ đủ chỗ cho 5 ô (SPEC §11A): 4 trang dùng hằng ngày + ô "Thêm" mở các trang còn lại.
const MOBILE_PRIMARY_KEYS: NavItem['key'][] = ['today', 'week', 'habits', FOCUS_ENABLED ? 'focus' : 'goals']
export const MOBILE_PRIMARY = MOBILE_PRIMARY_KEYS.map((key) => NAV_ITEMS.find((item) => item.key === key)!)
export const MOBILE_MORE = NAV_ITEMS.filter((item) => !MOBILE_PRIMARY_KEYS.includes(item.key))

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
      // Khi tab bị ẩn, /focus rơi xuống route '*' (về Hôm nay) và chunk FocusPage không bao giờ được tải.
      ...(FOCUS_ENABLED
        ? [
            {
              path: 'focus',
              lazy: () => import('../features/focus/FocusPage').then((m) => ({ Component: m.FocusPage })),
            },
          ]
        : []),
      { path: '*', element: <TodayPage /> },
    ],
  },
])
