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
import { GripVertical, LoaderCircle, Plus, Trash2, X, type LucideIcon } from 'lucide-react'
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
  GoalAreaDto,
  GoalDto,
  GoalStatus,
  GoalStepDto,
  SaveGoalRequest,
  SaveGoalStepRequest,
} from '../../api/types'
import {
  defaultDeadline,
  effectiveStartDate,
  isStepOverdue,
  toSaveRequest,
  type GoalFormValues,
} from './goalDrawerForm'
import { areaDisplay, formatDmy, GOAL_STATUS_LABEL } from './lifeAreas'

export interface GoalDrawerProps {
  open: boolean
  mode: 'create' | 'edit'
  goal: GoalDto | undefined
  today: string
  isSaving: boolean
  error: string | null
  onClose(): void
  // `steps`: các bước nhập sẵn lúc tạo mới, gửi lên sau khi mục tiêu đã có id. Khi sửa luôn là [].
  onSave(req: SaveGoalRequest, steps: SaveGoalStepRequest[]): void
  onDelete(): void
  onAddStep(req: SaveGoalStepRequest): void
  onUpdateStep(stepId: string, req: SaveGoalStepRequest): void
  onDeleteStep(stepId: string): void
  onReorderSteps(ids: string[]): void
  // Lĩnh vực của tài khoản; thêm/xoá trả Promise để ô chọn tự hiện lỗi (trùng tên, đang có mục tiêu…).
  areas: GoalAreaDto[]
  onCreateArea(name: string): Promise<GoalAreaDto>
  onDeleteArea(id: string): Promise<void>
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
          [
            { opacity: 0, transform: 'translateY(12px) scale(0.98)' },
            { opacity: 1, transform: 'none' },
          ],
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
      // Hộp thoại giữa màn hình, rộng tối đa 36rem như web mẫu; viền vẽ tay `.sketch` giống mọi khung khác của app.
      className="sketch fixed inset-0 m-auto h-fit max-h-[min(90dvh,56rem)] w-[calc(100vw-1.5rem)] max-w-[36rem] overflow-clip p-0 text-ink backdrop:bg-black/40"
    >
      {props.open && (
        // Trừ 4px viền của dialog: nếu khung trong cao bằng dialog, dialog dư 4px và tự cuộn lệch khi focus ô nhập.
        <div className="flex max-h-[calc(min(90dvh,56rem)-4px)] min-w-0 flex-col">
          <header className="flex shrink-0 items-center justify-between gap-3 px-5 pt-4 pb-2">
            <h2 id={titleId} className="font-display text-2xl font-extrabold text-primary-ink">
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

          <div className="min-h-0 min-w-0 flex-1 overflow-y-auto px-5 pt-2 pb-5">
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
                  areas={props.areas}
                  onCreateArea={props.onCreateArea}
                  onDeleteArea={props.onDeleteArea}
                />

                {props.mode === 'edit' && props.goal && (
                  <GoalSteps
                    goalId={props.goal.id}
                    steps={props.goal.steps}
                    today={props.today}
                    onAddStep={props.onAddStep}
                    onUpdateStep={props.onUpdateStep}
                    onDeleteStep={props.onDeleteStep}
                    onReorderSteps={props.onReorderSteps}
                  />
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

// Cùng kiểu ô "Thêm việc cho hôm nay" (components/AddTaskInput): viền mực đậm, bo xl, vòng focus màu chính.
const inputClass =
  'min-h-11 min-w-0 w-full rounded-xl border-2 border-ink bg-surface px-3 text-base text-ink placeholder:text-ink-muted focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none'

function initialForm(mode: GoalDrawerProps['mode'], goal: GoalDto | undefined, today: string): GoalFormValues {
  if (mode === 'edit' && goal) {
    return {
      title: goal.title,
      areaId: goal.areaId,
      status: goal.status,
      startDate: goal.startDate,
      deadline: goal.deadline,
      reward: goal.reward ?? '',
      why: goal.why ?? '',
    }
  }

  return {
    title: '',
    // Trống = lĩnh vực đầu tiên trong danh sách (danh sách có thể chưa tải xong lúc mở drawer).
    areaId: '',
    status: 'not_started',
    // Để trống: lưu sẽ lấy ngày tạo (xem effectiveStartDate).
    startDate: '',
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
  areas,
  onCreateArea,
  onDeleteArea,
}: Pick<
  GoalDrawerProps,
  'mode' | 'goal' | 'today' | 'isSaving' | 'onSave' | 'areas' | 'onCreateArea' | 'onDeleteArea'
>) {
  const { t } = useTranslation()
  const [rawForm, setForm] = useState(() => initialForm(mode, goal, today))
  // Lĩnh vực đã chọn bị xoá hoặc chưa chọn → rơi về lĩnh vực đã lưu của mục tiêu (khi sửa),
  // nếu không có thì lấy lĩnh vực đầu tiên. Tránh lặng lẽ chuyển mục tiêu sang "Sức khoẻ".
  const exists = (id: string | undefined) => Boolean(id && areas.some((a) => a.id === id))
  const savedAreaId = mode === 'edit' ? goal?.areaId : undefined
  const areaId = exists(rawForm.areaId)
    ? rawForm.areaId
    : exists(savedAreaId)
      ? savedAreaId!
      : (areas[0]?.id ?? rawForm.areaId)
  const form = { ...rawForm, areaId }
  // Bước nháp chỉ có ở chế độ tạo: mục tiêu chưa có id nên giữ ở state, lưu xong mới gửi lên server.
  const [draftSteps, setDraftSteps] = useState<string[]>([])
  const titleId = useId()
  const startId = useId()
  const startHintId = useId()
  const deadlineId = useId()
  const deadlineErrorId = useId()
  const rewardId = useId()
  const whyId = useId()
  const start = effectiveStartDate(form, today)
  const deadlineInvalid = Boolean(form.deadline && form.deadline < start)
  const canSave = Boolean(form.title.trim() && form.areaId && form.deadline && !deadlineInvalid && !isSaving)

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!canSave) return
    const steps = draftSteps.map((title) => ({ title, deadline: null, done: false }))
    onSave(toSaveRequest(form, today), steps)
  }

  return (
    <form onSubmit={submit} aria-busy={isSaving} className="min-w-0 space-y-4">
      <AreaPicker
        areas={areas}
        value={form.areaId}
        onChange={(id) => setForm((current) => ({ ...current, areaId: id }))}
        onCreateArea={onCreateArea}
        onDeleteArea={onDeleteArea}
      />

      <div>
        <label htmlFor={titleId} className="mb-1 block text-sm font-bold">
          {t('goals.drawer.titleLabel')}
        </label>
        <input
          id={titleId}
          required
          autoFocus
          value={form.title}
          placeholder={t('goals.drawer.titlePlaceholder')}
          onChange={(event) => setForm((current) => ({ ...current, title: event.target.value }))}
          className={inputClass}
        />
      </div>

      {mode === 'create' && <DraftSteps steps={draftSteps} onChange={setDraftSteps} />}

      <div className="grid min-w-0 grid-cols-1 gap-3 sm:grid-cols-2">
        <div className="min-w-0">
          <label htmlFor={startId} className="mb-1 block text-sm font-bold">
            {t('goals.drawer.startDateLabel')}
          </label>
          <input
            id={startId}
            type="date"
            value={form.startDate}
            aria-describedby={mode === 'create' ? startHintId : undefined}
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
        </div>
        {mode === 'create' && (
          <p id={startHintId} className="-mt-1 text-xs text-ink-muted sm:col-span-2">
            {t('goals.drawer.startDateHint', { date: formatDmy(today) })}
          </p>
        )}
        {deadlineInvalid && (
          <p id={deadlineErrorId} role="alert" className="-mt-1 text-sm font-bold text-danger sm:col-span-2">
            {t('goals.drawer.deadlineInvalid')}
          </p>
        )}
      </div>

      <div>
        <label htmlFor={rewardId} className="mb-1 block text-sm font-bold">
          {t('goals.drawer.rewardLabel')}
        </label>
        <input
          id={rewardId}
          value={form.reward}
          placeholder={t('goals.drawer.rewardPlaceholder')}
          onChange={(event) => setForm((current) => ({ ...current, reward: event.target.value }))}
          className={inputClass}
        />
      </div>

      <ChoiceGroup
        legend={t('goals.drawer.statusLabel')}
        value={form.status}
        options={STATUS_ORDER.map((status) => ({ value: status, label: GOAL_STATUS_LABEL[status] }))}
        onChange={(status) => setForm((current) => ({ ...current, status }))}
        variant="segmented"
      />

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

// Chọn lĩnh vực kiểu web mẫu: viên thuốc bo tròn, ô đang chọn tô xanh. Lĩnh vực tự tạo có icon Target,
// vạch ngăn và nút × để xoá; vòng tròn nét đứt "+" mở ô nhập tên lĩnh vực mới ngay tại chỗ.
function AreaPicker({
  areas,
  value,
  onChange,
  onCreateArea,
  onDeleteArea,
}: {
  areas: GoalAreaDto[]
  value: string
  onChange(id: string): void
  onCreateArea: GoalDrawerProps['onCreateArea']
  onDeleteArea: GoalDrawerProps['onDeleteArea']
}) {
  const { t } = useTranslation()
  const name = useId()
  const inputId = useId()
  const errorId = useId()
  const [adding, setAdding] = useState(false)
  const [draft, setDraft] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const trimmed = draft.trim()

  async function add() {
    if (!trimmed || busy) return
    setBusy(true)
    setError(null)
    try {
      const created = await onCreateArea(trimmed)
      onChange(created.id)
      setDraft('')
      setAdding(false)
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e))
    } finally {
      setBusy(false)
    }
  }

  async function remove(id: string) {
    if (busy) return
    setBusy(true)
    setError(null)
    try {
      await onDeleteArea(id)
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e))
    } finally {
      setBusy(false)
    }
  }

  function cancel() {
    setAdding(false)
    setDraft('')
    setError(null)
  }

  return (
    <fieldset className="min-w-0" aria-describedby={error ? errorId : undefined}>
      <legend className="mb-1.5 text-sm font-bold">{t('goals.drawer.areaLabel')}</legend>
      <div className="flex flex-wrap items-center gap-2">
        {areas.map((area) => {
          const info = areaDisplay(area)
          const Icon = info.Icon
          const checked = area.id === value
          return (
            <span
              key={area.id}
              className={`flex min-h-11 items-center rounded-full border-2 text-sm font-bold has-[:focus-visible]:ring-2 has-[:focus-visible]:ring-primary has-[:focus-visible]:ring-offset-2 ${
                checked
                  ? 'border-primary bg-primary text-white'
                  : 'border-[var(--line)] bg-surface text-ink hover:border-primary'
              }`}
            >
              <label className={`flex min-h-10 cursor-pointer items-center gap-1.5 ${info.custom ? 'pr-2 pl-3.5' : 'px-3.5'}`}>
                <input
                  type="radio"
                  name={name}
                  value={area.id}
                  checked={checked}
                  onChange={() => onChange(area.id)}
                  className="sr-only"
                />
                <Icon size={16} aria-hidden="true" />
                {info.label}
              </label>
              {info.custom && (
                <>
                  <span aria-hidden="true" className={`h-4 w-px ${checked ? 'bg-white/60' : 'bg-[var(--line)]'}`} />
                  <button
                    type="button"
                    onClick={() => remove(area.id)}
                    disabled={busy}
                    aria-label={t('goals.drawer.deleteAreaAria', { name: info.label })}
                    className={`grid size-9 cursor-pointer place-items-center rounded-full focus-visible:outline-none disabled:cursor-not-allowed ${
                      checked ? 'text-white/85 hover:text-white' : 'text-ink-muted hover:text-danger'
                    }`}
                  >
                    <X size={14} aria-hidden="true" />
                  </button>
                </>
              )}
            </span>
          )
        })}

        {adding ? (
          <span className="flex min-h-11 items-center rounded-full border-2 border-dashed border-primary bg-surface pl-3.5 focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2">
            <label htmlFor={inputId} className="sr-only">
              {t('goals.drawer.newAreaLabel')}
            </label>
            <input
              id={inputId}
              autoFocus
              value={draft}
              maxLength={40}
              autoComplete="off"
              placeholder={t('goals.drawer.newAreaPlaceholder')}
              onChange={(event) => setDraft(event.target.value)}
              onKeyDown={(event) => {
                // Không dùng <form> lồng trong form mục tiêu: Enter/Escape bắt tay ở đây.
                if (event.key === 'Enter') {
                  event.preventDefault()
                  void add()
                } else if (event.key === 'Escape') {
                  event.preventDefault()
                  event.stopPropagation()
                  cancel()
                }
              }}
              className="w-32 min-w-0 bg-transparent text-sm font-bold text-ink placeholder:font-medium placeholder:text-ink-muted focus:outline-none"
            />
            <button
              type="button"
              onClick={() => void add()}
              disabled={!trimmed || busy}
              aria-label={t('goals.drawer.addAreaConfirm')}
              className="grid size-9 cursor-pointer place-items-center rounded-full text-primary-ink hover:bg-accent-tint focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-45"
            >
              {busy ? (
                <LoaderCircle size={15} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
              ) : (
                <Plus size={16} aria-hidden="true" />
              )}
            </button>
            <button
              type="button"
              onClick={cancel}
              aria-label={t('common.cancel')}
              className="grid size-9 cursor-pointer place-items-center rounded-full text-ink-muted hover:text-ink focus-visible:outline-none"
            >
              <X size={14} aria-hidden="true" />
            </button>
          </span>
        ) : (
          <button
            type="button"
            onClick={() => {
              setError(null)
              setAdding(true)
            }}
            aria-label={t('goals.drawer.addAreaAria')}
            title={t('goals.drawer.addAreaAria')}
            className="grid size-11 cursor-pointer place-items-center rounded-full border-2 border-dashed border-[var(--line)] text-ink-muted hover:border-primary hover:text-primary-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
          >
            <Plus size={17} aria-hidden="true" />
          </button>
        )}
      </div>
      {error && (
        <p id={errorId} role="alert" className="mt-1.5 text-sm font-bold text-danger">
          {error}
        </p>
      )}
    </fieldset>
  )
}

interface Choice<T extends string> {
  value: T
  label: string
  Icon?: LucideIcon
}

// Nhóm lựa chọn một-trong-nhiều bằng radio thật: bàn phím (mũi tên, Tab) và trình đọc màn hình dùng được sẵn,
// chỉ phần nhìn là chip hoặc thanh phân đoạn.
function ChoiceGroup<T extends string>({
  legend,
  value,
  options,
  onChange,
  variant,
}: {
  legend: string
  value: T
  options: Choice<T>[]
  onChange(value: T): void
  variant: 'chips' | 'segmented'
}) {
  const name = useId()
  const chips = variant === 'chips'
  return (
    <fieldset className="min-w-0">
      <legend className="mb-1.5 text-sm font-bold">{legend}</legend>
      <div className={chips ? 'flex flex-wrap gap-2' : 'grid grid-cols-3 gap-1 rounded-xl bg-accent-tint p-1'}>
        {options.map(({ value: option, label, Icon }) => {
          const checked = option === value
          const look = chips
            ? checked
              ? 'border-primary bg-primary text-white'
              : 'border-[var(--line)] bg-surface text-ink hover:border-primary'
            : checked
              ? 'bg-primary text-white shadow-sm'
              : 'text-ink-muted hover:text-ink'
          return (
            <label
              key={option}
              className={`flex min-h-11 cursor-pointer items-center justify-center gap-1.5 text-sm font-bold has-[:focus-visible]:ring-2 has-[:focus-visible]:ring-primary has-[:focus-visible]:ring-offset-2 ${chips ? 'rounded-full border-2 px-3.5' : 'rounded-lg px-2 text-center'} ${look}`}
            >
              <input
                type="radio"
                name={name}
                value={option}
                checked={checked}
                onChange={() => onChange(option)}
                className="sr-only"
              />
              {Icon && <Icon size={16} aria-hidden="true" />}
              {label}
            </label>
          )
        })}
      </div>
    </fieldset>
  )
}

function DraftSteps({ steps, onChange }: { steps: string[]; onChange(steps: string[]): void }) {
  const { t } = useTranslation()
  const headingId = useId()
  const inputId = useId()
  const [title, setTitle] = useState('')
  const trimmed = title.trim()

  // Không dùng <form> lồng trong form mục tiêu (HTML không cho phép), nên Enter được bắt tay ở đây.
  function add() {
    if (!trimmed) return
    onChange([...steps, trimmed])
    setTitle('')
  }

  return (
    <section aria-labelledby={headingId} className="min-w-0">
      <h3 id={headingId} className="mb-1.5 text-sm font-bold">
        {t('goals.drawer.howHeading')}
      </h3>
      {steps.length === 0 ? (
        <p className="mb-2 text-sm text-ink-muted">{t('goals.drawer.stepsEmpty')}</p>
      ) : (
        <ol className="mb-2 min-w-0 divide-y divide-[var(--line)] rounded-xl border-2 border-[var(--line)] bg-surface">
          {steps.map((step, index) => (
            <li key={`${index}:${step}`} className="flex min-w-0 items-center gap-2 py-1 pr-1 pl-3">
              <span className="w-5 shrink-0 text-sm font-bold text-ink-muted">{index + 1}.</span>
              <span className="min-w-0 flex-1 font-semibold [overflow-wrap:anywhere]">{step}</span>
              <button
                type="button"
                onClick={() => onChange(steps.filter((_, i) => i !== index))}
                aria-label={t('goals.drawer.removeDraftStepAria', { title: step })}
                className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-[var(--danger-bg)] hover:text-danger focus-visible:ring-2 focus-visible:ring-danger focus-visible:outline-none"
              >
                <X size={16} aria-hidden="true" />
              </button>
            </li>
          ))}
        </ol>
      )}
      {/* Giống hệt ô "Thêm việc cho hôm nay": viền nằm ở khung ngoài, nút + là ô vuông nhạt nằm gọn bên trong. */}
      <div className="flex min-h-11 items-center rounded-xl border-2 border-ink bg-surface focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2">
        <label htmlFor={inputId} className="sr-only">
          {t('goals.drawer.newStepLabel')}
        </label>
        <input
          id={inputId}
          value={title}
          placeholder={t('goals.drawer.newStepPlaceholder')}
          autoComplete="off"
          onChange={(event) => setTitle(event.target.value)}
          onKeyDown={(event) => {
            if (event.key !== 'Enter') return
            event.preventDefault()
            add()
          }}
          className="min-w-0 flex-1 bg-transparent px-3 text-base text-ink placeholder:text-ink-muted focus:outline-none"
        />
        <button
          type="button"
          onClick={add}
          disabled={!trimmed}
          aria-label={t('goals.drawer.addStepAria')}
          className="group grid size-11 shrink-0 cursor-pointer place-items-center focus-visible:outline-none disabled:cursor-not-allowed"
        >
          <span className="grid size-8 place-items-center rounded-lg bg-accent-soft text-primary-ink transition-colors group-hover:bg-primary group-hover:text-white group-focus-visible:ring-2 group-focus-visible:ring-primary group-disabled:opacity-60 group-disabled:group-hover:bg-accent-soft group-disabled:group-hover:text-primary-ink">
            <Plus size={18} aria-hidden="true" />
          </span>
        </button>
      </div>
    </section>
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
          className="min-h-11 min-w-0 max-w-full rounded-xl border-2 border-ink bg-surface px-2 text-sm focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
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
        className="col-span-2 min-h-11 min-w-0 rounded-xl border-2 border-ink bg-surface px-3 text-base focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none sm:col-span-1"
      />
      <label htmlFor={deadlineId} className="sr-only">
        {t('goals.drawer.newStepDeadlineLabel')}
      </label>
      <input
        id={deadlineId}
        type="date"
        value={deadline}
        onChange={(event) => setDeadline(event.target.value)}
        className="min-h-11 min-w-0 w-full rounded-xl border-2 border-ink bg-surface px-2 text-sm focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
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
