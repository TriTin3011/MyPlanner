import type { TFunction } from 'i18next'

// "25 phút", "1 giờ", "1 giờ 30". Nhận t làm tham số (hàm thuần, test được, đổi ngôn ngữ là đổi theo).
export function formatFocusMinutes(t: TFunction, minutes: number) {
  if (minutes < 60) return t('focus.duration.minutes', { count: minutes })
  const h = Math.floor(minutes / 60)
  const m = minutes % 60
  return m === 0 ? t('focus.duration.hours', { h }) : t('focus.duration.hoursMinutes', { h, m })
}
