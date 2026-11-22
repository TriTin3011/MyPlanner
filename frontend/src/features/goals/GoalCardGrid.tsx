import type { GoalCardDto } from '../../api/types'
import { GoalCard } from './GoalCard'

export interface GoalCardGridProps {
  goals: GoalCardDto[]
  onOpen(id: string): void
  onToggleDone(id: string, done: boolean): void
  emptyText: string
}

// Lưới hiển thị các thẻ mục tiêu: 1 cột trên mobile, 2 cột trên md, 3 cột trên xl (SPEC §7.4).
// Thứ tự do backend sắp sẵn (chưa xong theo hạn gần nhất trước, đã xong ở cuối).
export function GoalCardGrid({ goals, onOpen, onToggleDone, emptyText }: GoalCardGridProps) {
  if (goals.length === 0) {
    return (
      <div className="rounded-2xl border-2 border-dashed border-line bg-surface/60 px-4 py-10 text-center text-sm font-medium text-ink-muted">
        {emptyText}
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
      {goals.map((goal) => (
        <GoalCard key={goal.id} goal={goal} onOpen={onOpen} onToggleDone={onToggleDone} />
      ))}
    </div>
  )
}
