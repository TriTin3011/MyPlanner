import { useEffect, type ReactNode } from 'react'
import { Navigate, useLocation } from 'react-router'
import { isSessionActive, msUntilExpiry, sessionExpiresAt, useSession } from './session'

// Route guard: bọc các trang cần đăng nhập (tương đương [Authorize] bên ASP.NET Core, nhưng chỉ để UX:
// bảo mật thật nằm ở backend, vì ai cũng sửa được JavaScript trên trình duyệt của mình).
// Chưa đăng nhập hoặc phiên hết hạn → chuyển sang /login, nhớ trang đang mở để quay lại sau khi đăng nhập.
export function RequireAuth({ children }: { children: ReactNode }) {
  const token = useSession((s) => s.token)
  const endsAt = useSession(sessionExpiresAt)
  const active = useSession((s) => isSessionActive(s))
  const signOut = useSession((s) => s.signOut)
  const location = useLocation()

  // Hẹn giờ đăng xuất đúng lúc cả phiên hết hạn, kể cả khi người dùng để tab mở mà không bấm gì.
  // Mỗi lần gia hạn, endsAt đổi nên hẹn giờ được đặt lại. Access token hết hạn thì client tự đổi khi gặp 401.
  useEffect(() => {
    if (!endsAt) return
    const id = setTimeout(signOut, msUntilExpiry(endsAt))
    return () => clearTimeout(id)
  }, [endsAt, signOut])

  // Phiên cũ còn nằm trong localStorage nhưng đã hết hạn: dọn đi để không gửi kèm request nữa.
  useEffect(() => {
    if (token && !active) signOut()
  }, [token, active, signOut])

  if (!active) return <Navigate to="/login" replace state={{ from: location.pathname + location.search }} />
  return children
}
