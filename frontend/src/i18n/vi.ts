// Bản dịch tiếng Việt: ngôn ngữ gốc của app và là "hợp đồng" cho mọi bản dịch khác.
// en.ts phải có đúng các khoá này (TypeScript báo lỗi nếu thiếu), còn t('...') chỉ nhận khoá có ở đây.
// Nhóm khoá theo nơi dùng (nav, shell, theme...) để dễ tìm và dễ tách file theo feature về sau.
export const vi = {
  nav: {
    today: { label: 'Hôm nay', short: 'Hôm nay' },
    goals: { label: 'Mục tiêu & tầm nhìn', short: 'Mục tiêu' },
    habits: { label: 'Theo dõi thói quen', short: 'Thói quen' },
    week: { label: 'Kế hoạch tuần', short: 'Tuần' },
    year: { label: 'Kế hoạch năm', short: 'Năm' },
    stats: { label: 'Thống kê', short: 'Thống kê' },
  },
  shell: {
    mainNav: 'Điều hướng chính',
    openMenu: 'Mở menu',
    closeMenu: 'Đóng menu',
    menu: 'Menu',
    quickSettings: 'Cài đặt nhanh',
    showClock: 'Xem giờ',
  },
  theme: {
    label: 'Bộ màu',
    choose: 'Chọn bộ màu',
    forest: 'Rừng xanh',
    ocean: 'Biển đêm',
    sunset: 'Hoàng hôn',
    lavender: 'Oải hương',
  },
  language: {
    label: 'Ngôn ngữ',
  },
  health: {
    pending: 'Đang kiểm tra API…',
    down: 'Không kết nối được API',
    degraded: 'API chạy, database lỗi',
    ok: 'Đã kết nối API',
  },
}
