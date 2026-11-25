import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { detectLanguage, type Language } from '../i18n/languages'

// Cài đặt giao diện (SPEC §12.7). Chỉ lưu ở localStorage của trình duyệt này,
// không gửi lên backend. Dữ liệu nghiệp vụ (việc, thói quen...) luôn lấy từ API.

export type ThemeId = 'forest' | 'ocean' | 'sunset' | 'lavender'
export type ChartMode = 'line' | 'bar' | 'table'
export type TodayBlockId = 'progress' | 'backlog' | 'tasks' | 'habits' | 'calendar'
export type StatsRange = '4w' | '8w' | '12w' | '6m' | '1y'

// Tên hiển thị của theme nằm trong bản dịch (theme.<id>), ở đây chỉ giữ id và màu mẫu.
export const THEMES: { id: ThemeId; swatch: string[] }[] = [
  { id: 'forest', swatch: ['#0A4D37', '#0B7A55', '#B7F0D8', '#EEF4E8'] },
  { id: 'ocean', swatch: ['#1E3A8A', '#1D4ED8', '#BFDBFE', '#EEF2FB'] },
  { id: 'sunset', swatch: ['#7C2D12', '#C2410C', '#FED7AA', '#FBF1EA'] },
  { id: 'lavender', swatch: ['#4C1D95', '#6D28D9', '#DDD6FE', '#F3F0FB'] },
]

export const DEFAULT_TODAY_LAYOUT: { id: TodayBlockId; hidden: boolean }[] = [
  { id: 'progress', hidden: false },
  { id: 'backlog', hidden: false },
  { id: 'tasks', hidden: false },
  { id: 'habits', hidden: false },
  { id: 'calendar', hidden: false },
]

interface SettingsState {
  theme: ThemeId
  language: Language
  todayLayout: { id: TodayBlockId; hidden: boolean }[]
  chartModes: Record<string, ChartMode>
  chartRanges: Record<string, string>
  statsRange: StatsRange
  lastExportAt?: string
  lastBackupAt?: string
  musicUrl?: string
  setMusicUrl: (url: string) => void
  musicFrame?: { x: number; y: number; width: number }
  setMusicFrame: (frame: { x: number; y: number; width: number }) => void
  // Tài khoản nào đã xem hoặc bỏ qua tour trên trình duyệt này (khoá là userName).
  tourSeen: Record<string, true>
  markTourSeen: (userName: string) => void
  setTheme: (theme: ThemeId) => void
  setLanguage: (language: Language) => void
  setTodayLayout: (layout: { id: TodayBlockId; hidden: boolean }[]) => void
  setChartMode: (chartId: string, mode: ChartMode) => void
  setChartRange: (chartId: string, range: string) => void
  setStatsRange: (range: StatsRange) => void
  setLastExportAt: (iso: string) => void
  markBackup: () => void
}

export const useSettings = create<SettingsState>()(
  persist(
    (set) => ({
      theme: 'forest',
      // Chưa lưu thì đoán theo trình duyệt; persist ghi đè bằng giá trị đã lưu khi có.
      language: detectLanguage(),
      todayLayout: DEFAULT_TODAY_LAYOUT,
      chartModes: {},
      chartRanges: {},
      statsRange: '8w',
      setMusicUrl: (musicUrl) => set({ musicUrl }),
      setMusicFrame: (musicFrame) => set({ musicFrame }),
      tourSeen: {},
      markTourSeen: (userName) => set((s) => ({ tourSeen: { ...s.tourSeen, [userName]: true } })),
      setTheme: (theme) => set({ theme }),
      setLanguage: (language) => set({ language }),
      setTodayLayout: (todayLayout) => set({ todayLayout }),
      setChartMode: (chartId, mode) =>
        set((s) => ({ chartModes: { ...s.chartModes, [chartId]: mode } })),
      setChartRange: (chartId, range) =>
        set((s) => ({ chartRanges: { ...s.chartRanges, [chartId]: range } })),
      setStatsRange: (statsRange) => set({ statsRange }),
      setLastExportAt: (lastExportAt) => set({ lastExportAt, lastBackupAt: lastExportAt }),
      markBackup: () => {
        const now = new Date().toISOString()
        set({ lastExportAt: now, lastBackupAt: now })
      },
    }),
    { name: 'myplanner-settings' },
  ),
)

// Áp theme lên <html data-theme="...">. Gọi một lần khi khởi động và mỗi khi đổi theme.
export function applyTheme(theme: ThemeId) {
  if (theme === 'forest') delete document.documentElement.dataset.theme
  else document.documentElement.dataset.theme = theme
}
