import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
// Font tự host (đi cùng bundle, chạy được offline cho PWA). Chỉ nạp các độ đậm SPEC §4.3 dùng.
import '@fontsource/baloo-2/700.css'
import '@fontsource/baloo-2/800.css'
import '@fontsource/be-vietnam-pro/400.css'
import '@fontsource/be-vietnam-pro/500.css'
import '@fontsource/be-vietnam-pro/600.css'
import '@fontsource/be-vietnam-pro/700.css'
import './styles/index.css'
// Khởi tạo i18next và áp ngôn ngữ đã lưu (cả <html lang>) trước khi React vẽ lần đầu.
import './i18n'
import { App } from './app/App.tsx'
import { startSessionTheme } from './features/auth/sessionTheme'

// Áp màu theo phiên đăng nhập trước khi vẽ lần đầu để không bị chớp sai màu.
startSessionTheme()

// Điểm vào của SPA: gắn cây React vào <div id="root"> trong index.html.
createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
