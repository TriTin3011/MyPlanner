import { addDays, parseDateKey, startOfWeek } from '../../lib/dates'

export type HabitGridView = 'month' | 'week'

export function getHabitGridDays(from: string, to: string, view: HabitGridView, today: string) {
  if (view === 'month') return listDays(from, to)

  const anchor = today >= from && today <= to ? today : from
  const weekFrom = startOfWeek(anchor)
  const weekTo = addDays(weekFrom, 6)
  return listDays(weekFrom < from ? from : weekFrom, weekTo > to ? to : weekTo)
}

export function weekdayLabel(date: string) {
  return ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'][parseDateKey(date).getDay()]
}

export function isWeekend(date: string) {
  const day = parseDateKey(date).getDay()
  return day === 0 || day === 6
}

function listDays(from: string, to: string) {
  const days: string[] = []
  for (let date = from; date <= to; date = addDays(date, 1)) days.push(date)
  return days
}
