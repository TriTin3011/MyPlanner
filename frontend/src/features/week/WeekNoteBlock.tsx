import { NoteCollapsible } from '../../components/NoteCollapsible'
import { useSaveWeekNote, useWeekNote } from './weekExtrasHooks'

export function WeekNoteBlock({ weekKey }: { weekKey: string }) {
  const note = useWeekNote(weekKey)
  const saveNote = useSaveWeekNote()

  if (note.isPending) {
    return (
      <div className="sketch min-h-20 bg-[var(--surface)] px-4 py-3">
        <p role="status" className="text-sm text-ink-muted">
          Đang tải ghi chú tuần…
        </p>
      </div>
    )
  }

  if (note.isError) {
    return (
      <div className="sketch min-h-20 bg-[var(--surface)] px-4 py-3">
        <p role="alert" className="text-sm font-semibold text-danger">
          {note.error instanceof Error ? note.error.message : 'Không tải được ghi chú tuần.'}
        </p>
      </div>
    )
  }

  return (
    <section
      aria-label="Ghi chú tuần"
      className="sketch bg-[var(--surface)] px-4 pb-4 [&>div]:mt-0 [&>div]:border-t-0 [&>div]:pt-4 [&_button]:min-h-11"
    >
      <NoteCollapsible
        key={weekKey}
        label="Ghi chú tuần"
        placeholder="Bấm để ghi"
        textareaPlaceholder="Viết ghi chú cho tuần này…"
        initialContent={note.data.content}
        onSave={(content) => saveNote.mutateAsync({ weekKey, content }).then(() => undefined)}
      />
    </section>
  )
}
