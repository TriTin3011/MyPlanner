// Logic Pomodoro dạng hàm thuần: nhận trạng thái và thời điểm, trả trạng thái mới, nên test được không cần đồng hồ thật.
// Lưu mốc kết thúc (endsAt) thay vì đếm lùi từng giây, vì trình duyệt làm chậm setInterval khi tab chạy nền.

export type PomodoroMode = 'focus' | 'break'

export interface PomodoroTimer {
  mode: PomodoroMode
  focusMinutes: number
  breakMinutes: number
  endsAt: number | null
  pausedMs: number | null
  sessionsDate: string
  sessionsCount: number
  sound: boolean
}

export const MINUTE_LIMITS: Record<PomodoroMode, { min: number; max: number; step: number }> = {
  focus: { min: 5, max: 120, step: 5 },
  break: { min: 1, max: 30, step: 1 },
}

export const INITIAL_TIMER: PomodoroTimer = {
  mode: 'focus',
  focusMinutes: 25,
  breakMinutes: 5,
  endsAt: null,
  pausedMs: null,
  sessionsDate: '',
  sessionsCount: 0,
  sound: true,
}

export function minutesOf(timer: PomodoroTimer, mode: PomodoroMode) {
  return mode === 'focus' ? timer.focusMinutes : timer.breakMinutes
}

export function durationMs(timer: PomodoroTimer) {
  return minutesOf(timer, timer.mode) * 60_000
}

export function remainingMs(timer: PomodoroTimer, now: number) {
  if (timer.endsAt !== null) return Math.min(durationMs(timer), Math.max(0, timer.endsAt - now))
  return timer.pausedMs ?? durationMs(timer)
}

export function startTimer(timer: PomodoroTimer, now: number): PomodoroTimer {
  return { ...timer, endsAt: now + remainingMs(timer, now), pausedMs: null }
}

export function pauseTimer(timer: PomodoroTimer, now: number): PomodoroTimer {
  return { ...timer, endsAt: null, pausedMs: remainingMs(timer, now) }
}

export function resetTimer(timer: PomodoroTimer): PomodoroTimer {
  return { ...timer, endsAt: null, pausedMs: null }
}

export function switchMode(timer: PomodoroTimer, mode: PomodoroMode): PomodoroTimer {
  return { ...resetTimer(timer), mode }
}

export function skipTimer(timer: PomodoroTimer): PomodoroTimer {
  return switchMode(timer, timer.mode === 'focus' ? 'break' : 'focus')
}

export function sessionsToday(timer: PomodoroTimer, today: string) {
  return timer.sessionsDate === today ? timer.sessionsCount : 0
}

// Hết giờ: chỉ phiên tập trung chạy trọn mới được tính, rồi chuyển sang chế độ kia và chờ người dùng bấm.
export function finishTimer(timer: PomodoroTimer, today: string): PomodoroTimer {
  const next = skipTimer(timer)
  if (timer.mode !== 'focus') return next
  return { ...next, sessionsDate: today, sessionsCount: sessionsToday(timer, today) + 1 }
}

export function changeMinutes(timer: PomodoroTimer, mode: PomodoroMode, direction: -1 | 1): PomodoroTimer {
  if (timer.mode === mode && timer.endsAt !== null) return timer
  const { min, max, step } = MINUTE_LIMITS[mode]
  const minutes = Math.min(max, Math.max(min, minutesOf(timer, mode) + direction * step))
  const changed = mode === 'focus' ? { ...timer, focusMinutes: minutes } : { ...timer, breakMinutes: minutes }
  return timer.mode === mode ? { ...changed, pausedMs: null } : changed
}

export function formatClock(ms: number) {
  const seconds = Math.ceil(ms / 1000)
  return `${Math.floor(seconds / 60)}:${String(seconds % 60).padStart(2, '0')}`
}
