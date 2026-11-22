// Thứ theo ISO: 1 = Thứ 2 … 7 = Chủ nhật (SPEC §12.2), khớp DayOfWeek phía BE sau khi đổi CN = 7.
// Tên thứ lấy từ Intl.DateTimeFormat theo locale để tự đổi khi chuyển ngôn ngữ, không giữ mảng tiếng Việt cứng.
const ISO_MONDAY_2026_11_16 = 16

export interface WeekdayOption {
  value: 1 | 2 | 3 | 4 | 5 | 6 | 7
  short: string
  long: string
}

export function getWeekdays(locale = 'vi-VN'): WeekdayOption[] {
  const isVi = locale.toLowerCase().startsWith('vi')
  const shortFmt = new Intl.DateTimeFormat(locale, { weekday: isVi ? 'narrow' : 'short' })
  const longFmt = new Intl.DateTimeFormat(locale, { weekday: 'long' })
  return ([1, 2, 3, 4, 5, 6, 7] as const).map((value) => {
    const date = new Date(2026, 10, ISO_MONDAY_2026_11_16 + value - 1)
    return {
      value,
      short: shortFmt.format(date),
      long: longFmt.format(date),
    }
  })
}

export function formatWeekdays(weekdays: number[], locale = 'vi-VN', everyDayLabel = 'Every day') {
  if (weekdays.length === 7) return everyDayLabel
  return getWeekdays(locale)
    .filter((d) => weekdays.includes(d.value))
    .map((d) => d.short)
    .join(', ')
}
