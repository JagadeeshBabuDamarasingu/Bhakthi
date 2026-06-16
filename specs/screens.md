# Screen Architecture

## Navigation Structure
Bottom tab bar with 5 tabs:

```
[ Home ] [ Deities ] [ Calendar ] [ Texts ] [ More ]
```

---

## Home Tab
**Purpose:** Personalized daily spiritual dashboard

- Today's panchang summary (Tithi, Nakshatra, day)
- "Good morning" greeting with current time-appropriate prayer suggestion
- Today's festival / Ekadashi / special day banner (if applicable)
- Daily shloka of the day (with audio play button)
- Quick-access row: user's favorited deities
- Upcoming festival strip (next 3 days)
- Recently visited content

---

## Deities Tab
**Purpose:** Browse all deities and access deity-specific content

### Deity List Screen
- Grid of deity cards (image + name)
- Filter by tradition: All / Shaiva / Vaishnava / Shakta / Others

### Deity Detail Screen
- Hero image / deity photo
- Brief introduction paragraph
- Tabs within screen:
  - **Stotras** — list of prayers for this deity
  - **Mantras** — seed mantras, ashtottara, sahasranama
  - **Stories** — mythology and significance
  - **Puja Guide** — how to perform puja for this deity
  - **Festivals** — festivals associated with this deity
- "Add to favorites" button

### Stotra/Mantra Detail Screen
- Title + deity tag
- Language toggle: Sanskrit | Transliteration | Regional | English
- Line-by-line display (synchronized with audio if playing)
- Audio player (play / pause / speed: 0.75x, 1x, 1.25x)
- Font size control
- Download for offline

---

## Calendar Tab
**Purpose:** Hindu calendar and festival planning

### Panchang Screen (default view)
- Date picker at top
- Today's details:
  - Tithi (lunar day)
  - Nakshatra (star)
  - Yoga
  - Karana
  - Vara (weekday deity)
  - Rahu Kalam
  - Gulika Kalam
  - Abhijit Muhurta
- Auspicious activity guide for the day

### Monthly Calendar Screen
- Month grid with color-coded markers:
  - Festival days (saffron)
  - Ekadashi (green)
  - Amavasya / Purnima (blue)
  - Pradosham (purple)
- Tap date → day detail

### Festival Detail Screen
- Festival name + deity
- Date and tithi
- Significance (1-2 paragraphs)
- How to observe (rituals, foods, prayers)
- Associated stotras (links)

---

## Texts Tab
**Purpose:** Sacred text library

### Text Library Screen
- Categories: Gita, Stotras, Upanishads, Epics
- Search bar

### Bhagavad Gita Screen
- Chapter list (18 chapters) with names
- Chapter detail: verse list
- Verse detail: Sanskrit | transliteration | English translation | commentary

### Stotra Library Screen
- Alphabetical / by deity / by language filter
- Stotra detail → same as Stotra/Mantra Detail above

---

## More Tab
**Purpose:** Settings, bhajans, puja guides, vrat tracker

### Sections:
- **Bhajans & Aarti** — audio library
- **Puja Guides** — step-by-step ritual guides
- **Vrat Tracker** — fasting calendar and rules
- **Settings:**
  - Default language
  - Notification preferences
  - Region (affects calendar variants)
  - Font size
  - Offline downloads manager
  - Premium / Bhakthi Plus

---

## Shared / Utility Screens
- **Search** — global search across slokas, deities, festivals, texts
- **Audio Player (mini bar)** — persistent bottom player when audio is playing
- **Onboarding** — deity preference selection, language, region (first launch)
- **Offline Indicator** — subtle banner when no internet (content still works)
