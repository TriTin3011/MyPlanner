// Query key tập trung một chỗ (key factory). Key là "địa chỉ" của một mục trong cache TanStack Query:
// cùng key thì dùng chung cache; invalidate một key cha (vd ['tasks']) làm mới mọi key con.
export const keys = {
  me: ['me'] as const,
  tasks: {
    all: ['tasks'] as const,
    range: (from: string, to: string) => ['tasks', 'range', from, to] as const,
    backlog: (today: string) => ['tasks', 'backlog', today] as const,
  },
  recurring: ['recurring'] as const,
  habits: ['habits'] as const,
  habitLogs: (from: string, to: string) => ['habit-logs', from, to] as const,
  goals: {
    all: ['goals'] as const,
    detail: (id: string) => ['goals', id] as const,
  },
  notes: {
    day: (date: string) => ['notes', 'day', date] as const,
    week: (weekKey: string) => ['notes', 'week', weekKey] as const,
  },
  years: {
    meta: (year: number) => ['years', year, 'meta'] as const,
    items: (year: number) => ['years', year, 'items'] as const,
  },
  dashboard: {
    all: ['dashboard'] as const,
    today: (date: string) => ['dashboard', 'today', date] as const,
    days: (from: string, to: string) => ['dashboard', 'days', from, to] as const,
    week: (weekKey: string, today: string) => ['dashboard', 'week', weekKey, today] as const,
    weeks: (to: string, count: number) => ['dashboard', 'weeks', to, count] as const,
    habits: (month: string, today: string) => ['dashboard', 'habits', month, today] as const,
    goals: (today: string) => ['dashboard', 'goals', today] as const,
    year: (year: number, today: string) => ['dashboard', 'year', year, today] as const,
    focus: (today: string) => ['dashboard', 'focus', today] as const,
  },
  stats: {
    all: ['stats'] as const,
    range: (range: string, today: string) => ['stats', range, today] as const,
  },
  deadlines: (from: string, to: string) => ['deadlines', from, to] as const,
}
