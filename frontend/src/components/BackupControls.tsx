import { Download, LoaderCircle, Upload } from 'lucide-react'
import { type ChangeEvent, useRef, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useQueryClient } from '@tanstack/react-query'
import type { BackupDto, ImportResultDto } from '../api/types'
import { exportBackupData, importBackupData } from '../lib/backup'
import { Modal } from './Modal'

// Cụm nút Xuất / Nhập dữ liệu sao lưu (SPEC §14.3). Dùng trong ThemePicker popover (desktop/tablet) và MobileMenu.
export function BackupControls({ compact = false }: { compact?: boolean }) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const fileInputRef = useRef<HTMLInputElement>(null)

  const [exporting, setExporting] = useState(false)
  const [importing, setImporting] = useState(false)
  const [inlineError, setInlineError] = useState<string | null>(null)
  const [modalError, setModalError] = useState<string | null>(null)
  const [pendingFile, setPendingFile] = useState<{ name: string; payload: BackupDto } | null>(null)
  const [importResult, setImportResult] = useState<ImportResultDto | null>(null)

  async function handleExport() {
    if (exporting) return
    setExporting(true)
    setInlineError(null)
    try {
      await exportBackupData()
    } catch (err) {
      setInlineError(err instanceof Error && err.message ? err.message : t('backup.exportError'))
    } finally {
      setExporting(false)
    }
  }

  async function handleFileChange(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0]
    event.target.value = ''
    if (!file) return

    setInlineError(null)
    setModalError(null)
    setImportResult(null)

    try {
      const text = await file.text()
      const parsed = JSON.parse(text) as BackupDto
      if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) {
        setInlineError(t('backup.invalidJson'))
        return
      }
      setPendingFile({ name: file.name, payload: parsed })
    } catch {
      setInlineError(t('backup.invalidJson'))
    }
  }

  async function handleConfirmImport() {
    if (!pendingFile || importing) return
    setImporting(true)
    setModalError(null)
    try {
      const result = await importBackupData(pendingFile.payload)
      await queryClient.invalidateQueries()
      setPendingFile(null)
      setImportResult(result)
    } catch (err) {
      setModalError(err instanceof Error && err.message ? err.message : t('backup.importError'))
    } finally {
      setImporting(false)
    }
  }

  function closeModal() {
    if (importing) return
    setPendingFile(null)
    setImportResult(null)
    setModalError(null)
  }

  const modalOpen = pendingFile !== null || importResult !== null

  return (
    <div className={compact ? 'flex flex-col gap-1.5' : 'flex flex-col gap-1'}>
      <button
        type="button"
        onClick={handleExport}
        disabled={exporting}
        className="flex min-h-11 w-full cursor-pointer items-center gap-2.5 rounded-full px-3 text-left text-sm font-semibold text-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:cursor-wait disabled:opacity-60"
      >
        {exporting ? (
          <LoaderCircle size={16} className="shrink-0 animate-spin motion-reduce:animate-none" aria-hidden="true" />
        ) : (
          <Download size={16} className="shrink-0 text-primary" aria-hidden="true" />
        )}
        <span className="truncate">{exporting ? t('backup.exporting') : t('backup.exportJson')}</span>
      </button>

      <button
        type="button"
        onClick={() => fileInputRef.current?.click()}
        disabled={importing}
        className="flex min-h-11 w-full cursor-pointer items-center gap-2.5 rounded-full px-3 text-left text-sm font-semibold text-ink hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:cursor-wait disabled:opacity-60"
      >
        <Upload size={16} className="shrink-0 text-primary" aria-hidden="true" />
        <span className="truncate">{t('backup.importJson')}</span>
      </button>

      <input
        ref={fileInputRef}
        type="file"
        accept=".json,application/json"
        aria-label={t('backup.importJson')}
        onChange={handleFileChange}
        className="sr-only"
      />

      {inlineError && (
        <p role="alert" className="rounded-lg bg-[var(--danger-bg)] px-2.5 py-1.5 text-xs font-bold text-danger">
          {inlineError}
        </p>
      )}

      <Modal
        open={modalOpen}
        title={importResult ? t('backup.importSuccessTitle') : t('backup.confirmTitle')}
        onClose={closeModal}
        footer={
          importResult ? (
            <div className="flex justify-end">
              <button
                type="button"
                onClick={closeModal}
                className="min-h-11 cursor-pointer rounded-full bg-primary px-5 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
              >
                {t('backup.closeModal')}
              </button>
            </div>
          ) : (
            <div className="flex flex-wrap justify-end gap-2">
              <button
                type="button"
                onClick={closeModal}
                disabled={importing}
                className="min-h-11 cursor-pointer rounded-full px-4 text-sm font-bold text-ink-muted hover:bg-accent-tint focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
              >
                {t('backup.confirmCancel')}
              </button>
              <button
                type="button"
                onClick={handleConfirmImport}
                disabled={importing}
                className="flex min-h-11 cursor-pointer items-center gap-2 rounded-full bg-danger px-4 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-danger focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-wait disabled:opacity-60"
              >
                {importing && (
                  <LoaderCircle size={15} className="animate-spin motion-reduce:animate-none" aria-hidden="true" />
                )}
                {importing ? t('backup.importing') : t('backup.confirmSubmit')}
              </button>
            </div>
          )
        }
      >
        {importResult ? (
          <p role="status" className="text-sm font-semibold text-ink">
            {t('backup.importSuccessSummary', {
              tasks: importResult.tasks,
              habits: importResult.habits,
              habitLogs: importResult.habitLogs,
              goals: importResult.goals,
            })}
          </p>
        ) : (
          <div className="space-y-3">
            <p className="text-sm font-semibold text-danger">{t('backup.confirmWarning')}</p>
            {pendingFile && (
              <p className="rounded-lg bg-accent-tint px-3 py-2 text-xs font-bold text-primary-ink">
                {t('backup.confirmFile', { name: pendingFile.name })}
              </p>
            )}
            {modalError && (
              <p role="alert" className="rounded-lg bg-[var(--danger-bg)] px-3 py-2 text-sm font-bold text-danger">
                {modalError}
              </p>
            )}
          </div>
        )}
      </Modal>
    </div>
  )
}
