import 'i18next'
import type { vi } from './vi'

// Cho TypeScript biết cấu trúc bản dịch: t('nav.today.label') được gợi ý và kiểm tra,
// gõ sai khoá như t('nav.todya.label') là lỗi biên dịch thay vì hiện chữ "nav.todya.label" lúc chạy.
declare module 'i18next' {
  interface CustomTypeOptions {
    defaultNS: 'translation'
    resources: { translation: typeof vi }
  }
}
