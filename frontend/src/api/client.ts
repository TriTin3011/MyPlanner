import axios, { AxiosError, type InternalAxiosRequestConfig } from 'axios'
import i18n from '../i18n'
import { useSession } from '../features/auth/session'
import type { LoginResponse } from './types'

// Một instance axios dùng chung cho cả app (tương đương một HttpClient cấu hình sẵn bên .NET).
// - baseURL lấy từ biến môi trường VITE_API_URL (file .env), đổi theo môi trường dev/prod.
// - Interceptor request gắn "Authorization: Bearer <JWT>" nếu đã đăng nhập (giống DelegatingHandler bên WPF).
// - Interceptor response đổi lỗi ProblemDetails của backend thành Error có message dễ đọc,
//   và gặp 401 thì đổi refresh token lấy access token mới rồi gửi lại request đúng một lần.
export const api = axios.create({
  baseURL: `${import.meta.env.VITE_API_URL ?? 'http://localhost:5274'}/api`,
  timeout: 15_000,
})

// 401 ở các endpoint này không có nghĩa "access token hết hạn", nên không được kích hoạt gia hạn.
const NO_REFRESH_URLS = ['/auth/login', '/auth/google', '/auth/register', '/auth/refresh', '/auth/logout']

// Ghi lại request được gửi bằng phiên nào, để phản hồi đến muộn không tác động lên phiên của người đăng nhập sau.
type SessionRequest = InternalAxiosRequestConfig & {
  sentToken?: string | null
  sentBy?: string | null
  retriedAfterRefresh?: boolean
}

api.interceptors.request.use((config: SessionRequest) => {
  // getState() đọc store ngoài React (interceptor không phải component nên không dùng hook được).
  const { token, userName } = useSession.getState()
  if (token) config.headers.Authorization = `Bearer ${token}`
  config.sentToken = token
  config.sentBy = userName
  // Báo backend ngôn ngữ người dùng đang xem (chuẩn HTTP, giống trình duyệt tự gửi).
  // Backend có thể dùng để trả thông báo lỗi đúng ngôn ngữ; WPF và Flutter gửi cùng header này.
  config.headers['Accept-Language'] = i18n.language
  return config
})

// Khoá giữa các tab: refresh token chỉ dùng được một lần. Trình duyệt không có Web Locks thì dựa vào ân hạn của backend.
function withRefreshLock<T>(task: () => Promise<T>): Promise<T> {
  return navigator.locks ? (navigator.locks.request('myplanner-refresh', task) as Promise<T>) : task()
}

// Nhiều request cùng gặp 401 chỉ tạo một lần gia hạn (single-flight), tất cả chờ chung một promise.
let refreshing: Promise<string | null> | null = null

// Trả access token mới, hoặc null nếu phiên đã kết thúc. Lỗi mạng hoặc 5xx thì ném ra và giữ nguyên phiên.
function refreshAccessToken(rejectedToken: string | null | undefined) {
  refreshing ??= withRefreshLock(async () => {
    // Tab khác có thể vừa gia hạn trong lúc tab này chờ khoá: đọc lại localStorage trước khi gọi server.
    await useSession.persist.rehydrate()
    const session = useSession.getState()
    if (session.token && session.token !== rejectedToken) return session.token
    const refreshToken = session.refreshToken
    if (!refreshToken) {
      session.signOut()
      return null
    }

    // 400/401 là câu trả lời chắc chắn "phiên hết", không để interceptor đổi nó thành lỗi chung.
    const res = await api.post<LoginResponse>(
      '/auth/refresh',
      { refreshToken },
      { validateStatus: (status) => status === 200 || status === 400 || status === 401 },
    )
    const current = useSession.getState()
    if (current.refreshToken !== refreshToken) return null // người dùng đã đăng xuất trong lúc chờ
    if (res.status !== 200) {
      current.signOut()
      return null
    }
    current.signIn(res.data)
    return res.data.accessToken
  }).finally(() => {
    refreshing = null
  })
  return refreshing
}

// Xoá phiên ở máy ngay để giao diện phản hồi tức thì, rồi báo server thu hồi. Mất mạng cũng vẫn đăng xuất được.
export function logout() {
  const { refreshToken, signOut } = useSession.getState()
  signOut()
  if (refreshToken) void api.post('/auth/logout', { refreshToken }).catch(() => undefined)
}

interface ProblemDetails {
  title?: string
  detail?: string
  errors?: Record<string, string[]>
}

api.interceptors.response.use(
  (res) => res,
  async (err: AxiosError<ProblemDetails>) => {
    const config = err.config as SessionRequest | undefined
    if (err.response?.status === 401 && config && !NO_REFRESH_URLS.includes(config.url ?? '')) {
      const session = useSession.getState()
      if (config.sentBy === session.userName) {
        if (config.retriedAfterRefresh) {
          session.signOut() // token vừa cấp mà vẫn 401: dừng lại, không lặp vô hạn
        } else {
          config.retriedAfterRefresh = true
          const token = await refreshAccessToken(config.sentToken).catch(() => null)
          if (token) return api(config)
        }
      }
    }
    const p = err.response?.data
    const firstFieldError = p?.errors ? Object.values(p.errors)[0]?.[0] : undefined
    const message = firstFieldError ?? p?.detail ?? p?.title ?? err.message
    return Promise.reject(new ApiError(message, err.response?.status))
  },
)

// Error kèm mã HTTP. status undefined nghĩa là không có phản hồi (mất mạng, timeout):
// hàng đợi offline của tab Tập trung dựa vào đó để giữ lại phiên và gửi lại sau.
export class ApiError extends Error {
  readonly status?: number
  constructor(message: string, status?: number) {
    super(message)
    this.name = 'ApiError'
    this.status = status
  }
}
