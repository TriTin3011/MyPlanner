interface ProgressRingProps {
  value: number
  label: string
  size?: 'sm' | 'md'
}

export function ProgressRing({ value, label, size = 'md' }: ProgressRingProps) {
  const safeValue = Math.min(100, Math.max(0, Math.round(value)))
  const sizeClass = size === 'sm' ? 'size-16' : 'size-20'

  return (
    <div
      role="progressbar"
      aria-label={label}
      aria-valuemin={0}
      aria-valuemax={100}
      aria-valuenow={safeValue}
      className={`relative grid shrink-0 place-items-center ${sizeClass}`}
    >
      <svg aria-hidden="true" viewBox="0 0 72 72" className="size-full -rotate-90">
        <circle
          cx="36"
          cy="36"
          r="28"
          pathLength="100"
          fill="none"
          strokeWidth="8"
          className="stroke-accent-tint"
        />
        <circle
          cx="36"
          cy="36"
          r="28"
          pathLength="100"
          fill="none"
          strokeWidth="8"
          strokeLinecap="round"
          strokeDasharray="100"
          strokeDashoffset={100 - safeValue}
          className="stroke-primary transition-[stroke-dashoffset] duration-500 motion-reduce:transition-none"
        />
      </svg>
      <span className="absolute font-display text-lg font-extrabold text-primary-ink">
        {safeValue}%
      </span>
    </div>
  )
}
