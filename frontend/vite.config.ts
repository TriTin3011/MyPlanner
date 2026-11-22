import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { VitePWA } from 'vite-plugin-pwa'
import { defineConfig } from 'vitest/config'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.svg', 'favicon.ico', 'apple-touch-icon-180x180.png'],
      manifest: {
        name: 'Mầm — Kế hoạch & Thói quen',
        short_name: 'Mầm',
        description: 'Ứng dụng lập kế hoạch ngày, tuần, năm, theo dõi thói quen và mục tiêu cuộc sống.',
        theme_color: '#0A4D37',
        background_color: '#EEF4E8',
        display: 'standalone',
        start_url: '/',
        lang: 'vi',
        // PNG sinh bằng `npm run gen:icons` (pwa-assets.config.ts). Icon "maskable" tách riêng:
        // gộp 'any maskable' vào một ảnh làm logo bị cắt mép khi Android bo icon thành hình tròn.
        icons: [
          { src: 'pwa-64x64.png', sizes: '64x64', type: 'image/png' },
          { src: 'pwa-192x192.png', sizes: '192x192', type: 'image/png' },
          { src: 'pwa-512x512.png', sizes: '512x512', type: 'image/png' },
          { src: 'maskable-icon-512x512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
        ],
      },
      workbox: {
        // Chỉ precache tài nguyên tĩnh của giao diện (app shell: JS, CSS, HTML, font, SVG).
        // Không cache các request /api/* để dữ liệu nghiệp vụ luôn lấy từ Backend.
        globPatterns: ['**/*.{js,css,html,svg,png,ico,woff,woff2}'],
        navigateFallbackDenylist: [/^\/api\//],
      },
    }),
  ],
  test: {
    setupFiles: ['./src/test/setup.ts'],
    testTimeout: 15_000,
    maxWorkers: 4,
  },
})
