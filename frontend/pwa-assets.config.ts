import { defineConfig, minimal2023Preset } from '@vite-pwa/assets-generator/config'

// Sinh icon PNG cho PWA từ logo SVG: chạy `npm run gen:icons` khi đổi logo.
// Preset minimal2023 tạo pwa-64/192/512, maskable-icon-512 và apple-touch-icon-180.
export default defineConfig({
  headLinkOptions: { preset: '2023' },
  preset: {
    ...minimal2023Preset,
    // Nền giấy của app thay cho nền trắng mặc định ở icon maskable và icon iOS.
    maskable: { ...minimal2023Preset.maskable, resizeOptions: { background: '#EEF4E8' } },
    apple: { ...minimal2023Preset.apple, resizeOptions: { background: '#EEF4E8' } },
  },
  images: ['public/favicon.svg'],
})
