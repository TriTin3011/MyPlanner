import { useTranslation } from 'react-i18next'
import { LogOut, UserRound } from 'lucide-react'
import { useSession } from './session'

// Tên người đang đăng nhập + nút Đăng xuất. Sidebar thu gọn (tablet) chỉ còn icon; menu ⋯ trên điện thoại
// dùng compact để hiện đủ chữ. Đăng xuất chỉ cần xoá token ở client (JWT không có phiên phía server để huỷ);
// store đổi thì RequireAuth tự chuyển về /login.
export function AccountControls({ compact = false }: { compact?: boolean }) {
  const { t } = useTranslation()
  const userName = useSession((s) => s.userName)
  const signOut = useSession((s) => s.signOut)
  const label = t('auth.signedInAs', { name: userName ?? '' })

  return (
    <div className={`flex items-center gap-2 ${compact ? '' : 'max-lg:flex-col'}`}>
      <span
        title={label}
        className={`flex min-w-0 flex-1 items-center gap-1.5 text-sm font-semibold text-ink-muted ${compact ? '' : 'max-lg:hidden'}`}
      >
        <UserRound size={16} aria-hidden className="shrink-0" />
        <span className="sr-only">{t('auth.account')}: </span>
        <span className="truncate">{userName}</span>
      </span>
      <button
        type="button"
        onClick={signOut}
        title={t('auth.logout')}
        className="flex min-h-11 items-center gap-1.5 rounded-full px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint hover:text-ink max-lg:justify-center"
      >
        <LogOut size={18} aria-hidden />
        <span className={compact ? '' : 'max-lg:sr-only'}>{t('auth.logout')}</span>
      </button>
    </div>
  )
}
