interface EmptyStateProps {
  text: string
}

/** Trạng thái trống dùng chung (SPEC §5): một dòng hướng dẫn, màu theo theme đang chọn. */
export function EmptyState({ text }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center py-4 text-center">
      <p className="max-w-xs text-sm font-medium text-ink-muted">{text}</p>
    </div>
  )
}
