import { useState, type FormEvent } from 'react'
import { useTranslation } from 'react-i18next'
import { Check, Pencil, X } from 'lucide-react'
import { useDisplayName, useSession } from './session'
import { useUpdateDisplayName } from './useProfile'

const MAX_LENGTH = 50
const ICON_BUTTON =
  'grid size-11 shrink-0 cursor-pointer place-items-center rounded-xl hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-50'

// Xem và sửa tên hiển thị. Tên đăng nhập luôn hiện bên dưới để người dùng không nhầm là đã đổi cách đăng nhập.
export function DisplayNameEditor() {
  const { t } = useTranslation()
  const name = useDisplayName() ?? ''
  const userName = useSession((s) => s.userName)
  const update = useUpdateDisplayName()
  const [draft, setDraft] = useState<string | null>(null)

  const cancel = () => {
    update.reset()
    setDraft(null)
  }

  const submit = (event: FormEvent) => {
    event.preventDefault()
    if (draft === null || update.isPending) return
    update.mutate(draft.trim(), { onSuccess: () => setDraft(null) })
  }

  if (draft === null) {
    return (
      <div className="flex max-w-full flex-col items-center">
        <div className="flex max-w-full items-center gap-1">
          <p className="min-w-0 font-display text-xl font-extrabold break-words">{name}</p>
          <button
            type="button"
            aria-label={t('auth.editName')}
            title={t('auth.editName')}
            onClick={() => setDraft(name === userName ? '' : name)}
            className={`${ICON_BUTTON} text-ink-muted hover:text-ink`}
          >
            <Pencil size={16} aria-hidden />
          </button>
        </div>
        <p className="max-w-full text-xs break-words text-ink-muted">{t('auth.loginName', { name: userName ?? '' })}</p>
      </div>
    )
  }

  return (
    <form onSubmit={submit} className="flex w-full max-w-xs flex-col gap-1 text-left">
      <label htmlFor="display-name" className="text-sm font-bold">
        {t('auth.displayName')}
      </label>
      <div className="flex items-center gap-1">
        <input
          id="display-name"
          autoFocus
          value={draft}
          maxLength={MAX_LENGTH}
          placeholder={userName ?? ''}
          onChange={(event) => setDraft(event.target.value)}
          onKeyDown={(event) => {
            if (event.key !== 'Escape') return
            // Esc chỉ huỷ sửa tên, không đóng cả modal.
            event.preventDefault()
            event.stopPropagation()
            cancel()
          }}
          className="min-h-11 w-full min-w-0 rounded-xl border-2 border-ink bg-surface px-3 font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
        />
        <button type="submit" aria-label={t('auth.saveName')} title={t('auth.saveName')} disabled={update.isPending} className={`${ICON_BUTTON} text-primary`}>
          <Check size={18} aria-hidden />
        </button>
        <button type="button" aria-label={t('auth.cancelName')} title={t('auth.cancelName')} onClick={cancel} className={ICON_BUTTON}>
          <X size={18} aria-hidden />
        </button>
      </div>
      <p className="text-xs text-ink-muted">{t('auth.displayNameHint')}</p>
      {update.isError && (
        <p role="alert" className="text-sm font-bold text-danger">
          {update.error.message}
        </p>
      )}
    </form>
  )
}
