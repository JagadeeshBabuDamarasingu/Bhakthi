# Design Language

## Aesthetic Direction
**Warm, sacred, timeless** — inspired by temple architecture, rangoli patterns, and manuscript illumination. Not a generic "spiritual wellness" app with generic gradients. Should feel like holding a beautifully printed prayer book.

## Color Palette

### Primary
| Token | Hex | Usage |
|---|---|---|
| saffron | `#FF6B00` | Primary actions, highlights, deity name accents |
| deepRed | `#8B1A1A` | AppBar, headers |
| gold | `#D4A017` | Icons, ornamental dividers |

### Secondary
| Token | Hex | Usage |
|---|---|---|
| creamWhite | `#FFF8F0` | Background (light mode) |
| darkNavy | `#1A1A2E` | Background (dark mode) |
| mutedGold | `#C8A96E` | Subtext, secondary labels |

### Semantic
| Token | Usage |
|---|---|
| auspicious (green `#2E7D32`) | Festival markers, auspicious time |
| inauspicious (muted gray) | Rahu Kalam, Gulika |
| ekadashi (teal `#00695C`) | Ekadashi markers |

## Typography
- **Script display** — use a Devanagari-capable serif (e.g. Tiro Devanagari or Noto Serif Devanagari) for Sanskrit verses
- **Body / UI** — Noto Sans (covers all regional scripts cleanly)
- **Numerals** — standard for panchang numbers; Devanagari numerals optional toggle

## Iconography
- Custom icon set inspired by traditional kolam/rangoli motifs
- Deity symbols as icons (Om, Trishul, Lotus, Conch, Chakra)
- Avoid generic Material icons on sacred content screens; use them only in utility/settings areas

## Layout Principles
- Generous whitespace; not cluttered
- Cards with soft drop shadows and slightly warm tint
- Ornamental horizontal dividers (thin gold line with lotus center) between sections
- Verse text: left-aligned Sanskrit, right-aligned transliteration below it
- Audio player: slide-up bottom sheet, not intrusive

## Dark Mode
- Dark navy + gold instead of pure black; avoids harsh contrast
- Saffron/gold accents remain; deepRed becomes a slightly lighter maroon
- All images use soft glow overlay

## Accessibility
- Minimum text size 16sp; user-adjustable up to 28sp
- All audio controls reachable without scrolling
- Sanskrit text and transliteration always shown together (never language-only)
- High contrast mode: stronger border on cards

## Onboarding Feel
- First screen: full-bleed deity collage with "Jai Sri Ganesha" and app name
- Language selection before anything else
- Simple 3-step: pick deities you love → set morning prayer time → done
