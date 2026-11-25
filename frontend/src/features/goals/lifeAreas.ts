import { Briefcase, BookOpen, HeartPulse, Home, Palette, Sprout, Target, Users, Wallet, type LucideIcon } from 'lucide-react'
import type { GoalStatus, LifeArea } from '../../api/types'
import i18n from '../../i18n'

// Bảng hiển thị lĩnh vực (SPEC §12.4). Thứ tự khớp enum LifeArea ở BE (cũng là thứ tự trục radar).
export interface LifeAreaInfo {
  key: LifeArea
  label: string      // nhãn đầy đủ: dòng meta GoalCard, select trong drawer
  chip: string       // nhãn ngắn: chip lọc, trục radar
  Icon: LucideIcon
}

const AREA_ICONS: readonly { key: LifeArea; Icon: LucideIcon }[] = [
  { key: 'health', Icon: HeartPulse },
  { key: 'finance', Icon: Wallet },
  { key: 'career', Icon: Briefcase },
  { key: 'growth', Icon: Sprout },
  { key: 'relationship', Icon: Users },
  { key: 'learning', Icon: BookOpen },
  { key: 'family', Icon: Home },
  { key: 'hobby', Icon: Palette },
]

export const LIFE_AREAS: readonly LifeAreaInfo[] = AREA_ICONS.map(({ key, Icon }) => ({
  key,
  Icon,
  get label() {
    return i18n.t(`goals.areas.${key}.label`)
  },
  get chip() {
    return i18n.t(`goals.areas.${key}.chip`)
  },
}))

export function lifeArea(key: LifeArea): LifeAreaInfo {
  return LIFE_AREAS.find((a) => a.key === key) ?? LIFE_AREAS[0]
}

// Phần chung của GoalAreaDto / AreaSummaryDto / StatsGoalAreaDto đủ để hiển thị.
export interface AreaRef {
  id: string
  key: LifeArea | null
  name: string | null
}

export interface AreaDisplay {
  label: string
  chip: string
  Icon: LucideIcon
  custom: boolean
}

// Hiển thị một lĩnh vực từ BE: có key → nhãn dịch + icon riêng; lĩnh vực tự tạo (key null) → tên người dùng đặt + icon Target.
export function areaDisplay(area: { key: LifeArea | null; name: string | null } | undefined): AreaDisplay {
  if (area?.key) {
    const info = lifeArea(area.key)
    return { label: info.label, chip: info.chip, Icon: info.Icon, custom: false }
  }
  const name = area?.name ?? ''
  return { label: name, chip: name, Icon: Target, custom: true }
}

export const GOAL_STATUS_LABEL: Record<GoalStatus, string> = {
  get not_started() {
    return i18n.t('goals.status.not_started')
  },
  get in_progress() {
    return i18n.t('goals.status.in_progress')
  },
  get done() {
    return i18n.t('goals.status.done')
  },
}

// "2027-04-21" → "21/04/2027"
export function formatDmy(date: string) {
  const [y, m, d] = date.split('-')
  return `${d}/${m}/${y}`
}
