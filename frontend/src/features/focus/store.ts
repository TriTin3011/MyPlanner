import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { FocusSessionDto, PlantKind, PotColor } from '../../api/types'
import {
  buildSession,
  clampMinutes,
  DEFAULT_MINUTES,
  type FocusLink,
  type FocusRun,
  REDUCED_STEP_MS,
  shouldRecordAbandon,
  STEP_MS,
} from './focusSession'

interface FocusState {
  // Lựa chọn ở màn chọn phiên, giữ lại cho lần sau.
  plantKind: PlantKind
  potColor: PotColor
  minutes: number
  link: FocusLink | null
  // Lượt đang trồng (null là đang ở màn chọn).
  run: FocusRun | null
  // Phiên đã xong nhưng chưa gửi được (mất mạng, tắt app): gửi lại sau, Id do client tạo nên gửi trùng vô hại.
  queue: FocusSessionDto[]

  setPlant: (plant: PlantKind) => void
  setPot: (pot: PotColor) => void
  setMinutes: (minutes: number) => void
  setLink: (link: FocusLink | null) => void
  begin: (now: number, reducedMotion: boolean) => void
  startGrowing: (at: number) => void
  complete: () => void
  giveUp: (now: number) => void
  dismiss: () => void
  dequeue: (id: string) => void
}

function finish(run: FocusRun, endedAt: number, outcome: 'completed' | 'abandoned'): FocusRun {
  return { ...run, endedAt, outcome }
}

export const useFocus = create<FocusState>()(
  persist(
    (set) => ({
      plantKind: 'basil',
      potColor: 'terra',
      minutes: DEFAULT_MINUTES,
      link: null,
      run: null,
      queue: [],

      setPlant: (plantKind) => set({ plantKind }),
      setPot: (potColor) => set({ potColor }),
      setMinutes: (minutes) => set({ minutes: clampMinutes(minutes) }),
      setLink: (link) => set({ link }),

      begin: (now, reducedMotion) =>
        set((s) => ({
          run: {
            id: crypto.randomUUID(),
            plantKind: s.plantKind,
            potColor: s.potColor,
            plannedMinutes: clampMinutes(s.minutes),
            link: s.link,
            stepMs: reducedMotion ? REDUCED_STEP_MS : STEP_MS,
            openingStartedAt: now,
            startedAt: null,
            endsAt: null,
            endedAt: null,
            outcome: null,
          },
        })),

      // Đồng hồ chỉ bắt đầu sau phần mở đầu (hoặc khi bấm Bỏ qua).
      startGrowing: (at) =>
        set((s) => {
          if (!s.run || s.run.startedAt !== null) return {}
          return { run: { ...s.run, startedAt: at, endsAt: at + s.run.plannedMinutes * 60_000 } }
        }),

      // Hết giờ: tính đúng mốc endsAt, kể cả khi app mở lại sau đó rất lâu.
      complete: () =>
        set((s) => {
          if (!s.run || s.run.endsAt === null || s.run.outcome !== null) return {}
          const run = finish(s.run, s.run.endsAt, 'completed')
          const body = buildSession(run)
          return { run, queue: body ? [...s.queue, body] : s.queue }
        }),

      giveUp: (now) =>
        set((s) => {
          if (!s.run || s.run.outcome !== null) return {}
          // Bỏ khi còn ở phần mở đầu: chưa trồng gì, quay về màn chọn.
          if (s.run.startedAt === null) return { run: null }
          const run = finish(s.run, now, 'abandoned')
          const body = shouldRecordAbandon(s.run.startedAt, now) ? buildSession(run) : null
          return { run, queue: body ? [...s.queue, body] : s.queue }
        }),

      dismiss: () => set({ run: null }),
      dequeue: (id) => set((s) => ({ queue: s.queue.filter((q) => q.id !== id) })),
    }),
    {
      name: 'myplanner-focus',
      // Không lưu các hàm, chỉ dữ liệu.
      partialize: (s) => ({
        plantKind: s.plantKind,
        potColor: s.potColor,
        minutes: s.minutes,
        link: s.link,
        run: s.run,
        queue: s.queue,
      }),
    },
  ),
)
