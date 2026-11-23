import {
  closestCenter,
  DndContext,
  type DragEndEvent,
  PointerSensor,
  TouchSensor,
  useSensor,
  useSensors,
} from '@dnd-kit/core'
import { SortableContext, useSortable, verticalListSortingStrategy } from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { Eye, EyeOff, GripVertical } from 'lucide-react'
import { type KeyboardEvent, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Modal } from '../../components/Modal'
import { DEFAULT_TODAY_LAYOUT, type TodayBlockId, useSettings } from '../../store/settings'
import { moveTodayBlock, normalizeTodayLayout } from './todayLayout'

// Modal "Sắp xếp khối" (SPEC §6.1). Giữ tay nắm 6 chấm rồi kéo lên/xuống, hoặc dùng phím ↑/↓ trên tay nắm.
// Mỗi thay đổi lưu ngay vào Zustand (persist xuống localStorage), trang Hôm nay phía sau đổi theo tức thì.
export function TodayLayoutModal({ open, onClose }: { open: boolean; onClose: () => void }) {
  const { t } = useTranslation()
  const stored = useSettings((s) => s.todayLayout)
  const setTodayLayout = useSettings((s) => s.setTodayLayout)
  const layout = normalizeTodayLayout(stored)
  const [announcement, setAnnouncement] = useState('')
  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 4 } }),
    useSensor(TouchSensor, { activationConstraint: { delay: 150, tolerance: 5 } }),
  )

  function move(from: number, to: number) {
    const next = moveTodayBlock(layout, from, to)
    if (next === layout) return
    setTodayLayout(next)
    setAnnouncement(
      t('today.layoutModal.moved', {
        label: t(`today.blocks.${next[to].id}`),
        position: to + 1,
        total: next.length,
      }),
    )
  }

  function handleDragEnd({ active, over }: DragEndEvent) {
    if (!over || active.id === over.id) return
    move(
      layout.findIndex((b) => b.id === active.id),
      layout.findIndex((b) => b.id === over.id),
    )
  }

  function toggleHidden(id: TodayBlockId) {
    setTodayLayout(layout.map((b) => (b.id === id ? { ...b, hidden: !b.hidden } : b)))
  }

  return (
    <Modal
      open={open}
      title={t('today.layoutModal.title')}
      onClose={onClose}
      footer={
        <div className="flex flex-wrap items-center justify-between gap-2">
          <button
            type="button"
            onClick={() => setTodayLayout(DEFAULT_TODAY_LAYOUT.map((b) => ({ ...b })))}
            className="min-h-11 cursor-pointer rounded-xl px-2 text-sm font-bold text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
          >
            {t('today.layoutModal.resetDefault')}
          </button>
          <button
            type="button"
            onClick={onClose}
            className="min-h-11 cursor-pointer rounded-xl border-2 border-ink bg-primary px-5 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
          >
            {t('common.done')}
          </button>
        </div>
      }
    >
      <p className="mb-2 text-sm text-ink-muted">{t('today.layoutModal.description')}</p>
      <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
        <SortableContext items={layout.map((b) => b.id)} strategy={verticalListSortingStrategy}>
          <ol className="divide-y-2 divide-dashed divide-[var(--grid-line)]">
            {layout.map((block, index) => (
              <BlockRow
                key={block.id}
                id={block.id}
                index={index}
                hidden={block.hidden}
                onMove={(delta) => move(index, index + delta)}
                onToggle={() => toggleHidden(block.id)}
              />
            ))}
          </ol>
        </SortableContext>
      </DndContext>
      <p className="sr-only" aria-live="polite">
        {announcement}
      </p>
    </Modal>
  )
}

function BlockRow({
  id,
  index,
  hidden,
  onMove,
  onToggle,
}: {
  id: TodayBlockId
  index: number
  hidden: boolean
  onMove: (delta: -1 | 1) => void
  onToggle: () => void
}) {
  const { t } = useTranslation()
  const label = t(`today.blocks.${id}`)
  const { attributes, listeners, setNodeRef, setActivatorNodeRef, transform, transition, isDragging } = useSortable({ id })

  function handleKeyDown(event: KeyboardEvent<HTMLButtonElement>) {
    if (event.key !== 'ArrowUp' && event.key !== 'ArrowDown') return
    event.preventDefault()
    onMove(event.key === 'ArrowUp' ? -1 : 1)
  }

  return (
    <li
      ref={setNodeRef}
      style={{ transform: CSS.Translate.toString(transform), transition }}
      className={`flex items-center gap-2 bg-surface py-1.5 ${isDragging ? 'relative z-10 rounded-xl opacity-90 shadow-lg' : ''}`}
    >
      <span className="w-6 shrink-0 text-center font-bold text-ink-muted" aria-hidden="true">
        {index + 1}
      </span>
      <div className={`min-w-0 flex-1 ${hidden ? 'opacity-50' : ''}`}>
        <p className={`font-display text-base leading-tight font-extrabold ${hidden ? 'line-through' : ''}`}>{label}</p>
        <p className="text-xs text-ink-muted">{t(`today.layoutModal.hints.${id}`)}</p>
      </div>
      <button
        type="button"
        aria-pressed={!hidden}
        aria-label={t('today.layoutModal.show', { label })}
        title={t('today.layoutModal.show', { label })}
        onClick={onToggle}
        className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
      >
        {hidden ? <EyeOff size={17} aria-hidden="true" /> : <Eye size={17} aria-hidden="true" />}
      </button>
      <button
        type="button"
        ref={setActivatorNodeRef}
        {...attributes}
        {...listeners}
        onKeyDown={handleKeyDown}
        aria-keyshortcuts="ArrowUp ArrowDown"
        aria-label={t('today.layoutModal.dragHandle', { label })}
        className="grid size-11 shrink-0 cursor-grab touch-none place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none active:cursor-grabbing"
      >
        <GripVertical size={20} aria-hidden="true" />
      </button>
    </li>
  )
}
