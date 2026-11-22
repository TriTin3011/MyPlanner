import { Clock, Gift } from 'lucide-react'
import type { GoalCardDto, GoalStatus } from '../../api/types'
import { formatDmy, GOAL_STATUS_LABEL, lifeArea } from './lifeAreas'

export interface GoalCardProps {
  goal: GoalCardDto
  onOpen(id: string): void
  onToggleDone(id: string, done: boolean): void
  disabled?: boolean
}

const STATUS_BADGE_CLASS: Record<GoalStatus, string> = {
  not_started: 'bg-line text-ink-muted',
  in_progress: 'bg-accent-soft text-primary-ink',
  done: 'bg-primary text-white',
}

// Thẻ mục tiêu trong lưới 3 cột (SPEC §7.4). Toàn bộ số %, ngày còn lại và cờ `behind` lấy từ BE.
export function GoalCard({ goal, onOpen, onToggleDone, disabled = false }: GoalCardProps) {
  const isDone = goal.status === 'done'
  const areaInfo = lifeArea(goal.area)
  const AreaIcon = areaInfo.Icon
  const isOverdue = !isDone && goal.daysLeft < 0

  // Mẫu "stretched button": thẻ là <article> thường, nút mở nằm ở tiêu đề và có ::after phủ kín thẻ
  // để bấm đâu trên thẻ cũng mở. Checkbox nằm trên lớp phủ (relative z-10) nên là phần tử ngang hàng,
  // không bị lồng trong role="button" (lồng control trong control là lỗi a11y, trình đọc màn hình bỏ qua).
  return (
    <article className="sketch relative flex flex-col justify-between gap-2.5 bg-surface p-4 transition-transform focus-within:-translate-y-0.5 hover:-translate-y-0.5">
      <div className="space-y-2">
        {/* Hàng 1: Checkbox hoàn thành + Tiêu đề + Badge trạng thái */}
        <div className="flex items-center justify-between gap-2">
          <div className="flex min-w-0 flex-1 items-center gap-1">
            <label className="relative z-10 -ml-2 grid min-h-11 min-w-11 shrink-0 cursor-pointer place-items-center rounded-full hover:bg-accent-tint/70">
              <input
                type="checkbox"
                checked={isDone}
                disabled={disabled}
                aria-label={`Đánh dấu hoàn thành: ${goal.title}`}
                onChange={(event) => onToggleDone(goal.id, event.target.checked)}
                className="size-5 cursor-pointer rounded accent-primary disabled:cursor-not-allowed disabled:opacity-50"
              />
            </label>

            <h3
              title={goal.title}
              className={`min-w-0 flex-1 truncate font-display text-base font-extrabold ${
                isDone ? 'text-ink-muted line-through' : 'text-ink'
              }`}
            >
              <button
                type="button"
                onClick={() => onOpen(goal.id)}
                className="block w-full cursor-pointer truncate text-left after:absolute after:inset-0 focus-visible:outline-none focus-visible:after:ring-2 focus-visible:after:ring-primary focus-visible:after:ring-offset-2"
              >
                {goal.title}
              </button>
            </h3>
          </div>

          <span
            className={`shrink-0 rounded-full px-2.5 py-0.5 text-xs font-bold ${STATUS_BADGE_CLASS[goal.status]}`}
          >
            {GOAL_STATUS_LABEL[goal.status]}
          </span>
        </div>

        {/* Hàng 2: Lĩnh vực (nhãn đầy đủ) + Hạn & số ngày còn/quá hạn */}
        <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-xs font-medium text-ink-muted">
          <span className="inline-flex items-center gap-1">
            <AreaIcon size={13} className="shrink-0 text-primary" aria-hidden="true" />
            <span>{areaInfo.label}</span>
          </span>

          <span
            className={`inline-flex items-center gap-1 ${
              isOverdue ? 'font-bold text-danger' : 'text-ink-muted'
            }`}
          >
            <Clock size={13} className="shrink-0" aria-hidden="true" />
            <span>
              {formatDmy(goal.deadline)}
              {!isDone && (
                <>
                  {goal.daysLeft > 0 && ` · còn ${goal.daysLeft} ngày`}
                  {goal.daysLeft === 0 && ' · hôm nay'}
                  {goal.daysLeft < 0 && ` · quá hạn ${Math.abs(goal.daysLeft)} ngày`}
                </>
              )}
            </span>
          </span>
        </div>

        {/* Hàng 3: Phần thưởng (nếu có) + Số bước quá hạn + x/y bước */}
        <div className="flex items-center justify-between gap-2 text-xs text-ink-muted">
          <div className="flex min-w-0 flex-1 items-center gap-2">
            {goal.reward && (
              <span className="inline-flex min-w-0 items-center gap-1" title={goal.reward}>
                <Gift size={13} className="shrink-0 text-primary" aria-hidden="true" />
                <span className="truncate">{goal.reward}</span>
              </span>
            )}
            {goal.overdueSteps > 0 && (
              <span className="shrink-0 font-bold text-danger">
                {goal.overdueSteps} bước quá hạn
              </span>
            )}
          </div>

          <span className="shrink-0 font-semibold text-ink-muted">
            {goal.stepsDone}/{goal.stepsTotal} bước
          </span>
        </div>
      </div>

      {/* Hàng 4: Hai thanh tiến độ Tiến độ & Thời gian đặt cạnh nhau + Cảnh báo chậm kế hoạch */}
      <div className="space-y-1.5 pt-1">
        <div className="grid grid-cols-2 gap-3">
          {/* Thanh Tiến độ */}
          <div>
            <div className="mb-1 flex items-center justify-between text-xs">
              <span className="font-medium text-ink-muted">Tiến độ</span>
              <span className="font-bold text-ink">{goal.stepPercent}%</span>
            </div>
            <div
              role="progressbar"
              aria-label={`Tiến độ ${goal.stepPercent}%`}
              aria-valuemin={0}
              aria-valuemax={100}
              aria-valuenow={goal.stepPercent}
              className="h-1.5 w-full overflow-hidden rounded-full bg-line"
            >
              <div
                className="h-full rounded-full bg-primary transition-[width]"
                style={{ width: `${Math.max(0, Math.min(100, goal.stepPercent))}%` }}
              />
            </div>
          </div>

          {/* Thanh Thời gian: chuyển sang màu cam (--warn) khi behind */}
          <div>
            <div className="mb-1 flex items-center justify-between text-xs">
              <span className={goal.behind ? 'font-bold text-warn-ink' : 'font-medium text-ink-muted'}>
                Thời gian
              </span>
              <span className={goal.behind ? 'font-bold text-warn-ink' : 'font-bold text-ink'}>
                {goal.timePercent}%
              </span>
            </div>
            <div
              role="progressbar"
              aria-label={`Thời gian ${goal.timePercent}%`}
              aria-valuemin={0}
              aria-valuemax={100}
              aria-valuenow={goal.timePercent}
              className="h-1.5 w-full overflow-hidden rounded-full bg-line"
            >
              <div
                className="h-full rounded-full transition-[width]"
                style={{
                  width: `${Math.max(0, Math.min(100, goal.timePercent))}%`,
                  backgroundColor: goal.behind ? 'var(--warn)' : 'var(--primary)',
                }}
              />
            </div>
          </div>
        </div>

        {goal.behind && (
          <p className="text-xs font-bold text-warn-ink">Đang chậm hơn kế hoạch</p>
        )}
      </div>
    </article>
  )
}
