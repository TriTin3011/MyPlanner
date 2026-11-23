import { Check, ChevronDown } from 'lucide-react'
import { type CSSProperties, type KeyboardEvent, type ReactNode, useEffect, useId, useRef, useState } from 'react'

export interface SelectOption<T extends string = string> {
  value: T
  label: string
}

interface SelectProps<T extends string> {
  // Gắn với <label htmlFor> bên ngoài; không có nhãn nhìn thấy thì truyền ariaLabel.
  id?: string
  ariaLabel?: string
  value: T
  options: readonly SelectOption<T>[]
  onChange: (value: T) => void
  icon?: ReactNode
  className?: string
}

const GAP = 6
const OPTION_HEIGHT = 44
const MENU_MAX_HEIGHT = 264

// Dropdown chung của hệ thống. Danh sách của <select> gốc do hệ điều hành vẽ nên CSS không chỉnh được,
// vì vậy ở đây tự dựng theo mẫu "select-only combobox" của WAI-ARIA: focus luôn ở nút,
// aria-activedescendant báo cho trình đọc màn hình biết dòng đang được chọn bằng phím mũi tên.
// Menu dùng position: fixed để không bị cắt bởi vùng cuộn hay modal chứa nó.
export function Select<T extends string>({ id, ariaLabel, value, options, onChange, icon, className = '' }: SelectProps<T>) {
  const listId = useId()
  const buttonRef = useRef<HTMLButtonElement>(null)
  const listRef = useRef<HTMLUListElement>(null)
  const [open, setOpen] = useState(false)
  const [active, setActive] = useState(0)
  const [menuStyle, setMenuStyle] = useState<CSSProperties>({})
  const selectedIndex = options.findIndex((option) => option.value === value)
  const selected = options[selectedIndex]

  const openMenu = () => {
    const rect = buttonRef.current?.getBoundingClientRect()
    if (!rect) return
    const wanted = Math.min(MENU_MAX_HEIGHT, options.length * OPTION_HEIGHT + 12)
    const below = window.innerHeight - rect.bottom
    const placeAbove = below < wanted + GAP && rect.top > below
    const width = Math.max(rect.width, 150)
    setMenuStyle({
      left: Math.max(8, Math.min(rect.left, window.innerWidth - width - 8)),
      minWidth: width,
      maxHeight: Math.min(MENU_MAX_HEIGHT, (placeAbove ? rect.top : below) - GAP - 8),
      ...(placeAbove ? { bottom: window.innerHeight - rect.top + GAP } : { top: rect.bottom + GAP }),
    })
    setActive(Math.max(0, selectedIndex))
    setOpen(true)
  }

  const choose = (index: number) => {
    const option = options[index]
    if (option && option.value !== value) onChange(option.value)
    setOpen(false)
  }

  // Menu đứng yên theo màn hình nên khi trang cuộn hoặc đổi cỡ thì đóng lại, tránh menu lệch khỏi nút.
  useEffect(() => {
    if (!open) return
    const close = (event: Event) => {
      if (listRef.current?.contains(event.target as Node)) return
      if (event.type === 'pointerdown' && buttonRef.current?.contains(event.target as Node)) return
      setOpen(false)
    }
    document.addEventListener('pointerdown', close)
    window.addEventListener('scroll', close, true)
    window.addEventListener('resize', close)
    return () => {
      document.removeEventListener('pointerdown', close)
      window.removeEventListener('scroll', close, true)
      window.removeEventListener('resize', close)
    }
  }, [open])

  useEffect(() => {
    if (open) listRef.current?.children[active]?.scrollIntoView?.({ block: 'nearest' })
  }, [open, active])

  const onKeyDown = (event: KeyboardEvent<HTMLButtonElement>) => {
    if (!open) {
      if (['ArrowDown', 'ArrowUp', 'Enter', ' '].includes(event.key)) {
        event.preventDefault()
        openMenu()
      }
      return
    }
    const last = options.length - 1
    const moves: Record<string, number> = {
      ArrowDown: Math.min(last, active + 1),
      ArrowUp: Math.max(0, active - 1),
      Home: 0,
      End: last,
    }
    if (event.key in moves) {
      event.preventDefault()
      setActive(moves[event.key])
    } else if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault()
      choose(active)
    } else if (event.key === 'Escape') {
      // Esc chỉ đóng menu, không đóng luôn modal đang chứa nó.
      event.preventDefault()
      event.stopPropagation()
      setOpen(false)
    } else if (event.key === 'Tab') {
      setOpen(false)
    }
  }

  return (
    <>
      <button
        ref={buttonRef}
        id={id}
        type="button"
        role="combobox"
        aria-label={ariaLabel}
        aria-haspopup="listbox"
        aria-expanded={open}
        aria-controls={listId}
        aria-activedescendant={open ? `${listId}-${active}` : undefined}
        onClick={() => (open ? setOpen(false) : openMenu())}
        onKeyDown={onKeyDown}
        onBlur={() => setOpen(false)}
        className={`inline-flex cursor-pointer items-center gap-1.5 text-left font-bold text-ink focus-visible:ring-2 focus-visible:ring-primary focus-visible:outline-none ${className}`}
      >
        {icon}
        <span className="min-w-0 flex-1 truncate">{selected?.label}</span>
        <ChevronDown
          size={15}
          aria-hidden="true"
          className={`shrink-0 text-ink-muted transition-transform motion-reduce:transition-none ${open ? 'rotate-180' : ''}`}
        />
      </button>
      {open && (
        <ul
          ref={listRef}
          id={listId}
          role="listbox"
          aria-label={ariaLabel}
          style={menuStyle}
          // Giữ focus ở nút khi bấm vào menu, nếu không onBlur sẽ đóng menu trước khi kịp chọn.
          onMouseDown={(event) => event.preventDefault()}
          className="fixed z-50 overflow-y-auto rounded-xl border-2 border-ink bg-surface p-1 text-sm shadow-[3px_3px_0_0_var(--ink)]"
        >
          {options.map((option, index) => {
            const isSelected = option.value === value
            return (
              <li
                key={option.value}
                id={`${listId}-${index}`}
                role="option"
                aria-selected={isSelected}
                onClick={() => choose(index)}
                onMouseEnter={() => setActive(index)}
                className={`flex min-h-11 cursor-pointer items-center justify-between gap-3 rounded-lg px-2.5 whitespace-nowrap md:min-h-9 ${
                  isSelected ? 'font-bold text-primary-ink' : 'font-semibold text-ink'
                } ${index === active ? 'bg-accent-soft' : ''}`}
              >
                {option.label}
                {isSelected && <Check size={15} aria-hidden="true" className="shrink-0" />}
              </li>
            )
          })}
        </ul>
      )}
    </>
  )
}
