import { Download, LoaderCircle, X } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useSettings } from '../store/settings'
import { exportBackupData, isBackupOverdue } from '../lib/backup'

// Thanh thông báo hệ thống trên cùng (SPEC §3.2, §14.3).
// Hiện nhắc nhở khi chưa từng sao lưu hoặc lần xuất gần nhất đã quá 7 ngày; đóng chỉ ẩn trong phiên hiện tại.
export function TopBanner() {
  const { t } = useTranslation()
  const lastExportAt = useSettings((s) => s.lastExportAt ?? s.lastBackupAt)
  const [dismissed, setDismissed] = useState(false)
  const [exporting, setExporting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  if (dismissed || !isBackupOverdue(lastExportAt)) {
    return null
  }

  async function handleExport() {
    if (exporting) return
    setExporting(true)
    setError(null)
    try {
      await exportBackupData()
    } catch (err) {
      setError(err instanceof Error && err.message ? err.message : t('backup.exportError'))
    } finally {
      setExporting(false)
    }
  }

  return (
    <div
      role="region"
      aria-label={t('backup.label')}
      className="flex flex-wrap items-center justify-between gap-2 border-b-2 border-ink bg-primary px-3 py-1.5 text-xs font-semibold text-white md:px-5"
    >
      <div className="flex min-w-0 flex-1 flex-wrap items-center gap-x-3 gap-y-1">
        <span>{t('backup.bannerReminder')}</span>
        {error && (
          <span role="alert" className="rounded bg-[var(--danger-bg)] px-2 py-0.5 font-bold text-danger">
            {error}
          </span>
        )}
      </div>

      <div className="flex shrink-0 items-center gap-1.5">
        <button
          type="button"
          onClick={handleExport}
          disabled={exporting}
          className="flex min-h-9 cursor-pointer items-center gap-1.5 rounded-xl border border-white/80 bg-white/15 px-3 py-1 text-xs font-bold text-white hover:bg-white/25 focus-visible:ring-2 focus-visible:ring-white focus-visible:outline-none disabled:cursor-wait disabled:opacity-60"
        >
          {exporting ? (
            <LoaderCircle size={14} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
          ) : (
            <Download size={14} aria-hidden="true" />
          )}
          {exporting ? t('backup.exporting') : t('backup.exportNow')}
        </button>

        <button
          type="button"
          onClick={() => setDismissed(true)}
          aria-label={t('backup.dismissBanner')}
          className="grid size-9 cursor-pointer place-items-center rounded-xl text-white hover:bg-white/20 focus-visible:ring-2 focus-visible:ring-white focus-visible:outline-none"
        >
          <X size={16} aria-hidden="true" />
        </button>
      </div>
    </div>
  )
}
