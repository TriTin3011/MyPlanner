import { LoaderCircle, Pencil, Plus, Trash2 } from 'lucide-react'
import { type FormEvent, useId, useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { RecurringTaskDto, SaveRecurringRequest, TaskTag } from '../../api/types'
import { EmptyState } from '../../components/EmptyState'
import { Modal } from '../../components/Modal'
import { getTaskTags, TAG_ORDER } from '../../components/taskTags'
import { INTL_LOCALE } from '../../i18n/languages'
import { useSettings } from '../../store/settings'
import { useCreateRecurring, useDeleteRecurring, useRecurring, useUpdateRecurring } from './hooks'
import { formatWeekdays, getWeekdays } from './weekdays'

interface RecurringModalProps {
  open: boolean
  today: string
  onClose: () => void
}

export function RecurringModal({ open, today, onClose }: RecurringModalProps) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const taskTags = getTaskTags(t)
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
    <Modal open={open} title={t('recurring.title')} onClose={onClose}>
      <p className="mb-4 text-sm text-ink-muted">{t('recurring.description')}</p>

      <section aria-label={t('recurring.listAria')}>
        {rules.isPending && (
          <p role="status" className="flex items-center gap-2 py-4 text-sm font-semibold text-ink-muted">
            <LoaderCircle size={16} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
            {t('recurring.loading')}
          </p>
        )}
        {rules.isError && (
          <p role="alert" className="rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
            {t('recurring.loadError')}
          </p>
        )}
        {rules.data && rules.data.length === 0 && (
          <EmptyState text={t('recurring.empty')} />
        )}
        {listError && (
          <p role="alert" className="mb-2 rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
            {t('recurring.saveChangesError')}
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
                      <span>{formatWeekdays(rule.weekdays, locale, t('recurring.everyDay'))}</span>
                      {rule.tags.map((tag) => (
                        <span key={tag} className={`rounded-full px-2 py-0.5 ${taskTags[tag].className}`}>
                          {taskTags[tag].label}
                        </span>
                      ))}
                    </p>
                  </div>

                  {confirming ? (
                    <div className="flex items-center gap-1">
                      <span className="text-sm font-bold text-danger">{t('recurring.confirmDelete')}</span>
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
                        {t('common.delete')}
                      </button>
                      <button
                        type="button"
                        onClick={() => setConfirmDeleteId(null)}
                        className="min-h-11 cursor-pointer rounded-lg px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
                      >
                        {t('common.cancel')}
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
                        <span>{t('recurring.activeLabel')}</span>
                        <span className="sr-only">{t('recurring.activeSrSuffix', { title: rule.title })}</span>
                      </label>
                      <button
                        type="button"
                        disabled={busy}
                        onClick={() => {
                          setEditing(rule)
                          setFormKey((k) => k + 1)
                        }}
                        aria-label={t('recurring.editRule', { title: rule.title })}
                        className="grid size-11 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:opacity-50"
                      >
                        <Pencil size={16} aria-hidden="true" />
                      </button>
                      <button
                        type="button"
                        disabled={busy}
                        onClick={() => setConfirmDeleteId(rule.id)}
                        aria-label={t('recurring.deleteRule', { title: rule.title })}
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
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const weekdayOptions = useMemo(() => getWeekdays(locale), [locale])
  const taskTags = getTaskTags(t)
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
      setError(reason instanceof Error ? reason.message : t('common.saveError'))
    }
  }

  return (
    <form onSubmit={submit} aria-busy={pending} className="mt-5 space-y-3 rounded-xl bg-accent-tint/40 p-3">
      <h3 className="font-display text-lg font-bold text-primary-ink">
        {initial ? t('recurring.editTitle') : t('recurring.addTitle')}
      </h3>

      <div>
        <label htmlFor={titleId} className="mb-1 block text-sm font-bold">
          {t('recurring.nameLabel')}
        </label>
        <input
          id={titleId}
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder={t('recurring.namePlaceholder')}
          maxLength={500}
          className="min-h-11 w-full rounded-lg border-2 border-[var(--line)] bg-surface px-3 text-base focus-visible:border-primary focus-visible:outline-none"
        />
      </div>

      <fieldset>
        <legend className="mb-1 text-sm font-bold">{t('recurring.weekdaysLegend')}</legend>
        <div className="flex flex-wrap gap-1.5">
          {weekdayOptions.map((day) => {
            const checked = weekdays.includes(day.value)
            return (
              <button
                key={day.value}
                type="button"
                aria-pressed={checked}
                aria-label={day.long}
                onClick={() => setWeekdays((prev) => toggle(prev, day.value))}
                className={`grid size-11 cursor-pointer place-items-center rounded-xl border-2 text-sm font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none ${
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
        <legend className="mb-1 text-sm font-bold">{t('common.tag')}</legend>
        <div className="flex flex-wrap gap-1.5">
          {TAG_ORDER.map((tag) => {
            const checked = tags.includes(tag)
            return (
              <button
                key={tag}
                type="button"
                aria-pressed={checked}
                onClick={() => setTags((prev) => toggle(prev, tag))}
                className={`min-h-11 cursor-pointer rounded-xl border-2 px-3 text-sm font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none ${
                  checked ? `border-ink ${taskTags[tag].className}` : 'border-[var(--line)] bg-surface text-ink-muted'
                }`}
              >
                {taskTags[tag].label}
              </button>
            )
          })}
        </div>
      </fieldset>

      <div>
        <label htmlFor={startId} className="mb-1 block text-sm font-bold">
          {t('recurring.startDateLabel')}
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
            {t('recurring.cancelEdit')}
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
          {initial ? t('recurring.saveChanges') : t('common.add')}
        </button>
      </div>
    </form>
  )
}
