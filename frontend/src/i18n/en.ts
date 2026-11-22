import type { vi } from './vi'

// Cùng "hình dạng" với vi nhưng giá trị là string bất kỳ: thiếu hoặc thừa khoá là lỗi biên dịch,
// nên không thể quên dịch một nhãn mới (giống implement đủ một interface bên C#).
type Messages<T> = { [K in keyof T]: T[K] extends string ? string : Messages<T[K]> }

export const en: Messages<typeof vi> = {
  nav: {
    today: { label: 'Today', short: 'Today' },
    goals: { label: 'Goals & vision', short: 'Goals' },
    habits: { label: 'Habit tracker', short: 'Habits' },
    week: { label: 'Weekly plan', short: 'Week' },
    year: { label: 'Yearly plan', short: 'Year' },
    stats: { label: 'Statistics', short: 'Stats' },
  },
  shell: {
    mainNav: 'Main navigation',
    openMenu: 'Open menu',
    closeMenu: 'Close menu',
    menu: 'Menu',
    quickSettings: 'Quick settings',
    showClock: 'Show time',
  },
  theme: {
    label: 'Color theme',
    choose: 'Choose a color theme',
    forest: 'Forest',
    ocean: 'Night ocean',
    sunset: 'Sunset',
    lavender: 'Lavender',
  },
  language: {
    label: 'Language',
  },
  health: {
    pending: 'Checking API…',
    down: 'Cannot reach the API',
    degraded: 'API is up, database error',
    ok: 'Connected to API',
  },
}
