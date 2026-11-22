import { Briefcase, BookOpen, HeartPulse, Home, Palette, Sprout, Users, Wallet, type LucideIcon } from 'lucide-react'
import type { GoalStatus, LifeArea } from '../../api/types'

// Bảng hiển thị lĩnh vực (SPEC §12.4). Thứ tự khớp enum LifeArea ở BE (cũng là thứ tự trục radar).
export interface LifeAreaInfo {
  key: LifeArea
  label: string      // nhãn đầy đủ: dòng meta GoalCard, select trong drawer
  chip: string       // nhãn ngắn: chip lọc, trục radar
  Icon: LucideIcon
}

export const LIFE_AREAS: readonly LifeAreaInfo[] = [
  { key: 'health', label: 'Sức khỏe & Lành mạnh', chip: 'Sức khỏe', Icon: HeartPulse },
  { key: 'finance', label: 'Tài chính', chip: 'Tài chính', Icon: Wallet },
  { key: 'career', label: 'Sự nghiệp', chip: 'Sự nghiệp', Icon: Briefcase },
  { key: 'growth', label: 'Phát triển bản thân', chip: 'Phát triển', Icon: Sprout },
  { key: 'relationship', label: 'Mối quan hệ', chip: 'Quan hệ', Icon: Users },
  { key: 'learning', label: 'Học tập', chip: 'Học tập', Icon: BookOpen },
  { key: 'family', label: 'Gia đình', chip: 'Gia đình', Icon: Home },
  { key: 'hobby', label: 'Sở thích', chip: 'Sở thích', Icon: Palette },
]

export function lifeArea(key: LifeArea): LifeAreaInfo {
  return LIFE_AREAS.find((a) => a.key === key) ?? LIFE_AREAS[0]
}

export const GOAL_STATUS_LABEL: Record<GoalStatus, string> = {
  not_started: 'Chưa bắt đầu',
  in_progress: 'Đang thực hiện',
  done: 'Đã hoàn thành',
}

// "2027-04-21" → "21/04/2027"
export function formatDmy(date: string) {
  const [y, m, d] = date.split('-')
  return `${d}/${m}/${y}`
}
