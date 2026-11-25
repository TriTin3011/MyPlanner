import { Info, LoaderCircle, Plus, RotateCcw } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { toLocalDateKey } from '../../lib/dates'
import { AreaRadar } from './AreaRadar'
import { GoalCardGrid } from './GoalCardGrid'
import { GoalDrawer } from './GoalDrawer'
import { GoalsOverview } from './GoalsOverview'
import {
  useAddStep,
  useCreateGoal,
  useCreateGoalArea,
  useDeleteGoal,
  useDeleteGoalArea,
  useDeleteStep,
  useGoal,
  useGoalAreas,
  useGoalBoard,
  useReorderSteps,
  useToggleGoalDone,
  useUpdateGoal,
  useUpdateStep,
} from './hooks'
import { areaDisplay } from './lifeAreas'

// Drawer đang đóng, đang tạo mới, hay đang sửa mục tiêu có id.
type DrawerState = null | { mode: 'create' } | { mode: 'edit'; id: string }

// Màn hình Mục tiêu & tầm nhìn (route "/goals", SPEC §7). Một query GET /dashboard/goals cấp mọi số cho
// tổng quan, radar và thẻ; drawer đọc bản đầy đủ GET /goals/{id} chỉ khi mở. Trang chỉ nối dây, khối con nhận props.
export function GoalsPage() {
  const { t } = useTranslation()
  const [today] = useState(() => toLocalDateKey(new Date()))
  // Id lĩnh vực đang lọc (null = tất cả).
  const [selectedArea, setSelectedArea] = useState<string | null>(null)
  const [drawer, setDrawer] = useState<DrawerState>(null)

  const board = useGoalBoard(today)
  const goal = useGoal(drawer?.mode === 'edit' ? drawer.id : null)
  const createGoal = useCreateGoal()
  const updateGoal = useUpdateGoal()
  const deleteGoal = useDeleteGoal()
  const addStep = useAddStep()
  const updateStep = useUpdateStep()
  const deleteStep = useDeleteStep()
  const reorderSteps = useReorderSteps()
  const toggleDone = useToggleGoalDone()
  const areas = useGoalAreas()
  const createArea = useCreateGoalArea()
  const deleteArea = useDeleteGoalArea()

  const drawerMutations = [createGoal, updateGoal, deleteGoal, addStep, updateStep, deleteStep, reorderSteps]

  function openDrawer(next: DrawerState) {
    // Lỗi của lần mở trước không được hiện lại ở lần mở sau.
    drawerMutations.forEach((m) => m.reset())
    setDrawer(next)
  }

  if (board.isPending) {
    return (
      <div
        role="status"
        aria-live="polite"
        className="mx-auto flex min-h-64 w-full max-w-[1320px] items-center justify-center gap-3 text-primary-ink"
      >
        <LoaderCircle className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
        <span className="font-bold">{t('goals.loading')}</span>
      </div>
    )
  }

  if (board.isError) {
    return (
      <div
        role="alert"
        className="sketch mx-auto flex min-h-44 w-full max-w-2xl flex-col items-center justify-center gap-3 p-6 text-center"
      >
        <p className="font-bold">
          {t('goals.loadErrorPrefix')} {board.error.message}
        </p>
        <button
          type="button"
          onClick={() => board.refetch()}
          className="flex min-h-11 cursor-pointer items-center gap-2 rounded-xl bg-primary px-4 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          <RotateCcw size={17} aria-hidden="true" />
          {t('common.retry')}
        </button>
      </div>
    )
  }

  const data = board.data
  // Lọc theo lĩnh vực ở FE là lọc hiển thị, không tính số: các con số trên thẻ vẫn do backend cấp.
  const goals = selectedArea ? data.goals.filter((g) => g.areaId === selectedArea) : data.goals
  const selectedInfo = selectedArea ? data.areas.find((a) => a.id === selectedArea) : undefined
  const emptyText = selectedInfo
    ? t('goals.emptyInArea', { area: areaDisplay(selectedInfo).label })
    : t('goals.emptyAll')
  const drawerError = drawerMutations.find((m) => m.isError)?.error?.message ?? null
  const editId = drawer?.mode === 'edit' ? drawer.id : null

  return (
    <div className="mx-auto w-full max-w-[1320px]">
      <header className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="flex items-center gap-2 font-display text-2xl leading-none font-extrabold text-primary-ink lg:text-3xl">
          {t('goals.title')}
          <Info
            size={18}
            className="text-ink-muted"
            aria-label={t('goals.infoAria')}
          />
        </h1>
        <button
          type="button"
          data-tour="goals-add"
          onClick={() => openDrawer({ mode: 'create' })}
          className="sketch flex min-h-11 cursor-pointer items-center gap-2 bg-primary px-4 font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
        >
          <Plus size={18} aria-hidden="true" />
          {t('goals.addGoal')}
        </button>
      </header>

      <div className="mt-4 grid gap-3 lg:grid-cols-2 lg:gap-4">
        <GoalsOverview board={data} selectedArea={selectedArea} onSelectArea={setSelectedArea} />
        <AreaRadar areas={data.areas} />
      </div>

      {toggleDone.isError && (
        <p role="alert" className="mt-4 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          {t('goals.updateError')}
        </p>
      )}

      <section aria-label={t('goals.listAria')} className="mt-3 lg:mt-4">
        <GoalCardGrid
          goals={goals}
          areas={data.areas}
          emptyText={emptyText}
          onOpen={(id) => openDrawer({ mode: 'edit', id })}
          onToggleDone={(id, done) => {
            toggleDone.reset()
            toggleDone.mutate({ id, done })
          }}
        />
      </section>

      <GoalDrawer
        open={drawer !== null}
        mode={drawer?.mode ?? 'create'}
        goal={goal.data}
        today={today}
        isSaving={createGoal.isPending || updateGoal.isPending || deleteGoal.isPending}
        error={drawerError}
        onClose={() => setDrawer(null)}
        onSave={(req, steps) => {
          if (editId) {
            updateGoal.mutate({ id: editId, req })
          } else {
            // Tạo xong chuyển sang chế độ sửa, rồi gửi lần lượt các bước đã nhập sẵn (cần id mục tiêu mới có).
            // Gửi tuần tự để giữ đúng thứ tự; một bước lỗi thì dừng, lỗi hiện qua drawerError.
            createGoal.mutate(req, {
              onSuccess: async (created) => {
                setDrawer({ mode: 'edit', id: created.id })
                for (const step of steps) {
                  try {
                    await addStep.mutateAsync({ goalId: created.id, req: step })
                  } catch {
                    break
                  }
                }
              },
            })
          }
        }}
        onDelete={() => {
          if (editId) deleteGoal.mutate(editId, { onSuccess: () => setDrawer(null) })
        }}
        onAddStep={(req) => editId && addStep.mutate({ goalId: editId, req })}
        onUpdateStep={(stepId, req) => editId && updateStep.mutate({ goalId: editId, stepId, req })}
        onDeleteStep={(stepId) => editId && deleteStep.mutate({ goalId: editId, stepId })}
        onReorderSteps={(ids) => editId && reorderSteps.mutate({ goalId: editId, ids })}
        areas={areas.data ?? []}
        onCreateArea={(name) => createArea.mutateAsync({ name })}
        onDeleteArea={async (id) => {
          await deleteArea.mutateAsync(id)
          if (selectedArea === id) setSelectedArea(null)
        }}
      />
    </div>
  )
}
