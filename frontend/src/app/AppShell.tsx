import { useEffect, useState } from 'react'
import { NavLink, Outlet } from 'react-router'
import { useTranslation } from 'react-i18next'
import { Clock, MoreHorizontal, X } from 'lucide-react'
import { NAV_ITEMS } from './routes'
import { BrandMark } from '../components/BrandMark'
import { BackupControls } from '../components/BackupControls'
import { LanguageSwitcher } from '../components/LanguageSwitcher'
import { ThemePicker } from '../components/ThemePicker'
import { INTL_LOCALE } from '../i18n/languages'
import { applyTheme, useSettings } from '../store/settings'
import { TopBanner } from '../components/TopBanner'
import { HealthDot } from '../components/HealthDot'

// Khung chung của mọi trang (SPEC §3):
// - Desktop (≥1024px): sidebar 230px + main panel.
// - Tablet (768–1023px): sidebar thu gọn chỉ còn icon.
// - Điện thoại (<768px): thanh trên (logo + menu ⋯) và thanh điều hướng đáy 6 icon.
// Mọi chữ lấy qua t('khoá') của react-i18next: đổi ngôn ngữ thì hook báo component vẽ lại với bản dịch mới.
export function AppShell() {
  const { t } = useTranslation()
  const theme = useSettings((s) => s.theme)
  const [menuOpen, setMenuOpen] = useState(false)

  // Đồng bộ theme (state React) ra DOM (thuộc tính data-theme trên <html>): đúng việc của effect.
  useEffect(() => applyTheme(theme), [theme])

  return (
    <div className="flex h-dvh flex-col bg-app">
      <TopBanner />
      <div className="flex min-h-0 flex-1 gap-4 md:p-4">
        {/* Sidebar: ẩn trên điện thoại */}
        <aside className="sketch hidden w-[72px] shrink-0 flex-col p-3 md:flex lg:w-[230px]">
          <Logo />
          <nav aria-label={t('shell.mainNav')} className="mt-6 flex flex-col gap-1">
            {NAV_ITEMS.map((item) => (
              <NavLink
                key={item.path}
                to={item.path}
                end={item.path === '/'}
                title={t(`nav.${item.key}.label`)}
                className={({ isActive }) =>
                  `flex min-h-11 items-center gap-3 px-3 text-sm max-lg:justify-center ${
                    isActive
                      ? 'sketch sketch--active font-bold'
                      : 'rounded-full font-semibold text-ink-muted hover:bg-accent-tint hover:text-ink'
                  }`
                }
              >
                <item.icon size={18} aria-hidden />
                <span className="max-lg:sr-only">{t(`nav.${item.key}.label`)}</span>
              </NavLink>
            ))}
          </nav>
          <div className="mt-auto flex flex-col gap-3">
            <HealthDot />
            <ClockButton />
            <LanguageSwitcher />
            <ThemePicker />
          </div>
        </aside>

        {/* Main panel: khối lớn nền kẻ ô, cuộn riêng */}
        <main className="sketch paper relative min-w-0 flex-1 overflow-y-auto px-4 pt-3 pb-28 max-md:rounded-none max-md:border-x-0 max-md:shadow-none md:px-5 md:pt-5 md:pb-10 lg:px-7">
          <MobileTopBar onMenu={() => setMenuOpen(true)} />
          <Outlet />
        </main>
      </div>

      {/* Thanh điều hướng đáy: chỉ trên điện thoại */}
      <nav
        aria-label={t('shell.mainNav')}
        className="fixed inset-x-0 bottom-0 z-30 flex border-t-2 border-ink bg-surface pb-[env(safe-area-inset-bottom)] md:hidden"
      >
        {NAV_ITEMS.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            end={item.path === '/'}
            className={({ isActive }) =>
              `flex min-h-14 flex-1 flex-col items-center justify-center gap-0.5 text-[10px] font-bold ${
                isActive ? 'text-primary-ink' : 'text-ink-muted'
              }`
            }
          >
            {({ isActive }) => (
              <>
                <span className={`rounded-full px-3 py-1 ${isActive ? 'bg-accent-soft' : ''}`}>
                  <item.icon size={20} aria-hidden />
                </span>
                {t(`nav.${item.key}.short`)}
              </>
            )}
          </NavLink>
        ))}
      </nav>

      {menuOpen && <MobileMenu onClose={() => setMenuOpen(false)} />}
    </div>
  )
}

// Logo tự thiết kế (cùng hình với public/favicon.svg) + tên app "Mầm". Tên thương hiệu không dịch.
function Logo() {
  return (
    <div className="flex items-center gap-2 max-lg:justify-center">
      <BrandMark size={40} className="shrink-0" />
      <span className="font-display text-2xl leading-none font-extrabold text-primary-ink max-lg:hidden">Mầm</span>
    </div>
  )
}

function ClockButton() {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const [open, setOpen] = useState(false)
  const [now, setNow] = useState(() => new Date())
  useEffect(() => {
    if (!open) return
    const id = setInterval(() => setNow(new Date()), 1000)
    return () => clearInterval(id)
  }, [open])
  return (
    <div className="relative">
      <button
        type="button"
        aria-label={t('shell.showClock')}
        aria-expanded={open}
        onClick={() => {
          setNow(new Date())
          setOpen((o) => !o)
        }}
        className="grid size-11 place-items-center rounded-full text-primary hover:bg-accent-tint"
      >
        <Clock size={20} aria-hidden />
      </button>
      {open && (
        <div className="sketch absolute bottom-full left-0 z-20 mb-2 px-4 py-3 font-display text-2xl font-extrabold whitespace-nowrap">
          {/* Giờ định dạng theo locale: vi-VN "14:05:09", en-US "2:05:09 PM". */}
          {now.toLocaleTimeString(INTL_LOCALE[language])}
        </div>
      )}
    </div>
  )
}

function MobileTopBar({ onMenu }: { onMenu: () => void }) {
  const { t } = useTranslation()
  return (
    <div className="mb-3 flex items-center justify-between md:hidden">
      <Logo />
      <span className="font-display text-lg font-extrabold text-primary-ink">Mầm</span>
      <button
        type="button"
        aria-label={t('shell.openMenu')}
        onClick={onMenu}
        className="ml-auto grid size-11 place-items-center rounded-full hover:bg-accent-tint"
      >
        <MoreHorizontal size={22} aria-hidden />
      </button>
    </div>
  )
}

// Menu ⋯ trên điện thoại: chứa đồng hồ, ngôn ngữ và bộ màu (SPEC §3.4), hiện dạng bottom sheet.
function MobileMenu({ onClose }: { onClose: () => void }) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const [now] = useState(() => new Date())
  return (
    <div className="fixed inset-0 z-40 bg-ink/30 md:hidden" onClick={onClose}>
      <div
        role="dialog"
        aria-label={t('shell.menu')}
        onClick={(e) => e.stopPropagation()}
        className="sketch absolute inset-x-0 bottom-0 p-4 pb-[calc(1rem+env(safe-area-inset-bottom))]"
      >
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-lg font-bold">{t('shell.quickSettings')}</h2>
          <button
            type="button"
            aria-label={t('shell.closeMenu')}
            onClick={onClose}
            className="grid size-11 place-items-center rounded-full hover:bg-accent-tint"
          >
            <X size={20} aria-hidden />
          </button>
        </div>
        <p className="mb-3 font-display text-2xl font-extrabold">
          {now.toLocaleTimeString(INTL_LOCALE[language], { hour: '2-digit', minute: '2-digit' })}
        </p>
        <p className="mb-2 text-xs font-bold tracking-wider text-ink-muted uppercase">{t('language.label')}</p>
        <div className="mb-4">
          <LanguageSwitcher compact />
        </div>
        <p className="mb-2 text-xs font-bold tracking-wider text-ink-muted uppercase">{t('theme.label')}</p>
        <div className="mb-4">
          <ThemePicker compact />
        </div>
        <p className="mb-2 text-xs font-bold tracking-wider text-ink-muted uppercase">{t('backup.label')}</p>
        <BackupControls compact />
      </div>
    </div>
  )
}
