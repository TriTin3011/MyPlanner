import type { ReactNode } from 'react'

export interface StatItem {
  // Nhãn chữ in hoa nhỏ, ví dụ "ĐÃ XONG".
  label: string
  icon: ReactNode
  // Số chính in đậm, ví dụ "24".
  value: ReactNode
  // Phần phụ nhạt màu sau số, ví dụ "/ 42" hoặc "việc".
  suffix?: ReactNode
}

// Dải 3 ô số liệu (SPEC §5) dùng ở Tuần và Thói quen. Chỉ hiển thị: số đã do BE tính sẵn.
// Dùng <dl> (danh sách thuật ngữ / giá trị) để trình đọc màn hình đọc thành cặp "Đã xong: 24 / 42".
export function StatStrip({ items }: { items: StatItem[] }) {
  return (
    <dl className="sketch grid grid-cols-3 divide-x-2 divide-dashed divide-[var(--grid-line)] px-1 py-2">
      {items.map((item) => (
        <div key={item.label} className="min-w-0 px-3">
          <dt className="flex items-center gap-1 text-[11px] font-extrabold tracking-wide text-ink-muted uppercase">
            <span className="text-primary">{item.icon}</span>
            {item.label}
          </dt>
          <dd className="mt-0.5 font-display text-xl leading-tight font-extrabold whitespace-nowrap text-primary-ink">
            {item.value}
            {item.suffix && <span className="ml-1 text-sm text-ink-muted">{item.suffix}</span>}
          </dd>
        </div>
      ))}
    </dl>
  )
}
