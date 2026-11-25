// Sinh nét viền vẽ tay dạng SVG (SPEC §4.4). Hàm thuần: cùng kích thước và màu luôn ra cùng hình,
// nên render lại không làm viền nhảy. Mỗi cạnh và mỗi góc là một nét riêng, hai đầu thon và vượt nhẹ qua điểm giao.

// Hai hằng số này phải khớp `border-image` trong styles/sketch.css.
export const SKETCH_OUTSET = 3
export const SKETCH_SLICE = 9

type Point = readonly [number, number]
type Random = () => number

function createRandom(width: number, height: number): Random {
  let state = (((Math.round(width) * 73856093) ^ (Math.round(height) * 19349663)) >>> 0) % 2147483646
  state += 1
  return () => {
    state = (state * 16807) % 2147483647
    return (state - 1) / 2147483646
  }
}

// `stroke` của SVG không đổi được độ dày dọc đường, nên biến đường tâm thành một dải đa giác hẹp ở hai đầu.
function ribbon(points: Point[], width: number, random: Random): string {
  const left: Point[] = []
  const right: Point[] = []
  const last = points.length - 1
  points.forEach((point, i) => {
    const before = points[Math.max(i - 1, 0)]
    const after = points[Math.min(i + 1, last)]
    const dx = after[0] - before[0]
    const dy = after[1] - before[1]
    const length = Math.hypot(dx, dy) || 1
    // sin(π) tính bằng số thực có thể ra số âm cực nhỏ, và lũy thừa 0.45 của số âm là NaN, làm SVG ngừng vẽ cả đường.
    const taper = 0.35 + 0.65 * Math.pow(Math.max(Math.sin((Math.PI * i) / last), 0), 0.45)
    const half = (width / 2) * taper * (0.9 + random() * 0.2)
    left.push([point[0] - (dy / length) * half, point[1] + (dx / length) * half])
    right.unshift([point[0] + (dy / length) * half, point[1] - (dx / length) * half])
  })
  return `M${[...left, ...right].map(([x, y]) => `${x.toFixed(1)} ${y.toFixed(1)}`).join('L')}Z`
}

function wobblyLine(from: Point, to: Point, wobble: number, random: Random): Point[] {
  const dx = to[0] - from[0]
  const dy = to[1] - from[1]
  const length = Math.hypot(dx, dy) || 1
  // Giới hạn số điểm để thẻ lớn không sinh chuỗi SVG quá dài.
  const count = Math.max(4, Math.ceil(length / Math.max(8, length / 40)))
  const slow = Math.PI * 2 * (0.6 + random() * 0.8)
  const fast = Math.PI * 2 * (1.7 + random() * 1.4)
  const slowPhase = random() * Math.PI * 2
  const fastPhase = random() * Math.PI * 2
  return Array.from({ length: count + 1 }, (_, i) => {
    const t = i / count
    const offset = wobble * (Math.sin(slow * t + slowPhase) * 0.7 + Math.sin(fast * t + fastPhase) * 0.3)
    return [from[0] + dx * t - (dy / length) * offset, from[1] + dy * t + (dx / length) * offset] as const
  })
}

function cornerArc(cx: number, cy: number, radius: number, start: number, end: number, random: Random): Point[] {
  const skew = (random() - 0.5) * 0.8
  return Array.from({ length: 11 }, (_, i) => {
    const t = i / 10
    const angle = start + (end - start) * t
    const r = radius + skew * Math.sin(Math.PI * t)
    return [cx + Math.cos(angle) * r, cy + Math.sin(angle) * r] as const
  })
}

export function buildSketchSvg(width: number, height: number, color: string): string {
  const random = createRandom(width, height)
  const large = height > 90
  const tiny = height < 26
  const wobble = large ? 0.4 : tiny ? 0.2 : 0.55
  const strokeWidth = large ? 2.3 : tiny ? 1.6 : 2.1
  const inset = 1
  const right = width - inset
  const bottom = height - inset
  const radius = Math.max(2, Math.min(tiny ? 5 : 14, Math.min(width, height) / 2 - 1))
  const overshoot = Math.min(large ? 3 : 4, radius * 0.4)
  const jitter = () => (random() - 0.5) * 0.7

  const sides: [Point, Point][] = [
    [[radius - overshoot, inset + jitter()], [width - radius + overshoot, inset + jitter()]],
    [[right + jitter(), radius - overshoot], [right + jitter(), height - radius + overshoot]],
    [[width - radius + overshoot, bottom + jitter()], [radius - overshoot, bottom + jitter()]],
    [[inset + jitter(), height - radius + overshoot], [inset + jitter(), radius - overshoot]],
  ]

  const main: string[] = []
  const faint: string[] = []
  sides.forEach(([from, to], i) => {
    main.push(ribbon(wobblyLine(from, to, wobble, random), strokeWidth, random))
    if (tiny) return
    // Nét phụ mảnh chạy sát vào phía trong, chỉ phủ một đoạn của cạnh.
    const start = large ? 0.04 + random() * 0.25 : 0.03 + random() * 0.08
    const end = large ? start + 0.22 + random() * 0.2 : 0.84 + random() * 0.12
    const shift = (i < 2 ? 1 : -1) * (large ? 1 : 1.3)
    const horizontal = i % 2 === 0
    const at = (t: number): Point => [
      from[0] + (to[0] - from[0]) * t + (horizontal ? 0 : -shift),
      from[1] + (to[1] - from[1]) * t + (horizontal ? shift : 0),
    ]
    faint.push(ribbon(wobblyLine(at(start), at(end), wobble, random), 1.1, random))
  })

  const corners: [number, number, number, number][] = [
    [radius, radius, Math.PI, 1.5 * Math.PI],
    [width - radius, radius, 1.5 * Math.PI, 2 * Math.PI],
    [width - radius, height - radius, 0, 0.5 * Math.PI],
    [radius, height - radius, 0.5 * Math.PI, Math.PI],
  ]
  for (const [cx, cy, start, end] of corners) {
    main.push(ribbon(cornerArc(cx, cy, radius - inset, start - 0.1, end + 0.1, random), strokeWidth * 1.05, random))
  }

  const fullWidth = width + SKETCH_OUTSET * 2
  const fullHeight = height + SKETCH_OUTSET * 2
  const faintPath = faint.length ? `<path d="${faint.join('')}" fill="${color}" fill-opacity=".6"/>` : ''
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${fullWidth}" height="${fullHeight}" viewBox="${-SKETCH_OUTSET} ${-SKETCH_OUTSET} ${fullWidth} ${fullHeight}"><path d="${main.join('')}" fill="${color}"/>${faintPath}</svg>`
}

export function sketchImageUrl(width: number, height: number, color: string): string {
  return `url("data:image/svg+xml,${encodeURIComponent(buildSketchSvg(width, height, color))}")`
}
