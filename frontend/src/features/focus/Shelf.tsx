import { ChevronLeft, ChevronRight, X } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import type { FocusPotDto, FocusShelfDto } from '../../api/types'
import { INTL_LOCALE } from '../../i18n/languages'
import { useSettings } from '../../store/settings'
import { formatFocusMinutes } from './focusFormat'
import { shelfScene, SHELF_SIZE, slotPosition, VIEW_H, VIEW_W } from './sceneSvg'
import { FocusScene } from './FocusScene'

const NAV_BTN =
  'flex size-11 cursor-pointer items-center justify-center rounded-xl border-2 border-line bg-surface hover:border-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-40'

// Kệ ba tầng (SPEC §11A.6). API trả kệ theo index tăng dần; kệ mới nhất (index lớn nhất) hiện trước.
export function Shelf({ shelves, potCount }: { shelves: FocusShelfDto[]; potCount: number }) {
  const { t } = useTranslation()
  const language = useSettings((s) => s.language)
  const locale = INTL_LOCALE[language]
  const ordered = [...shelves].sort((a, b) => b.index - a.index)
  const [position, setPosition] = useState(0)
  const [openId, setOpenId] = useState<string | null>(null)

  const current = ordered[Math.min(position, Math.max(0, ordered.length - 1))]
  const pots = current?.pots ?? []
  const isNewest = position === 0
  // Chỗ trống kế tiếp chỉ vẽ trên kệ mới nhất, và chỉ khi kệ chưa đầy.
  const nextSlot = isNewest && pots.length < SHELF_SIZE ? pots.length : null
  const opened = pots.find((p) => p.id === openId) ?? null

  const formatDate = (iso: string) =>
    new Intl.DateTimeFormat(locale, { day: '2-digit', month: '2-digit', year: 'numeric' }).format(new Date(`${iso}T00:00:00`))
  const formatTime = (iso: string) =>
    new Intl.DateTimeFormat(locale, { hour: '2-digit', minute: '2-digit' }).format(new Date(iso))

  const potLabel = (p: FocusPotDto) =>
    t('focus.shelf.potAria', {
      plant: t(`focus.plants.${p.plantKind}`),
      minutes: formatFocusMinutes(t, p.minutes),
      date: formatDate(p.date),
    })

  const go = (delta: number) => {
    setOpenId(null)
    setPosition((x) => Math.min(ordered.length - 1, Math.max(0, x + delta)))
  }

  return (
    <section aria-labelledby="focus-shelf-title" className="sketch flex flex-col gap-3 p-3.5 lg:p-5">
      <div className="flex items-center justify-between gap-2">
        <h2 id="focus-shelf-title" className="font-display text-xl font-extrabold">
          {t('focus.shelf.title')}{' '}
          <span className="text-sm font-bold text-ink-muted">
            · {potCount} {t('focus.strip.pots').toLowerCase()}
          </span>
        </h2>
        {ordered.length > 1 && (
          <div className="flex items-center gap-2">
            {/* Trái là kệ cũ hơn: vị trí 0 là mới nhất nên "cũ hơn" là tăng position. */}
            <button
              type="button"
              className={NAV_BTN}
              aria-label={t('focus.shelf.prev')}
              disabled={position >= ordered.length - 1}
              onClick={() => go(1)}
            >
              <ChevronLeft size={18} aria-hidden />
            </button>
            <span className="min-w-16 text-center text-sm font-bold tabular-nums text-ink-muted" aria-live="polite">
              {t('focus.shelf.position', { n: ordered.length - position, total: ordered.length })}
            </span>
            <button
              type="button"
              className={NAV_BTN}
              aria-label={t('focus.shelf.next')}
              disabled={position === 0}
              onClick={() => go(-1)}
            >
              <ChevronRight size={18} aria-hidden />
            </button>
          </div>
        )}
      </div>

      <div className="relative overflow-hidden rounded-xl border-2 border-ink">
        <FocusScene markup={shelfScene(pots, nextSlot)} label={t('focus.scene.shelfAria')} />
        {/* Nút phủ lên từng chậu: SVG chỉ để nhìn, tương tác nằm ở HTML để có focus và aria. */}
        {pots.map((p) => {
          const pos = slotPosition(p.slot)
          return (
            <button
              key={p.id}
              type="button"
              aria-label={potLabel(p)}
              aria-expanded={openId === p.id}
              onClick={() => setOpenId(openId === p.id ? null : p.id)}
              className="absolute -translate-x-1/2 cursor-pointer rounded-full focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
              style={{
                left: `${(pos.x / VIEW_W) * 100}%`,
                top: `${((pos.baseY - 70) / VIEW_H) * 100}%`,
                width: `${(70 / VIEW_W) * 100}%`,
                height: `${(76 / VIEW_H) * 100}%`,
              }}
            />
          )
        })}
      </div>

      {pots.length === 0 && <p className="text-sm text-ink-muted">{t('focus.shelf.empty')}</p>}

      {opened && (
        <div role="region" aria-label={potLabel(opened)} className="relative rounded-xl border-2 border-ink bg-paper p-3 pr-12">
          <p className="font-display text-lg font-extrabold">
            {t(`focus.plants.${opened.plantKind}`)} · {t(`focus.pots.${opened.potColor}`)}
          </p>
          <p className="text-sm text-ink-muted">
            {formatFocusMinutes(t, opened.minutes)} · {formatDate(opened.date)} · {t('focus.shelf.at')}{' '}
            {formatTime(opened.endedAt)}
          </p>
          {opened.linkTitle && (
            <p className="text-sm">
              <span className="font-bold">{t('focus.shelf.linkLabel')}:</span> {opened.linkTitle}
            </p>
          )}
          <button
            type="button"
            aria-label={t('focus.shelf.close')}
            onClick={() => setOpenId(null)}
            className="absolute top-2 right-2 flex size-9 cursor-pointer items-center justify-center rounded-lg hover:bg-accent-soft focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none"
          >
            <X size={16} aria-hidden />
          </button>
        </div>
      )}
    </section>
  )
}
