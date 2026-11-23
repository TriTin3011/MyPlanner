import { useEffect, type ReactNode } from 'react'
import { Navigate, useLocation } from 'react-router'
import { isSessionActive, msUntilExpiry, useSession } from './session'

// Route guard: bọc các trang cần đăng nhập (tương đương [Authorize] bên ASP.NET Core, nhưng chỉ để UX:
// bảo mật thật nằm ở backend, vì ai cũng sửa được JavaScript trên trình duyệt của mình).
// Chưa đăng nhập hoặc token hết hạn → chuyển sang /login, nhớ trang đang mở để quay lại sau khi đăng nhập.
export function RequireAuth({ children }: { children: ReactNode }) {
  const token = useSession((s) => s.token)
  const expiresAt = useSession((s) => s.expiresAt)
  const signOut = useSession((s) => s.signOut)
  const location = useLocation()
  const active = isSessionActive({ token, expiresAt })

  // Hẹn giờ đăng xuất đúng lúc token hết hạn, kể cả khi người dùng để tab mở mà không bấm gì.
  // Không có hẹn giờ thì phải đợi tới lần gọi API kế tiếp bị 401 mới biết.
  useEffect(() => {
    if (!expiresAt) return
    const id = setTimeout(signOut, msUntilExpiry(expiresAt))
    return () => clearTimeout(id)
  }, [expiresAt, signOut])

  // Token cũ còn nằm trong localStorage nhưng đã hết hạn: dọn đi để không gửi kèm request nữa.
  useEffect(() => {
    if (token && !active) signOut()
  }, [token, active, signOut])

  if (!active) return <Navigate to="/login" replace state={{ from: location.pathname + location.search }} />
  return children
}
