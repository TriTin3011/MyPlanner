// Logo Mầm: vòng tiến độ vẽ tay hở một đoạn, lá mọc ở đầu vòng, ba chấm là chuỗi ngày liên tiếp.
// Màu đọc từ CSS variables nên logo đổi theo 4 bộ màu; bản tĩnh cho favicon ở public/favicon.svg.
export function BrandMark({ size = 40, className }: { size?: number; className?: string }) {
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} className={className} aria-hidden="true" focusable="false">
      <circle cx="32" cy="34" r="22" fill="var(--accent-tint)" />
      <path
        d="M32 12 A22 22 0 1 1 12.5 24"
        fill="none"
        stroke="var(--primary)"
        strokeWidth="6"
        strokeLinecap="round"
      />
      <path
        d="M32 12 C31 7 35 3 41 3 C41 8 37 12 32 12 Z"
        fill="var(--primary)"
        stroke="var(--primary-ink)"
        strokeWidth="2"
        strokeLinejoin="round"
      />
      <circle cx="23" cy="36" r="3.2" fill="var(--primary-ink)" />
      <circle cx="32" cy="36" r="3.2" fill="var(--primary-ink)" />
      <circle cx="41" cy="36" r="3.2" fill="var(--primary)" />
    </svg>
  )
}
