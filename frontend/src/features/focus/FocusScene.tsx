import { useId } from 'react'
import { uniqueIds, VIEW_H, VIEW_W } from './sceneSvg'

interface FocusSceneProps {
  markup: string
  label: string
  className?: string
}

// Gắn chuỗi SVG do sceneSvg.ts dựng vào DOM. Chuỗi này do chính code của app sinh ra từ hằng số
// và enum (không có chữ người dùng nhập), nên dùng dangerouslySetInnerHTML ở đây là an toàn.
export function FocusScene({ markup, label, className = '' }: FocusSceneProps) {
  // useId trả dạng ":r1:"; bỏ ký tự đặc biệt để dùng được trong url(#...).
  const prefix = `fs${useId().replace(/[^a-zA-Z0-9]/g, '')}-`
  return (
    <svg
      viewBox={`0 0 ${VIEW_W} ${VIEW_H}`}
      role="img"
      aria-label={label}
      className={`focus-scene block h-auto w-full ${className}`}
      dangerouslySetInnerHTML={{ __html: uniqueIds(markup, prefix) }}
    />
  )
}
