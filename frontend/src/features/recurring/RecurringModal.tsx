import { LoaderCircle, Pencil, Plus, Trash2 } from 'lucide-react'
import { type FormEvent, useId, useState } from 'react'
import type { RecurringTaskDto, SaveRecurringRequest, TaskTag } from '../../api/types'
import { Modal } from '../../components/Modal'
import { TAG_ORDER, TASK_TAGS } from '../../components/taskTags'
import { useCreateRecurring, useDeleteRecurring, useRecurring, useUpdateRecurring } from './hooks'
import { formatWeekdays, WEEKDAYS } from './weekdays'

interface RecurringModalProps {
  open: boolean
  today: string
  onClose: () => void
}

export function RecurringModal({ open, today, onClose }: RecurringModalProps) {
  const rules = useRecurring()
  const create = useCreateRecurring(today)
  const update = useUpdateRecurring(today)
  const remove = useDeleteRecurring(today)
  // null: đang thêm mới; còn lại: đang sửa quy tắc này.
  const [editing, setEditing] = useState<RecurringTaskDto | null>(null)
  const [confirmDeleteId, setConfirmDeleteId] = useState<string | null>(null)
  // Đổi key để form mount lại với giá trị ban đầu mới (thay vì đồng bộ state bằng useEffect).
  const [formKey, setFormKey] = useState(0)

  function resetForm() {
    setEditing(null)
    setFormKey((k) => k + 1)
  }

  async function handleSave(request: SaveRecurringRequest) {
    if (editing) await update.mutateAsync({ id: editing.id, request })
    else await create.mutateAsync(request)
    resetForm()
  }

  function toRequest(rule: RecurringTaskDto, patch: Partial<SaveRecurringRequest>): SaveRecurringRequest {
    return {
      title: rule.title,
      weekdays: rule.weekdays,
      tags: rule.tags,
      active: rule.active,
      startDate: rule.startDate,
      ...patch,
    }
  }

  const busyId =
    update.isPending ? update.variables.id : remove.isPending ? remove.variables : undefined
  const listError = update.isError || remove.isError

  return (
    <Modal open={open} title="Việc lặp lại" onClose={onClose}>
      <p className="mb-4 text-sm text-ink-muted">
        Việc lặp lại tự sinh thành công việc vào các thứ đã chọn (tối đa 7 ngày tới). Khác thói quen: thói quen chỉ
        tick có hoặc không mỗi ngày.
      </p>

      <section aria-label="Danh sách việc lặp lại">
        {rules.isPending && (
          <p role="status" className="flex items-center gap-2 py-4 text-sm font-semibold text-ink-muted">
            <LoaderCircle size={16} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
            Đang tải…
          </p>
        )}
        {rules.isError && (
          <p role="alert" className="rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
            Chưa tải được danh sách việc lặp lại.
          </p>
        )}
        {rules.data && rules.data.length === 0 && (
          <p className="py-3 text-center text-sm font-medium text-ink-muted">Chưa có việc lặp lại nào.</p>
        )}
        {listError && (
          <p role="alert" className="mb-2 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
            Chưa lưu được thay đổi. Hãy thử lại.
          </p>
        )}
        {rules.data && rules.data.length > 0 && (
          <ul className="divide-y divide-[var(--line)] rounded-xl border-2 border-[var(--line)]">
            {rules.data.map((rule) => {
              const busy = busyId === rule.id
              const confirming = confirmDeleteId === rule.id
              return (
                <li key={rule.id} className="flex min-w-0 flex-wrap items-center gap-2 px-3 py-2">
                  <div className="min-w-0 flex-1">
                    <p
                      className={`[overflow-wrap:anywhere] font-semibold ${rule.active ? 'text-ink' : 'text-ink-muted line-through'}`}
                    >
                      {rule.title}
                    </p>
                    <p className="mt-0.5 flex flex-wrap items-center gap-1.5 text-xs font-bold text-ink-muted">
                      <span>{formatWeekdays(rule.weekdays)}</span>
                      {rule.tags.map((tag) => (
                        <span key={tag} className={`rounded-full px-2 py-0.5 ${TASK_TAGS[tag].className}`}>
                          {TASK_TAGS[tag].label}
                        </span>
                      ))}
                    </p>
                  </div>

                  {confirming ? (
                    <div className="flex items-center gap-1">
                      <span className="text-sm font-bold text-danger">Xoá quy tắc này?</span>
                      <button
                        type="button"
                        disabled={busy}
                        onClick={async () => {
                          await remove.mutateAsync(rule.id).catch(() => undefined)
                          setConfirmDeleteId(null)
                          if (editing?.id === rule.id) resetForm()
                        }}
                        className="min-h-11 cursor-pointer rounded-lg bg-danger px-3 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-danger focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-wait disabled:opacity-50"
                      >
                        Xoá
                      </button>
                      <button
                        type="button"
                        onClick={() => setConfirmDeleteId(null)}
                        className="min-h-11 cursor-pointer rounded-lg px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
                      >
                        Huỷ
                      </button>
                    </div>
                  ) : (
                    <div className="flex items-center gap-0.5">
                      <label className="flex min-h-11 cursor-pointer items-center gap-2 rounded-lg px-2 text-xs font-bold text-ink-muted hover:bg-accent-tint">
                        <input
                          type="checkbox"
                          role="switch"
                          checked={rule.active}
                          disabled={busy}
                          onChange={(e) =>
                            update.mutate({ id: rule.id, request: toRequest(rule, { active: e.target.checked }) })
                          }
                          className="size-4 cursor-pointer accent-primary disabled:cursor-wait"
                        />
                        <span>Bật</span>
                        <span className="sr-only">việc lặp lại “{rule.title}”</span>
                      </label>
                      <button
                        type="button"
                        disabled={busy}
                        onClick={() => {
                          setEditing(rule)
                          setFormKey((k) => k + 1)
                        }}
                        aria-label={`Sửa “${rule.title}”`}
                        className="grid size-11 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:opacity-50"
                      >
                        <Pencil size={16} aria-hidden="true" />
                      </button>
                      <button
                        type="button"
                        disabled={busy}
                        onClick={() => setConfirmDeleteId(rule.id)}
                        aria-label={`Xoá “${rule.title}”`}
                        className="grid size-11 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-[var(--danger-bg)] hover:text-danger focus-visible:ring-2 focus-visible:ring-danger focus-visible:outline-none disabled:opacity-50"
                      >
                        {busy ? (
                          <LoaderCircle size={16} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
                        ) : (
                          <Trash2 size={16} aria-hidden="true" />
                        )}
                      </button>
                    </div>
                  )}
                </li>
              )
            })}
          </ul>
        )}
      </section>

      <RecurringForm
        key={formKey}
        initial={editing}
        today={today}
        pending={create.isPending || update.isPending}
        onSave={handleSave}
        onCancelEdit={editing ? resetForm : undefined}
      />
    </Modal>
  )
}

interface RecurringFormProps {
  initial: RecurringTaskDto | null
  today: string
  pending: boolean
  onSave: (request: SaveRecurringRequest) => Promise<void>
  onCancelEdit?: () => void
}

function RecurringForm({ initial, today, pending, onSave, onCancelEdit }: RecurringFormProps) {
  const [title, setTitle] = useState(initial?.title ?? '')
  const [weekdays, setWeekdays] = useState<number[]>(initial?.weekdays ?? [])
  const [tags, setTags] = useState<TaskTag[]>(initial?.tags ?? [])
  const [startDate, setStartDate] = useState(initial?.startDate ?? today)
  const [error, setError] = useState<string | null>(null)
  const titleId = useId()
  const startId = useId()
  const trimmed = title.trim()
  const canSubmit = trimmed.length > 0 && weekdays.length > 0 && !pending

  function toggle<T>(list: T[], value: T) {
    return list.includes(value) ? list.filter((v) => v !== value) : [...list, value]
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!canSubmit) return
    setError(null)
    try {
      await onSave({
        title: trimmed,
        weekdays: [...weekdays].sort((a, b) => a - b),
        tags,
        active: initial?.active ?? true,
        startDate,
      })
    } catch (reason) {
      setError(reason instanceof Error ? reason.message : 'Chưa lưu được. Hãy thử lại.')
    }
  }

  return (
    <form onSubmit={submit} aria-busy={pending} className="mt-5 space-y-3 rounded-xl bg-accent-tint/40 p-3">
      <h3 className="font-display text-lg font-bold text-primary-ink">
        {initial ? 'Sửa việc lặp lại' : 'Thêm việc lặp lại'}
      </h3>

      <div>
        <label htmlFor={titleId} className="mb-1 block text-sm font-bold">
          Tên việc
        </label>
        <input
          id={titleId}
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="VD: Dọn nhà, Đi chợ…"
          maxLength={500}
          className="min-h-11 w-full rounded-lg border-2 border-[var(--line)] bg-surface px-3 text-base focus-visible:border-primary focus-visible:outline-none"
        />
      </div>

      <fieldset>
        <legend className="mb-1 text-sm font-bold">Lặp vào các thứ</legend>
        <div className="flex flex-wrap gap-1.5">
          {WEEKDAYS.map((day) => {
            const checked = weekdays.includes(day.value)
            return (
              <button
                key={day.value}
                type="button"
                aria-pressed={checked}
                aria-label={day.long}
                onClick={() => setWeekdays((prev) => toggle(prev, day.value))}
                className={`grid size-11 cursor-pointer place-items-center rounded-full border-2 text-sm font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none ${
                  checked
                    ? 'border-primary bg-primary text-white'
                    : 'border-[var(--line)] bg-surface text-ink hover:bg-accent-tint'
                }`}
              >
                {day.short}
              </button>
            )
          })}
        </div>
      </fieldset>

      <fieldset>
        <legend className="mb-1 text-sm font-bold">Tag</legend>
        <div className="flex flex-wrap gap-1.5">
          {TAG_ORDER.map((tag) => {
            const checked = tags.includes(tag)
            return (
              <button
                key={tag}
                type="button"
                aria-pressed={checked}
                onClick={() => setTags((prev) => toggle(prev, tag))}
                className={`min-h-11 cursor-pointer rounded-full border-2 px-3 text-sm font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none ${
                  checked ? `border-[var(--ink)] ${TASK_TAGS[tag].className}` : 'border-[var(--line)] bg-surface text-ink-muted'
                }`}
              >
                {TASK_TAGS[tag].label}
              </button>
            )
          })}
        </div>
      </fieldset>

      <div>
        <label htmlFor={startId} className="mb-1 block text-sm font-bold">
          Bắt đầu từ ngày
        </label>
        <input
          id={startId}
          type="date"
          value={startDate}
          onChange={(e) => setStartDate(e.target.value || today)}
          className="min-h-11 rounded-lg border-2 border-[var(--line)] bg-surface px-3 text-base focus-visible:border-primary focus-visible:outline-none"
        />
      </div>

      {error && (
        <p role="alert" className="rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
          {error}
        </p>
      )}

      <div className="flex flex-wrap justify-end gap-2">
        {onCancelEdit && (
          <button
            type="button"
            onClick={onCancelEdit}
            disabled={pending}
            className="min-h-11 cursor-pointer rounded-lg px-4 text-sm font-bold text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
          >
            Huỷ sửa
          </button>
        )}
        <button
          type="submit"
          disabled={!canSubmit}
          className="flex min-h-11 cursor-pointer items-center gap-1.5 rounded-lg bg-primary px-4 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-45"
        >
          {pending ? (
            <LoaderCircle size={15} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
          ) : (
            !initial && <Plus size={15} aria-hidden="true" />
          )}
          {initial ? 'Lưu thay đổi' : 'Thêm'}
        </button>
      </div>
    </form>
  )
}
