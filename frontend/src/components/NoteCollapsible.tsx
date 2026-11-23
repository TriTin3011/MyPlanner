import { Check, ChevronDown, LoaderCircle, Pencil } from 'lucide-react'
import { type ChangeEvent, useEffect, useId, useRef, useState } from 'react'
import { useTranslation } from 'react-i18next'

interface NoteCollapsibleProps {
  label?: string
  placeholder?: string
  // Gợi ý trong ô nhập khi đã mở (khác `placeholder` là chữ mờ cạnh nhãn lúc còn đóng).
  textareaPlaceholder?: string
  initialContent?: string
  onSave: (content: string) => Promise<void>
  disabled?: boolean
}

export function NoteCollapsible({
  label,
  placeholder,
  textareaPlaceholder,
  initialContent = '',
  onSave,
  disabled = false,
}: NoteCollapsibleProps) {
  const { t } = useTranslation()
  const resolvedLabel = label ?? t('common.note.defaultLabel')
  const resolvedPlaceholder = placeholder ?? t('common.note.defaultPlaceholder')
  const resolvedTextareaPlaceholder = textareaPlaceholder ?? t('common.note.defaultTextareaPlaceholder')
  const [isOpen, setIsOpen] = useState(() => Boolean(initialContent.trim()))
  const [content, setContent] = useState(initialContent)
  const [savedContent, setSavedContent] = useState(initialContent)
  const [prevInitialContent, setPrevInitialContent] = useState(initialContent)
  const [status, setStatus] = useState<'idle' | 'saving' | 'saved' | 'error'>('idle')
  const [errorMessage, setErrorMessage] = useState<string | null>(null)

  const textareaRef = useRef<HTMLTextAreaElement>(null)
  const debounceTimer = useRef<ReturnType<typeof setTimeout> | null>(null)
  const contentId = useId()
  const textareaId = useId()

  // Đồng bộ khi initialContent từ server thay đổi (theo chuẩn React: adjust state during render)
  if (prevInitialContent !== initialContent) {
    setPrevInitialContent(initialContent)
    if (status !== 'saving' && status !== 'error') {
      setContent(initialContent)
      setSavedContent(initialContent)
    }
  }

  // Dọn dẹp timer khi unmount
  useEffect(() => {
    return () => {
      if (debounceTimer.current) clearTimeout(debounceTimer.current)
    }
  }, [])

  async function performSave(textToSave: string) {
    if (textToSave === savedContent) return
    setStatus('saving')
    setErrorMessage(null)
    try {
      await onSave(textToSave)
      setSavedContent(textToSave)
      setStatus('saved')
    } catch (error) {
      setStatus('error')
      setErrorMessage(error instanceof Error ? error.message : t('common.note.error'))
    }
  }

  function handleChange(event: ChangeEvent<HTMLTextAreaElement>) {
    const next = event.target.value
    setContent(next)
    setStatus('idle')
    setErrorMessage(null)

    if (debounceTimer.current) clearTimeout(debounceTimer.current)
    debounceTimer.current = setTimeout(() => {
      performSave(next)
    }, 500)
  }

  function handleBlur() {
    if (debounceTimer.current) {
      clearTimeout(debounceTimer.current)
      debounceTimer.current = null
    }
    if (content !== savedContent) {
      performSave(content)
    }
  }

  function toggleOpen() {
    setIsOpen((prev) => {
      const next = !prev
      if (next) {
        setTimeout(() => textareaRef.current?.focus(), 50)
      }
      return next
    })
  }

  return (
    <div className="mt-4 border-t border-[var(--line)] pt-3">
      <button
        type="button"
        onClick={toggleOpen}
        aria-expanded={isOpen}
        aria-controls={contentId}
        disabled={disabled}
        className="flex w-full cursor-pointer items-center justify-between gap-2 rounded-lg py-1.5 text-left text-sm font-bold text-ink-muted hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-50"
      >
        <span className="flex items-center gap-1.5">
          <Pencil size={15} className="text-primary" aria-hidden="true" />
          <span>{resolvedLabel}</span>
          <span className="text-xs font-normal text-ink-muted">· {resolvedPlaceholder}</span>
        </span>

        <span className="flex items-center gap-2">
          {status === 'saving' && (
            <span role="status" aria-label={t('common.note.savingAria')} className="flex items-center gap-1 text-xs text-primary">
              <LoaderCircle size={13} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
              <span>{t('common.note.saving')}</span>
            </span>
          )}
          {status === 'saved' && (
            <span role="status" aria-label={t('common.note.savedAria')} className="flex items-center gap-1 text-xs text-primary">
              <Check size={13} aria-hidden="true" />
              <span>{t('common.note.saved')}</span>
            </span>
          )}
          <ChevronDown
            size={16}
            className={`transition-transform duration-200 motion-reduce:transition-none ${
              isOpen ? 'rotate-180' : ''
            }`}
            aria-hidden="true"
          />
        </span>
      </button>

      {isOpen && (
        <div id={contentId} className="mt-2 space-y-2">
          <label htmlFor={textareaId} className="sr-only">
            {resolvedLabel}
          </label>
          <textarea
            ref={textareaRef}
            id={textareaId}
            value={content}
            onChange={handleChange}
            onBlur={handleBlur}
            disabled={disabled}
            placeholder={resolvedTextareaPlaceholder}
            rows={3}
            className="w-full resize-y rounded-lg border-2 border-[var(--line)] bg-[var(--surface)] p-2.5 text-sm text-ink placeholder:text-ink-muted/60 focus-visible:border-primary focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-50"
          />
          {status === 'error' && errorMessage && (
            <p role="alert" className="text-xs font-semibold text-danger">
              {errorMessage}
            </p>
          )}
        </div>
      )}
    </div>
  )
}
