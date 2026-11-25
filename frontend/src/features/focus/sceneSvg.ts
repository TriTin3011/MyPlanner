import type { PlantKind, PotColor } from '../../api/types'
import type { OpeningStep } from './focusSession'

// Hình vẽ của tab Tập trung, viết bằng hàm thuần trả về chuỗi SVG (giống "view template" phía server).
// Không có chữ trong hình: chữ nằm ở HTML phủ lên để dịch được và đọc được bằng trình đọc màn hình.
// Mọi id trong <defs> đều mang tiền tố riêng (uniqueIds) để hai SVG trên cùng trang không giẫm id của nhau.

export const VIEW_W = 680
export const VIEW_H = 440

function lg(id: string, stops: [number, string][], x2 = 1, y2 = 0) {
  return (
    `<linearGradient id="${id}" x1="0" y1="0" x2="${x2}" y2="${y2}">` +
    stops.map(([o, c]) => `<stop offset="${o}" stop-color="${c}"/>`).join('') +
    '</linearGradient>'
  )
}

function rg(id: string, stops: [number, string, number?][], cx = 0.5, cy = 0.5, r = 0.5) {
  return (
    `<radialGradient id="${id}" cx="${cx}" cy="${cy}" r="${r}">` +
    stops
      .map(([o, c, a]) => `<stop offset="${o}" stop-color="${c}"${a != null ? ` stop-opacity="${a}"` : ''}/>`)
      .join('') +
    '</radialGradient>'
  )
}

const POT_COLORS: Record<PotColor, [string[], string[]]> = {
  terra: [['#9c4a28', '#e8925f', '#d57849', '#8f4122'], ['#b85d35', '#f4a97c', '#a34e2b']],
  cream: [['#bba98c', '#f7eedd', '#e6d9c0', '#a8957a'], ['#d3c3a5', '#fffaf0', '#c4b092']],
  sage: [['#5f7f5e', '#b6d1b0', '#97b891', '#55745a'], ['#7f9f7d', '#d3e6ce', '#6e8e6c']],
  blue: [['#4f6f93', '#a9c3e0', '#8aa8c9', '#46668a'], ['#6c8db1', '#cfe0f2', '#5f80a5']],
}

export function sceneDefs(extra = '') {
  let s = '<defs>'
  for (const key of Object.keys(POT_COLORS) as PotColor[]) {
    const [b, r] = POT_COLORS[key]
    s += lg(`pot-${key}`, [[0, b[0]], [0.36, b[1]], [0.62, b[2]], [1, b[3]]])
    s += lg(`rim-${key}`, [[0, r[0]], [0.42, r[1]], [1, r[2]]])
  }
  s += rg('soilG', [[0, '#8a6040'], [1, '#4e321d']], 0.45, 0.38, 0.7)
  s += rg('soilWet', [[0, '#5d3d24'], [1, '#2f1d10']], 0.45, 0.38, 0.7)
  s += lg('leafG', [[0, '#b8d99c'], [0.45, '#6eae6b'], [1, '#3d7550']])
  s += lg('leafSun', [[0, '#a8cf83'], [0.48, '#5f9b55'], [1, '#356b43']])
  s += lg('leafDry', [[0, '#d8c28a'], [0.5, '#b39352'], [1, '#765a32']])
  s += rg('cactG', [[0, '#9fd88f'], [1, '#3d8048']], 0.4, 0.35, 0.7)
  s += rg('cactDry', [[0, '#d6c58f'], [1, '#8f7a45']], 0.4, 0.35, 0.7)
  s += lg('skinG', [[0, '#f9ddc5'], [0.5, '#eebf9e'], [1, '#d99a75']], 0, 1)
  s += lg('sleeveG', [[0, '#9cb2c8'], [0.48, '#718eaa'], [1, '#536f8d']])
  s += lg('wood', [[0, '#d1a374'], [0.5, '#ba8356'], [1, '#8d5b38']], 0, 1)
  s += lg('woodTop', [[0, '#e9c79d'], [0.52, '#c99768'], [1, '#a86d43']], 0, 1)
  s += lg('woodFace', [[0, '#ad7449'], [0.5, '#875535'], [1, '#654029']], 0, 1)
  s += lg('floor', [[0, '#b98a5f'], [1, '#8c6140']], 0, 1)
  s += lg('wall', [[0, '#f3e7d3'], [1, '#e6d4b8']], 0, 1)
  s += lg('sill', [[0, '#f7f1e6'], [1, '#d9cbb3']], 0, 1)
  s += lg('bag', [[0, '#ead7ad'], [1, '#c9ae7c']])
  s += lg('can', [[0, '#5f97b3'], [0.4, '#a8d3e6'], [1, '#4c8099']])
  s += rg('vig', [[0.52, '#28180f', 0], [1, '#28180f', 0.3]])
  s += rg('sunpatch', [[0, '#ffe9ad', 0.62], [1, '#ffe9ad', 0]])
  s += rg('lampGlow', [[0, '#ffd995', 0.58], [0.55, '#efb85f', 0.2], [1, '#efb85f', 0]])
  s += lg('glassShine', [[0, '#ffffff'], [0.45, '#ffffff'], [1, '#d6e7ef']], 0, 1)
  s +=
    '<pattern id="woodGrain" width="82" height="24" patternUnits="userSpaceOnUse"><path d="M-8 10 C12 1 28 19 50 9 S83 4 94 13 M8 22 C26 13 44 27 72 17" fill="none" stroke="#55351f" stroke-opacity=".18" stroke-width="1.4"/></pattern>'
  s +=
    '<filter id="shadow" x="-30%" y="-30%" width="160%" height="170%"><feDropShadow dx="4" dy="8" stdDeviation="6" flood-color="#302017" flood-opacity=".24"/></filter>'
  s += '<filter id="blur"><feGaussianBlur stdDeviation="7"/></filter>'
  s +=
    '<filter id="grain" x="0" y="0" width="100%" height="100%"><feTurbulence type="fractalNoise" baseFrequency=".72" numOctaves="2" seed="17" result="noise"/><feColorMatrix in="noise" type="matrix" values="1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 .09 0"/><feBlend in="SourceGraphic" in2="noise" mode="soft-light"/></filter>'
  return s + extra + '</defs>'
}

function mix(a: string, b: string, t: number) {
  const pa = [1, 3, 5].map((i) => parseInt(a.substr(i, 2), 16))
  const pb = [1, 3, 5].map((i) => parseInt(b.substr(i, 2), 16))
  return `rgb(${pa.map((v, i) => Math.round(v + (pb[i] - v) * t)).join(',')})`
}

const r1 = (n: number) => Math.round(n * 10) / 10

function leaf(x: number, y: number, rotate: number, scale: number, dry: boolean, fill = 'leafG') {
  const vein = dry ? '#755a32' : '#3f7047'
  return `<g transform="translate(${x} ${y}) rotate(${rotate}) scale(${scale})"><path d="M0 0 C7 -15 24 -16 38 -3 C29 11 12 15 0 0Z" fill="url(#${dry ? 'leafDry' : fill})" stroke="${vein}" stroke-opacity=".5" stroke-width="1.1"/><path class="leaf-midrib" d="M3 0 Q20 -2 34 -3" fill="none" stroke="${vein}" stroke-opacity=".55" stroke-width="1"/></g>`
}

// Cây: grow trong [0, 1]; dry = héo (lá vàng nâu, rũ xuống, không có hoa).
export function plant(sy: number, grow: number, kind: PlantKind, dry = false) {
  const g = Math.max(0, Math.min(1, grow))
  if (g <= 0) return ''
  const wilt = dry ? ' plant-wilted' : ''
  const tilt = dry ? 13 : 0
  let s = `<g class="plant-${kind}${wilt}" transform="translate(0 ${r1(sy)}) scale(${r1(g)}) rotate(${tilt})">`

  if (kind === 'cactus') {
    const fill = dry ? 'cactDry' : 'cactG'
    const edge = dry ? '#776039' : '#3e744b'
    s += `<g class="${dry ? '' : 'focus-sway'}"><path d="M-20 0 C-22 -20 -20 -70 -13 -88 C-6 -104 9 -104 16 -88 C23 -65 22 -22 18 0Z" fill="url(#${fill})" stroke="${edge}" stroke-width="1.5"/>`
    s += '<path d="M-7 -4 C-9 -35 -8 -75 -4 -94 M7 -4 C10 -38 9 -73 5 -94" fill="none" stroke="#d9edc0" stroke-opacity=".36" stroke-width="2"/>'
    if (g > 0.42) {
      s += `<path d="M-17 -44 C-33 -46 -36 -61 -32 -70 C-29 -77 -21 -74 -22 -66 C-23 -59 -20 -56 -14 -57" fill="none" stroke="url(#${fill})" stroke-width="12" stroke-linecap="round"/><path d="M18 -35 C34 -37 37 -50 34 -59 C31 -66 24 -63 25 -55" fill="none" stroke="url(#${fill})" stroke-width="11" stroke-linecap="round"/>`
    }
    for (const [x, y] of [[-12, -20], [8, -30], [-8, -50], [11, -65], [-5, -81]]) {
      s += `<path d="M${x - 3} ${y} h6 M${x} ${y - 3} v6" stroke="#f2e8ce" stroke-opacity=".72" stroke-width="1"/>`
    }
    if (g > 0.82 && !dry) {
      s += '<g class="cactus-flower" transform="translate(0 -101)">'
      for (let i = 0; i < 6; i++) s += `<ellipse cy="-7" rx="4.5" ry="9" transform="rotate(${i * 60})" fill="#e98aa5"/>`
      s += '<circle r="3.5" fill="#f4c56a"/></g>'
    }
    return s + '</g></g>'
  }

  if (kind === 'sunflower') {
    const stem = dry ? '#8a6a35' : '#477d45'
    s += `<path d="M0 2 C${dry ? 7 : -4} -36 ${dry ? 18 : 2} -76 ${dry ? 22 : 0} -106" fill="none" stroke="${stem}" stroke-width="8" stroke-linecap="round"/>`
    s += `<g class="${dry ? '' : 'focus-sway'}">`
    s += leaf(-2, -34, dry ? 135 : 174, 1.25, dry, 'leafSun')
    s += leaf(1, -54, dry ? 50 : 8, 1.15, dry, 'leafSun')
    s += leaf(3, -76, dry ? 128 : 166, 0.95, dry, 'leafSun')
    if (!dry && g > 0.7) {
      const bloom = r1(Math.max(0.35, (g - 0.62) / 0.38))
      s += `<g class="sunflower-head" transform="translate(0 -112) scale(${bloom})">`
      for (let i = 0; i < 16; i++) s += `<ellipse cy="-22" rx="6.8" ry="17" transform="rotate(${i * 22.5})" fill="${i % 2 ? '#eeb332' : '#f5ca4d'}"/>`
      s += '<circle r="17" fill="#6b4327"/><circle r="12" fill="#8e6335"/><path d="M-9 -5 q9 -8 18 0 M-10 4 q10 -7 20 0" fill="none" stroke="#4d321f" stroke-width="1.4" stroke-linecap="round"/></g>'
    } else if (dry) {
      s += '<g transform="translate(23 -104) rotate(34)"><ellipse cy="-12" rx="21" ry="14" fill="#8d7041"/><circle cy="-12" r="13" fill="#60462b"/></g>'
    }
    return s + '</g></g>'
  }

  const stem = dry ? '#806033' : '#427846'
  s += `<path d="M0 2 C-4 -28 7 -56 ${dry ? 18 : 1} -92 M1 -34 L-25 -54 M3 -49 L28 -69 M1 -65 L-18 -82" fill="none" stroke="${stem}" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>`
  s += `<g class="${dry ? '' : 'focus-sway'}">`
  const basilLeaves: [number, number, number, number][] = dry
    ? [[-2, -22, 128, .9], [3, -34, 52, .85], [-11, -49, 122, .8], [13, -60, 58, .72], [-7, -72, 116, .65], [10, -82, 64, .58]]
    : [[-2, -21, 167, .95], [2, -31, 12, .92], [-22, -51, 190, .78], [24, -65, -7, .76], [-15, -77, 174, .66], [13, -87, 4, .62], [-2, -92, 168, .5]]
  for (const [x, y, r, sc] of basilLeaves) s += leaf(x, y, r, sc, dry)
  if (!dry && g > 0.78) {
    s += '<g class="basil-flower" transform="translate(1 -99)"><path d="M0 3 V-27" stroke="#557a4f" stroke-width="2"/>'
    for (let i = 0; i < 5; i++) s += `<g transform="translate(0 ${-i * 6})"><circle cx="-4" r="3" fill="#a98ac4"/><circle cx="4" cy="-2" r="3.2" fill="#c3a6da"/></g>`
    s += '</g>'
  }
  return s + '</g></g>'
}

export interface PotOptions {
  color?: PotColor
  soil?: number
  wet?: boolean
  seed?: boolean
  grow?: number
  kind?: PlantKind
  dry?: boolean
}

// Bộ đếm clipPath trong một lần dựng cảnh; đặt lại ở đầu mỗi hàm dựng cảnh.
let clipSeq = 0

export function pot(cx: number, cy: number, sc: number, o: PotOptions = {}) {
  const id = `clip${++clipSeq}`
  const c = o.color ?? 'terra'
  const l = o.soil ?? 0
  const sy = (1 - l) * 22
  let g = `<g class="focus-pot" transform="translate(${r1(cx)} ${r1(cy)}) scale(${sc})">`
  g += '<ellipse cx="6" cy="99" rx="82" ry="18" fill="#39261d" opacity=".18"/>'
  g += `<path d="M-90 0 L-62 84 A62 18 0 0 0 62 84 L90 0Z" fill="url(#pot-${c})"/>`
  g += '<path d="M-82 19 Q0 52 82 19" fill="none" stroke="#5e4233" stroke-opacity=".12" stroke-width="5"/>'
  g += '<path d="M-65 19 C-58 42 -50 65 -39 76" fill="none" stroke="#fff7e8" stroke-opacity=".34" stroke-width="8" stroke-linecap="round"/>'
  g += '<path d="M-50 21 C-45 38 -39 48 -34 55" fill="none" stroke="#ffffff" stroke-opacity=".2" stroke-width="3" stroke-linecap="round"/>'
  g += `<ellipse rx="92" ry="39" fill="url(#rim-${c})"/>`
  g += '<ellipse cy="4" rx="86" ry="34" fill="none" stroke="#5c4134" stroke-opacity=".24" stroke-width="5"/>'
  g += '<path d="M-67 -14 Q-28 -31 12 -27" fill="none" stroke="#fff" stroke-opacity=".32" stroke-width="5" stroke-linecap="round"/>'
  g += `<clipPath id="${id}"><ellipse rx="78" ry="31"/></clipPath>`
  g += `<ellipse rx="78" ry="31" fill="#3e2014"/><ellipse cx="0" cy="-8" rx="74" ry="22" fill="#5b2f1c" opacity=".55" clip-path="url(#${id})"/>`
  if (l > 0) {
    g += `<g clip-path="url(#${id})"><ellipse cx="0" cy="${r1(sy + 4)}" rx="${r1(80 - (1 - l) * 10)}" ry="${r1(32 - (1 - l) * 4)}" fill="url(#${o.wet ? 'soilWet' : 'soilG'})"/>`
    g += [
      [-30, 4],
      [22, -6],
      [40, 10],
      [-12, 14],
      [8, 2],
      [-48, -4],
    ]
      .map(([x, y], i) => `<circle cx="${x}" cy="${r1(sy + y)}" r="${i % 2 ? 2 : 3}" fill="${o.wet ? '#24160b' : '#3e2716'}" opacity=".56"/>`)
      .join('')
    if (o.wet) g += `<ellipse cx="-20" cy="${r1(sy - 4)}" rx="18" ry="5" fill="#9ac7dc" opacity=".35"/>`
    g += '</g>'
  }
  if (o.seed) g += `<ellipse cx="6" cy="${r1(sy)}" rx="6" ry="4" fill="#ecd9a2" stroke="#8a6a32" stroke-width="1.2"/>`
  g += plant(sy + 2, o.grow ?? 0, o.kind ?? 'basil', o.dry)
  return g + '</g>'
}

type Pose = 'open' | 'pinch' | 'grip' | 'point'

// Tay đưa lên từ góc dưới: side -1 là tay trái, 1 là tay phải.
function hand(side: -1 | 1, tx: number, ty: number, pose: Pose = 'open', sc = 1) {
  const ox = side < 0 ? -40 : 720
  const oy = 480
  const a = (Math.atan2(tx - ox, -(ty - oy)) * 180) / Math.PI
  const th = -side
  const base = { open: 52, pinch: 34, grip: 20, point: 20 }[pose]
  const mult = pose === 'point' ? [0.7, 0.8, 0.8, 2.6] : [0.76, 0.93, 1, 0.88]
  let xs = [-27, -9, 9, 27]
  if (side > 0) xs = [...xs].reverse()
  let g = `<g transform="translate(${r1(tx)} ${r1(ty)}) rotate(${r1(a)}) scale(${sc})" filter="url(#shadow)">`
  g += '<path d="M-46 102 Q-42 78 -31 70 H31 Q43 80 46 102 L70 430 H-70Z" fill="url(#sleeveG)"/>'
  g += '<path d="M-31 132 Q-7 176 -27 286" stroke="#405e7b" stroke-width="3" fill="none" opacity=".28"/>'
  g += '<path d="M-49 98 Q0 112 49 98 L47 118 Q0 130 -47 118Z" fill="#f1e9da" stroke="#bdb4a5" stroke-opacity=".65" stroke-width="1.5"/>'
  g += '<rect x="-29" y="50" width="58" height="61" rx="24" fill="url(#skinG)" stroke="#ad7658" stroke-opacity=".55" stroke-width="1.4"/>'
  for (let i = 0; i < 4; i++) {
    const fl = base * mult[i]
    g += `<rect x="${xs[i] - 8.7}" y="${r1(-5 - fl)}" width="17.4" height="${r1(fl + 24)}" rx="8.7" fill="url(#skinG)" stroke="#ad7658" stroke-opacity=".52" stroke-width="1.3"/>`
    g += `<ellipse cx="${xs[i]}" cy="${r1(-1 - fl)}" rx="5.2" ry="3.7" fill="#f8e2d2" opacity=".9"/>`
  }
  g += '<rect x="-36" y="-8" width="72" height="80" rx="29" fill="url(#skinG)" stroke="#ad7658" stroke-opacity=".55" stroke-width="1.4"/>'
  g += '<path d="M-22 5 Q0 0 22 5" stroke="#a66d51" stroke-opacity=".32" stroke-width="1.4" fill="none"/>'
  g += `<ellipse cx="${th * 38}" cy="29" rx="12" ry="29" transform="rotate(${th * -34} ${th * 38} 29)" fill="url(#skinG)" stroke="#ad7658" stroke-opacity=".55" stroke-width="1.4"/>`
  return g + '</g>'
}

function table() {
  let s = `<rect width="${VIEW_W}" height="${VIEW_H}" fill="url(#wood)"/>`
  for (let k = -6; k <= 6; k++) {
    s += `<line x1="${340 + k * 150}" y1="440" x2="${340 + k * 82}" y2="0" stroke="#6e4426" stroke-opacity=".22" stroke-width="2"/>`
  }
  s += '<path d="M60 120 q40 -6 80 4 M460 300 q50 -8 100 6 M200 380 q40 -6 70 2" stroke="#6e4426" stroke-opacity=".18" stroke-width="2" fill="none"/>'
  return s
}

const vignette = () => `<rect width="${VIEW_W}" height="${VIEW_H}" fill="url(#vig)" pointer-events="none"/>`

function particles(x: number, y: number, color: string, r: number) {
  return [0, 1, 2, 3, 4, 5]
    .map(
      (i) =>
        `<circle class="focus-fall" style="animation-delay:${r1(i * 0.18)}s" cx="${x + ((i % 3) - 1) * 7}" cy="${y + (i % 2) * 8}" r="${r - (i % 2)}" fill="${color}"/>`,
    )
    .join('')
}

function can(cx: number, cy: number) {
  const t = (-30 * Math.PI) / 180
  const lx = -150
  const ly = -44
  const tip = { x: cx + lx * Math.cos(t) - ly * Math.sin(t), y: cy + lx * Math.sin(t) + ly * Math.cos(t) }
  const svg =
    `<g transform="translate(${cx} ${cy}) rotate(-30)" filter="url(#shadow)">` +
    '<path d="M-58 4 L-146 -40 L-142 -50 L-54 -12Z" fill="url(#can)" stroke="#2f5a6e" stroke-width="2"/>' +
    '<ellipse cx="-148" cy="-45" rx="9" ry="13" transform="rotate(-25 -148 -45)" fill="#4c8099" stroke="#2f5a6e" stroke-width="2"/>' +
    '<path d="M40 -30 C100 -40 100 50 40 40" fill="none" stroke="#3d6f86" stroke-width="12" stroke-linecap="round"/>' +
    '<rect x="-62" y="-42" width="110" height="96" rx="22" fill="url(#can)" stroke="#2f5a6e" stroke-width="2"/>' +
    '<ellipse cx="-6" cy="-42" rx="40" ry="11" fill="#3d6f86" stroke="#2f5a6e" stroke-width="2"/>' +
    '<rect x="-44" y="-20" width="14" height="60" rx="7" fill="#fff" opacity=".35"/></g>'
  return { svg, tip }
}

function water(tip: { x: number; y: number }) {
  return [0, 1, 2, 3, 4]
    .map(
      (i) =>
        `<ellipse class="focus-fall" style="animation-delay:${r1(i * 0.2)}s" cx="${r1(tip.x + ((i % 3) - 1) * 6)}" cy="${r1(tip.y + 8 + (i % 2) * 10)}" rx="3" ry="6" fill="#7cc4e6"/>`,
    )
    .join('')
}

const SKY_KEYS: [number, string, string][] = [
  [0, '#18203a', '#354263'],
  [0.18, '#766d91', '#efb99c'],
  [0.32, '#7fb6cf', '#e7d9b7'],
  [0.64, '#78abc5', '#ead3a7'],
  [0.8, '#6b5879', '#e7a47d'],
  [1, '#18203a', '#354263'],
]

function skyAt(frac: number) {
  const hi = Math.max(1, SKY_KEYS.findIndex(([at]) => at >= frac))
  const a = SKY_KEYS[hi - 1]
  const b = SKY_KEYS[hi]
  const t = (frac - a[0]) / (b[0] - a[0])
  return { top: mix(a[1], b[1], t), bottom: mix(a[2], b[2], t) }
}

function cloud(x: number, y: number, sc: number, delay: number, opacity: number) {
  return `<g transform="translate(${x} ${y}) scale(${sc})" opacity="${r1(opacity)}"><g class="focus-cloud" style="animation-delay:${delay}s"><ellipse cx="0" cy="7" rx="36" ry="11" fill="#fff4e6"/><circle cx="-20" r="16" fill="#fff8ed"/><circle cx="3" cy="-8" r="22" fill="#fffaf1"/><circle cx="26" cy="2" r="15" fill="#f3e8dd"/></g></g>`
}

// t: số ngày trong cảnh (số thực). Phần lẻ quyết định vị trí mặt trời/mặt trăng và màu trời.
function windowScene(t: number) {
  const frac = ((t % 1) + 1) % 1
  const day = Math.max(0, Math.sin(((frac - 0.14) / 0.72) * Math.PI))
  const night = 1 - day
  const sky = skyAt(frac)
  const orbit = Math.max(0, Math.min(1, (frac - 0.12) / 0.76))
  const sx = 86 + 520 * orbit
  const sy = 143 - Math.sin(orbit * Math.PI) * 92
  const moonOrbit = (frac + 0.5) % 1
  const mx = 86 + 520 * moonOrbit
  const my = 138 - Math.sin(moonOrbit * Math.PI) * 82
  const warm = 1 - Math.min(1, Math.abs(frac - 0.79) * 8)
  let s = `<rect width="${VIEW_W}" height="${VIEW_H}" fill="url(#wall)"/>`
  s += '<rect width="680" height="236" fill="#d5ae82" opacity=".08" filter="url(#grain)"/>'
  s += '<g clip-path="url(#glass)"><rect x="66" width="548" height="208" fill="url(#sky)"/>'
  s += `<g opacity="${r1(night)}">` + [
    [105, 30, 1.4], [151, 68, 1], [209, 24, 1.8], [274, 52, 1.1], [393, 27, 1.4], [468, 67, 1.2], [536, 24, 1.7], [582, 81, 1],
  ].map(([x, y, r]) => `<circle class="focus-star" cx="${x}" cy="${y}" r="${r}" fill="#fff7dc"/>`).join('') + '</g>'
  s += `<g opacity="${r1(day)}"><circle cx="${r1(sx)}" cy="${r1(sy)}" r="34" fill="#ffd889" opacity=".18"/><circle cx="${r1(sx)}" cy="${r1(sy)}" r="22" fill="#ffe5a4"/></g>`
  s += `<g opacity="${r1(night)}"><circle cx="${r1(mx)}" cy="${r1(my)}" r="20" fill="#f1e9d4"/><circle cx="${r1(mx + 8)}" cy="${r1(my - 6)}" r="18" fill="${sky.top}"/></g>`
  s += cloud(160, 60, .64, -3.2, .28 + day * .42) + cloud(458, 80, .5, -8.5, .22 + day * .38)
  s += `<path d="M66 166 Q126 112 190 143 T305 132 T426 138 T614 116 V208 H66Z" fill="${mix('#303b55', '#82977a', day)}"/>`
  s += `<path d="M66 184 Q146 143 226 171 T374 158 T493 166 T614 148 V208 H66Z" fill="${mix('#26344a', '#5f8060', day)}"/>`
  s += `<path d="M66 196 Q140 172 220 192 T374 180 T510 189 T614 174 V208 H66Z" fill="${mix('#202c3e', '#45684e', day)}"/>`
  for (const [x, h] of [[94, 23], [121, 17], [505, 22], [538, 30], [568, 19]]) {
    s += `<path d="M${x} 195 l9 -${h} l9 ${h}Z" fill="${mix('#1d2a39', '#355b46', day)}" opacity=".9"/>`
  }
  for (const [x, y, delay] of [[118, 172, -1.3], [150, 184, -2.8], [524, 168, -4.1], [558, 181, -5.6]]) {
    s += `<g opacity="${r1(night * .85)}"><circle class="focus-firefly" style="animation-delay:${delay}s" cx="${x}" cy="${y}" r="2.4" fill="#f6d978"/></g>`
  }
  s += '</g>'
  s += '<rect x="62" y="-8" width="556" height="220" rx="4" fill="none" stroke="#f4ebdc" stroke-width="15"/><path d="M340 0 V205 M69 101 H611" stroke="#e7dcc9" stroke-width="9"/>'
  s += '<path d="M75 9 L112 9 L222 198 L184 198Z" fill="url(#glassShine)" opacity=".1"/>'
  s += '<rect x="48" y="202" width="584" height="16" rx="5" fill="url(#sill)"/><path d="M55 211 H625" stroke="#a99577" stroke-opacity=".3" stroke-width="2"/>'
  s += '<path d="M-10 234 H690 L704 440 H-24Z" fill="url(#woodTop)"/><path d="M-10 234 H690" stroke="#8e5e3c" stroke-opacity=".62" stroke-width="4"/>'
  for (let k = -5; k <= 5; k++) s += `<line x1="${340 + k * 70}" y1="234" x2="${340 + k * 96}" y2="440" stroke="#70462d" stroke-opacity=".18" stroke-width="2"/>`
  s += '<path d="M80 298 Q200 278 320 300 T610 286 M30 396 Q170 376 310 397 T650 383" fill="none" stroke="#6f462d" stroke-opacity=".15" stroke-width="2"/>'
  s += `<path d="M126 218 L492 218 L583 440 L36 440Z" fill="url(#sunpatch)" opacity="${r1(day * .72 + warm * .18)}"/>`
  for (const [x, y, r, delay] of [[205, 260, 2, -1], [265, 304, 1.5, -3], [442, 279, 1.8, -4.5], [500, 344, 1.2, -2]]) {
    s += `<g opacity="${r1(.18 + day * .44)}"><circle class="focus-mote" style="animation-delay:${delay}s" cx="${x}" cy="${y}" r="${r}" fill="#ffe9b0"/></g>`
  }
  s += '<g transform="translate(112 370) rotate(-8)" filter="url(#shadow)"><rect x="-82" y="-51" width="164" height="102" rx="7" fill="#f7f0df"/><path d="M0 -49 V49" stroke="#d1c1a8" stroke-width="3"/>'
  s += [-29, -13, 3, 19, 35].map((y) => `<path d="M-70 ${y} H-13 M13 ${y} H70" stroke="#b6c9d2" stroke-opacity=".72" stroke-width="1.6"/>`).join('')
  s += '<path d="M-18 39 L91 2" stroke="#d7a642" stroke-width="8" stroke-linecap="round"/><path d="M78 6 L94 0" stroke="#675647" stroke-width="8" stroke-linecap="round"/></g>'
  s += '<g transform="translate(612 390)" filter="url(#shadow)"><path d="M-27 -30 L-22 27 Q0 35 22 27 L27 -30Z" fill="#e9ece8"/><path d="M27 -15 C48 -16 47 14 23 13" fill="none" stroke="#8d9a99" stroke-width="6"/><ellipse cy="-30" rx="27" ry="8" fill="#765039"/><ellipse cy="-31" rx="19" ry="5" fill="#4f3425"/><path d="M-17 -21 V14" stroke="#fff" stroke-opacity=".42" stroke-width="5" stroke-linecap="round"/></g>'
  s += `<rect width="680" height="440" fill="#d5835d" opacity="${r1(warm * .06)}" pointer-events="none"/>`
  const extra = lg('sky', [[0, sky.top], [1, sky.bottom]], 0, 1) + '<clipPath id="glass"><rect x="66" y="0" width="548" height="208"/></clipPath>'
  return { svg: s, day, extra }
}

const nightShade = (day: number) =>
  `<rect width="${VIEW_W}" height="${VIEW_H}" fill="#101a3a" opacity="${((1 - day) * 0.42).toFixed(2)}" pointer-events="none"/>`

// Đổi id="x" và url(#x) thành id có tiền tố, để nhiều SVG trên một trang không trùng id.
export function uniqueIds(markup: string, prefix: string) {
  return markup.replace(/id="([^"]+)"/g, `id="${prefix}$1"`).replace(/url\(#([^)]+)\)/g, `url(#${prefix}$1)`)
}

const P = { x: 340, y: 236, s: 1.1 }

export interface SceneLook {
  plantKind: PlantKind
  potColor: PotColor
}

// Một động tác mở đầu.
export function openingScene(step: OpeningStep, look: SceneLook) {
  clipSeq = 0
  const color = look.potColor
  let body = ''
  let extra = ''
  switch (step) {
    case 'soil':
      body =
        table() +
        pot(P.x, P.y, P.s, { color, soil: 0.6 }) +
        particles(372, 150, '#5a3a22', 5) +
        '<g transform="translate(470 96) rotate(-38)" filter="url(#shadow)"><path d="M-70 -80 H70 L64 80 H-64Z" fill="url(#bag)" stroke="#8a6d43" stroke-width="2.5"/><path d="M-70 -80 L-60 -96 H60 L70 -80" fill="#d6be8c" stroke="#8a6d43" stroke-width="2.5"/><path d="M-14 34 q14 -22 28 0 q-14 10 -28 0" fill="#7cc07a"/></g>' +
        hand(1, 540, 200, 'grip') +
        hand(-1, 262, 262, 'open')
      break
    case 'seed':
      body =
        table() +
        pot(P.x, P.y, P.s, { color, soil: 0.6, seed: true }) +
        '<ellipse class="focus-fall" cx="352" cy="190" rx="6" ry="4" fill="#ecd9a2" stroke="#8a6a32" stroke-width="1.2"/>' +
        hand(1, 360, 168, 'pinch') +
        hand(-1, 170, 330, 'grip')
      break
    case 'cover':
      body =
        table() +
        pot(P.x, P.y, P.s, { color, soil: 0.85 }) +
        '<g class="focus-bob">' +
        hand(-1, 292, 232, 'open') +
        hand(1, 392, 232, 'open') +
        '</g>'
      break
    case 'water': {
      const c = can(500, 140)
      body =
        table() +
        pot(P.x, P.y, P.s, { color, soil: 0.85, wet: true }) +
        water(c.tip) +
        c.svg +
        hand(1, 575, 180, 'grip') +
        hand(-1, 250, 270, 'open')
      break
    }
    case 'press':
      body =
        table() +
        pot(P.x, P.y, P.s, { color, soil: 0.85, wet: true }) +
        '<g class="focus-press">' +
        hand(-1, 305, 238, 'grip') +
        hand(1, 380, 238, 'grip') +
        '</g>'
      break
    case 'carry': {
      const w = windowScene(0.18)
      extra = w.extra
      body = w.svg + pot(340, 290, 1, { color, soil: 0.85, wet: true }) + hand(-1, 236, 318, 'grip') + hand(1, 444, 318, 'grip')
      break
    }
  }
  return sceneDefs(extra) + body + vignette()
}

// Cảnh lúc cây đang lớn: p là phần thời gian đã trôi, days là số ngày giả lập.
export function growingScene(p: number, days: number, watering: boolean, look: SceneLook) {
  clipSeq = 0
  const w = windowScene(p * days + 0.18)
  let body = w.svg + pot(340, 290, 1, { color: look.potColor, kind: look.plantKind, soil: 0.85, grow: Math.min(1, p * 1.06), wet: watering })
  if (watering) {
    const c = can(520, 190)
    body += water(c.tip) + c.svg + hand(1, 592, 232, 'grip')
  }
  return sceneDefs(w.extra) + body + nightShade(w.day) + vignette()
}

// Kết thúc: cây lớn đủ (done) hoặc héo ở mức đã lớn được (wilted).
export function endScene(outcome: 'done' | 'wilted', grow: number, look: SceneLook) {
  clipSeq = 0
  const w = windowScene(outcome === 'done' ? 0.25 : 0.7)
  const dry = outcome === 'wilted'
  const body = w.svg + pot(340, 290, 1, { color: look.potColor, kind: look.plantKind, soil: 0.85, grow: dry ? Math.max(0.3, grow) : 1, dry })
  return sceneDefs(w.extra) + body + nightShade(w.day) + vignette()
}

// ---------- Kệ ba tầng (3 + 4 + 5 = 12 chỗ) ----------

export const SHELF_TIERS = [
  { y: 130, x0: 170, x1: 510, count: 3 },
  { y: 225, x0: 125, x1: 555, count: 4 },
  { y: 320, x0: 80, x1: 600, count: 5 },
] as const
export const SHELF_SIZE = 12
const SHELF_SCALE = 0.4

function shelfPlant(kind: PlantKind) {
  if (kind === 'cactus') {
    return '<g class="focus-sway plant-cactus"><path d="M-18 0 C-19 -31 -18 -73 -10 -91 C-4 -103 9 -103 15 -90 C22 -65 20 -28 18 0Z" fill="url(#cactG)"/><path d="M-16 -43 C-31 -44 -33 -61 -27 -67 M18 -35 C31 -36 34 -49 30 -57" fill="none" stroke="#57905c" stroke-width="11" stroke-linecap="round"/><path d="M-5 -5 V-91 M7 -5 V-88" stroke="#d9edc0" stroke-opacity=".35" stroke-width="2"/><g transform="translate(0 -100)"><ellipse cy="-7" rx="5" ry="9" fill="#e98aa5"/><ellipse cy="-7" rx="5" ry="9" transform="rotate(72)" fill="#e98aa5"/><ellipse cy="-7" rx="5" ry="9" transform="rotate(144)" fill="#e98aa5"/><circle r="4" fill="#f4c56a"/></g></g>'
  }
  if (kind === 'sunflower') {
    let s = '<g class="focus-sway plant-sunflower"><path d="M0 2 Q-5 -48 0 -102" stroke="#477d45" stroke-width="7" fill="none" stroke-linecap="round"/><path d="M-2 -35 q-35 -25 -45 4 q24 18 45 3 M2 -59 q31 -25 42 2 q-22 18 -42 5" fill="url(#leafSun)"/>'
    s += '<g transform="translate(0 -111)">'
    for (let i = 0; i < 10; i++) s += `<ellipse cy="-19" rx="7" ry="15" transform="rotate(${i * 36})" fill="${i % 2 ? '#edb335' : '#f5ca4d'}"/>`
    return s + '<circle r="15" fill="#704727"/><circle r="9" fill="#94683a"/></g></g>'
  }
  return '<g class="focus-sway plant-basil"><path d="M0 2 Q-4 -42 0 -87 M0 -34 L-25 -54 M1 -52 L25 -70" stroke="#427846" stroke-width="5" fill="none" stroke-linecap="round"/><g fill="url(#leafG)"><ellipse cx="-24" cy="-52" rx="24" ry="11" transform="rotate(18 -24 -52)"/><ellipse cx="24" cy="-68" rx="24" ry="11" transform="rotate(-18 24 -68)"/><ellipse cx="-17" cy="-76" rx="21" ry="10" transform="rotate(15 -17 -76)"/><ellipse cx="15" cy="-86" rx="19" ry="9" transform="rotate(-13 15 -86)"/></g><g class="basil-flower" fill="#b79acb"><circle cx="-4" cy="-96" r="4"/><circle cx="4" cy="-102" r="4"/><circle cx="-3" cy="-109" r="3.5"/></g></g>'
}

function shelfPot(cx: number, cy: number, color: PotColor, kind: PlantKind) {
  return `<g class="focus-pot" transform="translate(${r1(cx)} ${r1(cy)}) scale(${SHELF_SCALE})"><ellipse cx="5" cy="98" rx="82" ry="17" fill="#34231b" opacity=".2"/><path d="M-88 0 L-61 83 Q0 101 61 83 L88 0Z" fill="url(#pot-${color})"/><path d="M-63 18 Q-50 58 -38 74" fill="none" stroke="#fff" stroke-opacity=".3" stroke-width="7" stroke-linecap="round"/><ellipse rx="91" ry="38" fill="url(#rim-${color})"/><ellipse cy="2" rx="77" ry="29" fill="url(#soilG)"/><path d="M-62 -13 Q-25 -29 10 -26" fill="none" stroke="#fff" stroke-opacity=".3" stroke-width="5" stroke-linecap="round"/>${shelfPlant(kind)}</g>`
}

// Toạ độ tâm miệng chậu của chỗ thứ slot (0..11), trong hệ 680×440.
export function slotPosition(slot: number) {
  let rest = slot
  for (const tier of SHELF_TIERS) {
    if (rest < tier.count) {
      const step = (tier.x1 - tier.x0) / tier.count
      return { x: tier.x0 + step * (rest + 0.5), y: tier.y - 12 - 84 * SHELF_SCALE, baseY: tier.y - 12 }
    }
    rest -= tier.count
  }
  return { x: 0, y: 0, baseY: 0 }
}

export interface ShelfPotLook extends SceneLook {
  slot: number
}

// nextSlot: chỗ trống kế tiếp vẽ nét đứt (null khi kệ này đã đầy hoặc không phải kệ mới nhất).
export function shelfScene(pots: ShelfPotLook[], nextSlot: number | null) {
  clipSeq = 0
  let s = `<rect width="${VIEW_W}" height="302" fill="url(#wall)"/>`
  s += '<path d="M0 0 H86 V302 H0Z" fill="#c9b89e" opacity=".22"/><path d="M86 0 V302" stroke="#a99880" stroke-opacity=".42" stroke-width="3"/>'
  s += '<rect width="680" height="302" fill="#ddc8aa" opacity=".06" filter="url(#grain)"/>'
  s += '<rect x="0" y="292" width="680" height="148" fill="url(#floor)"/>'
  for (let k = -6; k <= 6; k++) {
    s += `<line x1="${340 + k * 140}" y1="440" x2="${340 + k * 95}" y2="292" stroke="#5e3c22" stroke-opacity=".18" stroke-width="2"/>`
  }
  s += '<rect x="0" y="286" width="680" height="10" fill="#f3eadb"/><path d="M0 286 H680" stroke="#aa977e" stroke-opacity=".35" stroke-width="2"/>'
  s += '<ellipse cx="340" cy="407" rx="296" ry="24" fill="#342219" opacity=".14"/>'
  s += '<ellipse cx="340" cy="409" rx="210" ry="21" fill="#c68868" opacity=".2"/><path d="M170 405 Q340 370 510 405 Q340 438 170 405Z" fill="#dfb49b" opacity=".18"/>'
  s += '<g><ellipse class="shelf-lamp-glow" cx="612" cy="105" rx="93" ry="104" fill="url(#lampGlow)" filter="url(#blur)"/><path d="M621 73 V269" stroke="#6f6257" stroke-width="7" stroke-linecap="round"/><path d="M577 84 Q621 45 665 84 L651 121 H591Z" fill="#d9a85e"/><path d="M590 121 H652" stroke="#886642" stroke-width="3"/><ellipse cx="621" cy="270" rx="38" ry="9" fill="#66564b"/></g>'
  s += '<path d="M104 100 V405 M576 100 V405" stroke="#674027" stroke-opacity=".2" stroke-width="24"/>'
  s += '<path d="M105 96 V404 M575 96 V404" stroke="url(#woodFace)" stroke-width="18"/>'
  s += '<path d="M111 101 V398 M581 101 V398" stroke="#f5d1a5" stroke-opacity=".16" stroke-width="3"/>'
  let slot = 0
  for (const tier of SHELF_TIERS) {
    const d = 26
    s += `<path d="M${tier.x0 - 5} ${tier.y + 17} H${tier.x1 + 5} L${tier.x1 - 12} ${tier.y - d + 15} H${tier.x0 + 12}Z" fill="#3b261c" opacity=".14"/>`
    s += `<path d="M${tier.x0} ${tier.y} H${tier.x1} L${tier.x1 - 18} ${tier.y - d} H${tier.x0 + 18}Z" fill="url(#woodTop)" stroke="#70472e" stroke-opacity=".58" stroke-width="1.5"/>`
    s += `<path class="wood-grain" d="M${tier.x0} ${tier.y} H${tier.x1} L${tier.x1 - 18} ${tier.y - d} H${tier.x0 + 18}Z" fill="url(#woodGrain)"/>`
    s += `<rect x="${tier.x0}" y="${tier.y}" width="${tier.x1 - tier.x0}" height="18" rx="2" fill="url(#woodFace)"/>`
    s += `<path d="M${tier.x0 + 8} ${tier.y + 4} H${tier.x1 - 8}" stroke="#f1c796" stroke-opacity=".22" stroke-width="2"/>`
    for (let i = 0; i < tier.count; i++, slot++) {
      const pos = slotPosition(slot)
      const p = pots.find((x) => x.slot === slot)
      if (p) {
        s += shelfPot(pos.x, pos.y, p.potColor, p.plantKind)
      } else if (slot === nextSlot) {
        s += `<ellipse cx="${r1(pos.x)}" cy="${pos.baseY}" rx="37" ry="11" fill="#f5d8a2" fill-opacity=".1" stroke="#755039" stroke-opacity=".72" stroke-dasharray="6 5" stroke-width="2"/>`
      }
    }
  }
  s += '<path d="M96 402 H120 V423 H92Z M560 402 H584 L588 423 H558Z" fill="#523521"/>'
  return sceneDefs() + s + vignette()
}
