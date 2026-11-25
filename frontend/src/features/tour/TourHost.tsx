import { type KeyboardEvent, useEffect, useId, useLayoutEffect, useRef, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useLocation, useNavigate } from 'react-router'
import { NAV_ITEMS } from '../../app/routes'
import { Mascot } from '../../components/Mascot'
import { useSettings } from '../../store/settings'
import { useSession } from '../auth/session'
import { useTour } from './store'
import './Tour.css'
import { placeCard, spotlightBox } from './tourPosition'
import { TOUR_STEPS } from './tourSteps'
import { useTourTarget } from './useTourTarget'

// Gắn một lần trong AppShell: tự mở tour cho tài khoản chưa xem và vẽ overlay khi tour đang chạy.
export function TourHost() {
  const userName = useSession((s) => s.userName)
  const seen = useSettings((s) => (userName ? Boolean(s.tourSeen[userName]) : true))
  const active = useTour((s) => s.active)
  const start = useTour((s) => s.start)

  useEffect(() => {
    if (!seen) start(window.location.pathname)
  }, [seen, start])

  // Hết phiên giữa chừng thì AppShell bị gỡ: không để tour "đang chạy" sót lại cho lần đăng nhập sau.
  useEffect(() => () => useTour.getState().stop(), [])

  return active ? <TourDialog userName={userName} /> : null
}

function TourDialog({ userName }: { userName: string | null }) {
  const { t, i18n } = useTranslation()
  const navigate = useNavigate()
  const { pathname } = useLocation()
  const index = useTour((s) => s.index)
  const next = useTour((s) => s.next)
  const back = useTour((s) => s.back)
  const markTourSeen = useSettings((s) => s.markTourSeen)
  const dialogRef = useRef<HTMLDialogElement>(null)
  const cardRef = useRef<HTMLDivElement>(null)
  const primaryRef = useRef<HTMLButtonElement>(null)
  const hitRef = useRef<HTMLButtonElement>(null)
  const titleId = useId()
  const [viewport, setViewport] = useState({ width: window.innerWidth, height: window.innerHeight })
  const [cardPosition, setCardPosition] = useState({ x: 12, y: 12 })

  const step = TOUR_STEPS[index]
  const isFirst = index === 0
  const isLast = index === TOUR_STEPS.length - 1
  // Bước nằm ở trang khác thì chưa tự chuyển: Mầm chỉ vào tab đó để người dùng tự bấm.
  const needsClick = Boolean(step.path) && step.path !== pathname
  const tab = needsClick ? NAV_ITEMS.find((item) => item.path === step.path) : undefined
  const screen = tab ? t(`nav.${tab.key}.short`) : ''
  const { rect, status } = useTourTarget(needsClick ? `tab:${step.path}` : step.target, true)
  const spot = rect ? spotlightBox(rect, viewport) : null
  const spotKey = spot ? `${spot.left}:${spot.top}:${spot.width}:${spot.height}` : ''

  // showModal() cho bẫy focus và làm phần còn lại inert, giống Modal. jsdom chưa có hàm này.
  // Phải là layout effect đặt trước effect đo thẻ: dialog chưa mở thì display:none, thẻ đo ra rộng 0.
  useLayoutEffect(() => {
    const dialog = dialogRef.current
    if (!dialog) return
    if (!dialog.open) {
      if (typeof dialog.showModal === 'function') dialog.showModal()
      else dialog.setAttribute('open', '')
    }
    return () => {
      if (dialog.open && typeof dialog.close === 'function') dialog.close()
    }
  }, [])

  // Mỗi bước đưa focus về thứ cần bấm: tab đang được chỉ, nếu không có thì nút chính. Enter dùng được ngay.
  const hasHitArea = needsClick && Boolean(spot)
  useEffect(() => {
    if (hasHitArea) hitRef.current?.focus()
    else primaryRef.current?.focus()
  }, [index, hasHitArea, status])

  useEffect(() => {
    const onResize = () => setViewport({ width: window.innerWidth, height: window.innerHeight })
    window.addEventListener('resize', onResize)
    return () => window.removeEventListener('resize', onResize)
  }, [])

  // Đo thẻ sau khi DOM có chữ mới, trước khi trình duyệt vẽ. Đang tìm phần tử thì giữ thẻ ở chỗ cũ.
  useLayoutEffect(() => {
    const card = cardRef.current
    if (!card || status === 'locating') return
    const box = status === 'found' && rect ? spotlightBox(rect, viewport) : null
    setCardPosition(placeCard(box, { width: card.offsetWidth, height: card.offsetHeight }, viewport))
    // spotKey đại diện cho rect theo giá trị; rect là object mới sau mỗi lần đo.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [spotKey, status, index, needsClick, viewport, i18n.language])

  function openStepScreen() {
    if (step.path) navigate(step.path, { replace: true })
  }

  // Đi lùi không bắt bấm tab lần nữa: tự về trang của bước trước.
  function goBack() {
    const previous = TOUR_STEPS[index - 1]
    if (!needsClick && previous?.path && previous.path !== pathname) navigate(previous.path, { replace: true })
    back()
  }

  function close() {
    const tour = useTour.getState()
    if (!tour.active) return
    const { origin } = tour
    tour.stop()
    if (userName) markTourSeen(userName)
    if (origin !== pathname) navigate(origin, { replace: true })
  }

  function handleKeyDown(event: KeyboardEvent<HTMLDialogElement>) {
    if (event.key === 'Escape') {
      event.preventDefault()
      close()
    } else if (event.key === 'ArrowRight' && needsClick) {
      event.preventDefault()
      openStepScreen()
    } else if (event.key === 'ArrowRight' && !isLast) {
      event.preventDefault()
      next()
    } else if (event.key === 'ArrowLeft' && !isFirst) {
      event.preventDefault()
      goBack()
    }
  }

  const secondaryClass =
    'min-h-11 cursor-pointer rounded-xl px-3 text-sm font-bold text-ink-muted hover:bg-accent-tint hover:text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none'

  return (
    <dialog
      ref={dialogRef}
      className="tour"
      aria-labelledby={titleId}
      onKeyDown={handleKeyDown}
      onCancel={(event) => {
        event.preventDefault()
        close()
      }}
    >
      {spot ? (
        <div
          className="tour__spot"
          style={{ width: spot.width, height: spot.height, transform: `translate(${spot.left}px, ${spot.top}px)` }}
        />
      ) : (
        <div className="tour__dim" />
      )}

      {/* Dialog làm phần nền inert nên tab thật không nhận click: nút trong suốt này nằm đúng trên tab. */}
      {hasHitArea && spot && (
        <button
          ref={hitRef}
          type="button"
          className="tour__hit"
          aria-label={t('tour.clickTitle', { screen })}
          style={{ width: spot.width, height: spot.height, transform: `translate(${spot.left}px, ${spot.top}px)` }}
          onClick={openStepScreen}
        />
      )}

      <div
        ref={cardRef}
        className="tour__card rounded-2xl border-2 border-[var(--ink)] bg-surface p-3.5 text-ink shadow-[4px_4px_0_0_var(--ink)]"
        style={{ transform: `translate(${cardPosition.x}px, ${cardPosition.y}px)` }}
      >
        <div className="flex items-start gap-2.5">
          {/* key đổi theo bước để React gắn lại phần tử, nhờ đó animation của Mầm chạy lại. */}
          <Mascot key={step.id} motion={step.motion} size={72} />
          <div key={`text-${step.id}-${needsClick}`} className="tour__text min-w-0 flex-1" aria-live="polite">
            <p className="text-xs font-bold text-ink-muted tabular-nums">
              {t('tour.progress', { current: index + 1, total: TOUR_STEPS.length })}
            </p>
            <h2 id={titleId} className="font-display text-lg leading-tight font-extrabold text-primary-ink">
              {needsClick ? t('tour.clickTitle', { screen }) : t(`tour.steps.${step.id}.title`)}
            </h2>
            <p className="mt-1 text-sm leading-snug">
              {needsClick ? t('tour.clickBody') : t(`tour.steps.${step.id}.body`)}
            </p>
            {status === 'missing' && <p className="mt-1 text-xs text-ink-muted">{t('tour.targetMissing')}</p>}
          </div>
        </div>

        <div className="mt-2 flex items-center gap-1">
          {!isLast && (
            <button type="button" onClick={close} className={secondaryClass}>
              {t(isFirst ? 'tour.later' : 'tour.skip')}
            </button>
          )}
          <span className="flex-1" />
          {!isFirst && (
            <button type="button" onClick={goBack} className={secondaryClass}>
              {t('tour.back')}
            </button>
          )}
          {/* Đang chờ bấm tab thì ẩn nút chính; chỉ hiện lại khi không tìm thấy tab để không bị kẹt. */}
          {!hasHitArea && (
            <button
              ref={primaryRef}
              type="button"
              onClick={needsClick ? openStepScreen : isLast ? close : next}
              className="min-h-11 cursor-pointer rounded-xl bg-primary px-4 text-sm font-bold text-white hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none"
            >
              {t(isFirst ? 'tour.start' : isLast ? 'tour.done' : 'tour.next')}
            </button>
          )}
        </div>
      </div>
    </dialog>
  )
}
