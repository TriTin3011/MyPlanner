import { ArrowDown, ArrowUp, RotateCcw } from 'lucide-react'
import { Modal } from '../../components/Modal'
import { DEFAULT_TODAY_LAYOUT, type TodayBlockId, useSettings } from '../../store/settings'
import { normalizeTodayLayout, TODAY_BLOCK_LABELS } from './todayLayout'

// Modal "Sắp xếp khối" (SPEC §6.1). Đổi thứ tự bằng nút lên/xuống (dùng được bằng chuột, chạm và bàn phím,
// không cần kéo thả trong modal nhỏ) và ẩn/hiện từng khối. Mỗi thay đổi lưu ngay vào Zustand (persist
// xuống localStorage), trang Hôm nay đọc cùng store nên cập nhật tức thì phía sau modal.
export function TodayLayoutModal({ open, onClose }: { open: boolean; onClose: () => void }) {
  const stored = useSettings((s) => s.todayLayout)
  const setTodayLayout = useSettings((s) => s.setTodayLayout)
  const layout = normalizeTodayLayout(stored)

  function move(index: number, delta: -1 | 1) {
    const target = index + delta
    if (target < 0 || target >= layout.length) return
    const next = [...layout]
    ;[next[index], next[target]] = [next[target], next[index]]
    setTodayLayout(next)
  }

  function toggleHidden(id: TodayBlockId) {
    setTodayLayout(layout.map((b) => (b.id === id ? { ...b, hidden: !b.hidden } : b)))
  }

  return (
    <Modal
      open={open}
      title="Sắp xếp khối"
      onClose={onClose}
      footer={
        <div className="flex flex-wrap items-center justify-between gap-2">
          <button
            type="button"
            onClick={() => setTodayLayout(DEFAULT_TODAY_LAYOUT.map((b) => ({ ...b })))}
            className="flex min-h-11 cursor-pointer items-center gap-2 rounded-full px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
          >
            <RotateCcw size={16} aria-hidden="true" />
            Đặt lại mặc định
          </button>
          <button
            type="button"
            onClick={onClose}
            className="min-h-11 cursor-pointer rounded-full bg-primary px-5 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
          >
            Xong
          </button>
        </div>
      }
    >
      <p className="mb-3 text-sm text-ink-muted">
        Đổi thứ tự các khối trên trang Hôm nay và chọn khối nào được hiện. Cài đặt lưu trên trình duyệt này.
      </p>
      <ol className="space-y-2">
        {layout.map((block, index) => {
          const label = TODAY_BLOCK_LABELS[block.id]
          return (
            <li
              key={block.id}
              className="flex items-center gap-2 rounded-xl border border-[var(--line)] bg-surface px-2 py-1.5"
            >
              <span className="w-6 text-center text-sm font-bold text-ink-muted" aria-hidden="true">
                {index + 1}
              </span>
              <label className="flex min-h-11 flex-1 cursor-pointer items-center gap-3 font-bold">
                <input
                  type="checkbox"
                  checked={!block.hidden}
                  onChange={() => toggleHidden(block.id)}
                  className="size-5 accent-[var(--primary)]"
                />
                <span className={block.hidden ? 'text-ink-muted line-through' : undefined}>{label}</span>
              </label>
              <button
                type="button"
                onClick={() => move(index, -1)}
                disabled={index === 0}
                aria-label={`Đưa “${label}” lên trên`}
                className="grid size-11 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-30"
              >
                <ArrowUp size={17} aria-hidden="true" />
              </button>
              <button
                type="button"
                onClick={() => move(index, 1)}
                disabled={index === layout.length - 1}
                aria-label={`Đưa “${label}” xuống dưới`}
                className="grid size-11 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-30"
              >
                <ArrowDown size={17} aria-hidden="true" />
              </button>
            </li>
          )
        })}
      </ol>
    </Modal>
  )
}
