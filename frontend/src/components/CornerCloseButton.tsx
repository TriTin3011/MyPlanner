import { X } from 'lucide-react'

// Nút đóng nhỏ ngồi trên góc phải trên của khung nổi (khung cha phải là fixed/relative).
// Lệch ra ngoài 8px, khớp mép 8px mà clampPosition chừa, nên khung kéo sát mép trên vẫn thấy nút.
// Cỡ 24px là mức tối thiểu của WCAG 2.2 (2.5.8), đổi lại hàng nút chính rộng thêm một ô.
export function CornerCloseButton({ label, onClick }: { label: string; onClick: () => void }) {
  return (
    <button
      type="button"
      aria-label={label}
      title={label}
      onClick={onClick}
      className="absolute -top-2 -right-2 z-10 grid size-6 cursor-pointer place-items-center rounded-full border-2 border-ink bg-surface text-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
    >
      <X size={12} strokeWidth={3} aria-hidden />
    </button>
  )
}
