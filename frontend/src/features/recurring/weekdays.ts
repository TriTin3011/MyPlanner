// Thứ theo ISO: 1 = Thứ 2 … 7 = Chủ nhật (SPEC §12.2), khớp DayOfWeek phía BE sau khi đổi CN = 7.
export const WEEKDAYS = [
  { value: 1, short: 'T2', long: 'Thứ 2' },
  { value: 2, short: 'T3', long: 'Thứ 3' },
  { value: 3, short: 'T4', long: 'Thứ 4' },
  { value: 4, short: 'T5', long: 'Thứ 5' },
  { value: 5, short: 'T6', long: 'Thứ 6' },
  { value: 6, short: 'T7', long: 'Thứ 7' },
  { value: 7, short: 'CN', long: 'Chủ nhật' },
] as const

export function formatWeekdays(weekdays: number[]) {
  if (weekdays.length === 7) return 'Mỗi ngày'
  return WEEKDAYS.filter((d) => weekdays.includes(d.value))
    .map((d) => d.short)
    .join(', ')
}
