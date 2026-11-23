import {
  type CollisionDetection,
  closestCorners,
  DndContext,
  type DragEndEvent,
  type DragOverEvent,
  type DragStartEvent,
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
import { GripVertical } from 'lucide-react'
import { type KeyboardEvent, type ReactNode, useLayoutEffect, useRef, useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { DeadlineDto, TaskDto } from '../../api/types'
import { formatDayMonth } from '../../lib/dates'
import { DayColumn } from './DayColumn'
import type { ArrangeDayInput } from './hooks'

type Columns = Record<string, string[]>

interface WeekDaysBoardProps {
  // 7 ngày Thứ 2 → Chủ nhật dạng YYYY-MM-DD.
  dates: string[]
  today: string
  tasksByDate: Record<string, TaskDto[]>
  deadlinesByDate: Record<string, DeadlineDto[]>
  notesByDate: Record<string, string>
  // Thứ tự mới của MỘT cột (có thể kèm việc vừa kéo từ cột khác sang). Trang gọi PUT /tasks/reorder.
  onArrange: (input: ArrangeDayInput) => void
  renderTask: (task: TaskDto, dragHandle: ReactNode) => ReactNode
  addPendingDate?: string
  onAdd: (date: string, title: string) => Promise<void>
  onSaveNote: (date: string, content: string) => Promise<void>
}

const COLUMN_PREFIX = 'col:'

// Lưới 7 cột ngày có kéo thả "nhiều vùng chứa" (multi-container): mỗi cột là một SortableContext,
// tất cả nằm trong MỘT DndContext để thẻ kéo được từ cột này sang cột khác.
// Trong lúc kéo, bảng giữ bản nháp `draft` (id theo cột) ở state cục bộ; thả tay mới báo trang một lần.
export function WeekDaysBoard({
  dates,
  today,
  tasksByDate,
  deadlinesByDate,
  notesByDate,
  onArrange,
  renderTask,
  addPendingDate,
  onAdd,
  onSaveNote,
}: WeekDaysBoardProps) {
  const { t } = useTranslation()
  const sensors = useSensors(
    // MouseSensor (không phải PointerSensor): PointerSensor cũng bắt sự kiện chạm và kích hoạt sau 5px,
    // nên trên điện thoại sẽ "cướp" thao tác trước TouchSensor (giữ 200ms) và chặn cuộn ngang.
    useSensor(MouseSensor, { activationConstraint: { distance: 5 } }),
    useSensor(TouchSensor, { activationConstraint: { delay: 200, tolerance: 5 } }),
  )
  const [draft, setDraft] = useState<Columns | null>(null)
  const [activeId, setActiveId] = useState<string | null>(null)
  const [announcement, setAnnouncement] = useState('')

  // Bản nháp chỉ cần sống tới khi dữ liệu mới (cache đã sửa optimistic) về tới props; đổi props thì bỏ nháp.
  // Đây là mẫu "chỉnh state ngay trong render" của React, thay cho useEffect.
  const [seenTasks, setSeenTasks] = useState(tasksByDate)
  if (seenTasks !== tasksByDate) {
    setSeenTasks(tasksByDate)
    if (activeId === null) setDraft(null)
  }

  const fromProps: Columns = Object.fromEntries(dates.map((d) => [d, (tasksByDate[d] ?? []).map((t) => t.id)]))
  const columns = draft ?? fromProps
  const taskById = new Map(dates.flatMap((d) => tasksByDate[d] ?? []).map((t) => [t.id, t]))

  function containerOf(id: UniqueIdentifier, cols: Columns) {
    const key = String(id)
    if (key.startsWith(COLUMN_PREFIX)) return key.slice(COLUMN_PREFIX.length)
    return dates.find((d) => cols[d]?.includes(key))
  }

  function titleOf(id: UniqueIdentifier) {
    return taskById.get(String(id))?.title ?? ''
  }

  function handleDragStart({ active }: DragStartEvent) {
    setActiveId(String(active.id))
    setDraft(fromProps)
  }

  // Kéo qua cột khác: chuyển id sang cột đó ngay trong bản nháp để cột mới "mở chỗ" cho thẻ.
  function handleDragOver({ active, over }: DragOverEvent) {
    if (!over || !draft) return
    const from = containerOf(active.id, draft)
    const to = containerOf(over.id, draft)
    if (!from || !to || from === to) return
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
    setActiveId(null)
    const id = String(active.id)
    const current = draft
    const originalDate = containerOf(id, fromProps)
    if (!over || !current || !originalDate) {
      setDraft(null)
      return
    }
    const date = containerOf(id, current)
    if (!date) {
      setDraft(null)
      return
    }
    let ids = current[date]
    const from = ids.indexOf(id)
    const to = ids.indexOf(String(over.id))
    if (to >= 0 && from !== to) ids = arrayMove(ids, from, to)

    const unchanged = date === originalDate && ids.join() === fromProps[date].join()
    if (unchanged) {
      setDraft(null)
      return
    }
    // Giữ bản nháp tới khi props đổi (xem trên) để thẻ không nháy về chỗ cũ trong một khung hình.
    setDraft({ ...current, [date]: ids })
    onArrange({ date, ids })
  }

  // Bàn phím trên tay nắm: ↑/↓ đổi chỗ trong cột, ←/→ chuyển sang cuối cột ngày trước/sau.
  function moveWithKeys(id: string, key: string) {
    const date = containerOf(id, fromProps)
    if (!date) return
    const ids = fromProps[date]
    const index = ids.indexOf(id)
    if (key === 'ArrowUp' || key === 'ArrowDown') {
      const next = index + (key === 'ArrowUp' ? -1 : 1)
      if (next < 0 || next >= ids.length) return
      onArrange({ date, ids: arrayMove(ids, index, next) })
      setAnnouncement(t('week.dnd.movedInDay', { title: titleOf(id), position: next + 1, total: ids.length }))
      return
    }
    const dayIndex = dates.indexOf(date) + (key === 'ArrowLeft' ? -1 : 1)
    if (dayIndex < 0 || dayIndex >= dates.length) return
    const target = dates[dayIndex]
    onArrange({ date: target, ids: [...fromProps[target], id] })
    setAnnouncement(t('week.dnd.movedToDay', { title: titleOf(id), date: formatDayMonth(target) }))
  }

  // Điện thoại: dải cột cuộn ngang, tự cuộn tới cột hôm nay khi mở tuần. Desktop là lưới nên không cuộn.
  const stripRef = useRef<HTMLDivElement>(null)
  useLayoutEffect(() => {
    const strip = stripRef.current
    if (!strip || strip.scrollWidth <= strip.clientWidth) return
    const column = strip.querySelector<HTMLElement>(`[data-date="${today}"]`)
    strip.scrollLeft = column ? column.offsetLeft - strip.offsetLeft : 0
  }, [dates, today])

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={collision}
      onDragStart={handleDragStart}
      onDragOver={handleDragOver}
      onDragEnd={handleDragEnd}
      onDragCancel={() => {
        setActiveId(null)
        setDraft(null)
      }}
      accessibility={{
        screenReaderInstructions: {
          draggable: t('week.dnd.instructions'),
        },
        announcements: {
          onDragStart: ({ active }) => t('week.dnd.dragStart', { title: titleOf(active.id) }),
          onDragOver: () => undefined,
          onDragEnd: ({ active, over }) => (over ? t('week.dnd.dragEnd', { title: titleOf(active.id) }) : undefined),
          onDragCancel: ({ active }) => t('week.dnd.dragCancel', { title: titleOf(active.id) }),
        },
      }}
    >
      <div
        ref={stripRef}
        className="relative -mx-4 flex snap-x snap-mandatory scroll-px-4 gap-3 overflow-x-auto px-4 pb-2 md:mx-0 md:grid md:grid-cols-2 md:items-start md:gap-4 md:overflow-visible md:px-0 md:pb-0 xl:grid-cols-3"
      >
        {dates.map((date, dayIndex) => (
          <div key={date} data-date={date} className="w-[85%] max-w-sm shrink-0 snap-start md:w-auto md:max-w-none">
            <DayColumn
              date={date}
              dayIndex={dayIndex}
              isToday={date === today}
              deadlines={deadlinesByDate[date] ?? []}
              taskCount={columns[date].length}
              addPending={addPendingDate === date}
              onAdd={(title) => onAdd(date, title)}
              noteContent={notesByDate[date] ?? ''}
              onSaveNote={(content) => onSaveNote(date, content)}
            >
              <DroppableList date={date} ids={columns[date]}>
                {columns[date].map((id) => {
                  const task = taskById.get(id)
                  return task ? (
                    <SortableRow key={id} task={task} renderTask={renderTask} onKey={(key) => moveWithKeys(id, key)} />
                  ) : null
                })}
              </DroppableList>
            </DayColumn>
          </div>
        ))}
      </div>
      <p className="sr-only" aria-live="polite">
        {announcement}
      </p>
    </DndContext>
  )
}

// Ưu tiên vùng đang nằm dưới con trỏ (chính xác khi lưới nhiều cột); ngoài mọi vùng thì lấy góc gần nhất.
const collision: CollisionDetection = (args) => {
  const hits = pointerWithin(args)
  return hits.length > 0 ? hits : closestCorners(args)
}

// Cột rỗng không có thẻ nào để "đè lên", nên cả danh sách cũng là một vùng thả (droppable) với id "col:<ngày>".
function DroppableList({ date, ids, children }: { date: string; ids: string[]; children: ReactNode }) {
  const { setNodeRef, isOver } = useDroppable({ id: `${COLUMN_PREFIX}${date}` })
  return (
    <SortableContext id={date} items={ids} strategy={verticalListSortingStrategy}>
      <div
        ref={setNodeRef}
        className={`min-h-10 rounded-lg transition-colors ${isOver && ids.length === 0 ? 'bg-accent-tint' : ''}`}
      >
        {children}
      </div>
    </SortableContext>
  )
}

const ARROW_KEYS = ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight']

function SortableRow({
  task,
  renderTask,
  onKey,
}: {
  task: TaskDto
  renderTask: WeekDaysBoardProps['renderTask']
  onKey: (key: string) => void
}) {
  const { t } = useTranslation()
  const { attributes, listeners, setNodeRef, setActivatorNodeRef, transform, transition, isDragging } = useSortable({
    id: task.id,
  })

  function handleKeyDown(e: KeyboardEvent<HTMLButtonElement>) {
    if (!ARROW_KEYS.includes(e.key)) return
    e.preventDefault()
    onKey(e.key)
  }

  const handle = (
    <button
      type="button"
      ref={setActivatorNodeRef}
      {...attributes}
      {...listeners}
      onKeyDown={handleKeyDown}
      aria-keyshortcuts="ArrowUp ArrowDown ArrowLeft ArrowRight"
      aria-label={t('week.dnd.dragHandleAria', { title: task.title })}
      className="grid size-11 shrink-0 cursor-grab touch-none place-items-center self-start rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none active:cursor-grabbing"
    >
      <GripVertical size={16} aria-hidden="true" />
    </button>
  )

  return (
    <div
      ref={setNodeRef}
      style={{ transform: CSS.Translate.toString(transform), transition }}
      className={isDragging ? 'relative z-10 rounded-xl bg-surface opacity-90 shadow-lg' : undefined}
    >
      {renderTask(task, handle)}
    </div>
  )
}
