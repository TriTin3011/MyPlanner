import { Check, LoaderCircle } from 'lucide-react'
import { useEffect, useId, useRef, useState } from 'react'
import type { SaveYearMetaRequest } from '../../api/types'

interface YearMetaBlockProps {
  keyword: string
  vision: string
  onSave: (req: SaveYearMetaRequest) => Promise<unknown>
  className?: string
}

const DEBOUNCE_MS = 800

// Khối "Từ khoá của năm" + "Tầm nhìn năm nay" (SPEC §10.2). Tự lưu: gõ xong 0,8 giây (debounce)
// hoặc rời ô (blur) thì gửi cả hai trường một lần. Không có nút Lưu.
// Ô nhập là "controlled" theo state cục bộ; trang remount khối này (key = năm) khi đổi năm.
export function YearMetaBlock({ keyword: initialKeyword, vision: initialVision, onSave, className = '' }: YearMetaBlockProps) {
  const [keyword, setKeyword] = useState(initialKeyword)
  const [vision, setVision] = useState(initialVision)
  const [status, setStatus] = useState<'idle' | 'saving' | 'saved' | 'error'>('idle')
  const keywordId = useId()
  const visionId = useId()

  // Bản đã lưu gần nhất: tránh gửi lại khi không có gì đổi (blur ngay sau khi debounce đã lưu).
  const savedRef = useRef({ keyword: initialKeyword, vision: initialVision })
  const timerRef = useRef<number | undefined>(undefined)

  async function save(next: SaveYearMetaRequest) {
    window.clearTimeout(timerRef.current)
    const saved = savedRef.current
    if (next.keyword === saved.keyword && next.vision === saved.vision) return
    setStatus('saving')
    try {
      await onSave(next)
      savedRef.current = { keyword: next.keyword, vision: next.vision }
      setStatus('saved')
    } catch {
      setStatus('error')
    }
  }

  function schedule(next: SaveYearMetaRequest) {
    window.clearTimeout(timerRef.current)
    timerRef.current = window.setTimeout(() => void save(next), DEBOUNCE_MS)
  }

  // Rời trang khi còn hẹn giờ: huỷ hẹn giờ (blur đã lưu trước đó nếu người dùng bấm sang chỗ khác).
  useEffect(() => () => window.clearTimeout(timerRef.current), [])

  const labelClass = 'block text-xs font-extrabold tracking-wide text-ink-muted uppercase'
  const fieldClass =
    'mt-1.5 w-full rounded-xl border-2 border-ink bg-surface px-3 text-ink placeholder:text-ink-muted focus:ring-2 focus:ring-primary focus:ring-offset-2 focus:outline-none'

  return (
    <section aria-label="Từ khoá và tầm nhìn năm" className={`sketch bg-[var(--surface)] p-4 sm:p-5 ${className}`}>
      <label htmlFor={keywordId} className={labelClass}>
        Từ khoá của năm
      </label>
      <input
        id={keywordId}
        value={keyword}
        maxLength={100}
        onChange={(e) => {
          setKeyword(e.target.value)
          schedule({ keyword: e.target.value, vision })
        }}
        onBlur={() => void save({ keyword, vision })}
        placeholder="Một từ cho cả năm, vd: Bứt phá"
        autoComplete="off"
        className={`${fieldClass} min-h-11 font-display text-lg font-extrabold text-primary-ink`}
      />

      <label htmlFor={visionId} className={`${labelClass} mt-4`}>
        Tầm nhìn năm nay
      </label>
      <textarea
        id={visionId}
        value={vision}
        maxLength={2000}
        rows={3}
        onChange={(e) => {
          setVision(e.target.value)
          schedule({ keyword, vision: e.target.value })
        }}
        onBlur={() => void save({ keyword, vision })}
        placeholder="Cuối năm nay, mình muốn…"
        className={`${fieldClass} resize-y py-2 text-base leading-relaxed`}
      />

      {/* Trạng thái lưu đọc cho trình đọc màn hình qua aria-live, không chen ngang người đang gõ. */}
      <p aria-live="polite" className="mt-2 flex min-h-5 items-center gap-1.5 text-xs font-bold text-ink-muted">
        {status === 'saving' && (
          <>
            <LoaderCircle size={13} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
            Đang lưu…
          </>
        )}
        {status === 'saved' && (
          <>
            <Check size={13} className="text-primary" aria-hidden="true" />
            Đã lưu
          </>
        )}
        {status === 'error' && <span className="text-danger">Chưa lưu được. Sửa tiếp hoặc bấm ra ngoài để thử lại.</span>}
      </p>
    </section>
  )
}
