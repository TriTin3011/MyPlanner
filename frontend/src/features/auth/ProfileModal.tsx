import { useRef, useState, type ChangeEvent } from 'react'
import { useTranslation } from 'react-i18next'
import { Camera, Trash2 } from 'lucide-react'
import { Modal } from '../../components/Modal'
import { AvatarCropper } from './AvatarCropper'
import { INTL_LOCALE } from '../../i18n/languages'
import { useSettings } from '../../store/settings'
import { DisplayNameEditor } from './DisplayNameEditor'
import { useDisplayName, useSession } from './session'
import { UserAvatar } from './UserAvatar'
import { useCurrentUser, useDeleteAvatar, useUploadAvatar } from './useProfile'

const MAX_BYTES = 5 * 1024 * 1024
const ACCEPTED_TYPES = ['image/jpeg', 'image/png', 'image/webp']
const BUTTON_CLASS =
  'inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border-2 border-ink px-4 text-sm font-bold hover:bg-accent-tint disabled:cursor-not-allowed disabled:opacity-60'

// Hồ sơ người dùng và đổi ảnh đại diện. Kiểm tra ở đây chỉ để báo lỗi sớm; server mới là nơi quyết định file có hợp lệ không.
export function ProfileModal({ open, onClose }: { open: boolean; onClose: () => void }) {
  const { t } = useTranslation()
  const userName = useDisplayName()
  const expiresAt = useSession((s) => s.expiresAt)
  const language = useSettings((s) => s.language)
  const { data: me } = useCurrentUser()
  const upload = useUploadAvatar()
  const remove = useDeleteAvatar()
  const inputRef = useRef<HTMLInputElement>(null)
  const [error, setError] = useState<string | null>(null)
  const [cropFile, setCropFile] = useState<File | null>(null)
  const busy = upload.isPending || remove.isPending
  const avatarUrl = me?.avatarUrl ?? null
  const expires = expiresAt
    ? new Date(expiresAt).toLocaleString(INTL_LOCALE[language], { dateStyle: 'medium', timeStyle: 'short' })
    : '—'

  const onPick = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    // Xoá giá trị để chọn lại đúng file đó vẫn phát sinh sự kiện change.
    event.target.value = ''
    if (!file) return
    if (!ACCEPTED_TYPES.includes(file.type)) return setError(t('auth.photoInvalid'))
    if (file.size > MAX_BYTES) return setError(t('auth.photoTooLarge'))
    setError(null)
    setCropFile(file)
  }

  const onCropConfirm = (blob: Blob) => {
    upload.mutate(new File([blob], 'avatar.jpg', { type: 'image/jpeg' }), {
      onSuccess: () => setCropFile(null),
      onError: (e) => {
        setCropFile(null)
        setError(e.message)
      },
    })
  }

  const onCropError = () => {
    setCropFile(null)
    setError(t('auth.cropFailed'))
  }

  const closeModal = () => {
    setCropFile(null)
    onClose()
  }

  const onRemove = () => {
    setError(null)
    remove.mutate(undefined, { onError: (e) => setError(e.message) })
  }

  return (
    <Modal open={open} title={t('auth.profile')} onClose={closeModal}>
      {cropFile ? (
        <AvatarCropper
          file={cropFile}
          busy={upload.isPending}
          onCancel={() => setCropFile(null)}
          onConfirm={onCropConfirm}
          onError={onCropError}
        />
      ) : (
      <div className="flex flex-col items-center gap-3 py-2 text-center">
        <UserAvatar name={userName} imageUrl={avatarUrl} size={96} />
        <DisplayNameEditor />
        <div className="flex flex-wrap justify-center gap-2">
          <input
            ref={inputRef}
            type="file"
            accept={ACCEPTED_TYPES.join(',')}
            className="sr-only"
            tabIndex={-1}
            aria-label={t('auth.choosePhoto')}
            onChange={onPick}
          />
          <button type="button" className={BUTTON_CLASS} disabled={busy} onClick={() => inputRef.current?.click()}>
            <Camera size={17} aria-hidden />
            {upload.isPending ? t('auth.uploadingPhoto') : avatarUrl ? t('auth.changePhoto') : t('auth.addPhoto')}
          </button>
          {avatarUrl && (
            <button type="button" className={BUTTON_CLASS} disabled={busy} onClick={onRemove}>
              <Trash2 size={17} aria-hidden />
              {t('auth.removePhoto')}
            </button>
          )}
        </div>
        <p className="text-xs text-ink-muted">{t('auth.photoHint')}</p>
        {error && (
          <p role="alert" className="text-sm font-bold text-danger">
            {error}
          </p>
        )}
        <p className="text-sm text-ink-muted">{t('auth.sessionUntil', { time: expires })}</p>
      </div>
      )}
    </Modal>
  )
}
