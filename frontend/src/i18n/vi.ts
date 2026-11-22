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
  backup: {
    label: 'Dữ liệu',
    exportJson: 'Xuất dữ liệu (.json)',
    exporting: 'Đang xuất…',
    exportNow: 'Xuất dữ liệu',
    importJson: 'Nhập dữ liệu',
    importing: 'Đang nhập…',
    bannerReminder: 'Chưa sao lưu dữ liệu trong 7 ngày qua — hãy xuất bản sao lưu để tránh mất dữ liệu.',
    dismissBanner: 'Đóng thông báo sao lưu',
    confirmTitle: 'Nhập dữ liệu sao lưu',
    confirmWarning: 'Thao tác này sẽ ghi đè toàn bộ dữ liệu hiện tại bằng nội dung từ file đã chọn. Không thể hoàn tác.',
    confirmFile: 'File đã chọn: {{name}}',
    confirmSubmit: 'Ghi đè & nhập dữ liệu',
    confirmCancel: 'Huỷ',
    closeModal: 'Đóng',
    importSuccessTitle: 'Đã nhập dữ liệu thành công',
    importSuccessSummary:
      'Đã khôi phục {{tasks}} công việc, {{habits}} thói quen ({{habitLogs}} lượt đánh dấu) và {{goals}} mục tiêu.',
    invalidJson: 'File JSON không hợp lệ. Vui lòng chọn đúng file sao lưu.',
    exportError: 'Chưa xuất được dữ liệu. Hãy thử lại.',
    importError: 'Chưa nhập được dữ liệu. Hãy thử lại.',
  },
  shortcuts: {
    focusAddTask: 'Nhấn N để thêm việc mới',
    addTaskKey: 'N',
  },
}
