import axios, { AxiosError } from 'axios'
import i18n from '../i18n'
import { useSession } from '../features/auth/session'

// Một instance axios dùng chung cho cả app (tương đương một HttpClient cấu hình sẵn bên .NET).
// - baseURL lấy từ biến môi trường VITE_API_URL (file .env), đổi theo môi trường dev/prod.
// - Interceptor request gắn "Authorization: Bearer <JWT>" nếu đã đăng nhập (giống DelegatingHandler bên WPF).
// - Interceptor response đổi lỗi ProblemDetails của backend thành Error có message dễ đọc,
//   và gặp 401 thì đăng xuất: RequireAuth thấy phiên trống sẽ đưa về /login.
export const api = axios.create({
  baseURL: `${import.meta.env.VITE_API_URL ?? 'http://localhost:5274'}/api`,
  timeout: 15_000,
})

// Riêng các endpoint đăng nhập: 401 ở đây là "sai thông tin", không phải "phiên hết hạn".
const SIGN_IN_URLS = ['/auth/login', '/auth/google']

api.interceptors.request.use((config) => {
  // getState() đọc store ngoài React (interceptor không phải component nên không dùng hook được).
  const token = useSession.getState().token
  if (token) config.headers.Authorization = `Bearer ${token}`
  // Báo backend ngôn ngữ người dùng đang xem (chuẩn HTTP, giống trình duyệt tự gửi).
  // Backend có thể dùng để trả thông báo lỗi đúng ngôn ngữ; WPF và Flutter gửi cùng header này.
  config.headers['Accept-Language'] = i18n.language
  return config
})

interface ProblemDetails {
  title?: string
  detail?: string
  errors?: Record<string, string[]>
}

api.interceptors.response.use(
  (res) => res,
  (err: AxiosError<ProblemDetails>) => {
    if (err.response?.status === 401 && !SIGN_IN_URLS.includes(err.config?.url ?? '')) {
      useSession.getState().signOut()
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
