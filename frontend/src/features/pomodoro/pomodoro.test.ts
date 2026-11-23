import { describe, expect, it } from 'vitest'
import {
  changeMinutes,
  finishTimer,
  formatClock,
  INITIAL_TIMER,
  pauseTimer,
  remainingMs,
  sessionsToday,
  skipTimer,
  startTimer,
} from './pomodoro'

describe('pomodoro', () => {
  it('counts down from an end time and keeps the rest when paused', () => {
    const running = startTimer(INITIAL_TIMER, 1000)
    expect(remainingMs(running, 61_000)).toBe(24 * 60_000)
    const paused = pauseTimer(running, 61_000)
    expect(remainingMs(paused, 999_999)).toBe(24 * 60_000)
    expect(remainingMs(startTimer(paused, 100_000), 100_000)).toBe(24 * 60_000)
  })

  it('counts only finished focus sessions and restarts the count on a new day', () => {
    const afterFocus = finishTimer(startTimer(INITIAL_TIMER, 0), '2026-11-24')
    expect(afterFocus.mode).toBe('break')
    expect(afterFocus.endsAt).toBeNull()
    expect(sessionsToday(afterFocus, '2026-11-24')).toBe(1)
    expect(sessionsToday(finishTimer(afterFocus, '2026-11-24'), '2026-11-24')).toBe(1)
    expect(sessionsToday(afterFocus, '2026-11-25')).toBe(0)
    expect(sessionsToday(skipTimer(INITIAL_TIMER), '2026-11-24')).toBe(0)
  })

  it('keeps minutes within limits and locks the running mode', () => {
    expect(changeMinutes(INITIAL_TIMER, 'focus', 1).focusMinutes).toBe(30)
    expect(changeMinutes({ ...INITIAL_TIMER, breakMinutes: 1 }, 'break', -1).breakMinutes).toBe(1)
    const running = startTimer(INITIAL_TIMER, 0)
    expect(changeMinutes(running, 'focus', 1)).toBe(running)
    expect(changeMinutes(running, 'break', 1).breakMinutes).toBe(6)
  })

  it('formats the clock and rounds partial seconds up', () => {
    expect(formatClock(5 * 60_000)).toBe('5:00')
    expect(formatClock(61_001)).toBe('1:02')
    expect(formatClock(0)).toBe('0:00')
  })
})
