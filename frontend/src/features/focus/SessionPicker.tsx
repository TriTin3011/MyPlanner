import { Lock, Sprout } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import type { FocusUnlockDto, PlantKind, PotColor } from '../../api/types'
import { useGoalBoard } from '../goals/hooks'
import { useTodayDashboard } from '../today/hooks'
import { formatFocusMinutes } from './focusFormat'
import { isUnlocked, MAX_MINUTES, MIN_MINUTES, PLANTS, POTS, PRESET_MINUTES, type FocusLink } from './focusSession'
import { useFocus } from './store'

// Ô màu đại diện cho từng màu chậu (trùng tông với gradient trong sceneSvg.ts).
const POT_SWATCH: Record<PotColor, string> = {
  terra: '#d57849',
  cream: '#efe3cc',
  sage: '#97b891',
  blue: '#8aa8c9',
}
const PLANT_DOT: Record<PlantKind, string> = {
  basil: '#5fae5a',
  sunflower: '#f2c33a',
  cactus: '#6fb07a',
}

interface SessionPickerProps {
  today: string
  unlocks: FocusUnlockDto[] | undefined
}

const CHIP =
  'flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border-2 px-3 text-sm font-bold focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none disabled:cursor-not-allowed'

// Màn chọn phiên (SPEC §11A.2). Lựa chọn lưu trong store `useFocus` để lần sau mở lại vẫn còn.
export function SessionPicker({ today, unlocks }: SessionPickerProps) {
  const { t } = useTranslation()
  const { plantKind, potColor, minutes, link, setPlant, setPot, setMinutes, setLink, begin } = useFocus()
  const dashboard = useTodayDashboard(today)
  const goals = useGoalBoard(today)

  const tasks = dashboard.data?.tasks.filter((x) => !x.done) ?? []
  const habits = dashboard.data?.habits ?? []
  const activeGoals = goals.data?.goals.filter((g) => g.status !== 'done') ?? []

  // Khoá đã chọn từ trước có thể bị khoá lại (vd. đổi tài khoản): khi đó quay về món khởi đầu.
  const plant = isUnlocked(unlocks, plantKind) ? plantKind : 'basil'
  const potKey = isUnlocked(unlocks, potColor) ? potColor : 'terra'
  const rawHoursLeft = (key: string) => unlocks?.find((u) => u.key === key)?.hoursRemaining ?? 0
  const hoursLeft = (key: string) => Math.ceil(rawHoursLeft(key))

  const linkValue = link ? `${link.kind}:${link.id}` : ''
  const onLinkChange = (value: string) => {
    if (!value) return setLink(null)
    const [kind, id] = value.split(':') as [FocusLink['kind'], string]
    const source = kind === 'task' ? tasks : kind === 'habit' ? habits : activeGoals
    const found = source.find((x) => x.id === id)
    setLink(found ? { kind, id, title: found.title } : null)
  }

  const start = () => {
    if (plant !== plantKind) setPlant(plant)
    if (potKey !== potColor) setPot(potKey)
    const reduced = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ?? false
    begin(Date.now(), reduced)
  }

  return (
    <section aria-labelledby="focus-picker-title" className="sketch flex flex-col gap-4 p-3.5 lg:p-5">
      <h2 id="focus-picker-title" className="font-display text-xl font-extrabold">
        {t('focus.picker.title')}
      </h2>

      <fieldset className="flex flex-col gap-2">
        <legend className="mb-2 text-sm font-bold text-ink-muted">{t('focus.picker.plant')}</legend>
        <div className="flex flex-wrap gap-2">
          {PLANTS.map((kind) => {
            const open = isUnlocked(unlocks, kind)
            const name = t(`focus.plants.${kind}`)
            const hours = hoursLeft(kind)
            return (
              <button
                key={kind}
                type="button"
                disabled={!open}
                aria-pressed={plant === kind}
                aria-label={open ? name : t('focus.picker.lockedAria', { name, hours })}
                onClick={() => setPlant(kind)}
                className={`${CHIP} ${plant === kind ? 'border-ink bg-accent-soft text-primary-ink' : 'border-line bg-surface'} ${open ? '' : 'opacity-55'}`}
              >
                {open ? (
                  <span className="size-3 rounded-full border border-ink" style={{ background: PLANT_DOT[kind] }} aria-hidden />
                ) : (
                  <Lock size={14} aria-hidden />
                )}
                {name}
                {!open && <span className="text-xs font-medium">{t('focus.picker.lockedHours', { hours })}</span>}
              </button>
            )
          })}
        </div>
      </fieldset>

      <fieldset className="flex flex-col gap-2">
        <legend className="mb-2 text-sm font-bold text-ink-muted">{t('focus.picker.pot')}</legend>
        <div className="flex flex-wrap gap-2">
          {POTS.map((color) => {
            const open = isUnlocked(unlocks, color)
            const name = t(`focus.pots.${color}`)
            const hours = hoursLeft(color)
            return (
              <button
                key={color}
                type="button"
                disabled={!open}
                aria-pressed={potKey === color}
                aria-label={open ? name : t('focus.picker.lockedAria', { name, hours })}
                onClick={() => setPot(color)}
                className={`${CHIP} ${potKey === color ? 'border-ink bg-accent-soft text-primary-ink' : 'border-line bg-surface'} ${open ? '' : 'opacity-55'}`}
              >
                <span className="size-4 rounded-md border-2 border-ink" style={{ background: POT_SWATCH[color] }} aria-hidden />
                {name}
                {!open && (
                  <span className="flex items-center gap-1 text-xs font-medium">
                    <Lock size={12} aria-hidden />
                    {t('focus.picker.lockedHours', { hours })}
                  </span>
                )}
              </button>
            )
          })}
        </div>
      </fieldset>

      <fieldset className="flex flex-col gap-2">
        <legend className="mb-2 text-sm font-bold text-ink-muted">{t('focus.picker.duration')}</legend>
        <div className="flex flex-wrap items-center gap-2">
          {PRESET_MINUTES.map((m) => (
            <button
              key={m}
              type="button"
              aria-pressed={minutes === m}
              onClick={() => setMinutes(m)}
              className={`${CHIP} ${minutes === m ? 'border-ink bg-accent-soft text-primary-ink' : 'border-line bg-surface'}`}
            >
              {formatFocusMinutes(t, m)}
            </button>
          ))}
          <label className="flex items-center gap-2 text-sm font-bold">
            {t('focus.picker.custom')}
            <input
              type="number"
              inputMode="numeric"
              min={MIN_MINUTES}
              max={MAX_MINUTES}
              step={5}
              value={minutes}
              aria-label={t('focus.picker.customAria')}
              onChange={(e) => e.target.value !== '' && setMinutes(Number(e.target.value))}
              className="min-h-11 w-20 rounded-xl border-2 border-line bg-surface px-2 text-center font-bold focus-visible:border-ink focus-visible:outline-none"
            />
          </label>
        </div>
      </fieldset>

      <label className="flex flex-col gap-2 text-sm font-bold text-ink-muted">
        {t('focus.picker.link')}
        <select
          value={linkValue}
          onChange={(e) => onLinkChange(e.target.value)}
          className="min-h-11 rounded-xl border-2 border-line bg-surface px-3 font-bold text-ink focus-visible:border-ink focus-visible:outline-none"
        >
          <option value="">{t('focus.picker.noLink')}</option>
          {tasks.length > 0 && (
            <optgroup label={t('focus.picker.groupTask')}>
              {tasks.map((x) => (
                <option key={x.id} value={`task:${x.id}`}>
                  {x.title}
                </option>
              ))}
            </optgroup>
          )}
          {habits.length > 0 && (
            <optgroup label={t('focus.picker.groupHabit')}>
              {habits.map((x) => (
                <option key={x.id} value={`habit:${x.id}`}>
                  {x.title}
                </option>
              ))}
            </optgroup>
          )}
          {activeGoals.length > 0 && (
            <optgroup label={t('focus.picker.groupGoal')}>
              {activeGoals.map((x) => (
                <option key={x.id} value={`goal:${x.id}`}>
                  {x.title}
                </option>
              ))}
            </optgroup>
          )}
        </select>
      </label>

      <button
        type="button"
        onClick={start}
        className="flex min-h-12 cursor-pointer items-center justify-center gap-2 self-start rounded-xl border-2 border-ink bg-primary px-5 font-bold text-white shadow-[3px_3px_0_var(--ink)] hover:opacity-90 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:outline-none active:translate-x-0.5 active:translate-y-0.5 active:shadow-none"
      >
        <Sprout size={18} aria-hidden />
        {t('focus.picker.start')} · {formatFocusMinutes(t, minutes)}
      </button>
    </section>
  )
}
