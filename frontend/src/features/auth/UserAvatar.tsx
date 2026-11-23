import { useState } from 'react'

interface UserAvatarProps {
  name: string | null
  imageUrl?: string | null
  size?: number
}

// Avatar hình tròn. Chưa có ảnh, hoặc ảnh tải lỗi, thì hiện chữ cái đầu của tên, nên chỗ dùng không phải xử lý trường hợp rỗng.
// Array.from tách theo ký tự Unicode: "Đ" hay emoji không bị cắt đôi như khi dùng name[0].
export function UserAvatar({ name, imageUrl, size = 36 }: UserAvatarProps) {
  // Nhớ đúng URL đã lỗi: khi có link mới, ảnh được thử lại mà không cần effect để reset state.
  const [failedUrl, setFailedUrl] = useState<string | null>(null)
  const initial = Array.from(name?.trim() ?? '')[0]?.toLocaleUpperCase() ?? '?'
  const showImage = Boolean(imageUrl) && imageUrl !== failedUrl

  return (
    <span
      aria-hidden="true"
      style={{ width: size, height: size, fontSize: Math.round(size * 0.44) }}
      className="grid shrink-0 place-items-center overflow-hidden rounded-full border-2 border-ink bg-accent-soft font-display leading-none font-extrabold text-primary-ink"
    >
      {showImage ? (
        <img
          src={imageUrl ?? undefined}
          alt=""
          width={size}
          height={size}
          referrerPolicy="no-referrer"
          className="size-full object-cover"
          onError={() => setFailedUrl(imageUrl ?? null)}
        />
      ) : (
        initial
      )}
    </span>
  )
}
