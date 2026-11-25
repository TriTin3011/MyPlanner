import i18n from '../../i18n'
import type { PomodoroMode } from './pomodoro'

export type NoticePermission = NotificationPermission | 'unsupported'

const NOTICE_TAG = 'mam-pomodoro-finished'
const NOTICE_ICON = '/pwa-192x192.png'

export function isDesktopApp() {
  return typeof window !== 'undefined' && window.chrome?.webview !== undefined
}

// App desktop báo qua Windows nên không cần trình duyệt cấp quyền.
export function noticePermission(): NoticePermission {
  if (isDesktopApp()) return 'granted'
  if (typeof Notification === 'undefined') return 'unsupported'
  return Notification.permission
}

// Phải gọi trong lúc người dùng bấm nút: trình duyệt chặn việc tự xin quyền khi vừa mở trang.
export async function requestNoticePermission(): Promise<NoticePermission> {
  const current = noticePermission()
  if (current !== 'default') return current
  return Notification.requestPermission()
}

// Đang nhìn vào app thì đã có tiếng báo và số đếm, hiện thêm thông báo chỉ gây phiền.
export function shouldNotify(enabled: boolean, permission: NoticePermission, pageActive: boolean) {
  return enabled && permission === 'granted' && !pageActive
}

export function notifyFinished(mode: PomodoroMode) {
  notifyText(i18n.t(`pomodoro.finished.${mode}.title`), i18n.t(`pomodoro.finished.${mode}.body`))
}

// Báo một câu bất kỳ ra ngoài app (tab Tập trung dùng khi cây nở). Cùng luật: chỉ báo khi không nhìn vào app.
export function notifyText(title: string, body: string) {
  const pageActive = !document.hidden && document.hasFocus()
  if (!shouldNotify(true, noticePermission(), pageActive)) return
  if (isDesktopApp()) {
    window.chrome?.webview?.postMessage({ type: 'pomodoro-notify', title, body })
    return
  }
  void showBrowserNotice(title, body)
}

async function showBrowserNotice(title: string, body: string) {
  // Cùng tag: mở nhiều tab thì thông báo sau thay thế thông báo trước, không chồng lên nhau.
  const options: NotificationOptions = { body, icon: NOTICE_ICON, tag: NOTICE_TAG }
  try {
    const notice = new Notification(title, options)
    notice.onclick = () => {
      window.focus()
      notice.close()
    }
  } catch {
    // Chrome Android không cho `new Notification`, phải đi qua service worker của PWA.
    const registration = await navigator.serviceWorker?.getRegistration()
    await registration?.showNotification(title, options).catch(() => undefined)
  }
}
