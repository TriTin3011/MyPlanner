import { useEffect } from 'react'
import { useQuery } from '@tanstack/react-query'
import { api, ApiError } from '../../api/client'
import { keys } from '../../api/keys'
import type { FocusBoardDto, FocusSessionDto } from '../../api/types'
import { queryClient } from '../../app/queryClient'
import i18n from '../../i18n'
import { notifyText } from '../pomodoro/notify'
import { openingEndsAt } from './focusSession'
import { useFocus } from './store'

// Luồng: FocusPage → useFocusBoard → axios GET /api/dashboard/focus → FocusController → FocusService
// → FocusRepository (EF Core) → Postgres, rồi FocusBoard.Build (Core) tính dải số, kệ, mở khoá.
export async function getFocusBoard(today: string) {
  const { data } = await api.get<FocusBoardDto>('/dashboard/focus', { params: { today } })
  return data
}

export function useFocusBoard(today: string) {
  return useQuery({ queryKey: keys.dashboard.focus(today), queryFn: () => getFocusBoard(today) })
}

export async function postFocusSession(body: FocusSessionDto) {
  const { data } = await api.post<FocusSessionDto>('/focus/sessions', body)
  return data
}

// Gửi lần lượt hàng đợi. Cờ module-level: hai lần gọi gần nhau (ticker và sự kiện online) không gửi song song.
let flushing = false
export async function flushFocusQueue() {
  if (flushing) return
  flushing = true
  let sent = false
  try {
    for (const item of [...useFocus.getState().queue]) {
      try {
        await postFocusSession(item)
        useFocus.getState().dequeue(item.id)
        sent = true
      } catch (error) {
        // Không có mã HTTP = chưa tới được server: giữ lại, lần sau gửi tiếp.
        const status = error instanceof ApiError ? error.status : undefined
        if (status === undefined || status === 401 || status >= 500) break
        // 4xx khác (dữ liệu sai, khoá chưa mở): gửi lại cũng sai, bỏ để hàng đợi không kẹt.
        useFocus.getState().dequeue(item.id)
      }
    }
  } finally {
    flushing = false
  }
  if (sent) {
    void queryClient.invalidateQueries({ queryKey: keys.dashboard.all })
    void queryClient.invalidateQueries({ queryKey: keys.stats.all })
  }
}

// Gắn ở AppShell: phiên vẫn được tính và báo khi đang ở trang khác.
export function useFocusTicker() {
  const run = useFocus((s) => s.run)
  const pending = useFocus((s) => s.queue.length)

  useEffect(() => {
    if (!run || run.outcome !== null) return
    const tick = () => {
      const { run: current, startGrowing, complete } = useFocus.getState()
      if (!current || current.outcome !== null) return
      const now = Date.now()
      if (current.startedAt === null) {
        const end = openingEndsAt(current)
        if (now >= end) startGrowing(end)
        return
      }
      if (current.endsAt !== null && now >= current.endsAt) {
        complete()
        notifyText(i18n.t('focus.notify.title'), i18n.t('focus.notify.body'))
        void flushFocusQueue()
      }
    }
    tick()
    const id = setInterval(tick, 500)
    return () => clearInterval(id)
  }, [run])

  useEffect(() => {
    if (pending === 0) return
    void flushFocusQueue()
    const retry = () => void flushFocusQueue()
    window.addEventListener('online', retry)
    const id = setInterval(retry, 60_000)
    return () => {
      window.removeEventListener('online', retry)
      clearInterval(id)
    }
  }, [pending])
}
