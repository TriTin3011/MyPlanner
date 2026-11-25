// Sinh icon Windows cho mọi theme từ cùng hình với components/BrandMark.tsx. Chạy: npm run gen:desktop-icons
// Cỡ nhỏ lưu dạng bitmap 32-bit vì Windows đọc chắc chắn nhất; riêng 256px nén PNG để file không quá nặng.
import { mkdirSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import sharp from 'sharp'

const here = dirname(fileURLToPath(import.meta.url))
const outDir = join(here, '../../desktop/MyPlanner.Desktop/Assets/ThemeIcons')
const sizes = [16, 20, 24, 32, 40, 48, 64, 256]

// Cùng giá trị với src/styles/tokens.css.
const themes = {
  forest: { primary: '#0b7a55', ink: '#0a4d37', tint: '#ddf3e8' },
  ocean: { primary: '#1d4ed8', ink: '#1e3a8a', tint: '#dbeafe' },
  sunset: { primary: '#c2410c', ink: '#7c2d12', tint: '#ffedd5' },
  lavender: { primary: '#6d28d9', ink: '#4c1d95', tint: '#ede9fe' },
  night: { primary: '#0e8159', ink: '#8ce6c2', tint: '#1a3329' },
}

const logo = ({ primary, ink, tint }) => `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <circle cx="32" cy="34" r="22" fill="${tint}"/>
  <path d="M32 12 A22 22 0 1 1 12.5 24" fill="none" stroke="${primary}" stroke-width="6" stroke-linecap="round"/>
  <path d="M32 12 C31 7 35 3 41 3 C41 8 37 12 32 12 Z" fill="${primary}" stroke="${ink}" stroke-width="2" stroke-linejoin="round"/>
  <circle cx="23" cy="36" r="3.2" fill="${ink}"/>
  <circle cx="32" cy="36" r="3.2" fill="${ink}"/>
  <circle cx="41" cy="36" r="3.2" fill="${primary}"/>
</svg>`

async function bitmapEntry(svg, size) {
  const rgba = await sharp(Buffer.from(svg), { density: 72 * (size / 64) * 4 })
    .resize(size, size)
    .ensureAlpha()
    .raw()
    .toBuffer()
  const header = Buffer.alloc(40)
  header.writeUInt32LE(40, 0)
  header.writeInt32LE(size, 4)
  header.writeInt32LE(size * 2, 8) // Chiều cao gồm cả mặt nạ AND, theo định dạng ICO.
  header.writeUInt16LE(1, 12)
  header.writeUInt16LE(32, 14)

  const pixels = Buffer.alloc(size * size * 4)
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const from = (y * size + x) * 4
      const to = ((size - 1 - y) * size + x) * 4 // Bitmap lưu từ dòng dưới lên.
      pixels[to] = rgba[from + 2]
      pixels[to + 1] = rgba[from + 1]
      pixels[to + 2] = rgba[from]
      pixels[to + 3] = rgba[from + 3]
    }
  }
  const maskRow = Math.ceil(size / 32) * 4
  return Buffer.concat([header, pixels, Buffer.alloc(maskRow * size)])
}

const pngEntry = (svg, size) =>
  sharp(Buffer.from(svg), { density: 72 * (size / 64) * 2 }).resize(size, size).png().toBuffer()

async function buildIco(svg) {
  const images = await Promise.all(sizes.map((s) => (s === 256 ? pngEntry(svg, s) : bitmapEntry(svg, s))))
  const head = Buffer.alloc(6 + 16 * sizes.length)
  head.writeUInt16LE(1, 2)
  head.writeUInt16LE(sizes.length, 4)
  let offset = head.length
  sizes.forEach((size, i) => {
    const at = 6 + 16 * i
    head[at] = size === 256 ? 0 : size // Quy ước ICO: 0 nghĩa là 256.
    head[at + 1] = size === 256 ? 0 : size
    head.writeUInt16LE(1, at + 4)
    head.writeUInt16LE(32, at + 6)
    head.writeUInt32LE(images[i].length, at + 8)
    head.writeUInt32LE(offset, at + 12)
    offset += images[i].length
  })
  return Buffer.concat([head, ...images])
}

mkdirSync(outDir, { recursive: true })
for (const [name, palette] of Object.entries(themes)) {
  writeFileSync(join(outDir, `${name}.ico`), await buildIco(logo(palette)))
}
