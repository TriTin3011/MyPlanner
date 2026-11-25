import { useId, useState, type FormEvent } from 'react'
import { Link, Navigate, useLocation, useNavigate } from 'react-router'
import { useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { Eye, EyeOff, LoaderCircle, LogIn } from 'lucide-react'
import { api } from '../../api/client'
import type { LoginRequest, LoginResponse } from '../../api/types'
import { BrandMark } from '../../components/BrandMark'
import { LanguageSwitcher } from '../../components/LanguageSwitcher'
import { GoogleSignInButton } from './GoogleSignInButton'
import { isSessionActive, useSession } from './session'

// Trang /login (SPEC §15 bước 11.2). Nằm ngoài AppShell: chưa đăng nhập thì không có menu để bấm.
// Luồng: form → useMutation → api.post('/auth/login') → AuthController → AuthService → token
// → signIn() lưu vào store → điều hướng về trang người dùng định mở (state.from) hoặc Hôm nay.
export function LoginPage() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const location = useLocation()
  const from = (location.state as { from?: string } | null)?.from ?? '/'
  const active = useSession((s) => isSessionActive(s))
  const signIn = useSession((s) => s.signIn)

  const userId = useId()
  const passwordId = useId()
  const errorId = useId()
  const [userName, setUserName] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)

  const login = useMutation({
    mutationFn: (body: LoginRequest) => api.post<LoginResponse>('/auth/login', body).then((r) => r.data),
    onSuccess: (res) => {
      signIn(res)
      navigate(from, { replace: true })
    },
    // Sai mật khẩu thì xoá ô mật khẩu, giữ tên đăng nhập (thói quen của hầu hết trang đăng nhập).
    onError: () => setPassword(''),
  })

  // Đã đăng nhập mà vẫn mở /login (gõ tay, bấm Back): đưa thẳng vào app.
  if (active) return <Navigate to={from} replace />

  const canSubmit = userName.trim() !== '' && password !== '' && !login.isPending

  function submit(e: FormEvent) {
    e.preventDefault()
    if (canSubmit) login.mutate({ userName: userName.trim(), password })
  }

  return (
    <div className="paper flex min-h-dvh flex-col items-center justify-center bg-app px-4 py-10">
      <form
        onSubmit={submit}
        aria-labelledby="login-title"
        className="sketch relative flex w-full max-w-sm flex-col gap-4 p-5 lg:p-7"
        noValidate
      >
        <div className="absolute top-1 right-1">
          <LanguageSwitcher mini />
        </div>
        <div className="flex flex-col items-center gap-2 text-center">
          <BrandMark size={56} />
          <span className="font-display text-3xl leading-none font-extrabold text-primary-ink">Mầm</span>
          <h1 id="login-title" className="mt-2 text-xl font-bold">
            {t('auth.title')}
          </h1>
          <p className="text-sm text-ink-muted">{t('auth.subtitle')}</p>
        </div>

        <div>
          <label htmlFor={userId} className="mb-1 block text-sm font-bold">
            {t('auth.userName')}
          </label>
          <input
            id={userId}
            name="username"
            autoComplete="username"
            autoCapitalize="none"
            spellCheck={false}
            value={userName}
            onChange={(e) => setUserName(e.target.value)}
            maxLength={64}
            required
            autoFocus
            className="min-h-11 w-full rounded-lg border-2 border-[var(--line)] bg-surface px-3 text-base focus-visible:border-primary focus-visible:outline-none"
          />
        </div>

        <div>
          <label htmlFor={passwordId} className="mb-1 block text-sm font-bold">
            {t('auth.password')}
          </label>
          <div className="relative">
            <input
              id={passwordId}
              name="password"
              type={showPassword ? 'text' : 'password'}
              autoComplete="current-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              maxLength={256}
              required
              aria-invalid={login.isError || undefined}
              aria-describedby={login.isError ? errorId : undefined}
              className="min-h-11 w-full rounded-lg border-2 border-[var(--line)] bg-surface pr-12 pl-3 text-base focus-visible:border-primary focus-visible:outline-none"
            />
            <button
              type="button"
              onClick={() => setShowPassword((v) => !v)}
              aria-label={showPassword ? t('auth.hidePassword') : t('auth.showPassword')}
              aria-pressed={showPassword}
              className="absolute inset-y-0 right-0 grid w-11 place-items-center rounded-r-lg text-ink-muted hover:text-ink"
            >
              {showPassword ? <EyeOff size={18} aria-hidden /> : <Eye size={18} aria-hidden />}
            </button>
          </div>
        </div>

        {login.isError && (
          // Thông báo lấy từ ProblemDetails.detail của backend (đã dịch theo Accept-Language).
          <p id={errorId} role="alert" className="rounded-lg bg-danger-bg px-3 py-2 text-sm font-semibold text-danger">
            {login.error.message}
          </p>
        )}

        <button
          type="submit"
          disabled={!canSubmit}
          className="flex min-h-11 cursor-pointer items-center justify-center gap-1.5 rounded-lg bg-primary px-4 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-45"
        >
          {login.isPending ? (
            <LoaderCircle size={16} className="animate-spin" aria-hidden />
          ) : (
            <LogIn size={16} aria-hidden />
          )}
          {login.isPending ? t('auth.submitting') : t('auth.submit')}
        </button>

        <GoogleSignInButton from={from} />

        <p className="text-center text-sm text-ink-muted">
          {t('auth.noAccount')}{' '}
          <Link to="/register" state={{ from }} className="font-bold text-primary-ink underline underline-offset-2">
            {t('auth.goToRegister')}
          </Link>
        </p>
      </form>
    </div>
  )
}
