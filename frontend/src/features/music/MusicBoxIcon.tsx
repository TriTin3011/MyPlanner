// Icon hộp nhạc retro tự vẽ: đĩa than, cần đọc, núm vặn. Khi đang phát, CSS (.music-box--playing)
// làm đĩa quay, cần đọc hạ xuống và nốt nhạc bay lên. Chỉ đổi class nên React không phải vẽ lại mỗi khung hình.
export function MusicBoxIcon({ playing = false, size = 30 }: { playing?: boolean; size?: number }) {
  return (
    <svg
      viewBox="0 0 32 32"
      width={size}
      height={size}
      aria-hidden="true"
      className={`music-box shrink-0 overflow-visible ${playing ? 'music-box--playing' : ''}`}
    >
      <path className="music-box__note" d="M7 5V1.5l3-.7v3.4" fill="none" stroke="var(--primary)" strokeWidth="1.3" strokeLinecap="round" />
      <path className="music-box__note music-box__note--late" d="M20 4.5V1l3-.6v3.3" fill="none" stroke="var(--primary)" strokeWidth="1.3" strokeLinecap="round" />
      <rect x="2" y="7" width="28" height="23" rx="4" fill="var(--accent-soft)" stroke="var(--ink)" strokeWidth="2" />
      <g className="music-box__disc">
        <circle cx="13" cy="18.5" r="8" fill="var(--ink)" />
        <circle cx="13" cy="18.5" r="5.6" fill="none" stroke="var(--surface)" strokeOpacity="0.35" strokeWidth="0.7" />
        <path d="M13 11.8a6.7 6.7 0 0 1 5.8 3.4" fill="none" stroke="var(--surface)" strokeOpacity="0.8" strokeWidth="1" strokeLinecap="round" />
        <circle cx="13" cy="18.5" r="2.6" fill="var(--primary)" />
        <circle cx="13" cy="18.5" r="0.8" fill="var(--surface)" />
      </g>
      <g className="music-box__arm">
        <path d="M25.5 11v6.5l-4.5 3.5" fill="none" stroke="var(--ink)" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" />
        <circle cx="25.5" cy="11" r="1.7" fill="var(--surface)" stroke="var(--ink)" strokeWidth="1.2" />
      </g>
      <circle cx="26" cy="26" r="1.5" fill="var(--primary)" stroke="var(--ink)" strokeWidth="0.8" />
    </svg>
  )
}
