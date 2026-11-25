import { describe, expect, it } from 'vitest'
import {
  actualMinutes,
  buildSession,
  clampMinutes,
  formatCountdown,
  type FocusRun,
  isUnlocked,
  isWatering,
  openingEndsAt,
  openingStepIndex,
  phaseOf,
  progress,
  sceneDay,
  shouldRecordAbandon,
  STEP_MS,
  toOffsetIso,
} from './focusSession'

const MIN = 60_000
const start = new Date(2026, 10, 24, 9, 0, 0).getTime()

function run(over: Partial<FocusRun> = {}): FocusRun {
  return {
    id: 'a1',
    plantKind: 'basil',
    potColor: 'terra',
    plannedMinutes: 25,
    link: null,
    stepMs: STEP_MS,
    openingStartedAt: start - 6 * STEP_MS,
    startedAt: start,
    endsAt: start + 25 * MIN,
    endedAt: null,
    outcome: null,
    ...over,
  }
}

describe('focusSession', () => {
  it('derives the phase from the run', () => {
    expect(phaseOf(null)).toBe('pick')
    expect(phaseOf(run({ startedAt: null, endsAt: null }))).toBe('opening')
    expect(phaseOf(run())).toBe('growing')
    expect(phaseOf(run({ outcome: 'completed' }))).toBe('done')
    expect(phaseOf(run({ outcome: 'abandoned' }))).toBe('wilted')
  })

  it('walks the six opening steps then stops', () => {
    expect(openingStepIndex(0, 0, STEP_MS)).toBe(0)
    expect(openingStepIndex(STEP_MS * 2.5, 0, STEP_MS)).toBe(2)
    expect(openingStepIndex(STEP_MS * 99, 0, STEP_MS)).toBe(6)
    expect(openingEndsAt({ openingStartedAt: 1000, stepMs: 1000 })).toBe(7000)
  })

  it('maps time to progress and scene day 1..7', () => {
    const end = start + 70 * MIN
    expect(progress(start - 5, start, end)).toBe(0)
    expect(progress(start + 35 * MIN, start, end)).toBe(0.5)
    expect(progress(end + 5, start, end)).toBe(1)
    expect(sceneDay(0)).toBe(1)
    expect(sceneDay(0.5)).toBe(4)
    expect(sceneDay(1)).toBe(7)
  })

  it('waters for three seconds after each quarter', () => {
    const end = start + 100_000
    expect(isWatering(start + 25_000, start, end)).toBe(true)
    expect(isWatering(start + 27_999, start, end)).toBe(true)
    expect(isWatering(start + 28_000, start, end)).toBe(false)
    expect(isWatering(start + 10_000, start, end)).toBe(false)
  })

  it('rounds minutes down and caps at the plan', () => {
    expect(actualMinutes(start, start + 12 * MIN + 59_000, 25)).toBe(12)
    expect(actualMinutes(start, start + 40 * MIN, 25)).toBe(25)
    expect(shouldRecordAbandon(start, start + 59_999)).toBe(false)
    expect(shouldRecordAbandon(start, start + MIN)).toBe(true)
  })

  it('formats the countdown and clamps custom minutes', () => {
    expect(formatCountdown(25 * MIN)).toBe('25:00')
    expect(formatCountdown(500)).toBe('00:01')
    expect(formatCountdown(65 * MIN)).toBe('1:05:00')
    expect(clampMinutes(2)).toBe(5)
    expect(clampMinutes(500)).toBe(180)
    expect(clampMinutes(Number.NaN)).toBe(25)
  })

  it('keeps the local offset in ISO strings', () => {
    const iso = toOffsetIso(start)
    expect(iso.startsWith('2026-11-24T09:00:00')).toBe(true)
    expect(iso).toMatch(/[+-]\d{2}:\d{2}$/)
    expect(new Date(iso).getTime()).toBe(start)
  })

  it('builds the request body with one link and the local start date', () => {
    expect(buildSession(run())).toBeNull()
    const body = buildSession(
      run({ endedAt: start + 25 * MIN, outcome: 'completed', link: { kind: 'habit', id: 'h1', title: 'Đọc' } }),
    )
    expect(body).toMatchObject({
      id: 'a1',
      date: '2026-11-24',
      actualMinutes: 25,
      outcome: 'completed',
      taskId: null,
      habitId: 'h1',
      goalId: null,
    })
  })

  it('treats only the starters as unlocked before the board loads', () => {
    expect(isUnlocked(undefined, 'basil')).toBe(true)
    expect(isUnlocked(undefined, 'cactus')).toBe(false)
    expect(
      isUnlocked([{ kind: 'plant', key: 'cactus', thresholdHours: 20, unlocked: true, hoursRemaining: 0 }], 'cactus'),
    ).toBe(true)
  })
})
