import { useEffect, useRef, useState } from 'react'
import { useDeleteWeek } from './weekExtrasHooks'

const CONFIRM_TIMEOUT_MS = 4_000

interface DeleteWeekLinkProps {
  weekKey: string
  onDeleted?: () => void
}

export function DeleteWeekLink({ weekKey, onDeleted }: DeleteWeekLinkProps) {
  const [isConfirming, setIsConfirming] = useState(false)
  const resetTimer = useRef<ReturnType<typeof setTimeout> | null>(null)
  const deleteWeek = useDeleteWeek()

  useEffect(() => {
    return () => {
      if (resetTimer.current) clearTimeout(resetTimer.current)
    }
  }, [])

  async function handleClick() {
    if (!isConfirming) {
      deleteWeek.reset()
      setIsConfirming(true)
      resetTimer.current = setTimeout(() => {
        setIsConfirming(false)
        resetTimer.current = null
      }, CONFIRM_TIMEOUT_MS)
      return
    }

    if (resetTimer.current) {
      clearTimeout(resetTimer.current)
      resetTimer.current = null
    }
    setIsConfirming(false)

    try {
      await deleteWeek.mutateAsync(weekKey)
      onDeleted?.()
    } catch {
      // Lỗi đã được mutation giữ để hiện ngay dưới liên kết.
    }
  }

  const label = deleteWeek.isPending
    ? 'Đang xóa…'
    : isConfirming
      ? 'Bấm lần nữa để xóa vĩnh viễn'
      : 'Xóa dữ liệu tuần đang xem'

  return (
    <div className="flex flex-col items-center gap-1 py-4 text-center">
      <button
        type="button"
        onClick={handleClick}
        disabled={deleteWeek.isPending}
        className={`min-h-11 rounded-lg px-3 text-xs font-semibold underline-offset-4 hover:underline focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-wait disabled:opacity-70 ${
          isConfirming ? 'text-danger' : 'text-ink-muted hover:text-primary-ink'
        }`}
      >
        {label}
      </button>
      {deleteWeek.isError && (
        <p role="alert" className="text-xs font-semibold text-danger">
          {deleteWeek.error instanceof Error ? deleteWeek.error.message : 'Không thể xóa dữ liệu tuần.'}
        </p>
      )}
    </div>
  )
}
