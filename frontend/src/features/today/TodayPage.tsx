import { AlertCircle, LoaderCircle, RotateCcw } from 'lucide-react'
import { Fragment, type ReactNode, useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { TaskDto } from '../../api/types'
import type { TaskItemMenuActions } from '../../components/TaskItem'
import { toLocalDateKey } from '../../lib/dates'
import { useRecurring } from '../recurring/hooks'
import { RecurringModal } from '../recurring/RecurringModal'
import { type TodayBlockId, useSettings } from '../../store/settings'
import { TodayLayoutModal } from './TodayLayoutModal'
import { groupTodayBlocks, normalizeTodayLayout } from './todayLayout'
import { TodayHeader } from './TodayHeader'
import { TodayProgressChartBlock } from './TodayProgressChartBlock'
import { PlanningCalendarBlock } from './PlanningCalendarBlock'
import { TodayBacklogBlock } from './TodayBacklogBlock'
import { TodayHabitsBlock } from './TodayHabitsBlock'
import { TodayTasksBlock } from './TodayTasksBlock'
import {
  useCreateTask,
  useDeleteTask,
  useMaterializeRecurring,
  useMoveBacklogToToday,
  useMoveTaskToDate,
  useReorderTodayTasks,
  useSaveDayNote,
  useSaveTask,
  useTodayDashboard,
  useToggleHabit,
  useToggleTask,
  useUpdateSubtask,
  useUpdateTaskTitle,
} from './hooks'

// Màn hình Hôm nay (route "/", SPEC §6). Trang ghép các khối; hook giữ server state.
export function TodayPage() {
  const { t } = useTranslation()
  const [today] = useState(() => toLocalDateKey(new Date()))
  const dashboard = useTodayDashboard(today)
  const toggleTask = useToggleTask()
  const createTask = useCreateTask()
  const updateTaskTitle = useUpdateTaskTitle()
  const updateSubtask = useUpdateSubtask()
  const toggleHabit = useToggleHabit()
  const saveDayNote = useSaveDayNote()
  const moveBacklog = useMoveBacklogToToday()
  const moveTask = useMoveTaskToDate()
  const deleteTask = useDeleteTask()
  const saveTask = useSaveTask()
  const reorder = useReorderTodayTasks(today)
  const recurring = useRecurring()
  const materialize = useMaterializeRecurring()
  const [recurringOpen, setRecurringOpen] = useState(false)
  const [layoutOpen, setLayoutOpen] = useState(false)
  // Bố cục khối là cài đặt UI (localStorage), không phải dữ liệu nghiệp vụ nên không đi qua API.
  const layout = normalizeTodayLayout(useSettings((s) => s.todayLayout))

  // Mở Hôm nay thì nhờ BE sinh Task từ Việc lặp lại cho hôm nay..+7 (SPEC §14.3). Endpoint idempotent nên
  // StrictMode gọi effect hai lần cũng không sinh trùng; mutate ổn định nên effect chỉ chạy khi đổi ngày.
  const { mutate: runMaterialize } = materialize
  useEffect(() => {
    runMaterialize(today)
  }, [runMaterialize, today])

  // Menu ⋯ của Việc hôm nay. Mọi thao tác sửa đi qua PUT /tasks/{id} với patch đã ghép (toSaveTaskRequest).
  function todayTaskMenu(task: TaskDto): TaskItemMenuActions {
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

  if (dashboard.isPending) {
    return (
      <div
        role="status"
        aria-live="polite"
        className="mx-auto flex min-h-64 w-full max-w-[1320px] items-center justify-center gap-3 text-primary-ink"
      >
        <LoaderCircle className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
        <span className="font-bold">{t('today.loading')}</span>
      </div>
    )
  }

  if (dashboard.isError) {
    return (
      <div
        role="alert"
        className="sketch mx-auto flex min-h-44 w-full max-w-2xl flex-col items-center justify-center gap-3 p-6 text-center"
      >
        <AlertCircle className="text-danger" aria-hidden="true" />
        <p className="font-bold">{dashboard.error.message}</p>
        <button
          type="button"
          onClick={() => dashboard.refetch()}
          className="flex min-h-11 items-center gap-2 rounded-full bg-primary px-4 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
        >
          <RotateCcw size={17} aria-hidden="true" />
          {t('common.retry')}
        </button>
      </div>
    )
  }

  const blocks: Record<TodayBlockId, ReactNode> = {
    progress: <TodayProgressChartBlock today={today} />,
    backlog: (
      <TodayBacklogBlock
        backlog={dashboard.data.backlog}
        moveAllPending={moveBacklog.isPending}
        pendingTaskId={
          moveTask.isPending
            ? moveTask.variables.task.id
            : deleteTask.isPending
              ? deleteTask.variables
              : undefined
        }
        error={moveBacklog.isError || moveTask.isError || deleteTask.isError}
        onMoveAll={async () => {
          await moveBacklog.mutateAsync(today)
        }}
        onMoveTask={async (task) => {
          await moveTask.mutateAsync({ task, date: today })
        }}
        onChangeDate={async (task, date) => {
          await moveTask.mutateAsync({ task, date })
        }}
        onDeleteTask={async (id) => {
          await deleteTask.mutateAsync(id)
        }}
        onToggleTask={(id, done) => {
          toggleTask.reset()
          toggleTask.mutate({ id, done })
        }}
      />
    ),
    tasks: (
      <TodayTasksBlock
        tasks={dashboard.data.tasks}
        pendingTaskId={toggleTask.isPending ? toggleTask.variables.id : undefined}
        pendingRenameTaskId={updateTaskTitle.isPending ? updateTaskTitle.variables.task.id : undefined}
        pendingSubtaskId={updateSubtask.isPending ? updateSubtask.variables.subtaskId : undefined}
        error={toggleTask.isError || reorder.isError}
        onToggle={(id, done) => {
          toggleTask.reset()
          toggleTask.mutate({ id, done })
        }}
        onRename={async (task, title) => {
          await updateTaskTitle.mutateAsync({ task, title })
        }}
        onToggleSubtask={async (task, subtaskId, done) => {
          await updateSubtask.mutateAsync({ task, subtaskId, done })
        }}
        addPending={createTask.isPending}
        onAdd={async (title) => {
          await createTask.mutateAsync({ title, date: today })
        }}
        noteContent={dashboard.data.note?.content ?? ''}
        onSaveNote={async (content) => {
          await saveDayNote.mutateAsync({ date: today, content })
        }}
        isSavingNote={saveDayNote.isPending}
        menuFor={todayTaskMenu}
        recurringCount={recurring.data?.filter((r) => r.active).length}
        onOpenRecurring={() => setRecurringOpen(true)}
        onReorder={(ids) => {
          reorder.reset()
          reorder.mutate(ids)
        }}
      />
    ),
    habits: (
      <TodayHabitsBlock
        habits={dashboard.data.habits}
        pendingHabitId={toggleHabit.isPending ? toggleHabit.variables.habitId : undefined}
        error={toggleHabit.isError}
        onToggle={(habitId, done) => {
          toggleHabit.reset()
          toggleHabit.mutate({ habitId, date: today, done })
        }}
      />
    ),
    calendar: (
      <PlanningCalendarBlock
        today={today}
        onAddTask={async (title, date) => {
          await createTask.mutateAsync({ title, date })
        }}
        addPending={createTask.isPending}
      />
    ),
  }

  return (
    <div className="mx-auto w-full max-w-[1320px]">
      <TodayHeader dashboard={dashboard.data} onArrangeBlocks={() => setLayoutOpen(true)} />
      <div className="flex flex-col gap-3 lg:gap-4">
        {groupTodayBlocks(layout).map((group) =>
          group.length === 2 ? (
            <div key={group.join('-')} className="grid items-start gap-3 lg:grid-cols-2 lg:gap-4">
              <Fragment key={group[0]}>{blocks[group[0]]}</Fragment>
              <Fragment key={group[1]}>{blocks[group[1]]}</Fragment>
            </div>
          ) : (
            <Fragment key={group[0]}>{blocks[group[0]]}</Fragment>
          ),
        )}
      </div>
      <RecurringModal open={recurringOpen} today={today} onClose={() => setRecurringOpen(false)} />
      <TodayLayoutModal open={layoutOpen} onClose={() => setLayoutOpen(false)} />
    </div>
  )
}
