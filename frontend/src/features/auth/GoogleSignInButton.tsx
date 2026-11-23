import { useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router'
import { useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { api } from '../../api/client'
import type { GoogleLoginRequest, LoginResponse } from '../../api/types'
import { useSession } from './session'

// Chỉ khai báo phần API của Google Identity Services mà app dùng.
interface GoogleAccountsId {
  initialize(config: { client_id: string; callback: (response: { credential: string }) => void }): void
  renderButton(
    parent: HTMLElement,
    options: { theme: 'outline'; size: 'large'; text: 'signin_with'; width: number; locale: string },
  ): void
}

declare global {
  interface Window {
    google?: { accounts: { id: GoogleAccountsId } }
  }
}

const GIS_SRC = 'https://accounts.google.com/gsi/client'
let gisScript: Promise<void> | null = null

// Chỉ tải script khi trang đăng nhập cần, và tải một lần dù chuyển qua lại giữa /login và /register.
function loadGoogleScript(): Promise<void> {
  if (window.google?.accounts?.id) return Promise.resolve()
  gisScript ??= new Promise<void>((resolve, reject) => {
    const script = document.createElement('script')
    script.src = GIS_SRC
    script.async = true
    script.onload = () => resolve()
    script.onerror = () => {
      gisScript = null // cho phép thử lại ở lần mở trang sau
      script.remove()
      reject(new Error('GIS load failed'))
    }
    document.head.appendChild(script)
  })
  return gisScript
}

// Nút "Đăng nhập bằng Google" (SPEC §15 bước 11.7).
// Luồng: Google trả ID token cho trình duyệt → POST /auth/google → AuthController → AuthService
// → GoogleTokenVerifier kiểm chữ ký + aud → tìm hoặc tạo user → JWT của app → signIn() → vào app.
export function GoogleSignInButton({ from }: { from: string }) {
  const clientId = import.meta.env.VITE_GOOGLE_CLIENT_ID as string | undefined
  const { t, i18n } = useTranslation()
  const navigate = useNavigate()
  const signIn = useSession((s) => s.signIn)
  const containerRef = useRef<HTMLDivElement>(null)
  const [scriptFailed, setScriptFailed] = useState(false)

  const { mutate, isPending, isError, error } = useMutation({
    mutationFn: (body: GoogleLoginRequest) => api.post<LoginResponse>('/auth/google', body).then((r) => r.data),
    onSuccess: (res) => {
      signIn(res)
      navigate(from, { replace: true })
    },
  })

  useEffect(() => {
    if (!clientId) return
    let cancelled = false
    loadGoogleScript()
      .then(() => {
        const container = containerRef.current
        const gis = window.google?.accounts.id
        if (cancelled || !container || !gis) return
        gis.initialize({ client_id: clientId, callback: (r) => mutate({ idToken: r.credential }) })
        container.replaceChildren()
        // Google chỉ nhận chiều rộng từ 200 đến 400px.
        const width = Math.round(Math.min(400, Math.max(200, container.clientWidth)))
        gis.renderButton(container, { theme: 'outline', size: 'large', text: 'signin_with', width, locale: i18n.language })
      })
      .catch(() => {
        if (!cancelled) setScriptFailed(true)
      })
    return () => {
      cancelled = true
    }
  }, [clientId, i18n.language, mutate])

  // Chưa cấu hình Client ID thì ẩn hẳn, trang vẫn dùng được bằng tên và mật khẩu.
  if (!clientId) return null

  return (
    <div className="flex flex-col gap-3">
      <div className="flex items-center gap-3 text-xs font-semibold text-ink-muted">
        <span className="h-px flex-1 bg-[var(--line)]" aria-hidden />
        {t('auth.or')}
        <span className="h-px flex-1 bg-[var(--line)]" aria-hidden />
      </div>
      <div ref={containerRef} className="flex min-h-11 w-full justify-center" />
      {isPending && (
        <p role="status" className="text-center text-sm text-ink-muted">
          {t('auth.googleSigningIn')}
        </p>
      )}
      {(isError || scriptFailed) && (
        <p role="alert" className="rounded-lg bg-danger-bg px-3 py-2 text-sm font-semibold text-danger">
          {isError ? error.message : t('auth.googleUnavailable')}
        </p>
      )}
    </div>
  )
}
