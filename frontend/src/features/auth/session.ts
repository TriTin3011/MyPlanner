import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { LoginResponse } from '../../api/types'
import { queryClient } from '../../app/queryClient'

// Phiên đăng nhập phía web (SPEC §15 bước 11.2). Lưu ở localStorage để mở lại tab vẫn còn đăng nhập.
// Trade-off: JavaScript đọc được localStorage nên lỗi XSS có thể lấy token; cookie httpOnly an toàn hơn
// nhưng API chọn Bearer (không cookie) để web, WPF và Flutter dùng chung một cách xác thực.
interface SessionState {
  token: string | null
  userName: string | null
  displayName: string | null // tên người dùng tự đặt; null thì hiện userName
  expiresAt: string | null // ISO 8601 do backend trả, để client tự biết lúc nào token hết hạn
  signIn: (res: LoginResponse) => void
  signOut: () => void
}

export const useSession = create<SessionState>()(
  persist(
    (set) => ({
      token: null,
      userName: null,
      displayName: null,
      expiresAt: null,
      signIn: (res) =>
        set({
          token: res.accessToken,
          userName: res.userName,
          displayName: res.displayName ?? null,
          expiresAt: res.expiresAt,
        }),
      signOut: () => {
        set({ token: null, userName: null, displayName: null, expiresAt: null })
        // Xoá cache: người đăng nhập sau (hoặc chính mình) không thấy dữ liệu cũ của phiên trước.
        queryClient.clear()
      },
    }),
    // Chỉ lưu dữ liệu, không lưu hàm.
    {
      name: 'myplanner-session',
      partialize: (s) => ({ token: s.token, userName: s.userName, displayName: s.displayName, expiresAt: s.expiresAt }),
    },
  ),
)

// Tên để hiển thị khắp app. Lưu cùng phiên nên mở lại trang hiện đúng ngay, không nháy tên đăng nhập trong lúc chờ /me.
export const useDisplayName = () => useSession((s) => s.displayName ?? s.userName)

// Còn dùng được không: có token và chưa tới giờ hết hạn. Hàm thuần, nhận `now` để test không phụ thuộc đồng hồ.
export function isSessionActive(s: Pick<SessionState, 'token' | 'expiresAt'>, now = Date.now()): boolean {
  if (!s.token || !s.expiresAt) return false
  const expires = Date.parse(s.expiresAt)
  return Number.isFinite(expires) && expires > now
}

// Số mili giây tới lúc hết hạn, kẹp trong giới hạn của setTimeout (~24,8 ngày) để tránh tràn số.
export function msUntilExpiry(expiresAt: string, now = Date.now()): number {
  return Math.min(Math.max(Date.parse(expiresAt) - now, 0), 2_147_483_647)
}
