import { useCallback, useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useSettings } from '../../store/settings'
import { isDesktopApp } from './notify'
import { remainingMs } from './pomodoro'
import { usePomodoro } from './store'

// Document Picture-in-Picture chưa có trong kiểu DOM của TypeScript và chỉ có trên Chrome/Edge máy tính.
interface DocumentPip {
  requestWindow(options: { width: number; height: number }): Promise<Window>
}

const PIP_SIZE = { width: 360, height: 88 }

function documentPip() {
  return (window as unknown as { documentPictureInPicture?: DocumentPip }).documentPictureInPicture
}

// Cửa sổ PiP là một document trống, phải mang CSS sang thì class Tailwind và token màu mới có tác dụng.
function copyStyles(target: Document) {
  document.querySelectorAll<HTMLElement>('style, link[rel="stylesheet"]').forEach((node) => {
    const clone = node.cloneNode(true) as HTMLElement
    if (node instanceof HTMLLinkElement) (clone as HTMLLinkElement).href = node.href
    target.head.append(clone)
  })
  target.body.className = 'bg-surface text-ink'
  target.body.style.margin = '0'
}

function syncRoot(target: Document) {
  const { theme } = document.documentElement.dataset
  if (theme) target.documentElement.dataset.theme = theme
  else delete target.documentElement.dataset.theme
  target.documentElement.lang = document.documentElement.lang
}

// Hai "động cơ", một giao diện gọi: Chrome/Edge dùng PiP, app desktop nhờ WPF mở cửa sổ luôn nổi.
export function usePomodoroFloat(onExpand: () => void) {
  const { t } = useTranslation()
  const theme = useSettings((s) => s.theme)
  const language = useSettings((s) => s.language)
  const [pipWindow, setPipWindow] = useState<Window | null>(null)
  const [nativeOpen, setNativeOpen] = useState(false)
  const desktop = isDesktopApp()
  const supported = desktop || documentPip() !== undefined

  const open = useCallback(async () => {
    if (desktop) {
      setNativeOpen(true)
      return
    }
    const api = documentPip()
    if (!api) return
    try {
      const next = await api.requestWindow(PIP_SIZE)
      copyStyles(next.document)
      syncRoot(next.document)
      next.document.title = t('pomodoro.title')
      next.addEventListener('pagehide', () => setPipWindow(null), { once: true })
      setPipWindow(next)
    } catch {
      // Trình duyệt từ chối mở thì thanh nhỏ trong trang vẫn còn nguyên.
    }
  }, [desktop, t])

  const close = useCallback(() => {
    pipWindow?.close()
    setNativeOpen(false)
  }, [pipWindow])

  useEffect(() => {
    if (pipWindow) syncRoot(pipWindow.document)
  }, [pipWindow, theme, language])

  // Rời AppShell (đăng xuất) thì không để lại cửa sổ nổi mồ côi.
  useEffect(() => () => pipWindow?.close(), [pipWindow])

  // App desktop: gửi mốc endsAt sang WPF, để WPF tự đếm kể cả khi WebView bị giảm nhịp lúc thu nhỏ.
  useEffect(() => {
    if (!nativeOpen) return
    const send = () => {
      const timer = usePomodoro.getState()
      const running = timer.endsAt !== null
      const paused = timer.pausedMs !== null
      window.chrome?.webview?.postMessage({
        type: 'pomodoro-float',
        endsAt: timer.endsAt,
        remainingMs: remainingMs(timer, Date.now()),
        status: running
          ? t(`pomodoro.running.${timer.mode}`)
          : paused
            ? t('pomodoro.paused')
            : t(`pomodoro.ready.${timer.mode}`),
        toggleLabel: running ? t('pomodoro.pause') : paused ? t('pomodoro.resume') : t('pomodoro.start'),
        expandLabel: t('pomodoro.expand'),
        closeLabel: t('pomodoro.closeFloat'),
      })
    }
    send()
    return usePomodoro.subscribe(send)
  }, [nativeOpen, t])

  useEffect(() => {
    if (!nativeOpen) return
    return () => window.chrome?.webview?.postMessage({ type: 'pomodoro-float-close' })
  }, [nativeOpen])

  useEffect(() => {
    const bridge = window.chrome?.webview
    if (!bridge) return
    const onMessage = (event: MessageEvent) => {
      const data = event.data as { type?: string; command?: string } | null
      if (data?.type === 'pomodoro-float-closed') setNativeOpen(false)
      if (data?.type !== 'pomodoro-command') return
      if (data.command === 'expand') onExpand()
      if (data.command === 'toggle') {
        const timer = usePomodoro.getState()
        if (timer.endsAt !== null) timer.pause()
        else timer.start()
      }
    }
    bridge.addEventListener('message', onMessage)
    return () => bridge.removeEventListener('message', onMessage)
  }, [onExpand])

  return { supported, active: pipWindow !== null || nativeOpen, pipWindow, open, close }
}
