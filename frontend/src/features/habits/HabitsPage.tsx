import { LoaderCircle, RotateCcw } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { toLocalDateKey } from '../../lib/dates'
import { useRecurring } from '../recurring/hooks'
import { RecurringModal } from '../recurring/RecurringModal'
import { HabitDayChartBlock } from './HabitDayChartBlock'
import { HabitGrid } from './HabitGrid'
import { HabitsHeader } from './HabitsHeader'
import {
  addMonths,
  monthOf,
  useCreateHabit,
  useDeleteHabit,
  useHabitMonth,
  useReorderHabits,
  useToggleHabitCell,
} from './hooks'

// Màn hình Theo dõi thói quen (route "/habits", SPEC §8). Trang giữ "tháng đang xem", một query
// GET /dashboard/habits cấp số cho cả header, biểu đồ và lưới; các khối con chỉ nhận props.
export function HabitsPage() {
  const { t } = useTranslation()
  // "Hôm nay" theo giờ máy người dùng, chốt một lần khi mở trang (giống TodayPage, WeekPage).
  const [today] = useState(() => toLocalDateKey(new Date()))
  const [month, setMonth] = useState(() => monthOf(today))
  const [recurringOpen, setRecurringOpen] = useState(false)

  const habitMonth = useHabitMonth(month, today)
  const toggleCell = useToggleHabitCell(month, today)
  const createHabit = useCreateHabit()
  const deleteHabit = useDeleteHabit()
  const reorder = useReorderHabits()
  const recurring = useRecurring()

  if (habitMonth.isPending) {
    return (
      <div
        role="status"
        aria-live="polite"
        className="mx-auto flex min-h-64 w-full max-w-[1320px] items-center justify-center gap-3 text-primary-ink"
      >
        <LoaderCircle className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
        <span className="font-bold">{t('habits.loading')}</span>
      </div>
    )
  }

  if (habitMonth.isError) {
    return (
      <div
        role="alert"
        className="sketch mx-auto flex min-h-44 w-full max-w-2xl flex-col items-center justify-center gap-3 p-6 text-center"
      >
        <p className="font-bold">
          {t('habits.loadErrorPrefix')} {habitMonth.error.message}
        </p>
        <button
          type="button"
          onClick={() => habitMonth.refetch()}
          className="flex min-h-11 cursor-pointer items-center gap-2 rounded-full bg-primary px-4 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          <RotateCcw size={17} aria-hidden="true" />
          {t('common.retry')}
        </button>
      </div>
    )
  }

  const data = habitMonth.data
  const error = toggleCell.isError || createHabit.isError || deleteHabit.isError || reorder.isError

  return (
    <div className="mx-auto w-full max-w-[1320px]" aria-busy={habitMonth.isPlaceholderData}>
      <HabitsHeader
        month={data}
        isCurrentMonth={month === monthOf(today)}
        onPrev={() => setMonth((m) => addMonths(m, -1))}
        onNext={() => setMonth((m) => addMonths(m, 1))}
        onCurrent={() => setMonth(monthOf(today))}
      />

      <HabitDayChartBlock
        data={data}
        isLoading={habitMonth.isFetching && habitMonth.isPlaceholderData}
        isError={false}
        onRetry={() => habitMonth.refetch()}
      />

      {error && (
        <p role="alert" className="mt-4 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          {t('habits.updateError')}
        </p>
      )}

      <div className="mt-3 lg:mt-4">
        <HabitGrid
          // Đổi tháng thì dựng lại lưới, bỏ trạng thái kéo thả và lựa chọn Tháng/Tuần của tháng trước.
          key={data.month}
          month={data}
          today={today}
          recurringCount={recurring.data?.filter((r) => r.active).length ?? 0}
          isAdding={createHabit.isPending}
          onToggle={(habitId, date, done) => {
            toggleCell.reset()
            toggleCell.mutate({ habitId, date, done })
          }}
          // Thói quen mới bắt đầu từ hôm nay: các ngày trước đó trên lưới bị khoá, không kéo % xuống.
          onAdd={(title) => createHabit.mutate({ title, startDate: today })}
          onDelete={(habitId) => deleteHabit.mutate(habitId)}
          onReorder={(ids) => reorder.mutate({ ids, month, today })}
          onOpenRecurring={() => setRecurringOpen(true)}
        />
      </div>

      <RecurringModal open={recurringOpen} today={today} onClose={() => setRecurringOpen(false)} />
    </div>
  )
}
