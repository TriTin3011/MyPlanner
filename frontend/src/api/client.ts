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

// Riêng endpoint đăng nhập: 401 ở đây là "sai mật khẩu", không phải "phiên hết hạn".
const LOGIN_URL = '/auth/login'

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
    if (err.response?.status === 401 && err.config?.url !== LOGIN_URL) {
      useSession.getState().signOut()
    }
    const p = err.response?.data
    const firstFieldError = p?.errors ? Object.values(p.errors)[0]?.[0] : undefined
    const message = firstFieldError ?? p?.detail ?? p?.title ?? err.message
    return Promise.reject(new Error(message))
  },
)
