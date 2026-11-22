import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'
import { useSettings } from '../store/settings'
import { en } from './en'
import type { Language } from './languages'
import { vi } from './vi'

// Khởi tạo i18next một lần khi app nạp (main.tsx import file này trước khi render).
// - resources: bản dịch đóng gói sẵn trong bundle (app nhỏ, 2 ngôn ngữ), nên init chạy đồng bộ, không chớp chữ.
// - lng: ngôn ngữ đã lưu trong settings (Zustand + localStorage), lần đầu là ngôn ngữ trình duyệt.
// - fallbackLng: khoá nào bản en chưa có thì hiện tiếng Việt thay vì hiện tên khoá.
// - escapeValue: false vì React đã tự escape khi render chuỗi.
i18n.use(initReactI18next).init({
  resources: { vi: { translation: vi }, en: { translation: en } },
  lng: useSettings.getState().language,
  fallbackLng: 'vi',
  interpolation: { escapeValue: false },
  initAsync: false,
})

// Một điểm đồng bộ duy nhất: settings.language (nguồn sự thật) → i18next (để component vẽ lại) và <html lang>
// (để trình đọc màn hình đọc đúng giọng, trình duyệt gạch chính tả đúng ngôn ngữ, Google hiểu trang).
export function applyLanguage(lang: Language) {
  if (i18n.language !== lang) void i18n.changeLanguage(lang)
  document.documentElement.lang = lang
}

applyLanguage(useSettings.getState().language)
useSettings.subscribe((state, prev) => {
  if (state.language !== prev.language) applyLanguage(state.language)
})

export default i18n
