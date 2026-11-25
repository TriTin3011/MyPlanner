import { applyTheme, type ThemeId, useSettings } from '../../store/settings'
import { isSessionActive, sessionExpiresAt, useSession } from './session'

// Chưa đăng nhập (hoặc phiên đã hết hạn) luôn dùng màu thương hiệu; đã đăng nhập mới dùng theme đã chọn.
export function themeForSession(
  theme: ThemeId,
  session: Parameters<typeof isSessionActive>[0],
  now = Date.now(),
): ThemeId {
  return isSessionActive(session, now) ? theme : 'forest'
}

// Một nơi duy nhất quyết định màu đang hiển thị, chạy trước lần vẽ đầu và mỗi khi theme hoặc phiên đổi.
// Trên app desktop còn báo cho WPF, vì splash vẽ trước khi WebView2 đọc được localStorage.
export function startSessionTheme() {
  let lastSent = ''
  const sync = () => {
    const session = useSession.getState()
    const theme = themeForSession(useSettings.getState().theme, session)
    applyTheme(theme)
    const expiresAt = theme === 'forest' ? null : sessionExpiresAt(session)
    const key = `${theme}|${expiresAt}`
    if (key === lastSent) return
    lastSent = key
    window.chrome?.webview?.postMessage({ type: 'splash-theme', theme, expiresAt })
  }
  sync()
  const unsubscribeSettings = useSettings.subscribe(sync)
  const unsubscribeSession = useSession.subscribe(sync)
  return () => {
    unsubscribeSettings()
    unsubscribeSession()
  }
}
