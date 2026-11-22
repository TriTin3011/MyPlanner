import {
  closestCenter,
  DndContext,
  type DragEndEvent,
  PointerSensor,
  TouchSensor,
  useSensor,
  useSensors,
} from '@dnd-kit/core'
import {
  arrayMove,
  SortableContext,
  useSortable,
  verticalListSortingStrategy,
} from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { GripVertical } from 'lucide-react'
import { type KeyboardEvent, type ReactNode, useState } from 'react'
import type { TaskDto } from '../../api/types'

interface SortableTaskListProps {
  tasks: TaskDto[]
  // Gọi với danh sách id theo thứ tự mới; trang lo optimistic update + PUT /tasks/reorder.
  onReorder: (ids: string[]) => void
  disabled?: boolean
  // Render một dòng; nhận tay nắm kéo đã gắn listener để đặt vào TaskItem.
  renderItem: (task: TaskDto, dragHandle: ReactNode) => ReactNode
}

// Danh sách kéo thả để sắp xếp Việc hôm nay (SPEC §6.3). dnd-kit tách "cảm biến" (sensor: chuột, chạm,
// bàn phím) khỏi logic sắp xếp, nên cùng một danh sách dùng được trên desktop, điện thoại và bằng phím.
export function SortableTaskList({ tasks, onReorder, disabled, renderItem }: SortableTaskListProps) {
  const sensors = useSensors(
    // Chuột: phải kéo quá 5px mới tính là kéo, để click thường vẫn là click.
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } }),
    // Chạm: giữ 200ms mới kéo, để vuốt cuộn trang không bị nhầm thành kéo.
    useSensor(TouchSensor, { activationConstraint: { delay: 200, tolerance: 5 } }),
    // Bàn phím KHÔNG dùng KeyboardSensor: trong vùng cuộn riêng (<main overflow-y-auto>) sensor đó cuộn
    // vùng chứa thay vì dịch mục. Thay vào đó tay nắm tự nghe ↑/↓ và đổi chỗ ngay một bước (moveBy).
  )
  // Thông báo cho trình đọc màn hình sau mỗi lần đổi chỗ bằng phím.
  const [announcement, setAnnouncement] = useState('')

  function moveBy(id: string, delta: -1 | 1) {
    const from = tasks.findIndex((t) => t.id === id)
    const to = from + delta
    if (from < 0 || to < 0 || to >= tasks.length) return
    onReorder(arrayMove(tasks, from, to).map((t) => t.id))
    setAnnouncement(`Đã chuyển ${titleOf(tasks, id)} tới vị trí ${to + 1} trên ${tasks.length}.`)
  }

  function handleDragEnd({ active, over }: DragEndEvent) {
    if (!over || active.id === over.id) return
    const from = tasks.findIndex((t) => t.id === active.id)
    const to = tasks.findIndex((t) => t.id === over.id)
    if (from < 0 || to < 0) return
    onReorder(arrayMove(tasks, from, to).map((t) => t.id))
  }

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={closestCenter}
      onDragEnd={handleDragEnd}
      accessibility={{
        screenReaderInstructions: {
          draggable:
            'Dùng phím mũi tên lên hoặc xuống để đổi chỗ việc này, hoặc giữ chuột / giữ ngón tay rồi kéo.',
        },
        announcements: {
          onDragStart: ({ active }) => `Đã nhấc ${titleOf(tasks, active.id)}.`,
          onDragOver: ({ active, over }) =>
            over ? `${titleOf(tasks, active.id)} đang ở vị trí ${positionOf(tasks, over.id)}.` : undefined,
          onDragEnd: ({ active, over }) =>
            over ? `Đã thả ${titleOf(tasks, active.id)} ở vị trí ${positionOf(tasks, over.id)}.` : undefined,
          onDragCancel: ({ active }) => `Đã huỷ kéo ${titleOf(tasks, active.id)}.`,
        },
      }}
    >
      <SortableContext items={tasks.map((t) => t.id)} strategy={verticalListSortingStrategy} disabled={disabled}>
        {tasks.map((task) => (
          <SortableRow
            key={task.id}
            task={task}
            disabled={disabled}
            renderItem={renderItem}
            onMove={(delta) => moveBy(task.id, delta)}
          />
        ))}
      </SortableContext>
      <p className="sr-only" aria-live="polite">
        {announcement}
      </p>
    </DndContext>
  )
}

function titleOf(tasks: TaskDto[], id: string | number) {
  return `“${tasks.find((t) => t.id === id)?.title ?? ''}”`
}

function positionOf(tasks: TaskDto[], id: string | number) {
  return `${tasks.findIndex((t) => t.id === id) + 1} trên ${tasks.length}`
}

function SortableRow({
  task,
  disabled,
  renderItem,
  onMove,
}: {
  task: TaskDto
  disabled?: boolean
  renderItem: SortableTaskListProps['renderItem']
  onMove: (delta: -1 | 1) => void
}) {
  const { attributes, listeners, setNodeRef, setActivatorNodeRef, transform, transition, isDragging } = useSortable({
    id: task.id,
    disabled,
  })

  // Chỉ tay nắm mới bắt sự kiện kéo (setActivatorNodeRef + listeners), để bấm checkbox, sửa tên, mở menu
  // trong dòng không vô tình khởi động kéo. touch-action: none để trình duyệt di động không cuộn khi kéo.
  // Bàn phím: ↑/↓ trên tay nắm đổi chỗ một bước. Không dùng KeyboardSensor (xem SortableTaskList).
  function handleKeyDown(e: KeyboardEvent<HTMLButtonElement>) {
    if (e.key !== 'ArrowUp' && e.key !== 'ArrowDown') return
    e.preventDefault() // không để mũi tên cuộn vùng <main>
    onMove(e.key === 'ArrowUp' ? -1 : 1)
  }

  const handle = (
    <button
      type="button"
      ref={setActivatorNodeRef}
      {...attributes}
      {...listeners}
      onKeyDown={handleKeyDown}
      aria-keyshortcuts="ArrowUp ArrowDown"
      aria-label={`Kéo để sắp xếp “${task.title}”`}
      disabled={disabled}
      className="grid size-11 shrink-0 cursor-grab touch-none place-items-center self-start rounded-lg text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none active:cursor-grabbing disabled:cursor-not-allowed disabled:opacity-40 md:size-9"
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
      {renderItem(task, handle)}
    </div>
  )
}
