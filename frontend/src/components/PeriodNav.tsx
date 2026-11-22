import { ChevronLeft, ChevronRight } from 'lucide-react'

interface PeriodNavProps {
  // Nhãn nút giữa, ví dụ "Tuần này", "Tháng này", "Năm nay".
  currentLabel: string
  // Tên kỳ cho aria-label của hai nút mũi tên, ví dụ "tuần".
  unit: string
  onPrev: () => void
  onNext: () => void
  onCurrent: () => void
  // Đang ở kỳ hiện tại thì nút giữa mờ đi (vẫn bấm được, không làm gì).
  isCurrent: boolean
}

// ‹ [Tuần này] › dùng chung cho Tuần, Thói quen (tháng), Năm (SPEC §5).
// Component "ngu" (presentational): không biết tuần là gì, chỉ báo lên trang người dùng bấm nút nào.
export function PeriodNav({ currentLabel, unit, onPrev, onNext, onCurrent, isCurrent }: PeriodNavProps) {
  const button =
    'sketch grid min-h-11 min-w-11 cursor-pointer place-items-center bg-surface px-3 font-bold text-primary-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none'

  return (
    <nav aria-label={`Chuyển ${unit}`} className="flex items-center gap-2">
      <button type="button" onClick={onPrev} aria-label={`${unit} trước`} className={button}>
        <ChevronLeft size={18} aria-hidden="true" />
      </button>
      <button
        type="button"
        onClick={onCurrent}
        aria-current={isCurrent ? 'date' : undefined}
        className={`${button} text-sm ${isCurrent ? 'opacity-70' : ''}`}
      >
        {currentLabel}
      </button>
      <button type="button" onClick={onNext} aria-label={`${unit} sau`} className={button}>
        <ChevronRight size={18} aria-hidden="true" />
      </button>
    </nav>
  )
}
