import { describe, expect, it, vi as vitest } from 'vitest'
import { queryClient } from '../app/queryClient'
import { GOAL_STATUS_LABEL, lifeArea } from '../features/goals/lifeAreas'
import { STATS_RANGES, weekdayLabel } from '../features/stats/statsFormat'
import { useSettings } from '../store/settings'
import { en } from './en'
import i18n from './index'
import { detectLanguage } from './languages'
import { vi } from './vi'

describe('detectLanguage', () => {
  it('lấy ngôn ngữ đầu tiên app hỗ trợ trong danh sách ưu tiên của trình duyệt', () => {
    expect(detectLanguage(['fr-FR', 'en-US', 'vi'])).toBe('en')
    expect(detectLanguage(['vi-VN', 'en'])).toBe('vi')
  })

  it('không khớp ngôn ngữ nào thì về tiếng Việt', () => {
    expect(detectLanguage(['ja-JP'])).toBe('vi')
    expect(detectLanguage([])).toBe('vi')
  })
})

// Khoá phẳng hoá "nav.today.label"... để so hai bản dịch. TypeScript đã chặn lúc biên dịch,
// test này giữ thêm một lớp khi ai đó ép kiểu hoặc sửa file bằng công cụ khác.
function flatKeys(obj: object, prefix = ''): string[] {
  return Object.entries(obj).flatMap(([k, v]) =>
    typeof v === 'string' ? [`${prefix}${k}`] : flatKeys(v as object, `${prefix}${k}.`),
  )
}

describe('bản dịch', () => {
  it('en có đúng các khoá của vi và không có chuỗi rỗng', () => {
    expect(flatKeys(en).sort()).toEqual(flatKeys(vi).sort())
    expect(JSON.stringify(en)).not.toContain('""')
  })

  it('đổi ngôn ngữ trong settings đồng bộ i18next, nhãn động và invalidate cache dashboard', () => {
    const spy = vitest.spyOn(queryClient, 'invalidateQueries')
    try {
      useSettings.getState().setLanguage('en')
      expect(i18n.language).toBe('en')
      expect(lifeArea('health').label).toBe('Health & Wellness')
      expect(GOAL_STATUS_LABEL.in_progress).toBe('In progress')
      expect(STATS_RANGES[0].label).toBe('4 weeks')
      expect(weekdayLabel(1, true)).toBe('Mon')
      expect(spy).toHaveBeenCalledWith({ queryKey: ['dashboard'] })
    } finally {
      useSettings.getState().setLanguage('vi')
      spy.mockRestore()
    }
    expect(lifeArea('health').label).toBe('Sức khỏe & Lành mạnh')
  })
})
