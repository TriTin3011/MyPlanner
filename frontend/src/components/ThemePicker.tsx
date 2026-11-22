import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Palette } from 'lucide-react'
import { THEMES, useSettings } from '../store/settings'

// Nút "Bộ màu" ở đáy sidebar (SPEC §3.1, §4.2). Bấm để mở danh sách 4 theme.
// `compact` dùng trong menu ⋯ trên điện thoại: hiện thẳng danh sách, không cần popover.
// Tên theme lấy từ bản dịch theo id (theme.forest...), store chỉ giữ id và màu.
export function ThemePicker({ compact = false }: { compact?: boolean }) {
  const { t } = useTranslation()
  const theme = useSettings((s) => s.theme)
  const setTheme = useSettings((s) => s.setTheme)
  const [open, setOpen] = useState(false)
  const current = THEMES.find((th) => th.id === theme) ?? THEMES[0]

  const list = (
    <ul className="flex flex-col gap-1" role="listbox" aria-label={t('theme.choose')}>
      {THEMES.map((th) => (
        <li key={th.id}>
          <button
            type="button"
            role="option"
            aria-selected={th.id === theme}
            onClick={() => {
              setTheme(th.id)
              setOpen(false)
            }}
            className={`flex min-h-11 w-full items-center gap-3 rounded-full px-3 text-sm font-semibold ${
              th.id === theme ? 'bg-accent-soft' : 'hover:bg-accent-tint'
            }`}
          >
            <Swatch colors={th.swatch} />
            {t(`theme.${th.id}`)}
          </button>
        </li>
      ))}
    </ul>
  )

  if (compact) return list

  return (
    <div className="relative">
      <button
        type="button"
        onClick={() => setOpen((o) => !o)}
        aria-expanded={open}
        className="sketch flex min-h-11 w-full items-center gap-2 px-3 py-2 text-left"
      >
        <Palette size={16} aria-hidden />
        <span className="flex min-w-0 flex-1 flex-col leading-tight max-lg:hidden">
          <span className="text-[10px] font-bold text-ink-muted">{t('theme.label')}</span>
          <span className="truncate text-xs font-bold">{t(`theme.${current.id}`)}</span>
        </span>
        <span className="max-lg:hidden">
          <Swatch colors={current.swatch} />
        </span>
      </button>
      {open && (
        <div className="sketch absolute bottom-full left-0 z-20 mb-2 w-56 p-2">{list}</div>
      )}
    </div>
  )
}

function Swatch({ colors }: { colors: string[] }) {
  return (
    <span className="flex gap-0.5" aria-hidden>
      {colors.map((c) => (
        <span key={c} className="size-3 rounded-full border border-ink/30" style={{ background: c }} />
      ))}
    </span>
  )
}
