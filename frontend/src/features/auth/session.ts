import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { LoginResponse } from '../../api/types'
import { queryClient } from '../../app/queryClient'

const STORAGE_KEY = 'myplanner-session'

// Phiên đăng nhập phía web (SPEC §15 bước 11.2). Lưu ở localStorage để mở lại tab vẫn còn đăng nhập.
// Trade-off: JavaScript đọc được localStorage nên lỗi XSS có thể lấy token; cookie httpOnly an toàn hơn
// nhưng API chọn Bearer (không cookie) để web, WPF và Flutter dùng chung một cách xác thực.
// Xoay vòng refresh token giúp giảm thiệt hại: token bị lấy mà dùng lại sẽ làm cả phiên bị thu hồi.
interface SessionState {
  token: string | null
  userName: string | null
  displayName: string | null // tên người dùng tự đặt; null thì hiện userName
  expiresAt: string | null // hạn của access token (ISO 8601 do backend trả)
  refreshToken: string | null // null với phiên cũ đã lưu từ trước khi có refresh token
  refreshExpiresAt: string | null // hạn của cả phiên, tính lại mỗi lần gia hạn
  signIn: (res: LoginResponse) => void
  signOut: () => void
}

type SessionTiming = Pick<SessionState, 'token' | 'expiresAt'> &
  Partial<Pick<SessionState, 'refreshToken' | 'refreshExpiresAt'>>

export const useSession = create<SessionState>()(
  persist(
    (set) => ({
      token: null,
      userName: null,
      displayName: null,
      expiresAt: null,
      refreshToken: null,
      refreshExpiresAt: null,
      signIn: (res) =>
        set({
          token: res.accessToken,
          userName: res.userName,
          displayName: res.displayName ?? null,
          expiresAt: res.expiresAt,
          refreshToken: res.refreshToken ?? null,
          refreshExpiresAt: res.refreshExpiresAt ?? null,
        }),
      signOut: () => {
        set({ token: null, userName: null, displayName: null, expiresAt: null, refreshToken: null, refreshExpiresAt: null })
        // Xoá cache: người đăng nhập sau (hoặc chính mình) không thấy dữ liệu cũ của phiên trước.
        queryClient.clear()
      },
    }),
    // Chỉ lưu dữ liệu, không lưu hàm.
    {
      name: STORAGE_KEY,
      partialize: (s) => ({
        token: s.token,
        userName: s.userName,
        displayName: s.displayName,
        expiresAt: s.expiresAt,
        refreshToken: s.refreshToken,
        refreshExpiresAt: s.refreshExpiresAt,
      }),
    },
  ),
)

// Sự kiện storage chỉ bắn ở các tab khác: nhờ đó tab này nhận token vừa xoay vòng, hoặc biết đã đăng xuất.
if (typeof window !== 'undefined') {
  window.addEventListener('storage', (event) => {
    if (event.key !== STORAGE_KEY) return
    const before = useSession.getState().userName
    void Promise.resolve(useSession.persist.rehydrate()).then(() => {
      if (useSession.getState().userName !== before) queryClient.clear()
    })
  })
}

// Tên để hiển thị khắp app. Lưu cùng phiên nên mở lại trang hiện đúng ngay, không nháy tên đăng nhập trong lúc chờ /me.
export const useDisplayName = () => useSession((s) => s.displayName ?? s.userName)

// Lúc phiên thật sự kết thúc: có refresh token thì theo hạn của nó, phiên cũ thì theo access token.
export function sessionExpiresAt(s: SessionTiming): string | null {
  return s.refreshToken && s.refreshExpiresAt ? s.refreshExpiresAt : s.expiresAt
}

// Còn dùng được không. Access token hết hạn chưa phải hết phiên, vì client tự đổi được token mới.
// Hàm thuần, nhận `now` để test không phụ thuộc đồng hồ.
export function isSessionActive(s: SessionTiming, now = Date.now()): boolean {
  const end = sessionExpiresAt(s)
  if (!s.token || !end) return false
  const expires = Date.parse(end)
  return Number.isFinite(expires) && expires > now
}

// Số mili giây tới lúc hết hạn, kẹp trong giới hạn của setTimeout (~24,8 ngày) để tránh tràn số.
export function msUntilExpiry(expiresAt: string, now = Date.now()): number {
  return Math.min(Math.max(Date.parse(expiresAt) - now, 0), 2_147_483_647)
}
