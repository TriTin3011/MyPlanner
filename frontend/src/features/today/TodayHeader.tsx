import { SlidersHorizontal } from 'lucide-react'
import type { TodayDashboardDto } from '../../api/types'
import { ProgressRing } from '../../components/ProgressRing'

const WEEKDAYS = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy']

const MOTIVATIONS = [
  'Buổi sáng là lúc tập trung tốt nhất, hãy làm việc quan trọng trước.',
  'Một bước nhỏ hoàn thành hôm nay sẽ tạo đà cho ngày mai.',
  'Chọn việc quan trọng nhất và bắt đầu bằng mười phút tập trung.',
  'Giữ nhịp đều quan trọng hơn cố làm mọi thứ cùng lúc.',
]

function formatVietnameseDate(value: string) {
  const [year, month, day] = value.split('-').map(Number)
  const weekday = WEEKDAYS[new Date(year, month - 1, day).getDay()]
  return `${weekday}, ${String(day).padStart(2, '0')}/${String(month).padStart(2, '0')}/${year}`
}

function dailyMotivation(date: string) {
  const seed = [...date].reduce((sum, char) => sum + char.charCodeAt(0), 0)
  return MOTIVATIONS[seed % MOTIVATIONS.length]
}

export function TodayHeader({
  dashboard,
  onArrangeBlocks,
}: {
  dashboard: TodayDashboardDto
  onArrangeBlocks?: () => void
}) {
  return (
    <header className="mb-6 grid gap-4 lg:grid-cols-[minmax(180px,1fr)_auto_minmax(260px,1.4fr)_auto] lg:items-center">
      <div>
        <h1 className="font-display text-3xl leading-none font-extrabold text-primary-ink md:text-4xl">
          Hôm nay
        </h1>
        <p className="mt-1 text-sm font-medium text-ink-muted">
          {formatVietnameseDate(dashboard.date)}
        </p>
      </div>

      <div className="flex items-center gap-3">
        <ProgressRing value={dashboard.percent} label="Tiến độ hôm nay" />
        <div className="space-y-1 font-display text-lg leading-tight font-extrabold">
          <p>
            {dashboard.tasksDone}/{dashboard.tasksTotal}{' '}
            <span className="text-ink-muted">việc</span>
          </p>
          <p>
            {dashboard.habitsDone}/{dashboard.habitsTotal}{' '}
            <span className="text-ink-muted">thói quen</span>
          </p>
        </div>
      </div>

      <p className="border-l-4 border-primary pl-4 text-sm leading-6 font-bold text-primary-ink lg:max-w-xl">
        {dailyMotivation(dashboard.date)}
      </p>

      <button
        type="button"
        onClick={onArrangeBlocks}
        disabled={!onArrangeBlocks}
        aria-haspopup="dialog"
        className="flex min-h-11 cursor-pointer items-center justify-center gap-2 rounded-full px-3 text-sm font-bold text-primary-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-60"
      >
        <SlidersHorizontal size={17} aria-hidden="true" />
        Sắp xếp khối
      </button>
    </header>
  )
}
