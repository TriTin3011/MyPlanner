# Mầm · Frontend

Ứng dụng web React 19 + TypeScript + Vite của Mầm. Xem giới thiệu chung ở [README gốc](../README.md).

## Lệnh

| Lệnh | Việc làm |
|------|----------|
| `npm run dev` | Chạy dev server ở `http://localhost:5173` |
| `npm run build` | Kiểm tra kiểu (`tsc -b`) rồi build ra `dist/` |
| `npm test` | Chạy unit test bằng Vitest |
| `npm run lint` | Chạy oxlint |
| `npm run gen:api` | Sinh `src/api/schema.ts` từ OpenAPI của backend (backend phải đang chạy ở cổng 5274) |

## Cấu hình

Sao chép `.env.example` thành `.env` rồi đặt `VITE_API_URL` là địa chỉ backend, không có `/api` ở cuối.

## Tổ chức code

| Thư mục | Nội dung |
|---------|----------|
| `src/app/` | App shell, router |
| `src/features/<màn hình>/` | Trang, component, hook và test của từng màn hình |
| `src/components/` | Component dùng chung (modal, biểu đồ, vòng tiến độ…) |
| `src/api/` | Axios client, kiểu sinh từ OpenAPI |
| `src/store/` | Cài đặt giao diện (Zustand, lưu `localStorage`) |
| `src/i18n/` | Bản dịch tiếng Việt và tiếng Anh |
| `src/styles/` | Token CSS, 4 bộ màu, phong cách vẽ tay |
