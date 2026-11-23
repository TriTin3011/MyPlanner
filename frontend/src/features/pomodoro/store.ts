import { useEffect, useState } from 'react'
import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { toLocalDateKey } from '../../lib/dates'
import {
  changeMinutes,
  finishTimer,
  INITIAL_TIMER,
  pauseTimer,
  type PomodoroMode,
  type PomodoroTimer,
  resetTimer,
  skipTimer,
  startTimer,
  switchMode,
} from './pomodoro'

interface PomodoroState extends PomodoroTimer {
  start: () => void
  pause: () => void
  reset: () => void
  skip: () => void
  finish: () => void
  selectMode: (mode: PomodoroMode) => void
  adjust: (mode: PomodoroMode, direction: -1 | 1) => void
  toggleSound: () => void
}

// Store riêng, tách khỏi settings: đây là trạng thái đang chạy, lưu lại để tải lại trang không mất giờ.
export const usePomodoro = create<PomodoroState>()(
  persist(
    (set) => ({
      ...INITIAL_TIMER,
      start: () => set((s) => startTimer(s, Date.now())),
      pause: () => set((s) => pauseTimer(s, Date.now())),
      reset: () => set((s) => resetTimer(s)),
      skip: () => set((s) => skipTimer(s)),
      finish: () => set((s) => finishTimer(s, toLocalDateKey(new Date()))),
      selectMode: (mode) => set((s) => switchMode(s, mode)),
      adjust: (mode, direction) => set((s) => changeMinutes(s, mode, direction)),
      toggleSound: () => set((s) => ({ sound: !s.sound })),
    }),
    { name: 'myplanner-pomodoro' },
  ),
)

function playChime() {
  try {
    const audio = new AudioContext()
    const gain = audio.createGain()
    gain.connect(audio.destination)
    gain.gain.setValueAtTime(0.18, audio.currentTime)
    gain.gain.exponentialRampToValueAtTime(0.001, audio.currentTime + 0.9)
    const tone = audio.createOscillator()
    tone.frequency.value = 880
    tone.connect(gain)
    tone.onended = () => void audio.close()
    tone.start()
    tone.stop(audio.currentTime + 0.9)
  } catch {
    // Trình duyệt chặn âm thanh thì bỏ qua: đồng hồ vẫn chuyển chế độ bình thường.
  }
}

// Giờ hiện tại để vẽ số đếm. Chỉ là nhịp hiển thị, thời gian thật vẫn tính từ mốc endsAt.
export function usePomodoroNow(running: boolean) {
  const [now, setNow] = useState(() => Date.now())
  useEffect(() => {
    if (!running) return
    const id = setInterval(() => setNow(Date.now()), 250)
    return () => clearInterval(id)
  }, [running])
  return [now, setNow] as const
}

// Gắn ở AppShell, nên đồng hồ vẫn chạy và báo khi đã đóng modal hoặc chuyển trang.
export function usePomodoroTicker() {
  const endsAt = usePomodoro((s) => s.endsAt)
  useEffect(() => {
    if (endsAt === null) return
    const id = setInterval(() => {
      if (Date.now() < endsAt) return
      const { sound, finish } = usePomodoro.getState()
      finish()
      if (sound) playChime()
    }, 500)
    return () => clearInterval(id)
  }, [endsAt])
}
