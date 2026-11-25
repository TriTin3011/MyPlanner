import { api } from '../api/client'
import type { BackupDto, ImportResultDto } from '../api/types'
import { toLocalDateKey } from './dates'

// Tạo tên file sao lưu chuẩn mam-backup-YYYY-MM-DD.json theo ngày địa phương.
export function getBackupFilename(now = new Date()): string {
  return `mam-backup-${toLocalDateKey(now)}.json`
}

// Kích hoạt tải file JSON trên trình duyệt bằng Blob + Object URL.
export function triggerJsonDownload(data: BackupDto, filename: string) {
  const json = JSON.stringify(data, null, 2)
  const blob = new Blob([json], { type: 'application/json' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  link.remove()
  URL.revokeObjectURL(url)
}

// Gọi GET /api/export rồi tải file mam-backup-YYYY-MM-DD.json.
export async function exportBackupData(): Promise<BackupDto> {
  const response = await api.get<BackupDto>('/export')
  triggerJsonDownload(response.data, getBackupFilename())
  return response.data
}

// Gọi POST /api/import để ghi đè toàn bộ dữ liệu từ bản sao lưu.
export async function importBackupData(backup: BackupDto): Promise<ImportResultDto> {
  const response = await api.post<ImportResultDto>('/import', backup)
  return response.data
}
