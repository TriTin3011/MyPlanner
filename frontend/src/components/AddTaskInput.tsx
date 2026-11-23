import { LoaderCircle, Plus } from 'lucide-react'
import { type FormEvent, type Ref, useId, useState } from 'react'
import { useTranslation } from 'react-i18next'

interface AddTaskInputProps {
  pending: boolean
  onAdd: (title: string) => Promise<void>
  placeholder?: string
  inputRef?: Ref<HTMLInputElement>
  shortcutHint?: string
}

export function AddTaskInput({
  pending,
  onAdd,
  placeholder,
  inputRef,
  shortcutHint,
}: AddTaskInputProps) {
  const { t } = useTranslation()
  const resolvedPlaceholder = placeholder ?? t('common.addTask.defaultPlaceholder')
  const [title, setTitle] = useState('')
  const [error, setError] = useState<string | null>(null)
  const inputId = useId()
  const errorId = useId()
  const trimmedTitle = title.trim()

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (!trimmedTitle || pending) return

    setError(null)
    try {
      await onAdd(trimmedTitle)
      setTitle('')
    } catch (reason) {
      setError(reason instanceof Error ? reason.message : t('common.addTask.error'))
    }
  }

  return (
    <div className="mt-3">
      <form
        onSubmit={handleSubmit}
        aria-busy={pending}
        className="flex min-h-11 items-center rounded-xl border-2 border-ink bg-surface focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-2"
      >
        <label htmlFor={inputId} className="sr-only">
          {t('common.addTask.label')}
        </label>
        <input
          ref={inputRef}
          id={inputId}
          value={title}
          onChange={(event) => setTitle(event.target.value)}
          disabled={pending}
          aria-invalid={error ? true : undefined}
          aria-describedby={error ? errorId : undefined}
          aria-keyshortcuts={shortcutHint ? shortcutHint.toLowerCase() : undefined}
          placeholder={resolvedPlaceholder}
          autoComplete="off"
          className="min-w-0 flex-1 bg-transparent px-3 text-base text-ink placeholder:text-ink-muted focus:outline-none disabled:cursor-wait disabled:opacity-60"
        />
        {shortcutHint && (
          <kbd
            title={t('shortcuts.focusAddTask')}
            aria-hidden="true"
            className="mr-2 hidden rounded border border-ink/40 bg-accent-tint px-1.5 py-0.5 font-sans text-[11px] font-bold text-primary-ink sm:inline-block"
          >
            {shortcutHint}
          </kbd>
        )}
        <button
          type="submit"
          disabled={pending || !trimmedTitle}
          aria-label={pending ? t('common.addTask.adding') : t('common.addTask.submit')}
          className="group grid size-11 shrink-0 cursor-pointer place-items-center focus-visible:outline-none disabled:cursor-not-allowed"
        >
          {/* Vùng bấm 44px cho cảm ứng, phần nhìn thấy là ô vuông bo 32px nằm gọn trong ô nhập. */}
          <span className="grid size-8 place-items-center rounded-lg bg-accent-soft text-primary-ink transition-colors group-hover:bg-primary group-hover:text-white group-focus-visible:ring-2 group-focus-visible:ring-primary group-disabled:opacity-60 group-disabled:group-hover:bg-accent-soft group-disabled:group-hover:text-primary-ink">
            {pending ? (
              <LoaderCircle size={17} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
            ) : (
              <Plus size={18} aria-hidden="true" />
            )}
          </span>
        </button>
      </form>

      {error && (
        <p id={errorId} role="alert" className="mt-2 text-sm font-semibold text-danger">
          {error}
        </p>
      )}
    </div>
  )
}
