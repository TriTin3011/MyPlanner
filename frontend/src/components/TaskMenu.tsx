import {
  ArrowDownToLine,
  CalendarDays,
  Check,
  ListPlus,
  LoaderCircle,
  MoreHorizontal,
  Trash2,
} from 'lucide-react'
import {
  type FormEvent,
  type KeyboardEvent,
  type ReactNode,
  type RefObject,
  useEffect,
  useId,
  useRef,
  useState,
} from 'react'
import { useTranslation } from 'react-i18next'
import type { TaskDto, TaskTag } from '../api/types'
import { getTaskTags, TAG_ORDER } from './taskTags'

// Menu ⋯ của một Task (SPEC §6.3, §6.4). Component chỉ hiển thị và gọi callback; việc gọi API do trang làm.
// Mục nào không truyền callback thì không hiện, nhờ vậy cùng một menu dùng được cho Việc hôm nay và Việc còn tồn.
export interface TaskMenuProps {
  task: TaskDto
  open: boolean
  onOpenChange: (open: boolean) => void
  disabled?: boolean
  dateLabel?: string
  onMoveToToday?: () => Promise<unknown>
  onToggleTag?: (tag: TaskTag) => Promise<unknown>
  onAddSubtask?: (title: string) => Promise<unknown>
  onChangeDate?: (date: string) => Promise<unknown>
  onDelete?: () => Promise<unknown>
}

export function TaskMenu(props: TaskMenuProps) {
  const { t } = useTranslation()
  const { task, open, onOpenChange, disabled } = props
  const triggerRef = useRef<HTMLButtonElement>(null)
  const menuId = useId()

  function close(returnFocus: boolean) {
    onOpenChange(false)
    if (returnFocus) triggerRef.current?.focus()
  }

  return (
    <div className="relative shrink-0">
      <button
        ref={triggerRef}
        type="button"
        onClick={() => onOpenChange(!open)}
        disabled={disabled}
        aria-haspopup="menu"
        aria-expanded={open}
        aria-controls={open ? menuId : undefined}
        aria-label={t('common.taskMenu.actionsFor', { title: task.title })}
        className="grid size-11 cursor-pointer place-items-center rounded-lg text-ink-muted md:size-9 hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-wait disabled:opacity-50"
      >
        <MoreHorizontal size={18} aria-hidden="true" />
      </button>
      {/* Popover chỉ mount khi mở: state bên trong (đang ở màn nào, lỗi) tự reset mỗi lần mở lại. */}
      {open && <TaskMenuPopover {...props} id={menuId} triggerRef={triggerRef} onClose={close} />}
    </div>
  )
}

type View = 'menu' | 'date' | 'subtask'

interface PopoverProps extends TaskMenuProps {
  id: string
  triggerRef: RefObject<HTMLButtonElement | null>
  onClose: (returnFocus: boolean) => void
}

function TaskMenuPopover({
  id,
  task,
  triggerRef,
  onClose,
  dateLabel,
  onMoveToToday,
  onToggleTag,
  onAddSubtask,
  onChangeDate,
  onDelete,
}: PopoverProps) {
  const { t } = useTranslation()
  const taskTags = getTaskTags(t)
  const resolvedDateLabel = dateLabel ?? t('common.taskMenu.defaultDateLabel')
  const [view, setView] = useState<View>('menu')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const panelRef = useRef<HTMLDivElement>(null)

  // Bấm ra ngoài thì đóng. Dùng pointerdown (chạy trước click) để không lọt cú bấm vào phần tử bên dưới.
  useEffect(() => {
    function onPointerDown(event: PointerEvent) {
      const target = event.target as Node
      if (panelRef.current?.contains(target) || triggerRef.current?.contains(target)) return
      onClose(false)
    }
    document.addEventListener('pointerdown', onPointerDown)
    return () => document.removeEventListener('pointerdown', onPointerDown)
  }, [onClose, triggerRef])

  // Mở menu hoặc đổi màn thì đưa focus vào phần tử đầu tiên, để người dùng bàn phím thao tác ngay.
  useEffect(() => {
    const first = panelRef.current?.querySelector<HTMLElement>('[role^="menuitem"], input')
    first?.focus()
  }, [view])

  async function run(action: () => Promise<unknown>, closeAfter = true) {
    setBusy(true)
    setError(null)
    try {
      await action()
      if (closeAfter) onClose(true)
    } catch (reason) {
      setError(reason instanceof Error ? reason.message : t('common.saveError'))
    } finally {
      setBusy(false)
    }
  }

  // Điều hướng bằng phím mũi tên theo mẫu WAI-ARIA "menu".
  function handleKeyDown(event: KeyboardEvent<HTMLDivElement>) {
    if (event.key === 'Escape') {
      event.preventDefault()
      if (view === 'menu') onClose(true)
      else setView('menu')
      return
    }
    if (view !== 'menu') return
    const items = [...(panelRef.current?.querySelectorAll<HTMLElement>('[role^="menuitem"]') ?? [])]
    const index = items.indexOf(document.activeElement as HTMLElement)
    const next =
      event.key === 'ArrowDown' ? items[(index + 1) % items.length]
      : event.key === 'ArrowUp' ? items[(index - 1 + items.length) % items.length]
      : event.key === 'Home' ? items[0]
      : event.key === 'End' ? items[items.length - 1]
      : undefined
    if (next) {
      event.preventDefault()
      next.focus()
    }
  }

  return (
    <div
      ref={panelRef}
      onKeyDown={handleKeyDown}
      aria-busy={busy}
      className="absolute top-full right-0 z-30 mt-1 w-64 max-w-[calc(100vw-2rem)] rounded-xl border-2 border-ink bg-surface p-1.5 shadow-[3px_3px_0_0_var(--sketch-ink)]"
    >
      {view === 'menu' && (
        <div id={id} role="menu" aria-label={t('common.taskMenu.actionsFor', { title: task.title })}>
          {onMoveToToday && (
            <MenuItem icon={<ArrowDownToLine size={16} />} disabled={busy} onClick={() => run(onMoveToToday)}>
              {t('common.taskMenu.moveToToday')}
            </MenuItem>
          )}
          {onChangeDate && (
            <MenuItem icon={<CalendarDays size={16} />} disabled={busy} onClick={() => setView('date')}>
              {t('common.taskMenu.changeDateItem', { label: resolvedDateLabel })}
            </MenuItem>
          )}
          {onAddSubtask && (
            <MenuItem icon={<ListPlus size={16} />} disabled={busy} onClick={() => setView('subtask')}>
              {t('common.taskMenu.addSubtaskItem')}
            </MenuItem>
          )}
          {onToggleTag && (
            <div role="group" aria-label={t('common.tag')} className="my-1 border-y border-[var(--line)] py-1">
              {TAG_ORDER.map((tag) => {
                const checked = task.tags.includes(tag)
                return (
                  <button
                    key={tag}
                    type="button"
                    role="menuitemcheckbox"
                    aria-checked={checked}
                    disabled={busy}
                    onClick={() => run(() => onToggleTag(tag), false)}
                    className={itemClass}
                  >
                    <span className="grid size-4 place-items-center" aria-hidden="true">
                      {checked && <Check size={16} />}
                    </span>
                    <span className={`rounded-full px-2 py-0.5 text-xs font-bold ${taskTags[tag].className}`}>
                      {taskTags[tag].label}
                    </span>
                  </button>
                )
              })}
            </div>
          )}
          {onDelete && (
            <MenuItem icon={<Trash2 size={16} />} danger disabled={busy} onClick={() => run(onDelete)}>
              {t('common.taskMenu.deleteTask')}
            </MenuItem>
          )}
        </div>
      )}

      {view === 'date' && onChangeDate && (
        <InlineForm
          label={resolvedDateLabel}
          type="date"
          initialValue={task.date}
          submitLabel={t('common.move')}
          busy={busy}
          onCancel={() => setView('menu')}
          onSubmit={(value) => run(() => onChangeDate(value))}
        />
      )}

      {view === 'subtask' && onAddSubtask && (
        <InlineForm
          label={t('common.taskMenu.newSubtaskLabel')}
          type="text"
          initialValue=""
          placeholder={t('common.taskMenu.newSubtaskPlaceholder')}
          submitLabel={t('common.add')}
          busy={busy}
          onCancel={() => setView('menu')}
          onSubmit={(value) => run(() => onAddSubtask(value))}
        />
      )}

      {error && (
        <p role="alert" className="mt-1 rounded-lg bg-[var(--danger-bg)] px-2 py-1.5 text-sm font-semibold text-danger">
          {error}
        </p>
      )}
    </div>
  )
}

const itemClass =
  'flex min-h-11 w-full cursor-pointer items-center gap-2.5 rounded-lg px-2.5 text-left text-sm font-semibold text-ink hover:bg-accent-tint focus-visible:bg-accent-tint focus-visible:outline-none disabled:cursor-wait disabled:opacity-50'

function MenuItem({
  icon,
  danger,
  disabled,
  onClick,
  children,
}: {
  icon: ReactNode
  danger?: boolean
  disabled?: boolean
  onClick: () => void
  children: ReactNode
}) {
  return (
    <button
      type="button"
      role="menuitem"
      disabled={disabled}
      onClick={onClick}
      className={`${itemClass} ${danger ? 'text-danger hover:bg-[var(--danger-bg)] focus-visible:bg-[var(--danger-bg)]' : ''}`}
    >
      <span aria-hidden="true">{icon}</span>
      {children}
    </button>
  )
}

function InlineForm({
  label,
  type,
  initialValue,
  placeholder,
  submitLabel,
  busy,
  onCancel,
  onSubmit,
}: {
  label: string
  type: 'date' | 'text'
  initialValue: string
  placeholder?: string
  submitLabel: string
  busy: boolean
  onCancel: () => void
  onSubmit: (value: string) => void
}) {
  const { t } = useTranslation()
  const [value, setValue] = useState(initialValue)
  const inputId = useId()
  const trimmed = value.trim()

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (trimmed && !busy) onSubmit(trimmed)
  }

  return (
    <form onSubmit={submit} className="space-y-2 p-1.5">
      <label htmlFor={inputId} className="block text-sm font-bold text-ink">
        {label}
      </label>
      <input
        id={inputId}
        type={type}
        value={value}
        placeholder={placeholder}
        onChange={(event) => setValue(event.target.value)}
        disabled={busy}
        className="min-h-11 w-full rounded-lg border-2 border-[var(--line)] bg-surface px-3 text-base text-ink focus-visible:border-primary focus-visible:outline-none"
      />
      <div className="flex justify-end gap-2">
        <button
          type="button"
          onClick={onCancel}
          disabled={busy}
          className="min-h-11 cursor-pointer rounded-lg px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
        >
          {t('common.back')}
        </button>
        <button
          type="submit"
          disabled={busy || !trimmed}
          className="flex min-h-11 cursor-pointer items-center gap-1.5 rounded-lg bg-primary px-4 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-45"
        >
          {busy && <LoaderCircle size={15} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />}
          {submitLabel}
        </button>
      </div>
    </form>
  )
}
