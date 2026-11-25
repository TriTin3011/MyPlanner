import type { GoalCardDto } from '../../api/types'
import { EmptyState } from '../../components/EmptyState'
import { GoalCard } from './GoalCard'
import type { AreaRef } from './lifeAreas'

export interface GoalCardGridProps {
  goals: GoalCardDto[]
  onOpen(id: string): void
  onToggleDone(id: string, done: boolean): void
  emptyText: string
  // Lĩnh vực của tài khoản (board.areas) để thẻ hiện tên lĩnh vực theo areaId.
  areas?: AreaRef[]
}

// Lưới hiển thị các thẻ mục tiêu: 1 cột trên mobile, 2 cột trên md, 3 cột trên xl (SPEC §7.4).
// Thứ tự do backend sắp sẵn (chưa xong theo hạn gần nhất trước, đã xong ở cuối).
export function GoalCardGrid({ goals, onOpen, onToggleDone, emptyText, areas = [] }: GoalCardGridProps) {
  const byId = new Map(areas.map((a) => [a.id, a]))
  if (goals.length === 0) {
    return (
      <div className="rounded-2xl border-2 border-dashed border-line bg-surface/60 px-4 py-4">
        <EmptyState text={emptyText} />
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-3">
      {goals.map((goal) => (
        <GoalCard
          key={goal.id}
          goal={goal}
          area={byId.get(goal.areaId)}
          onOpen={onOpen}
          onToggleDone={onToggleDone}
        />
      ))}
    </div>
  )
}
