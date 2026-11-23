import { DEFAULT_TODAY_LAYOUT, type TodayBlockId } from '../../store/settings'

export type TodayLayout = { id: TodayBlockId; hidden: boolean }[]

// Chuẩn hoá bố cục đọc từ localStorage: bỏ id lạ, bỏ trùng, thêm khối mới (nếu bản sau thêm khối)
// vào cuối. Nhờ vậy dữ liệu cũ trong trình duyệt không làm hỏng trang khi danh sách khối thay đổi.
export function normalizeTodayLayout(layout: TodayLayout | undefined): TodayLayout {
  const known = new Set(DEFAULT_TODAY_LAYOUT.map((b) => b.id))
  const seen = new Set<TodayBlockId>()
  const result: TodayLayout = []
  for (const block of layout ?? []) {
    if (known.has(block.id) && !seen.has(block.id)) {
      seen.add(block.id)
      result.push({ id: block.id, hidden: Boolean(block.hidden) })
    }
  }
  for (const block of DEFAULT_TODAY_LAYOUT) if (!seen.has(block.id)) result.push({ ...block })
  return result
}

// Đưa một khối tới vị trí mới. Vị trí ngoài danh sách thì giữ nguyên (ví dụ bấm ↑ ở dòng đầu).
export function moveTodayBlock(layout: TodayLayout, from: number, to: number): TodayLayout {
  if (from < 0 || from >= layout.length || to < 0 || to >= layout.length || from === to) return layout
  const next = [...layout]
  const [block] = next.splice(from, 1)
  next.splice(to, 0, block)
  return next
}

// Nhóm các khối đang hiện theo thứ tự bố cục. "Việc hôm nay" và "Thói quen" đứng cạnh nhau thì ghép
// thành một hàng hai cột trên màn rộng (như ảnh 01); các khối khác chiếm trọn hàng.
export function groupTodayBlocks(layout: TodayLayout): TodayBlockId[][] {
  const visible = layout.filter((b) => !b.hidden).map((b) => b.id)
  const halfWidth = new Set<TodayBlockId>(['tasks', 'habits'])
  const groups: TodayBlockId[][] = []
  for (let i = 0; i < visible.length; i++) {
    const id = visible[i]
    const next = visible[i + 1]
    if (halfWidth.has(id) && next !== undefined && halfWidth.has(next)) {
      groups.push([id, next])
      i++
    } else {
      groups.push([id])
    }
  }
  return groups
}
