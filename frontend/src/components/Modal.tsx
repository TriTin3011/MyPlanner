import { X } from 'lucide-react'
import { type ReactNode, useEffect, useId, useRef } from 'react'

interface ModalProps {
  open: boolean
  title: string
  onClose: () => void
  children: ReactNode
  // Nội dung chân modal (nút Đóng, Đặt lại…), nằm cố định dưới phần cuộn.
  footer?: ReactNode
}

// Modal dùng thẻ <dialog> gốc của trình duyệt với showModal(): trình duyệt tự lo bẫy focus (focus trap),
// phím Esc, nền mờ (::backdrop), đưa modal lên lớp trên cùng (top layer) và làm phần còn lại "inert".
// Tự viết các việc đó bằng div rất dễ sót; thư viện (Radix, Headless UI) cũng làm được nhưng thêm phụ thuộc.
export function Modal({ open, title, onClose, children, footer }: ModalProps) {
  const ref = useRef<HTMLDialogElement>(null)
  const titleId = useId()

  // React chỉ giữ state "open"; đồng bộ sang DOM bằng showModal()/close() vì thuộc tính open của <dialog>
  // không bật chế độ modal. jsdom (khi test) chưa có showModal nên rơi về set thuộc tính.
  useEffect(() => {
    const dialog = ref.current
    if (!dialog) return
    if (open && !dialog.open) {
      if (typeof dialog.showModal === 'function') dialog.showModal()
      else dialog.setAttribute('open', '')
    } else if (!open && dialog.open) {
      if (typeof dialog.close === 'function') dialog.close()
      else dialog.removeAttribute('open')
    }
  }, [open])

  return (
    <dialog
      ref={ref}
      aria-labelledby={titleId}
      // Esc phát sự kiện "cancel": chặn hành vi mặc định để React vẫn là nơi quyết định đóng.
      onCancel={(event) => {
        event.preventDefault()
        onClose()
      }}
      // Bấm vào nền mờ: target chính là <dialog> (nội dung nằm trong div con).
      onClick={(event) => {
        if (event.target === event.currentTarget) onClose()
      }}
      className="m-auto w-[min(36rem,calc(100vw-2rem))] max-h-[calc(100dvh-2rem)] overflow-hidden rounded-2xl border-2 border-[var(--ink)] bg-surface p-0 text-ink shadow-[4px_4px_0_0_var(--ink)] backdrop:bg-black/40"
    >
      {open && (
        <div className="flex max-h-[calc(100dvh-2rem)] flex-col">
          <header className="flex items-center justify-between gap-3 border-b border-[var(--line)] px-4 py-3 sm:px-5">
            <h2 id={titleId} className="font-display text-xl font-extrabold text-primary-ink">
              {title}
            </h2>
            <button
              type="button"
              onClick={onClose}
              aria-label="Đóng"
              className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
            >
              <X size={18} aria-hidden="true" />
            </button>
          </header>
          <div className="min-h-0 flex-1 overflow-y-auto px-4 py-4 sm:px-5">{children}</div>
          {footer && <footer className="border-t border-[var(--line)] px-4 py-3 sm:px-5">{footer}</footer>}
        </div>
      )}
    </dialog>
  )
}
