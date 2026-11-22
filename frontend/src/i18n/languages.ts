// Danh sách ngôn ngữ app hỗ trợ và cách chọn ngôn ngữ ban đầu. File thuần, không import React/i18next,
// để store/settings.ts dùng được mà không tạo vòng import với i18n/index.ts.
export const LANGUAGES = ['vi', 'en'] as const
export type Language = (typeof LANGUAGES)[number]

// Tên mỗi ngôn ngữ viết bằng chính ngôn ngữ đó (endonym): người không đọc được tiếng Việt vẫn tìm ra "English".
export const LANGUAGE_NAMES: Record<Language, { code: string; name: string }> = {
  vi: { code: 'VI', name: 'Tiếng Việt' },
  en: { code: 'EN', name: 'English' },
}

// Locale đầy đủ cho Intl (ngày, giờ, số): ngôn ngữ giao diện chỉ là "vi", còn Intl cần cả vùng "vi-VN".
export const INTL_LOCALE: Record<Language, string> = { vi: 'vi-VN', en: 'en-US' }

// Lần đầu mở app (chưa từng chọn): lấy ngôn ngữ đầu tiên trong danh sách ưu tiên của trình duyệt mà app hỗ trợ,
// không có thì về tiếng Việt. Khi người dùng đã chọn, lựa chọn lưu trong settings luôn thắng.
export function detectLanguage(preferred: readonly string[] = browserLanguages()): Language {
  for (const tag of preferred) {
    const base = tag.toLowerCase().split('-')[0]
    const hit = LANGUAGES.find((l) => l === base)
    if (hit) return hit
  }
  return 'vi'
}

function browserLanguages(): readonly string[] {
  if (typeof navigator === 'undefined') return []
  return navigator.languages?.length ? navigator.languages : [navigator.language]
}
