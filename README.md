# MyPlanner

Web planner cá nhân: việc hằng ngày, thói quen, mục tiêu, kế hoạch tuần/năm, thống kê.

## Cấu trúc repo

| Thư mục | Nội dung | Deploy |
|---------|----------|--------|
| `backend/` | ASP.NET Core Web API (.NET 10) + EF Core | Server/container riêng (VD: Render, Azure App Service, VPS) |
| `frontend/` | React + Vite + TypeScript, responsive cho PC và điện thoại (PWA), gọi API qua `VITE_API_URL` | Static host riêng (VD: Vercel, Netlify, Cloudflare Pages) |
| `desktop/` | WPF (.NET 10), gọi cùng API — làm sau | Bản cài Windows |
| `mobile/` | Flutter (Android/iOS), gọi cùng API — làm sau | Google Play / App Store |

FE và BE tách thư mục, build và deploy độc lập; chung một repo để giữ đồng bộ API contract. Hợp đồng API xem ở OpenAPI của backend (`/scalar/v1` khi chạy dev).

Quy ước nhánh, commit message và pull request: xem [CONTRIBUTING.md](CONTRIBUTING.md).
