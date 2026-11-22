import type { TFunction } from 'i18next'
import type { TaskTag } from '../api/types'

// Nhãn và màu của tag (SPEC §12.1). Dùng chung cho TaskItem, khối Việc còn tồn, menu ⋯ và modal Việc lặp lại.
export const TASK_TAG_CLASSES: Record<TaskTag, string> = {
  urgent: 'bg-[var(--tag-urgent-bg)] text-[var(--tag-urgent-ink)]',
  important: 'bg-[var(--tag-important-bg)] text-[var(--tag-important-ink)]',
}

export function getTaskTags(t: TFunction): Record<TaskTag, { label: string; className: string }> {
  return {
    urgent: {
      label: t('common.tags.urgent'),
      className: TASK_TAG_CLASSES.urgent,
    },
    important: {
      label: t('common.tags.important'),
      className: TASK_TAG_CLASSES.important,
    },
  }
}

export const TAG_ORDER: TaskTag[] = ['urgent', 'important']
