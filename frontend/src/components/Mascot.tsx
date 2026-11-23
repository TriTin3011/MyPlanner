import './Mascot.css'

/** `still` không có animation, dùng khi nhiều linh vật có thể xuất hiện cùng lúc. */
export type MascotMotion = 'idle' | 'success' | 'still'

interface MascotProps {
  motion?: MascotMotion
  size?: number
  label?: string
  className?: string
}

/**
 * Mascot Mầm dùng một ảnh trong suốt và chỉ animate transform/opacity.
 * Component giữ sẵn khung vuông để ảnh tải chậm không làm xê dịch bố cục.
 */
export function Mascot({ motion = 'idle', size = 160, label, className = '' }: MascotProps) {
  return (
    <span
      className={`mascot mascot--${motion} ${className}`.trim()}
      style={{ width: `${size}px`, height: `${size}px` }}
    >
      <img
        className="mascot__image"
        src="/mascot/mam-companion.webp"
        alt={label ?? ''}
        width={739}
        height={768}
        loading="lazy"
        decoding="async"
        draggable={false}
      />
      <span className="mascot__streak" aria-hidden="true">
        <i />
        <i />
        <i />
      </span>
    </span>
  )
}
