import type { TaskTag } from '../api/types'

// Nhãn và màu của tag (SPEC §12.1). Dùng chung cho TaskItem, khối Việc còn tồn, menu ⋯ và modal Việc lặp lại.
export const TASK_TAGS: Record<TaskTag, { label: string; className: string }> = {
  urgent: {
    label: 'Gấp',
    className: 'bg-[var(--tag-urgent-bg)] text-[var(--tag-urgent-ink)]',
  },
  important: {
    label: 'Quan trọng',
    className: 'bg-[var(--tag-important-bg)] text-[var(--tag-important-ink)]',
  },
}

export const TAG_ORDER: TaskTag[] = ['urgent', 'important']
