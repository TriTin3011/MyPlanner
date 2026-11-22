import { useTranslation } from 'react-i18next'
import { useHealth } from '../api/health'

// Chấm trạng thái kết nối backend ở đáy sidebar: xanh = API + DB ổn, vàng = API ổn nhưng DB lỗi,
// đỏ = không gọi được API. Đây là kết quả bước 0.7: FE gọi được BE.
export function HealthDot() {
  const { t } = useTranslation()
  const { data, isPending, isError } = useHealth()
  const state = isPending ? 'pending' : isError ? 'down' : data.database ? 'ok' : 'degraded'
  const label = t(`health.${state}`)
  const color = {
    pending: 'bg-muted-bar',
    down: 'bg-danger',
    degraded: 'bg-warn',
    ok: 'bg-primary',
  }[state]
  return (
    <p className="flex items-center gap-2 text-[11px] text-ink-muted max-lg:justify-center" title={label}>
      <span className={`size-2.5 shrink-0 rounded-full ${color}`} aria-hidden />
      <span className="max-lg:sr-only" role="status">
        {label}
      </span>
    </p>
  )
}
