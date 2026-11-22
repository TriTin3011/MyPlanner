import { describe, expect, it } from 'vitest'
import { en } from './en'
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
})
