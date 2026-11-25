import { useEffect, useId, useRef, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useLocation } from 'react-router'
import { CircleHelp, LogOut, UserRound } from 'lucide-react'
import { logout } from '../../api/client'
import { useTour } from '../tour/store'
import { ProfileModal } from './ProfileModal'
import { useDisplayName } from './session'
import { useCurrentUser } from './useProfile'
import { UserAvatar } from './UserAvatar'

const ITEM_CLASS =
  'flex min-h-11 w-full cursor-pointer items-center gap-2 rounded-xl px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint hover:text-ink'

// Avatar ở đáy sidebar, bấm để mở menu Hồ sơ, Hướng dẫn sử dụng và Đăng xuất. Trong menu ⋯ trên điện thoại (`compact`)
// đã có sẵn một bảng nên hiện thẳng các mục; `onBeforeTour` đóng bảng đó trước khi tour chạy để không che phần tử được chỉ.
// Đăng xuất xoá phiên ở client rồi báo server thu hồi; store đổi thì RequireAuth tự về /login.
// Dùng mẫu disclosure (nút + aria-expanded) thay vì role="menu", vì role đó buộc phải tự làm điều hướng phím mũi tên.
export function AccountControls({ compact = false, onBeforeTour }: { compact?: boolean; onBeforeTour?: () => void }) {
  const { t } = useTranslation()
  const { pathname } = useLocation()
  const startTour = useTour((s) => s.start)
  const userName = useDisplayName()
  const avatarUrl = useCurrentUser().data?.avatarUrl
  const [open, setOpen] = useState(false)
  const [profileOpen, setProfileOpen] = useState(false)
  const rootRef = useRef<HTMLDivElement>(null)
  const triggerRef = useRef<HTMLButtonElement>(null)
  const panelId = useId()

  // Chỉ nghe sự kiện toàn trang khi menu đang mở, và gỡ ngay khi đóng.
  useEffect(() => {
    if (!open) return
    const onPointerDown = (event: PointerEvent) => {
      if (!rootRef.current?.contains(event.target as Node)) setOpen(false)
    }
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') return
      setOpen(false)
      triggerRef.current?.focus()
    }
    document.addEventListener('pointerdown', onPointerDown)
    document.addEventListener('keydown', onKeyDown)
    return () => {
      document.removeEventListener('pointerdown', onPointerDown)
      document.removeEventListener('keydown', onKeyDown)
    }
  }, [open])

  const items = (
    <>
      <button
        type="button"
        className={ITEM_CLASS}
        onClick={() => {
          setOpen(false)
          setProfileOpen(true)
        }}
      >
        <UserRound size={17} aria-hidden />
        {t('auth.profile')}
      </button>
      <button
        type="button"
        className={ITEM_CLASS}
        onClick={() => {
          setOpen(false)
          onBeforeTour?.()
          startTour(pathname)
        }}
      >
        <CircleHelp size={17} aria-hidden />
        {t('tour.open')}
      </button>
      <button type="button" className={ITEM_CLASS} onClick={logout}>
        <LogOut size={17} aria-hidden />
        {t('auth.logout')}
      </button>
    </>
  )

  if (compact) {
    return (
      <div className="flex flex-col gap-1">
        <div className="flex min-w-0 items-center gap-2 px-1 pb-1">
          <UserAvatar name={userName} imageUrl={avatarUrl} />
          <span className="truncate text-sm font-bold">{userName}</span>
        </div>
        {items}
        <ProfileModal open={profileOpen} onClose={() => setProfileOpen(false)} />
      </div>
    )
  }

  return (
    <div ref={rootRef} className="relative min-w-0 flex-1">
      <button
        ref={triggerRef}
        type="button"
        data-tour="help"
        aria-expanded={open}
        aria-controls={panelId}
        aria-label={t('auth.accountMenu', { name: userName ?? '' })}
        title={userName ?? undefined}
        onClick={() => setOpen((value) => !value)}
        className="flex min-h-11 w-full cursor-pointer items-center gap-2 rounded-xl p-1 text-left hover:bg-accent-tint max-lg:justify-center"
      >
        <UserAvatar name={userName} imageUrl={avatarUrl} />
        <span className="truncate text-sm font-bold max-lg:hidden">{userName}</span>
      </button>
      {open && (
        <div id={panelId} className="sketch absolute bottom-full left-0 z-20 mb-2 flex w-56 flex-col gap-1 p-2">
          <p className="truncate px-3 py-1 text-xs font-bold text-ink-muted">{userName}</p>
          {items}
        </div>
      )}
      <ProfileModal open={profileOpen} onClose={() => setProfileOpen(false)} />
    </div>
  )
}
