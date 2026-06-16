# Bhakthi — Hindu Devotional App

## Vision
A comprehensive, culturally authentic Hindu devotional companion for daily spiritual practice — covering prayers, rituals, festivals, sacred texts, and deity-specific content across all major traditions and regional languages.

## Target Audience
- Practicing Hindus of all ages (primary: 25–55)
- Diaspora communities seeking a digital connection to their traditions
- Beginners curious about Hindu spirituality
- Priests and puja performers who need structured guides

## Platform
- Flutter (iOS + Android)
- Offline-first with optional cloud sync

## Core Principles
1. **Authenticity** — content reviewed by scholars and priests, not crowd-sourced
2. **Inclusivity** — cover Shaiva, Vaishnava, Shakta, Smarta traditions equally
3. **Multilingual** — Sanskrit originals + transliteration + regional language + English meaning
4. **Accessible** — works without internet; large-text and audio for elderly users
5. **Non-commercial feel** — no intrusive ads; optional premium for advanced features

---

## Feature Modules

### 1. Daily Practice
- Morning/evening prayer routines (Suprabhatam, Sandhyavandanam, Shloka sets)
- Customizable daily reminders (Brahma Muhurta, sunrise, sunset)
- Streak tracker for consistency

### 2. Deities
Dedicated pages for major deities with:
- Stotra, Ashtottara (108 names), Sahasranama (1000 names)
- Origin story / Mythology summary
- Significance of the deity
- Associated mantras with audio

**Covered deities (Phase 1):**
Ganesha, Lakshmi, Saraswati, Vishnu, Shiva, Parvati/Durga, Krishna, Rama, Hanuman, Murugan/Kartikeya, Ayyappa, Venkateshwara/Balaji

### 3. Prayers & Mantras
- Searchable library of slokas, stotras, and mantras
- Each entry: Sanskrit → transliteration → regional language → English meaning
- Audio pronunciation by trained priests
- Favorites and personal collections
- Offline audio download

### 4. Puja Guide
- Step-by-step ritual instructions for common pujas:
  - Ganesh Puja, Lakshmi Puja, Satyanarayana Puja, Navagraha Puja, Rudrabhishek
- Ingredients checklist (what to buy/arrange)
- Timing recommendations (muhurta suggestions)
- Video walkthroughs (Phase 2)

### 5. Hindu Calendar (Panchang)
- Daily Tithi, Nakshatra, Yoga, Karana, Vara
- Auspicious/inauspicious time windows (Rahu Kalam, Gulika, Abhijit Muhurta)
- Festival calendar with descriptions and associated rituals
- Ekadashi, Pradosham, Amavasya, Purnima alerts
- Regional calendar variants (Tamil, Telugu, Malayalam, Kannada, Bengali)

### 6. Sacred Texts
- Bhagavad Gita — chapter-by-chapter with commentary
- Vishnu Sahasranama
- Shiva Mahimna Stotram
- Soundarya Lahari
- Ramayana & Mahabharata summaries
- Upanishad excerpts (Phase 2)

### 7. Bhajans & Aarti
- Curated bhajan library with lyrics + audio
- Aarti collection (Jai Ganesh, Om Jai Jagdish, etc.)
- Category filter: deity, language, occasion
- Background play support

### 8. Festivals
- Full Hindu festival calendar (year-view)
- Each festival: significance, rituals, foods, legends
- Push notifications before festivals
- Regional festival variants

### 9. Temple Directory (Phase 2)
- Famous temples with history, darshan timings, location
- Nearby temple finder (GPS)
- Virtual darshan links where available

### 10. Vrat (Fasting) Tracker
- Common vratas: Ekadashi, Monday fast, Navratri, Karva Chauth, Sawan, etc.
- Rules for each vrat (what to eat/avoid)
- Reminders and streak tracking

---

## Languages Supported (Phase 1)
- Sanskrit (Devanagari script)
- Transliteration (IAST / common romanization)
- English (meaning / translation)
- Telugu
- Hindi

**Phase 2 additions:** Tamil, Kannada, Malayalam, Bengali, Marathi, Gujarati

---

## Monetization
- **Free tier:** daily prayers, basic calendar, core deity pages, limited audio
- **Premium (Bhakthi Plus):** full audio library, offline downloads, advanced panchang, all sacred texts, ad-free
- No ads on prayer/puja screens ever

---

## Content & Audio Decisions

### Content Authorship
All content (slokas, stotra text, festival descriptions, puja guides, mythology) is authored and curated by the app owner. No crowd-sourcing, no third-party editorial dependency. This ensures consistency, accuracy, and full IP control.

- Content stored as version-controlled JSON in the repo
- Owner edits JSON directly or via a simple admin tool (future)
- No CMS dependency in Phase 1

### Audio — AI Generated
All voice audio (mantra recitation, stotra audio, puja step narration) is AI-generated using a text-to-speech pipeline tuned for Sanskrit pronunciation. 

**Recommended approach:**
- Use ElevenLabs or a Sanskrit-capable TTS (e.g. Google Cloud TTS with `hi-IN` neural voice as fallback)
- Generate audio at content-authoring time, store as `.mp3` in Firebase Storage
- Keep source text in the JSON so audio can be regenerated if voice/quality improves
- Label audio in-app as "AI recitation" in settings (transparency)

**Benefits:** Zero licensing cost, scalable to hundreds of stotras, consistent pacing, re-generable.

### Panchang — Pan-India
No regional calendar variant as default. Calculations use a single astronomical engine (Drik Ganit / Surya Siddhanta) that works accurately across all of India.

- User sets their city on first launch → used for sunrise/sunset/muhurta
- No regional calendar school bias (covers North, South, East, West equally)
- Festival dates computed from tithi, valid pan-India

---

## Non-Goals (explicitly out of scope)
- Astrology / horoscope predictions (too complex, risk of misinformation)
- E-commerce (puja items, merchandise)
- Social / community features (comments, sharing feeds)
- Non-Hindu religious content
