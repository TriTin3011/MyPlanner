import { toLocalDateKey } from '../../lib/dates'
import type { FocusOutcome, FocusSessionDto, FocusUnlockDto, PlantKind, PotColor } from '../../api/types'

// Hàm thuần của tab Tập trung (SPEC §11A). Không đọc đồng hồ, không đụng store: nhận "now" làm tham số
// nên test được bằng số cố định, giống Core/Domain bên backend.

export const PRESET_MINUTES = [15, 25, 45, 60] as const
export const MIN_MINUTES = 5
export const MAX_MINUTES = 180
export const DEFAULT_MINUTES = 25

export const PLANTS: PlantKind[] = ['basil', 'sunflower', 'cactus']
export const POTS: PotColor[] = ['terra', 'cream', 'sage', 'blue']

// Sáu động tác mở đầu bằng tay, mỗi động tác ~3,3 giây (1 giây khi giảm chuyển động).
export const OPENING_STEPS = ['soil', 'seed', 'cover', 'water', 'press', 'carry'] as const
export type OpeningStep = (typeof OPENING_STEPS)[number]
export const STEP_MS = 3300
export const REDUCED_STEP_MS = 1000

export const SCENE_DAYS = 7
export const WATER_MARKS = [0.25, 0.5, 0.75] as const
export const WATER_MS = 3000
// Bỏ cuộc trước 1 phút không ghi phiên: bấm nhầm không làm bẩn số liệu.
export const MIN_ABANDON_MS = 60_000

export type FocusLinkKind = 'task' | 'habit' | 'goal'
export interface FocusLink {
  kind: FocusLinkKind
  id: string
  title: string
}

// Một lượt trồng. Các mốc là epoch ms; startedAt/endsAt chỉ có sau phần mở đầu.
export interface FocusRun {
  id: string
  plantKind: PlantKind
  potColor: PotColor
  plannedMinutes: number
  link: FocusLink | null
  stepMs: number
  openingStartedAt: number
  startedAt: number | null
  endsAt: number | null
  endedAt: number | null
  outcome: FocusOutcome | null
}

export type FocusPhase = 'pick' | 'opening' | 'growing' | 'done' | 'wilted'

export function phaseOf(run: FocusRun | null): FocusPhase {
  if (!run) return 'pick'
  if (run.startedAt === null) return 'opening'
  if (run.outcome === null) return 'growing'
  return run.outcome === 'completed' ? 'done' : 'wilted'
}

export function clampMinutes(value: number) {
  if (!Number.isFinite(value)) return DEFAULT_MINUTES
  return Math.min(MAX_MINUTES, Math.max(MIN_MINUTES, Math.round(value)))
}

// Chỉ số động tác mở đầu đang diễn ra; bằng OPENING_STEPS.length nghĩa là đã xong.
export function openingStepIndex(now: number, openingStartedAt: number, stepMs: number) {
  const index = Math.floor(Math.max(0, now - openingStartedAt) / stepMs)
  return Math.min(OPENING_STEPS.length, index)
}

export function openingEndsAt(run: Pick<FocusRun, 'openingStartedAt' | 'stepMs'>) {
  return run.openingStartedAt + OPENING_STEPS.length * run.stepMs
}

// p trong [0, 1]: phần thời gian đã trôi.
export function progress(now: number, startedAt: number, endsAt: number) {
  if (endsAt <= startedAt) return 1
  return Math.min(1, Math.max(0, (now - startedAt) / (endsAt - startedAt)))
}

// Ngày trong cảnh: 7 ngày giả lập trải đều suốt phiên, từ 1 tới 7.
export function sceneDay(p: number) {
  return Math.min(SCENE_DAYS, Math.floor(p * SCENE_DAYS) + 1)
}

// Tưới khoảng 3 giây ngay sau các mốc 25/50/75%.
export function isWatering(now: number, startedAt: number, endsAt: number) {
  const duration = endsAt - startedAt
  return WATER_MARKS.some((mark) => {
    const at = startedAt + mark * duration
    return now >= at && now < at + WATER_MS
  })
}

export function remainingMs(now: number, endsAt: number) {
  return Math.max(0, endsAt - now)
}

// 24:59 khi dưới 1 giờ, 1:04:59 khi từ 1 giờ trở lên. Làm tròn lên để giây cuối vẫn hiện 00:01.
export function formatCountdown(ms: number) {
  const total = Math.ceil(ms / 1000)
  const h = Math.floor(total / 3600)
  const m = Math.floor((total % 3600) / 60)
  const s = total % 60
  const pad = (n: number) => String(n).padStart(2, '0')
  return h > 0 ? `${h}:${pad(m)}:${pad(s)}` : `${pad(m)}:${pad(s)}`
}

// Số phút thực tế, làm tròn xuống, không vượt số phút đã đặt (backend cũng kiểm luật này).
export function actualMinutes(startedAt: number, endedAt: number, plannedMinutes: number) {
  return Math.min(plannedMinutes, Math.max(0, Math.floor((endedAt - startedAt) / 60_000)))
}

export function shouldRecordAbandon(startedAt: number, now: number) {
  return now - startedAt >= MIN_ABANDON_MS
}

// ISO kèm độ lệch giờ địa phương (2026-11-24T09:00:00+07:00), không đổi về UTC:
// backend lưu DateTimeOffset nên giữ được giờ người dùng thấy.
export function toOffsetIso(ms: number) {
  const d = new Date(ms)
  const pad = (n: number) => String(Math.trunc(Math.abs(n))).padStart(2, '0')
  const offset = -d.getTimezoneOffset()
  const sign = offset >= 0 ? '+' : '-'
  return (
    `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}` +
    `T${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}` +
    `${sign}${pad(offset / 60)}:${pad(offset % 60)}`
  )
}

// Dựng body cho POST /focus/sessions từ một lượt đã kết thúc.
export function buildSession(run: FocusRun): FocusSessionDto | null {
  if (run.startedAt === null || run.endedAt === null || run.outcome === null) return null
  return {
    id: run.id,
    startedAt: toOffsetIso(run.startedAt),
    endedAt: toOffsetIso(run.endedAt),
    date: toLocalDateKey(new Date(run.startedAt)),
    plannedMinutes: run.plannedMinutes,
    actualMinutes: actualMinutes(run.startedAt, run.endedAt, run.plannedMinutes),
    outcome: run.outcome,
    plantKind: run.plantKind,
    potColor: run.potColor,
    taskId: run.link?.kind === 'task' ? run.link.id : null,
    habitId: run.link?.kind === 'habit' ? run.link.id : null,
    goalId: run.link?.kind === 'goal' ? run.link.id : null,
  }
}

// Mở khoá do backend tính; khi chưa có dữ liệu thì chỉ coi hai món khởi đầu là mở.
export function isUnlocked(unlocks: FocusUnlockDto[] | undefined, key: string) {
  const found = unlocks?.find((u) => u.key === key)
  if (!found) return key === 'basil' || key === 'terra'
  return found.unlocked
}
