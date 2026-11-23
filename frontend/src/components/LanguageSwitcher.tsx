import { useTranslation } from 'react-i18next'
import { LANGUAGES, LANGUAGE_NAMES } from '../i18n/languages'
import { useSettings } from '../store/settings'

// Nút đổi ngôn ngữ VI | EN. Component chỉ ghi vào settings (nguồn sự thật);
// i18n/index.ts lắng nghe store rồi đổi i18next và <html lang>, mọi component dùng t() tự vẽ lại.
// Sidebar thu gọn (tablet) xếp dọc để vừa 72px; menu ⋯ trên điện thoại xếp ngang.
// `mini` cho đáy sidebar: một nút nhỏ hiện ngôn ngữ đang dùng, bấm là đổi sang ngôn ngữ còn lại.
// Phần nhìn thấy nhỏ, nhưng vùng bấm vẫn 44px để dễ chạm.
export function LanguageSwitcher({ compact = false, mini = false }: { compact?: boolean; mini?: boolean }) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const setLanguage = useSettings((s) => s.setLanguage)

  if (mini) {
    const next = LANGUAGES[(LANGUAGES.indexOf(language) + 1) % LANGUAGES.length]
    const label = t('language.switchTo', { name: LANGUAGE_NAMES[next].name })
    return (
      <button
        type="button"
        aria-label={label}
        title={label}
        onClick={() => setLanguage(next)}
        className="group grid size-11 cursor-pointer place-items-center rounded-xl"
      >
        <span
          aria-hidden="true"
          className="rounded-md border-2 border-ink px-1.5 py-0.5 text-[10px] leading-none font-extrabold text-primary-ink group-hover:bg-accent-tint"
        >
          {LANGUAGE_NAMES[language].code}
        </span>
      </button>
    )
  }

  return (
    <div
      role="group"
      aria-label={t('language.label')}
      className={`sketch flex gap-1 p-1 ${compact ? '' : 'max-lg:flex-col'}`}
    >
      {LANGUAGES.map((lang) => (
        <button
          key={lang}
          type="button"
          // lang trên nút: trình đọc màn hình đọc "English" bằng giọng Anh dù trang đang tiếng Việt.
          lang={lang}
          aria-pressed={lang === language}
          title={LANGUAGE_NAMES[lang].name}
          onClick={() => setLanguage(lang)}
          className={`flex min-h-11 flex-1 cursor-pointer items-center justify-center rounded-xl px-2 text-xs font-bold ${
            lang === language ? 'bg-primary text-white' : 'text-ink-muted hover:bg-accent-tint'
          }`}
        >
          <span aria-hidden="true">{LANGUAGE_NAMES[lang].code}</span>
          <span className="sr-only">{LANGUAGE_NAMES[lang].name}</span>
        </button>
      ))}
    </div>
  )
}
