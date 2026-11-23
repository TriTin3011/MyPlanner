// Icon quả cà chua tự vẽ. Màu đỏ cố định để nhận ra ngay dù đang dùng bộ màu nào.
export function TomatoIcon({ size = 22 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M12 6.5c5 -1.6 9 1.5 9 6.4 0 4.9 -4 8.1 -9 8.1s-9 -3.2 -9 -8.1c0 -4.9 4 -8 9 -6.4Z"
        fill="#E5484D"
        stroke="var(--ink)"
        strokeWidth="1.8"
        strokeLinejoin="round"
      />
      <path d="M7 12.5c.2 -1.3 1 -2.2 2.2 -2.6" fill="none" stroke="#fff" strokeWidth="1.5" strokeLinecap="round" />
      <path
        d="M12 7.2 8.6 9l.8 -3L7 4.8l3.2 -.3L12 2.5l1.8 2 3.2.3L14.6 6l.8 3L12 7.2Z"
        fill="#22A06B"
        stroke="var(--ink)"
        strokeWidth="1.3"
        strokeLinejoin="round"
      />
    </svg>
  )
}
