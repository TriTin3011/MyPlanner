import { type KeyboardEvent, type PointerEvent, useEffect, useRef, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { clampOffset, type CropOffset, cropScale, cropSource, type ImageSize, MAX_ZOOM, MIN_ZOOM } from './avatarCrop'

const VIEWPORT = 240
const OUTPUT = 512
const KEY_STEP = 10
const BUTTON_CLASS = 'min-h-11 cursor-pointer rounded-xl border-2 border-ink px-4 text-sm font-bold'

// Cắt ảnh ngay trên trình duyệt bằng canvas, nên server chỉ nhận một ảnh vuông 512px đã gọn nhẹ.
export function AvatarCropper({
  file,
  busy,
  onCancel,
  onConfirm,
  onError,
}: {
  file: File
  busy: boolean
  onCancel: () => void
  onConfirm: (blob: Blob) => void
  onError: () => void
}) {
  const { t } = useTranslation()
  const [url, setUrl] = useState<string | null>(null)
  const [size, setSize] = useState<ImageSize | null>(null)
  const [zoom, setZoom] = useState(MIN_ZOOM)
  const [offset, setOffset] = useState<CropOffset>({ x: 0, y: 0 })
  const imageRef = useRef<HTMLImageElement>(null)
  const viewportRef = useRef<HTMLDivElement>(null)
  const dragRef = useRef<{ x: number; y: number; origin: CropOffset } | null>(null)
  const wheelRef = useRef<(deltaY: number) => void>(() => {})

  const errorRef = useRef(onError)
  useEffect(() => {
    errorRef.current = onError
  })

  // Đọc file bất đồng bộ thành data URL. Component được tạo mới cho mỗi lần chọn ảnh nên không cần đặt lại zoom.
  useEffect(() => {
    const reader = new FileReader()
    reader.onload = () => setUrl(String(reader.result))
    reader.onerror = () => errorRef.current()
    reader.readAsDataURL(file)
    return () => {
      reader.onload = null
      reader.onerror = null
      reader.abort()
    }
  }, [file])

  const applyZoom = (next: number) => {
    const value = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, next))
    setZoom(value)
    if (size) setOffset((current) => clampOffset(current, size, VIEWPORT, value))
  }

  useEffect(() => {
    wheelRef.current = (deltaY) => applyZoom(zoom - deltaY * 0.002)
  })

  // onWheel của React là passive nên không chặn được cuộn trang; phải tự gắn listener.
  useEffect(() => {
    const element = viewportRef.current
    if (!element) return
    const onWheel = (event: WheelEvent) => {
      event.preventDefault()
      wheelRef.current(event.deltaY)
    }
    element.addEventListener('wheel', onWheel, { passive: false })
    return () => element.removeEventListener('wheel', onWheel)
  }, [])

  const onPointerDown = (event: PointerEvent<HTMLDivElement>) => {
    event.currentTarget.setPointerCapture(event.pointerId)
    dragRef.current = { x: event.clientX, y: event.clientY, origin: offset }
  }

  const onPointerMove = (event: PointerEvent<HTMLDivElement>) => {
    const drag = dragRef.current
    if (!drag || !size) return
    const next = { x: drag.origin.x + event.clientX - drag.x, y: drag.origin.y + event.clientY - drag.y }
    setOffset(clampOffset(next, size, VIEWPORT, zoom))
  }

  const endDrag = () => {
    dragRef.current = null
  }

  const onKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    const steps: Record<string, CropOffset> = {
      ArrowLeft: { x: -KEY_STEP, y: 0 },
      ArrowRight: { x: KEY_STEP, y: 0 },
      ArrowUp: { x: 0, y: -KEY_STEP },
      ArrowDown: { x: 0, y: KEY_STEP },
    }
    const step = steps[event.key]
    if (!step || !size) return
    event.preventDefault()
    setOffset(clampOffset({ x: offset.x + step.x, y: offset.y + step.y }, size, VIEWPORT, zoom))
  }

  const confirm = () => {
    const image = imageRef.current
    const canvas = document.createElement('canvas')
    canvas.width = OUTPUT
    canvas.height = OUTPUT
    const context = canvas.getContext('2d')
    if (!image || !size || !context) return onError()
    // JPEG không có kênh trong suốt, phủ nền trắng để PNG trong suốt không thành nền đen.
    context.fillStyle = '#fff'
    context.fillRect(0, 0, OUTPUT, OUTPUT)
    const source = cropSource(size, VIEWPORT, zoom, offset)
    context.drawImage(image, source.x, source.y, source.size, source.size, 0, 0, OUTPUT, OUTPUT)
    canvas.toBlob((blob) => (blob ? onConfirm(blob) : onError()), 'image/jpeg', 0.9)
  }

  const shownWidth = size ? size.width * cropScale(size, VIEWPORT, zoom) : VIEWPORT

  return (
    <div className="flex flex-col items-center gap-3 py-2">
      <p className="font-display text-lg font-extrabold">{t('auth.cropTitle')}</p>
      <div
        ref={viewportRef}
        role="group"
        tabIndex={0}
        aria-label={t('auth.cropArea')}
        onPointerDown={onPointerDown}
        onPointerMove={onPointerMove}
        onPointerUp={endDrag}
        onPointerCancel={endDrag}
        onKeyDown={onKeyDown}
        style={{ width: VIEWPORT, height: VIEWPORT }}
        className="relative shrink-0 cursor-grab touch-none overflow-hidden rounded-xl border-2 border-ink bg-accent-tint select-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none active:cursor-grabbing"
      >
        {url && (
          <img
            ref={imageRef}
            src={url}
            alt=""
            draggable={false}
            onLoad={(event) =>
              setSize({ width: event.currentTarget.naturalWidth, height: event.currentTarget.naturalHeight })
            }
            onError={onError}
            style={{
              width: shownWidth,
              transform: `translate(calc(-50% + ${offset.x}px), calc(-50% + ${offset.y}px))`,
            }}
            className="absolute top-1/2 left-1/2 h-auto max-w-none"
          />
        )}
        <div className="pointer-events-none absolute inset-0 rounded-full shadow-[0_0_0_200px_rgb(0_0_0/0.45)]" />
      </div>
      <p className="text-xs text-ink-muted">{t('auth.cropHint')}</p>
      <label className="flex w-full max-w-60 items-center gap-2 text-xs font-bold text-ink-muted">
        {t('auth.cropZoom')}
        <input
          type="range"
          min={MIN_ZOOM}
          max={MAX_ZOOM}
          step={0.01}
          value={zoom}
          onChange={(event) => applyZoom(Number(event.target.value))}
          className="min-h-11 min-w-0 flex-1 cursor-pointer accent-[var(--primary)]"
        />
      </label>
      <div className="flex justify-center gap-2">
        <button
          type="button"
          disabled={busy}
          onClick={onCancel}
          className={`${BUTTON_CLASS} hover:bg-accent-tint disabled:opacity-60`}
        >
          {t('auth.cropCancel')}
        </button>
        <button
          type="button"
          disabled={busy || !size}
          onClick={confirm}
          className={`${BUTTON_CLASS} bg-primary text-white disabled:opacity-60`}
        >
          {busy ? t('auth.uploadingPhoto') : t('auth.cropSave')}
        </button>
      </div>
    </div>
  )
}
