import {
  DndContext,
  KeyboardSensor,
  MouseSensor,
  TouchSensor,
  type DragEndEvent,
  useSensor,
  useSensors,
} from '@dnd-kit/core'
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  useSortable,
  verticalListSortingStrategy,
} from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { GripVertical, LoaderCircle, Trash2, X } from 'lucide-react'
import {
  type CSSProperties,
  type FormEvent,
  type KeyboardEvent,
  useId,
  useRef,
  useState,
  useEffect,
} from 'react'
import { useTranslation } from 'react-i18next'
import type {
  GoalDto,
  GoalStatus,
  GoalStepDto,
  LifeArea,
  SaveGoalRequest,
  SaveGoalStepRequest,
} from '../../api/types'
import { defaultDeadline, isStepOverdue, toSaveRequest, type GoalFormValues } from './goalDrawerForm'
import { GOAL_STATUS_LABEL, LIFE_AREAS } from './lifeAreas'

export interface GoalDrawerProps {
  open: boolean
  mode: 'create' | 'edit'
  goal: GoalDto | undefined
  today: string
  isSaving: boolean
  error: string | null
  onClose(): void
  onSave(req: SaveGoalRequest): void
  onDelete(): void
  onAddStep(req: SaveGoalStepRequest): void
  onUpdateStep(stepId: string, req: SaveGoalStepRequest): void
  onDeleteStep(stepId: string): void
  onReorderSteps(ids: string[]): void
}

const STATUS_ORDER: readonly GoalStatus[] = ['not_started', 'in_progress', 'done']

export function GoalDrawer(props: GoalDrawerProps) {
  const { t } = useTranslation()
  const dialogRef = useRef<HTMLDialogElement>(null)
  const titleId = useId()
  const loading = props.mode === 'edit' && !props.goal

  useEffect(() => {
    const dialog = dialogRef.current
    if (!dialog) return

    if (props.open && !dialog.open) {
      if (typeof dialog.showModal === 'function') dialog.showModal()
      else dialog.setAttribute('open', '')

      const reduceMotion = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ?? false
      if (!reduceMotion && typeof dialog.animate === 'function') {
        const animation = dialog.animate(
          [{ transform: 'translateX(100%)' }, { transform: 'translateX(0)' }],
          { duration: 180, easing: 'cubic-bezier(0.22, 1, 0.36, 1)' },
        )
        return () => animation.cancel()
      }
    } else if (!props.open && dialog.open) {
      if (typeof dialog.close === 'function') dialog.close()
      else dialog.removeAttribute('open')
    }
  }, [props.open])

  return (
    <dialog
      ref={dialogRef}
      aria-labelledby={titleId}
      onCancel={(event) => {
        event.preventDefault()
        props.onClose()
      }}
      onClick={(event) => {
        if (event.target === event.currentTarget) props.onClose()
      }}
      className="fixed inset-y-0 right-0 left-auto m-0 h-dvh max-h-dvh w-screen max-w-none overflow-hidden border-0 bg-surface p-0 text-ink shadow-[-6px_0_24px_rgb(0_0_0/0.18)] backdrop:bg-black/40 md:w-[28rem] md:border-l-2 md:border-[var(--ink)]"
    >
      {props.open && (
        <div className="flex h-dvh min-w-0 flex-col">
          <header className="flex shrink-0 items-center justify-between gap-3 border-b border-[var(--line)] px-4 py-3">
            <h2 id={titleId} className="font-display text-xl font-extrabold text-primary-ink">
              {props.mode === 'create' ? t('goals.addGoal') : t('goals.editGoal')}
            </h2>
            <button
              type="button"
              onClick={props.onClose}
              aria-label={t('common.close')}
              className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink active:opacity-70 focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
            >
              <X size={19} aria-hidden="true" />
            </button>
          </header>

          <div className="min-h-0 min-w-0 flex-1 overflow-y-auto px-4 py-4 [padding-bottom:max(1rem,env(safe-area-inset-bottom))]">
            {props.error && (
              <p role="alert" className="mb-3 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
                {props.error}
              </p>
            )}
            {loading ? (
              <p role="status" className="flex items-center gap-2 py-8 text-sm font-bold text-ink-muted">
                <LoaderCircle size={17} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
                {t('goals.loading')}
              </p>
            ) : (
              <>
                <GoalForm
                  key={`${props.mode}:${props.goal?.id ?? 'new'}`}
                  mode={props.mode}
                  goal={props.goal}
                  today={props.today}
                  isSaving={props.isSaving}
                  onSave={props.onSave}
                />

                {props.mode === 'create' ? (
                  <p className="mt-5 rounded-xl bg-accent-tint px-3 py-3 text-sm font-semibold text-ink-muted">
                    {t('goals.drawer.saveFirstHint')}
                  </p>
                ) : (
                  props.goal && (
                    <GoalSteps
                      goalId={props.goal.id}
                      steps={props.goal.steps}
                      today={props.today}
                      onAddStep={props.onAddStep}
                      onUpdateStep={props.onUpdateStep}
                      onDeleteStep={props.onDeleteStep}
                      onReorderSteps={props.onReorderSteps}
                    />
                  )
                )}
              </>
            )}
          </div>

          {props.mode === 'edit' && props.goal && (
            <DeleteGoalFooter key={props.goal.id} onDelete={props.onDelete} />
          )}
        </div>
      )}
    </dialog>
  )
}

function initialForm(mode: GoalDrawerProps['mode'], goal: GoalDto | undefined, today: string): GoalFormValues {
  if (mode === 'edit' && goal) {
    return {
      title: goal.title,
      area: goal.area,
      status: goal.status,
      startDate: goal.startDate,
      deadline: goal.deadline,
      reward: goal.reward ?? '',
      why: goal.why ?? '',
    }
  }

  return {
    title: '',
    area: LIFE_AREAS[0].key,
    status: 'not_started',
    startDate: today,
    deadline: defaultDeadline(today),
    reward: '',
    why: '',
  }
}

function GoalForm({
  mode,
  goal,
  today,
  isSaving,
  onSave,
}: Pick<GoalDrawerProps, 'mode' | 'goal' | 'today' | 'isSaving' | 'onSave'>) {
  const { t } = useTranslation()
  const [form, setForm] = useState(() => initialForm(mode, goal, today))
  const titleId = useId()
  const areaId = useId()
  const statusId = useId()
  const startId = useId()
  const deadlineId = useId()
  const deadlineErrorId = useId()
  const rewardId = useId()
  const whyId = useId()
  const deadlineInvalid = Boolean(form.startDate && form.deadline && form.deadline < form.startDate)
  const canSave = Boolean(form.title.trim() && form.startDate && form.deadline && !deadlineInvalid && !isSaving)

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!canSave) return
    onSave(toSaveRequest(form))
  }

  const inputClass =
    'min-h-11 min-w-0 w-full rounded-lg border-2 border-[var(--line)] bg-surface px-3 text-base text-ink focus-visible:border-primary focus-visible:outline-none'

  return (
    <form onSubmit={submit} aria-busy={isSaving} className="min-w-0 space-y-3">
      <div>
        <label htmlFor={titleId} className="mb-1 block text-sm font-bold">
          {t('goals.drawer.titleLabel')}
        </label>
        <input
          id={titleId}
          required
          autoFocus
          value={form.title}
          onChange={(event) => setForm((current) => ({ ...current, title: event.target.value }))}
          className={inputClass}
        />
      </div>

      <div className="grid min-w-0 grid-cols-1 gap-3 sm:grid-cols-2">
        <div className="min-w-0">
          <label htmlFor={areaId} className="mb-1 block text-sm font-bold">
            {t('goals.drawer.areaLabel')}
          </label>
          <select
            id={areaId}
            value={form.area}
            onChange={(event) => setForm((current) => ({ ...current, area: event.target.value as LifeArea }))}
            className={inputClass}
          >
            {LIFE_AREAS.map((area) => (
              <option key={area.key} value={area.key}>
                {area.label}
              </option>
            ))}
          </select>
        </div>

        {mode === 'edit' && (
          <div className="min-w-0">
            <label htmlFor={statusId} className="mb-1 block text-sm font-bold">
              {t('goals.drawer.statusLabel')}
            </label>
            <select
              id={statusId}
              value={form.status}
              onChange={(event) => setForm((current) => ({ ...current, status: event.target.value as GoalStatus }))}
              className={inputClass}
            >
              {STATUS_ORDER.map((status) => (
                <option key={status} value={status}>
                  {GOAL_STATUS_LABEL[status]}
                </option>
              ))}
            </select>
          </div>
        )}
      </div>

      <div className="grid min-w-0 grid-cols-1 gap-3 sm:grid-cols-2">
        <div className="min-w-0">
          <label htmlFor={startId} className="mb-1 block text-sm font-bold">
            {t('goals.drawer.startDateLabel')}
          </label>
          <input
            id={startId}
            type="date"
            required
            value={form.startDate}
            onChange={(event) => setForm((current) => ({ ...current, startDate: event.target.value }))}
            className={inputClass}
          />
        </div>
        <div className="min-w-0">
          <label htmlFor={deadlineId} className="mb-1 block text-sm font-bold">
            {t('goals.drawer.deadlineLabel')}
          </label>
          <input
            id={deadlineId}
            type="date"
            required
            value={form.deadline}
            aria-invalid={deadlineInvalid || undefined}
            aria-describedby={deadlineInvalid ? deadlineErrorId : undefined}
            onChange={(event) => setForm((current) => ({ ...current, deadline: event.target.value }))}
            className={`${inputClass} ${deadlineInvalid ? 'border-danger' : ''}`}
          />
          {deadlineInvalid && (
            <p id={deadlineErrorId} role="alert" className="mt-1 text-sm font-bold text-danger">
              {t('goals.drawer.deadlineInvalid')}
            </p>
          )}
        </div>
      </div>

      <div>
        <label htmlFor={rewardId} className="mb-1 block text-sm font-bold">
          {t('goals.drawer.rewardLabel')}
        </label>
        <input
          id={rewardId}
          value={form.reward}
          onChange={(event) => setForm((current) => ({ ...current, reward: event.target.value }))}
          className={inputClass}
        />
      </div>

      <div>
        <label htmlFor={whyId} className="mb-1 block text-sm font-bold">
          {t('goals.drawer.whyLabel')}
        </label>
        <textarea
          id={whyId}
          rows={3}
          value={form.why}
          onChange={(event) => setForm((current) => ({ ...current, why: event.target.value }))}
          className={`${inputClass} py-2`}
        />
      </div>

      <div className="flex justify-end pt-1">
        <button
          type="submit"
          disabled={!canSave}
          className="flex min-h-11 cursor-pointer items-center gap-2 rounded-lg bg-primary px-5 text-sm font-bold text-white hover:opacity-90 active:opacity-75 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-45"
        >
          {isSaving && (
            <LoaderCircle size={16} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
          )}
          {t('goals.drawer.saveBtn')}
        </button>
      </div>
    </form>
  )
}

interface GoalStepsProps {
  goalId: string
  steps: GoalStepDto[]
  today: string
  onAddStep: GoalDrawerProps['onAddStep']
  onUpdateStep: GoalDrawerProps['onUpdateStep']
  onDeleteStep: GoalDrawerProps['onDeleteStep']
  onReorderSteps: GoalDrawerProps['onReorderSteps']
}

function GoalSteps(props: GoalStepsProps) {
  const { t } = useTranslation()
  // useId thay cho id cứng: hai drawer (hoặc test render hai lần) không trùng id trong cùng trang.
  const headingId = useId()
  const sortedIds = [...props.steps].sort((a, b) => a.order - b.order).map((step) => step.id)
  const sourceOrder = `${props.goalId}:${sortedIds.map((id) => `${id}:${props.steps.find((step) => step.id === id)?.order}`).join('|')}`
  const [draftOrder, setDraftOrder] = useState(() => ({ source: sourceOrder, ids: sortedIds }))

  // Dữ liệu mới từ cha thắng thứ tự lạc quan sau khi API trả về.
  if (draftOrder.source !== sourceOrder) setDraftOrder({ source: sourceOrder, ids: sortedIds })

  const stepById = new Map(props.steps.map((step) => [step.id, step]))
  const orderedSteps = draftOrder.ids.flatMap((id) => {
    const step = stepById.get(id)
    return step ? [step] : []
  })
  const doneCount = props.steps.filter((step) => step.done).length
  const sensors = useSensors(
    useSensor(MouseSensor, { activationConstraint: { distance: 5 } }),
    useSensor(TouchSensor, { activationConstraint: { delay: 200, tolerance: 5 } }),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates }),
  )

  function commitOrder(ids: string[]) {
    setDraftOrder({ source: sourceOrder, ids })
    props.onReorderSteps(ids)
  }

  function handleDragEnd({ active, over }: DragEndEvent) {
    if (!over || active.id === over.id) return
    const from = draftOrder.ids.indexOf(String(active.id))
    const to = draftOrder.ids.indexOf(String(over.id))
    if (from < 0 || to < 0) return
    commitOrder(arrayMove(draftOrder.ids, from, to))
  }

  function moveWithKeys(id: string, key: string) {
    const from = draftOrder.ids.indexOf(id)
    const to = from + (key === 'ArrowUp' ? -1 : 1)
    if (from < 0 || to < 0 || to >= draftOrder.ids.length) return
    commitOrder(arrayMove(draftOrder.ids, from, to))
  }

  return (
    <section className="sketch mt-5 min-w-0 bg-accent-tint/35 p-3" aria-labelledby={headingId}>
      <h3 id={headingId} className="mb-3 font-display text-lg font-extrabold text-primary-ink">
        {t('goals.drawer.stepsHeading', { done: doneCount, total: props.steps.length })}
      </h3>

      {orderedSteps.length === 0 ? (
        <p className="mb-3 text-sm font-medium text-ink-muted">{t('goals.drawer.stepsEmpty')}</p>
      ) : (
        <DndContext sensors={sensors} onDragEnd={handleDragEnd}>
          <SortableContext items={draftOrder.ids} strategy={verticalListSortingStrategy}>
            <div className="min-w-0 divide-y divide-[var(--line)] rounded-xl border-2 border-[var(--line)] bg-surface">
              {orderedSteps.map((step) => (
                <SortableStep
                  key={step.id}
                  step={step}
                  today={props.today}
                  onUpdate={props.onUpdateStep}
                  onDelete={props.onDeleteStep}
                  onMoveKey={(key) => moveWithKeys(step.id, key)}
                />
              ))}
            </div>
          </SortableContext>
        </DndContext>
      )}

      <AddStepForm onAddStep={props.onAddStep} />
    </section>
  )
}

function SortableStep({
  step,
  today,
  onUpdate,
  onDelete,
  onMoveKey,
}: {
  step: GoalStepDto
  today: string
  onUpdate: GoalDrawerProps['onUpdateStep']
  onDelete: GoalDrawerProps['onDeleteStep']
  onMoveKey: (key: string) => void
}) {
  const { t } = useTranslation()
  const { attributes, listeners, setNodeRef, setActivatorNodeRef, transform, transition, isDragging } = useSortable({
    id: step.id,
  })
  const [titleEdit, setTitleEdit] = useState({ source: step.title, value: step.title, editing: false })

  if (!titleEdit.editing && titleEdit.source !== step.title) {
    setTitleEdit({ source: step.title, value: step.title, editing: false })
  }

  const style: CSSProperties = {
    transform: CSS.Transform.toString(transform),
    transition,
    zIndex: isDragging ? 1 : undefined,
  }

  function update(patch: Partial<SaveGoalStepRequest>) {
    onUpdate(step.id, {
      title: step.title,
      deadline: step.deadline,
      done: step.done,
      ...patch,
    })
  }

  function commitTitle() {
    const title = titleEdit.value.trim()
    setTitleEdit({ source: step.title, value: title || step.title, editing: false })
    if (title && title !== step.title) update({ title })
  }

  function handleTitleKeyDown(event: KeyboardEvent<HTMLInputElement>) {
    if (event.key === 'Enter') {
      event.preventDefault()
      commitTitle()
    } else if (event.key === 'Escape') {
      event.preventDefault()
      setTitleEdit({ source: step.title, value: step.title, editing: false })
    }
  }

  function handleDragKeyDown(event: KeyboardEvent<HTMLButtonElement>) {
    if (event.key !== 'ArrowUp' && event.key !== 'ArrowDown') {
      listeners?.onKeyDown?.(event)
      return
    }
    event.preventDefault()
    event.stopPropagation()
    onMoveKey(event.key)
  }

  return (
    <div
      ref={setNodeRef}
      style={style}
      className={`grid min-w-0 grid-cols-[2.75rem_2.75rem_minmax(0,1fr)_2.75rem] items-start gap-x-2 px-1 py-2 ${isDragging ? 'bg-accent-tint shadow-lg' : 'bg-surface'}`}
    >
      <button
        type="button"
        ref={setActivatorNodeRef}
        {...attributes}
        {...listeners}
        onKeyDown={handleDragKeyDown}
        aria-label={t('goals.drawer.dragStepAria', { title: step.title })}
        aria-keyshortcuts="ArrowUp ArrowDown"
        className="grid size-11 cursor-grab touch-none place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink active:cursor-grabbing focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
      >
        <GripVertical size={17} aria-hidden="true" />
      </button>

      <label className="grid size-11 cursor-pointer place-items-center rounded-lg hover:bg-accent-tint active:opacity-70">
        <input
          type="checkbox"
          checked={step.done}
          onChange={() => update({ done: !step.done })}
          aria-label={t('goals.drawer.completeStepAria', { title: step.title })}
          className="size-5 cursor-pointer accent-primary"
        />
      </label>

      {titleEdit.editing ? (
        <input
          autoFocus
          value={titleEdit.value}
          onChange={(event) => setTitleEdit((current) => ({ ...current, value: event.target.value }))}
          onBlur={commitTitle}
          onKeyDown={handleTitleKeyDown}
          aria-label={t('goals.drawer.editStepAria', { title: step.title })}
          className="min-h-11 min-w-0 w-full rounded-lg border-2 border-primary bg-surface px-2 text-base font-semibold focus:outline-none"
        />
      ) : (
        <button
          type="button"
          onClick={() => setTitleEdit({ source: step.title, value: step.title, editing: true })}
          className={`min-h-11 min-w-0 w-full cursor-text rounded-lg px-2 text-left font-semibold [overflow-wrap:anywhere] hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none ${step.done ? 'text-ink-muted line-through' : 'text-ink'}`}
        >
          {step.title}
        </button>
      )}

      <button
        type="button"
        onClick={() => onDelete(step.id)}
        aria-label={t('goals.drawer.deleteStepAria', { title: step.title })}
        className="grid size-11 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-[var(--danger-bg)] hover:text-danger active:opacity-70 focus-visible:ring-2 focus-visible:ring-danger focus-visible:outline-none"
      >
        <Trash2 size={16} aria-hidden="true" />
      </button>

      <div className="col-start-3 col-end-5 flex min-w-0 flex-wrap items-center gap-2 pr-1">
        <input
          type="date"
          value={step.deadline ?? ''}
          onChange={(event) => update({ deadline: event.target.value || null })}
          aria-label={t('goals.drawer.stepDeadlineAria', { title: step.title })}
          className="min-h-11 min-w-0 max-w-full rounded-lg border-2 border-[var(--line)] bg-surface px-2 text-sm focus-visible:border-primary focus-visible:outline-none"
        />
        {isStepOverdue(step, today) && <span className="text-xs font-bold text-danger">{t('goals.drawer.stepOverdue')}</span>}
      </div>
    </div>
  )
}

function AddStepForm({ onAddStep }: Pick<GoalDrawerProps, 'onAddStep'>) {
  const { t } = useTranslation()
  const [title, setTitle] = useState('')
  const [deadline, setDeadline] = useState('')
  const inputId = useId()
  const deadlineId = useId()
  const trimmedTitle = title.trim()

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!trimmedTitle) return
    onAddStep({ title: trimmedTitle, deadline: deadline || null, done: false })
    setTitle('')
    setDeadline('')
  }

  return (
    <form
      onSubmit={submit}
      className="mt-3 grid min-w-0 grid-cols-[minmax(0,1fr)_auto] gap-2 sm:grid-cols-[minmax(0,1fr)_9rem_auto]"
    >
      <label htmlFor={inputId} className="sr-only">
        {t('goals.drawer.newStepLabel')}
      </label>
      <input
        id={inputId}
        value={title}
        onChange={(event) => setTitle(event.target.value)}
        placeholder={t('goals.drawer.newStepPlaceholder')}
        className="col-span-2 min-h-11 min-w-0 rounded-lg border-2 border-[var(--line)] bg-surface px-3 text-base focus-visible:border-primary focus-visible:outline-none sm:col-span-1"
      />
      <label htmlFor={deadlineId} className="sr-only">
        {t('goals.drawer.newStepDeadlineLabel')}
      </label>
      <input
        id={deadlineId}
        type="date"
        value={deadline}
        onChange={(event) => setDeadline(event.target.value)}
        className="min-h-11 min-w-0 w-full rounded-lg border-2 border-[var(--line)] bg-surface px-2 text-sm focus-visible:border-primary focus-visible:outline-none"
      />
      <button
        type="submit"
        disabled={!trimmedTitle}
        className="min-h-11 cursor-pointer rounded-lg bg-primary px-4 text-sm font-bold text-white hover:opacity-90 active:opacity-75 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-45"
      >
        {t('common.add')}
      </button>
    </form>
  )
}

function DeleteGoalFooter({ onDelete }: Pick<GoalDrawerProps, 'onDelete'>) {
  const { t } = useTranslation()
  const [confirming, setConfirming] = useState(false)

  return (
    <footer className="shrink-0 border-t border-[var(--line)] bg-surface px-4 py-3 [padding-bottom:max(0.75rem,env(safe-area-inset-bottom))]">
      {confirming ? (
        <div className="flex min-w-0 flex-wrap items-center gap-2">
          <p className="min-w-0 flex-1 text-sm font-bold text-danger">{t('goals.drawer.confirmDeleteGoal')}</p>
          <button
            type="button"
            onClick={onDelete}
            className="min-h-11 cursor-pointer rounded-lg bg-danger px-4 text-sm font-bold text-white hover:opacity-90 active:opacity-75 focus-visible:ring-2 focus-visible:ring-danger focus-visible:ring-offset-2 focus-visible:outline-none"
          >
            {t('common.delete')}
          </button>
          <button
            type="button"
            onClick={() => setConfirming(false)}
            className="min-h-11 cursor-pointer rounded-lg px-4 text-sm font-bold text-ink-muted hover:bg-accent-tint active:opacity-70 focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
          >
            {t('common.cancel')}
          </button>
        </div>
      ) : (
        <button
          type="button"
          onClick={() => setConfirming(true)}
          className="min-h-11 cursor-pointer rounded-lg px-3 text-sm font-bold text-danger hover:bg-[var(--danger-bg)] active:opacity-70 focus-visible:ring-2 focus-visible:ring-danger focus-visible:outline-none"
        >
          {t('goals.drawer.deleteGoalBtn')}
        </button>
      )}
    </footer>
  )
}
