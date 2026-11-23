import { AlertCircle, Info, LoaderCircle, Repeat2, RotateCcw } from 'lucide-react'
import { type ReactNode, useEffect, useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { DeadlineDto, TaskDto } from '../../api/types'
import { TaskItem, type TaskItemMenuActions } from '../../components/TaskItem'
import { addDays, isoWeekKey, startOfWeek, toLocalDateKey } from '../../lib/dates'
import { useRecurring } from '../recurring/hooks'
import { RecurringModal } from '../recurring/RecurringModal'
import {
  useCreateTask,
  useDeleteTask,
  useSaveDayNote,
  useSaveTask,
  useToggleTask,
  useUpdateSubtask,
  useUpdateTaskTitle,
} from '../today/hooks'
import {
  groupTasksByDate,
  useArrangeWeekTasks,
  useDayNotes,
  useDeadlines,
  useMaterializeWeek,
  useWeekDashboard,
  useWeekTasks,
} from './hooks'
import { DeleteWeekLink } from './DeleteWeekLink'
import { WeekDaysBoard } from './WeekDaysBoard'
import { WeekHeader } from './WeekHeader'
import { WeekNoteBlock } from './WeekNoteBlock'
import { WeekProgressChartBlock } from './WeekProgressChartBlock'

// Màn hình Kế hoạch tuần (route "/week", SPEC §9). Trang giữ "tuần đang xem" (Thứ 2 của tuần),
// hook lấy số liệu theo tuần đó, các khối con chỉ nhận props.
export function WeekPage() {
  const { t } = useTranslation()
  // "Hôm nay" theo giờ máy người dùng, chốt một lần khi mở trang (giống TodayPage).
  const [today] = useState(() => toLocalDateKey(new Date()))
  const [monday, setMonday] = useState(() => startOfWeek(today))
  const [resetCount, setResetCount] = useState(0)
  const weekKey = isoWeekKey(monday)
  const isCurrentWeek = monday === startOfWeek(today)
  const week = useWeekDashboard(weekKey, today)

  if (week.isPending) {
    return (
      <div
        role="status"
        aria-live="polite"
        className="mx-auto flex min-h-64 w-full max-w-[1320px] items-center justify-center gap-3 text-primary-ink"
      >
        <LoaderCircle className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
        <span className="font-bold">{t('week.loading')}</span>
      </div>
    )
  }

  if (week.isError) {
    return (
      <div
        role="alert"
        className="sketch mx-auto flex min-h-44 w-full max-w-2xl flex-col items-center justify-center gap-3 p-6 text-center"
      >
        <AlertCircle className="text-danger" aria-hidden="true" />
        <p className="font-bold">
          {t('week.loadErrorPrefix')} {week.error.message}
        </p>
        <button
          type="button"
          onClick={() => week.refetch()}
          className="flex min-h-11 items-center gap-2 rounded-xl bg-primary px-4 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
        >
          <RotateCcw size={17} aria-hidden="true" />
          {t('common.retry')}
        </button>
      </div>
    )
  }

  return (
    // aria-busy: đang hiện số tuần cũ (keepPreviousData) trong lúc chờ tuần mới.
    <div className="mx-auto w-full max-w-[1320px]" aria-busy={week.isPlaceholderData}>
      <WeekHeader
        week={week.data}
        isCurrentWeek={isCurrentWeek}
        onPrev={() => setMonday((m) => addDays(m, -7))}
        onNext={() => setMonday((m) => addDays(m, 7))}
        onCurrent={() => setMonday(startOfWeek(today))}
      />
      <WeekProgressChartBlock monday={monday} className="mt-3 lg:mt-4" />
      <div className="mt-3 lg:mt-4">
        <WeekNoteBlock weekKey={weekKey} />
      </div>
      {/* key đổi sau khi xoá tuần → khối remount → effect materialize chạy lại (SPEC §9.5). */}
      <WeekTasksSection key={`${monday}-${resetCount}`} monday={monday} today={today} />
      <DeleteWeekLink weekKey={weekKey} onDeleted={() => setResetCount((n) => n + 1)} />
    </div>
  )
}

// Khối "Công việc trong tuần" (SPEC §9.4): 7 cột ngày. Tách riêng để header không phải chờ dữ liệu việc,
// và mỗi khối có trạng thái tải/lỗi của riêng nó.
function WeekTasksSection({ monday, today }: { monday: string; today: string }) {
  const { t } = useTranslation()
  const sunday = addDays(monday, 6)
  // Memo theo tuần: bảng tự cuộn tới hôm nay khi `dates` đổi, nên mảng mới mỗi lần render sẽ cuộn liên tục.
  const dates = useMemo(() => Array.from({ length: 7 }, (_, i) => addDays(monday, i)), [monday])

  const tasks = useWeekTasks(monday, sunday)
  const deadlines = useDeadlines(monday, sunday, today)
  const notes = useDayNotes(dates)
  const arrange = useArrangeWeekTasks(monday, sunday)
  const toggleTask = useToggleTask()
  const createTask = useCreateTask()
  const updateTaskTitle = useUpdateTaskTitle()
  const updateSubtask = useUpdateSubtask()
  const saveTask = useSaveTask()
  const deleteTask = useDeleteTask()
  const saveDayNote = useSaveDayNote()
  const recurring = useRecurring()
  const [recurringOpen, setRecurringOpen] = useState(false)

  // Tuần còn ngày từ hôm nay trở đi thì nhờ BE sinh việc lặp lại cho phần đó (idempotent, an toàn khi gọi lại).
  const { mutate: runMaterialize } = useMaterializeWeek()
  useEffect(() => {
    if (sunday >= today) runMaterialize({ monday, sunday, today })
  }, [runMaterialize, monday, sunday, today])

  function taskMenu(task: TaskDto): TaskItemMenuActions {
    return {
      onToggleTag: (tag) => {
        const tags = task.tags.includes(tag) ? task.tags.filter((t) => t !== tag) : [...task.tags, tag]
        return saveTask.mutateAsync({ task, patch: { tags } })
      },
      onAddSubtask: (title) =>
        saveTask.mutateAsync({ task, patch: { subtasks: [...task.subtasks, { id: null, title, done: false }] } }),
      onChangeDate: (date) => saveTask.mutateAsync({ task, patch: { date } }),
      onDelete: () => deleteTask.mutateAsync(task.id),
    }
  }

  function renderTask(task: TaskDto, dragHandle: ReactNode) {
    return (
      <TaskItem
        task={task}
        pending={toggleTask.isPending && toggleTask.variables.id === task.id}
        renamePending={updateTaskTitle.isPending && updateTaskTitle.variables.task.id === task.id}
        pendingSubtaskId={updateSubtask.isPending ? updateSubtask.variables.subtaskId : undefined}
        onToggle={(id, done) => {
          toggleTask.reset()
          toggleTask.mutate({ id, done })
        }}
        onRename={async (t, title) => {
          await updateTaskTitle.mutateAsync({ task: t, title })
        }}
        onToggleSubtask={async (t, subtaskId, done) => {
          await updateSubtask.mutateAsync({ task: t, subtaskId, done })
        }}
        menu={taskMenu(task)}
        dragHandle={dragHandle}
      />
    )
  }

  // Giữ nguyên tham chiếu khi cache chưa đổi: WeekDaysBoard dựa vào việc "tasksByDate đổi" để bỏ bản nháp kéo thả.
  const tasksByDate = useMemo(() => groupTasksByDate(tasks.data ?? [], dates), [tasks.data, dates])

  const deadlinesByDate: Record<string, DeadlineDto[]> = {}
  for (const d of deadlines.data ?? []) (deadlinesByDate[d.date] ??= []).push(d)
  const notesByDate = Object.fromEntries(dates.map((date, i) => [date, notes[i]?.data?.content ?? '']))
  const error = toggleTask.isError || arrange.isError || createTask.isError

  return (
    <section aria-labelledby="week-tasks-title" className="mt-3 lg:mt-4">
      <div className="mb-3 flex flex-wrap items-center justify-between gap-2">
        <h2 id="week-tasks-title" className="flex items-center gap-1.5 font-display text-xl font-extrabold text-primary-ink">
          {t('week.tasksSection.title')}
          <span
            title={t('week.tasksSection.infoTitle')}
            className="text-ink-muted"
          >
            <Info size={16} aria-hidden="true" />
            <span className="sr-only">
              {t('week.tasksSection.infoSr')}
            </span>
          </span>
        </h2>
        <button
          type="button"
          onClick={() => setRecurringOpen(true)}
          aria-haspopup="dialog"
          className="flex min-h-11 cursor-pointer items-center gap-1.5 rounded-xl px-3 text-sm font-bold text-primary-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          <Repeat2 size={16} aria-hidden="true" />
          {t('week.tasksSection.recurringButton')}
          {recurring.data && (
            <span className="rounded-full bg-accent-tint px-2 py-0.5 text-xs">
              {recurring.data.filter((r) => r.active).length}
            </span>
          )}
        </button>
      </div>

      {error && (
        <p role="alert" className="mb-3 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          {t('week.tasksSection.updateError')}
        </p>
      )}

      {tasks.isPending ? (
        <div role="status" className="flex min-h-40 items-center justify-center gap-2 text-primary-ink">
          <LoaderCircle className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
          <span className="font-bold">{t('week.tasksSection.loadingTasks')}</span>
        </div>
      ) : tasks.isError ? (
        <div role="alert" className="sketch flex flex-col items-center gap-3 p-6 text-center">
          <p className="font-bold">{tasks.error.message}</p>
          <button
            type="button"
            onClick={() => tasks.refetch()}
            className="flex min-h-11 items-center gap-2 rounded-xl bg-primary px-4 font-bold text-white hover:opacity-90"
          >
            <RotateCcw size={17} aria-hidden="true" />
            {t('common.retry')}
          </button>
        </div>
      ) : (
        <WeekDaysBoard
          dates={dates}
          today={today}
          tasksByDate={tasksByDate}
          deadlinesByDate={deadlinesByDate}
          notesByDate={notesByDate}
          onArrange={(input) => {
            arrange.reset()
            arrange.mutate(input)
          }}
          renderTask={renderTask}
          addPendingDate={createTask.isPending ? createTask.variables.date : undefined}
          onAdd={async (date, title) => {
            await createTask.mutateAsync({ title, date })
          }}
          onSaveNote={async (date, content) => {
            await saveDayNote.mutateAsync({ date, content })
          }}
        />
      )}

      <RecurringModal open={recurringOpen} today={today} onClose={() => setRecurringOpen(false)} />
    </section>
  )
}
