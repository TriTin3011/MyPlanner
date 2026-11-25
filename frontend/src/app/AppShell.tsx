import { useCallback, useEffect, useState } from 'react'
import { createPortal } from 'react-dom'
import { matchPath, NavLink, Outlet, useLocation } from 'react-router'
import { useTranslation } from 'react-i18next'
import { Clock, LayoutGrid, MoreHorizontal, X } from 'lucide-react'
import { MOBILE_MORE, MOBILE_PRIMARY, NAV_ITEMS } from './routes'
import { useFocusTicker } from '../features/focus/hooks'
import { BrandMark } from '../components/BrandMark'
import { BackupControls } from '../components/BackupControls'
import { LanguageSwitcher } from '../components/LanguageSwitcher'
import { ThemePicker } from '../components/ThemePicker'
import { INTL_LOCALE } from '../i18n/languages'
import { useSettings } from '../store/settings'
import { AccountControls } from '../features/auth/AccountControls'
import { MusicBoxIcon } from '../features/music/MusicBoxIcon'
import { MusicPlayer } from '../features/music/MusicPlayer'
import { PomodoroCompact, PomodoroMini } from '../features/pomodoro/PomodoroMini'
import { PomodoroModal } from '../features/pomodoro/PomodoroModal'
import { usePomodoro, usePomodoroTicker } from '../features/pomodoro/store'
import { usePomodoroFloat } from '../features/pomodoro/usePomodoroFloat'
import { TomatoIcon } from '../features/pomodoro/TomatoIcon'
import { TourHost } from '../features/tour/TourHost'

// Khung chung của mọi trang (SPEC §3):
// - Desktop (≥1024px): sidebar 230px + main panel.
// - Tablet (768–1023px): sidebar thu gọn chỉ còn icon.
// - Điện thoại (<768px): thanh trên (logo + menu ⋯) và thanh điều hướng đáy 5 ô (4 trang chính + "Thêm").
// Mọi chữ lấy qua t('khoá') của react-i18next: đổi ngôn ngữ thì hook báo component vẽ lại với bản dịch mới.
export function AppShell() {
  const { t } = useTranslation()
  const [menuOpen, setMenuOpen] = useState(false)
  const [musicOpen, setMusicOpen] = useState(false)
  const [musicPlaying, setMusicPlaying] = useState(false)
  const [pomodoroOpen, setPomodoroOpen] = useState(false)
  usePomodoroTicker()
  useFocusTicker()
  const expandPomodoro = useCallback(() => setPomodoroOpen(true), [])
  const pomodoroFloat = usePomodoroFloat(expandPomodoro)
  const { pathname } = useLocation()
  const activeTab = NAV_ITEMS.findIndex((item) => matchPath({ path: item.path, end: item.path === '/' }, pathname))


  return (
    <div className="flex h-dvh flex-col bg-app">
      <a
        href="#main-content"
        className="sr-only focus:not-sr-only focus:fixed focus:top-2 focus:left-2 focus:z-50 focus:rounded-xl focus:border-2 focus:border-ink focus:bg-primary focus:px-4 focus:py-2 focus:text-sm focus:font-bold focus:text-white focus:outline-none"
      >
        {t('shell.skipToContent')}
      </a>
      <div className="flex min-h-0 flex-1 gap-4 md:p-4">
        {/* Sidebar: ẩn trên điện thoại */}
        <aside className="sketch hidden w-[72px] shrink-0 flex-col p-3 md:flex lg:w-[230px]">
          <Logo />
          {/* Cửa sổ thấp thì chỉ danh sách tab cuộn, cụm điều khiển ở đáy luôn thấy được. */}
          <nav
            data-tour="nav"
            aria-label={t('shell.mainNav')}
            className="relative -mx-1 mt-6 flex min-h-0 flex-1 flex-col gap-1 overflow-x-hidden overflow-y-auto overscroll-none px-1 py-1"
          >
            {/* Một khung duy nhất trượt theo tab đang chọn: mỗi tab cao 44px + khe 4px = 48px. */}
            {activeTab >= 0 && (
              <span
                aria-hidden="true"
                className="nav-pill sketch sketch--active absolute inset-x-1 top-1 h-11"
                style={{ transform: `translateY(${activeTab * 48}px)` }}
              />
            )}
            {NAV_ITEMS.map((item) => (
              <NavLink
                key={item.path}
                to={item.path}
                end={item.path === '/'}
                data-tour={`tab:${item.path}`}
                title={t(`nav.${item.key}.label`)}
                className={({ isActive }) =>
                  `nav-tab relative z-10 flex h-11 shrink-0 items-center gap-3 rounded-xl px-3 text-sm font-bold transition-colors focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none max-lg:justify-center ${
                    isActive ? 'text-ink' : 'text-ink-muted hover:text-ink'
                  }`
                }
              >
                <item.icon size={18} className="nav-tab__icon shrink-0" aria-hidden />
                <span className="truncate max-lg:sr-only">{t(`nav.${item.key}.label`)}</span>
              </NavLink>
            ))}
          </nav>
          <div className="mt-2 flex shrink-0 flex-col gap-3">
            <div className="flex items-center justify-between max-lg:flex-col">
              <div className="flex items-center gap-1 max-lg:flex-col">
                <ClockButton />
                <PomodoroButton onOpen={() => setPomodoroOpen(true)} />
              </div>
              <LanguageSwitcher mini />
            </div>
            <ThemePicker />
            <div className="flex items-center gap-1 max-lg:flex-col">
              <AccountControls />
              <button
                type="button"
                aria-label={t(musicOpen ? 'music.close' : 'music.open')}
                aria-pressed={musicOpen}
                title={t('music.title')}
                onClick={() => setMusicOpen((open) => !open)}
                className={`grid size-11 shrink-0 cursor-pointer place-items-center rounded-xl text-primary hover:bg-accent-tint ${
                  musicOpen ? 'bg-accent-soft' : ''
                }`}
              >
                <MusicBoxIcon playing={musicPlaying} size={30} />
              </button>
            </div>
          </div>
        </aside>

        {/* Main panel: khối lớn nền kẻ ô, cuộn riêng */}
        <main
          id="main-content"
          tabIndex={-1}
          className="sketch paper relative min-w-0 flex-1 overflow-x-hidden overflow-y-auto overscroll-none px-4 pt-3 pb-28 focus:outline-none max-md:rounded-none max-md:border-x-0 max-md:shadow-none md:px-5 md:pt-5 md:pb-10 lg:px-7"
        >
          <MobileTopBar onMenu={() => setMenuOpen(true)} />
          <Outlet />
        </main>
      </div>

      <BottomNav pathname={pathname} />

      {musicOpen && <MusicPlayer onClose={() => setMusicOpen(false)} onPlayingChange={setMusicPlaying} />}
      <PomodoroModal open={pomodoroOpen} onClose={() => setPomodoroOpen(false)} />
      {!pomodoroOpen && !pomodoroFloat.active && (
        <PomodoroMini
          onExpand={expandPomodoro}
          onFloat={pomodoroFloat.supported ? () => void pomodoroFloat.open() : undefined}
        />
      )}
      {/* Portal sang document của cửa sổ PiP: vẫn là cây React này, nên dùng chung store và không cần đồng bộ. */}
      {pomodoroFloat.pipWindow &&
        createPortal(
          <PomodoroCompact
            className="flex h-dvh items-center justify-center gap-1 px-2"
            onExpand={() => {
              pomodoroFloat.close()
              window.focus()
              expandPomodoro()
            }}
          />,
          pomodoroFloat.pipWindow.document.body,
        )}
      <TourHost />
      {menuOpen && (
        <MobileMenu
          onClose={() => setMenuOpen(false)}
          onPomodoro={() => {
            setMenuOpen(false)
            setPomodoroOpen(true)
          }}
          musicPlaying={musicPlaying}
          onMusic={() => {
            setMenuOpen(false)
            setMusicOpen(true)
          }}
        />
      )}
    </div>
  )
}

const BOTTOM_TAB =
  'flex min-h-14 flex-1 cursor-pointer flex-col items-center justify-center gap-0.5 text-[10px] font-bold'

// Thanh điều hướng đáy (chỉ trên điện thoại): 4 trang chính + ô "Thêm" mở menu nhỏ ngay phía trên.
function BottomNav({ pathname }: { pathname: string }) {
  const { t } = useTranslation()
  // Nhớ menu được mở ở trang nào: đổi trang là tự đóng, không cần effect gọi setState.
  const [openOn, setOpenOn] = useState<string | null>(null)
  const moreOpen = openOn === pathname
  const setMoreOpen = (open: boolean) => setOpenOn(open ? pathname : null)
  const moreActive = MOBILE_MORE.some((item) => matchPath({ path: item.path, end: true }, pathname))

  // Esc đóng menu.
  useEffect(() => {
    if (!moreOpen) return
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && setOpenOn(null)
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [moreOpen])

  return (
    <>
      {moreOpen && <div className="fixed inset-0 z-30 md:hidden" onClick={() => setMoreOpen(false)} />}
      <nav
        data-tour="nav"
        aria-label={t('shell.mainNav')}
        className="fixed inset-x-0 bottom-0 z-30 flex border-t-2 border-ink bg-surface pb-[env(safe-area-inset-bottom)] md:hidden"
      >
        {MOBILE_PRIMARY.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            end={item.path === '/'}
            data-tour={`tab:${item.path}`}
            className={({ isActive }) => `${BOTTOM_TAB} ${isActive ? 'text-primary-ink' : 'text-ink-muted'}`}
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
        <div className="relative flex flex-1">
          <button
            type="button"
            aria-label={t('nav.more.label')}
            aria-expanded={moreOpen}
            aria-controls="bottom-nav-more"
            onClick={() => setMoreOpen(!moreOpen)}
            className={`${BOTTOM_TAB} ${moreActive || moreOpen ? 'text-primary-ink' : 'text-ink-muted'}`}
          >
            <span className={`rounded-full px-3 py-1 ${moreActive ? 'bg-accent-soft' : ''}`}>
              <LayoutGrid size={20} aria-hidden />
            </span>
            {t('nav.more.short')}
          </button>
          {moreOpen && (
            <ul
              id="bottom-nav-more"
              className="sketch absolute right-2 bottom-full z-40 mb-3 flex w-52 flex-col gap-1 p-2"
            >
              {MOBILE_MORE.map((item) => (
                <li key={item.path}>
                  <NavLink
                    to={item.path}
                    className={({ isActive }) =>
                      `flex min-h-11 items-center gap-3 rounded-xl px-3 text-sm font-bold ${
                        isActive ? 'bg-accent-soft text-primary-ink' : 'text-ink-muted hover:bg-accent-tint hover:text-ink'
                      }`
                    }
                  >
                    <item.icon size={18} aria-hidden />
                    {t(`nav.${item.key}.label`)}
                  </NavLink>
                </li>
              ))}
            </ul>
          )}
        </div>
      </nav>
    </>
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
        className="grid size-11 place-items-center rounded-xl text-primary hover:bg-accent-tint"
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

// Chấm nhỏ trên quả cà chua báo đồng hồ đang chạy, kể cả khi modal đã đóng.
function PomodoroButton({ onOpen }: { onOpen: () => void }) {
  const { t } = useTranslation()
  const running = usePomodoro((s) => s.endsAt !== null)
  return (
    <button
      type="button"
      aria-label={t(running ? 'pomodoro.openRunning' : 'pomodoro.open')}
      title={t('pomodoro.title')}
      onClick={onOpen}
      className="relative grid size-11 shrink-0 cursor-pointer place-items-center rounded-xl hover:bg-accent-tint"
    >
      <TomatoIcon size={24} />
      {running && (
        <span className="absolute top-1.5 right-1.5 size-2.5 rounded-full border border-surface bg-primary motion-safe:animate-pulse" />
      )}
    </button>
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
        data-tour="help"
        aria-label={t('shell.openMenu')}
        onClick={onMenu}
        className="ml-auto grid size-11 place-items-center rounded-xl hover:bg-accent-tint"
      >
        <MoreHorizontal size={22} aria-hidden />
      </button>
    </div>
  )
}

// Menu ⋯ trên điện thoại: chứa đồng hồ, ngôn ngữ và bộ màu (SPEC §3.4), hiện dạng bottom sheet.
function MobileMenu({
  onClose,
  onMusic,
  onPomodoro,
  musicPlaying,
}: {
  onClose: () => void
  onMusic: () => void
  onPomodoro: () => void
  musicPlaying: boolean
}) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const [now] = useState(() => new Date())
  return (
    <div className="fixed inset-0 z-40 bg-black/40 md:hidden" onClick={onClose}>
      <div
        role="dialog"
        aria-label={t('shell.menu')}
        onClick={(e) => e.stopPropagation()}
        className="sketch absolute inset-x-0 bottom-0 max-h-[calc(100dvh-1rem)] overflow-y-auto p-4 pb-[calc(1rem+env(safe-area-inset-bottom))]"
      >
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-lg font-bold">{t('shell.quickSettings')}</h2>
          <button
            type="button"
            aria-label={t('shell.closeMenu')}
            onClick={onClose}
            className="grid size-11 place-items-center rounded-xl hover:bg-accent-tint"
          >
            <X size={20} aria-hidden />
          </button>
        </div>
        <p className="mb-3 font-display text-2xl font-extrabold">
          {now.toLocaleTimeString(INTL_LOCALE[language], { hour: '2-digit', minute: '2-digit' })}
        </p>
        <button
          type="button"
          onClick={onPomodoro}
          className="mb-1 flex min-h-11 w-full cursor-pointer items-center gap-2 rounded-xl px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint hover:text-ink"
        >
          <TomatoIcon size={24} />
          {t('pomodoro.title')}
        </button>
        <button
          type="button"
          onClick={onMusic}
          className="mb-4 flex min-h-11 w-full cursor-pointer items-center gap-2 rounded-xl px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint hover:text-ink"
        >
          <MusicBoxIcon playing={musicPlaying} size={24} />
          {t('music.title')}
        </button>
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
        <p className="mt-4 mb-2 text-xs font-bold tracking-wider text-ink-muted uppercase">{t('auth.account')}</p>
        <AccountControls compact onBeforeTour={onClose} />
      </div>
    </div>
  )
}
