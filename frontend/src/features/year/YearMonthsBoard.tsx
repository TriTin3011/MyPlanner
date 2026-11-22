import {
  type CollisionDetection,
  closestCorners,
  DndContext,
  type DragEndEvent,
  type DragOverEvent,
  MouseSensor,
  pointerWithin,
  TouchSensor,
  type UniqueIdentifier,
  useDroppable,
  useSensor,
  useSensors,
} from '@dnd-kit/core'
import { arrayMove, SortableContext, useSortable, verticalListSortingStrategy } from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { ChevronDown, Flag, GripVertical, X } from 'lucide-react'
import { type KeyboardEvent, type ReactNode, useId, useState } from 'react'
import type { YearMonthDto, YearPlanItemDto } from '../../api/types'
import { AddTaskInput } from '../../components/AddTaskInput'
import { DeadlineRow } from '../week/DayColumn'

type Columns = Record<number, string[]>

interface YearMonthsBoardProps {
  months: YearMonthDto[]
  // Tháng hiện tại (1–12) nếu đang xem năm nay; null nếu năm khác. Tháng này mở sẵn và có nhãn "Nay".
  currentMonth: number | null
  onReorder: (input: { month: number; ids: string[] }) => void
  onToggle: (item: YearPlanItemDto, done: boolean) => void
  onDelete: (item: YearPlanItemDto) => void
  addPendingMonth?: number
  onAdd: (month: number, title: string) => Promise<void>
}

const COLUMN_PREFIX = 'month:'

// Lưới 12 thẻ tháng có kéo thả giữa các tháng (SPEC §10.4). Cùng mẫu "nhiều vùng chứa" với WeekDaysBoard:
// một DndContext, mỗi tháng một SortableContext + một vùng thả cho cả thẻ (kể cả thẻ đang thu gọn).
export function YearMonthsBoard({
  months,
  currentMonth,
  onReorder,
  onToggle,
  onDelete,
  addPendingMonth,
  onAdd,
}: YearMonthsBoardProps) {
  const sensors = useSensors(
    useSensor(MouseSensor, { activationConstraint: { distance: 5 } }),
    useSensor(TouchSensor, { activationConstraint: { delay: 200, tolerance: 5 } }),
  )
  // Thẻ nào đang mở là trạng thái giao diện thuần. Mặc định chỉ mở tháng hiện tại.
  const [open, setOpen] = useState<Set<number>>(() => new Set(currentMonth ? [currentMonth] : []))
  const [draft, setDraft] = useState<Columns | null>(null)
  const [dragging, setDragging] = useState(false)
  const [announcement, setAnnouncement] = useState('')

  // Props đổi (cache đã sửa optimistic) thì bỏ bản nháp kéo thả, giống WeekDaysBoard.
  const [seenMonths, setSeenMonths] = useState(months)
  if (seenMonths !== months) {
    setSeenMonths(months)
    if (!dragging) setDraft(null)
  }

  const fromProps: Columns = Object.fromEntries(months.map((m) => [m.month, m.items.map((it) => it.id)]))
  const columns = draft ?? fromProps
  const itemById = new Map(months.flatMap((m) => m.items).map((it) => [it.id, it]))

  function containerOf(id: UniqueIdentifier, cols: Columns) {
    const key = String(id)
    if (key.startsWith(COLUMN_PREFIX)) return Number(key.slice(COLUMN_PREFIX.length))
    const found = months.find((m) => cols[m.month]?.includes(key))
    return found?.month
  }

  function titleOf(id: UniqueIdentifier) {
    return `“${itemById.get(String(id))?.title ?? ''}”`
  }

  function toggleOpen(month: number) {
    setOpen((prev) => {
      const next = new Set(prev)
      if (next.has(month)) next.delete(month)
      else next.add(month)
      return next
    })
  }

  // Chỉ "mở chỗ" trong thẻ đang mở. Thẻ thu gọn không hiện danh sách, thả vào đó thì nối vào cuối (xem dragEnd).
  function handleDragOver({ active, over }: DragOverEvent) {
    if (!over || !draft) return
    const from = containerOf(active.id, draft)
    const to = containerOf(over.id, draft)
    if (!from || !to || from === to || !open.has(to)) return
    const id = String(active.id)
    const target = draft[to]
    const overIndex = target.indexOf(String(over.id))
    const insertAt = overIndex >= 0 ? overIndex : target.length
    setDraft({
      ...draft,
      [from]: draft[from].filter((x) => x !== id),
      [to]: [...target.slice(0, insertAt), id, ...target.slice(insertAt)],
    })
  }

  function handleDragEnd({ active, over }: DragEndEvent) {
    setDragging(false)
    const id = String(active.id)
    const current = draft
    const originalMonth = containerOf(id, fromProps)
    if (!over || !current || !originalMonth) {
      setDraft(null)
      return
    }
    let month = containerOf(id, current)
    const overMonth = containerOf(over.id, current)
    let ids: string[]
    if (overMonth && month && overMonth !== month) {
      // Thả lên thẻ đang thu gọn: chuyển sang cuối tháng đó.
      ids = [...current[overMonth].filter((x) => x !== id), id]
      month = overMonth
    } else if (month) {
      ids = current[month]
      const from = ids.indexOf(id)
      const to = ids.indexOf(String(over.id))
      if (to >= 0 && from !== to) ids = arrayMove(ids, from, to)
    } else {
      setDraft(null)
      return
    }

    if (month === originalMonth && ids.join() === fromProps[month].join()) {
      setDraft(null)
      return
    }
    // Gỡ id khỏi mọi tháng khác (nó có thể đã "ghé" một thẻ mở khác trong lúc kéo) rồi đặt vào tháng đích.
    const cleaned: Columns = Object.fromEntries(
      Object.entries(current).map(([k, list]) => [k, list.filter((x) => x !== id)]),
    )
    setDraft({ ...cleaned, [month]: ids })
    onReorder({ month, ids })
  }

  // Bàn phím trên tay nắm: ↑/↓ đổi chỗ trong tháng, ←/→ chuyển sang cuối tháng trước/sau.
  function moveWithKeys(id: string, key: string) {
    const month = containerOf(id, fromProps)
    if (!month) return
    const ids = fromProps[month]
    const index = ids.indexOf(id)
    if (key === 'ArrowUp' || key === 'ArrowDown') {
      const next = index + (key === 'ArrowUp' ? -1 : 1)
      if (next < 0 || next >= ids.length) return
      onReorder({ month, ids: arrayMove(ids, index, next) })
      setAnnouncement(`Đã chuyển ${titleOf(id)} tới vị trí ${next + 1} trên ${ids.length}.`)
      return
    }
    const target = month + (key === 'ArrowLeft' ? -1 : 1)
    if (target < 1 || target > 12) return
    onReorder({ month: target, ids: [...fromProps[target], id] })
    setAnnouncement(`Đã chuyển ${titleOf(id)} sang tháng ${target}.`)
  }

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={collision}
      onDragStart={() => {
        setDragging(true)
        setDraft(fromProps)
      }}
      onDragOver={handleDragOver}
      onDragEnd={handleDragEnd}
      onDragCancel={() => {
        setDragging(false)
        setDraft(null)
      }}
      accessibility={{
        screenReaderInstructions: {
          draggable:
            'Phím lên hoặc xuống để đổi chỗ trong tháng, trái hoặc phải để chuyển sang tháng bên cạnh. Hoặc giữ chuột / giữ ngón tay rồi kéo.',
        },
        announcements: {
          onDragStart: ({ active }) => `Đã nhấc ${titleOf(active.id)}.`,
          onDragOver: () => undefined,
          onDragEnd: ({ active, over }) => (over ? `Đã thả ${titleOf(active.id)}.` : undefined),
          onDragCancel: ({ active }) => `Đã huỷ kéo ${titleOf(active.id)}.`,
        },
      }}
    >
      {/* items-start: thẻ mở cao hơn thì các thẻ hàng dưới tự dời xuống. grid-flow-dense lấp ô trống. */}
      <ul className="grid grid-flow-dense grid-cols-2 items-start gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6">
        {months.map((m) => (
          <MonthCard
            key={m.month}
            month={m}
            isCurrent={m.month === currentMonth}
            isOpen={open.has(m.month)}
            onToggleOpen={() => toggleOpen(m.month)}
            itemCount={columns[m.month].length}
            addPending={addPendingMonth === m.month}
            onAdd={(title) => onAdd(m.month, title)}
          >
            <SortableContext id={String(m.month)} items={columns[m.month]} strategy={verticalListSortingStrategy}>
              <ul className="divide-y divide-[var(--line)]/50">
                {columns[m.month].map((id) => {
                  const item = itemById.get(id)
                  return item ? (
                    <SortableItem
                      key={id}
                      item={item}
                      onToggle={onToggle}
                      onDelete={onDelete}
                      onKey={(key) => moveWithKeys(id, key)}
                    />
                  ) : null
                })}
              </ul>
            </SortableContext>
          </MonthCard>
        ))}
      </ul>
      <p className="sr-only" aria-live="polite">
        {announcement}
      </p>
    </DndContext>
  )
}

const collision: CollisionDetection = (args) => {
  const hits = pointerWithin(args)
  return hits.length > 0 ? hits : closestCorners(args)
}

interface MonthCardProps {
  month: YearMonthDto
  isCurrent: boolean
  isOpen: boolean
  onToggleOpen: () => void
  itemCount: number
  addPending: boolean
  onAdd: (title: string) => Promise<void>
  children: ReactNode
}

// Một thẻ tháng. Cả thẻ là vùng thả "month:<n>" để kéo được vào thẻ đang thu gọn.
// Số x/y, % và cờ ⚑ k lấy từ YearMonthDto (BE đếm), không đếm lại từ danh sách.
function MonthCard({ month, isCurrent, isOpen, onToggleOpen, itemCount, addPending, onAdd, children }: MonthCardProps) {
  const { setNodeRef, isOver } = useDroppable({ id: `${COLUMN_PREFIX}${month.month}` })
  const bodyId = useId()
  const deadlineCount = month.deadlines.length
  const overdue = month.deadlines.some((d) => d.overdue)

  return (
    <li
      ref={setNodeRef}
      data-month={month.month}
      className={`sketch bg-[var(--surface)] px-3 py-2 transition-colors ${
        isOpen ? 'col-span-2' : ''
      } ${isOver && !isOpen ? 'bg-accent-tint' : ''}`}
    >
      <h3>
        <button
          type="button"
          onClick={onToggleOpen}
          aria-expanded={isOpen}
          aria-controls={bodyId}
          className="flex min-h-11 w-full cursor-pointer items-center gap-2 rounded-lg text-left md:min-h-8 focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
        >
          <span className="font-display font-extrabold text-ink">Tháng {month.month}</span>
          {isCurrent && (
            <span className="rounded-full bg-primary px-2 py-0.5 text-[11px] font-extrabold text-white">Nay</span>
          )}
          <ChevronDown
            size={16}
            aria-hidden="true"
            className={`ml-auto text-ink-muted transition-transform motion-reduce:transition-none ${isOpen ? 'rotate-180' : ''}`}
          />
        </button>
      </h3>

      <div className="mt-1 flex items-center gap-2">
        <div
          role="progressbar"
          aria-label={`Tiến độ tháng ${month.month}`}
          aria-valuemin={0}
          aria-valuemax={100}
          aria-valuenow={month.percent}
          className="h-1.5 flex-1 overflow-hidden rounded-full bg-[var(--line)]/40"
        >
          <div className="h-full rounded-full bg-primary" style={{ width: `${month.percent}%` }} />
        </div>
        <span className="text-xs font-bold text-ink-muted tabular-nums">
          {month.done}/{month.total}
        </span>
        {deadlineCount > 0 && (
          <span
            title={`${deadlineCount} hạn trong tháng`}
            className={`flex items-center gap-0.5 text-xs font-extrabold ${overdue ? 'text-danger' : 'text-primary-ink'}`}
          >
            <Flag size={12} aria-hidden="true" />
            {deadlineCount}
            <span className="sr-only"> hạn trong tháng</span>
          </span>
        )}
      </div>

      <div id={bodyId} hidden={!isOpen} className="mt-3">
        {isOpen && (
          <>
            {deadlineCount > 0 && <ul className="mb-2 space-y-1.5">{month.deadlines.map((d) => <DeadlineRow key={`${d.kind}-${d.goalId}-${d.title}-${d.date}`} deadline={d} />)}</ul>}
            {children}
            {itemCount === 0 && deadlineCount === 0 && (
              <p className="py-2 text-sm text-ink-muted">Chưa có kế hoạch cho tháng này.</p>
            )}
            <AddTaskInput pending={addPending} onAdd={onAdd} placeholder="Thêm kế hoạch…" />
          </>
        )}
      </div>
    </li>
  )
}

const ARROW_KEYS = ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight']

function SortableItem({
  item,
  onToggle,
  onDelete,
  onKey,
}: {
  item: YearPlanItemDto
  onToggle: (item: YearPlanItemDto, done: boolean) => void
  onDelete: (item: YearPlanItemDto) => void
  onKey: (key: string) => void
}) {
  const { attributes, listeners, setNodeRef, setActivatorNodeRef, transform, transition, isDragging } = useSortable({
    id: item.id,
  })
  const checkboxId = useId()

  function handleKeyDown(e: KeyboardEvent<HTMLButtonElement>) {
    if (!ARROW_KEYS.includes(e.key)) return
    e.preventDefault()
    onKey(e.key)
  }

  return (
    <li
      ref={setNodeRef}
      style={{ transform: CSS.Translate.toString(transform), transition }}
      className={`flex items-center gap-1 ${isDragging ? 'relative z-10 rounded-xl bg-surface opacity-90 shadow-lg' : ''}`}
    >
      <input
        id={checkboxId}
        type="checkbox"
        checked={item.done}
        onChange={(e) => onToggle(item, e.target.checked)}
        className="size-5 shrink-0 cursor-pointer accent-[var(--primary)]"
      />
      <label
        htmlFor={checkboxId}
        className={`min-h-11 min-w-0 flex-1 cursor-pointer content-center px-2 text-sm md:min-h-9 break-words ${
          item.done ? 'text-ink-muted line-through' : 'text-ink'
        }`}
      >
        {item.title}
      </label>
      <button
        type="button"
        onClick={() => onDelete(item)}
        aria-label={`Xoá “${item.title}”`}
        className="grid size-11 shrink-0 cursor-pointer place-items-center rounded-lg text-ink-muted md:size-8 hover:bg-[var(--danger-bg)] hover:text-danger focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
      >
        <X size={15} aria-hidden="true" />
      </button>
      <button
        type="button"
        ref={setActivatorNodeRef}
        {...attributes}
        {...listeners}
        onKeyDown={handleKeyDown}
        aria-keyshortcuts="ArrowUp ArrowDown ArrowLeft ArrowRight"
        aria-label={`Kéo để sắp xếp hoặc chuyển tháng “${item.title}”`}
        className="grid size-11 shrink-0 cursor-grab md:size-8 touch-none place-items-center rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none active:cursor-grabbing"
      >
        <GripVertical size={16} aria-hidden="true" />
      </button>
    </li>
  )
}
