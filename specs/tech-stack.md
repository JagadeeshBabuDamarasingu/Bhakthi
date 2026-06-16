# Technical Stack

## App
| Layer | Choice | Reason |
|---|---|---|
| Framework | Flutter 3.x | Cross-platform iOS + Android from single codebase |
| Language | Dart | Required by Flutter |
| State management | Riverpod | Compile-safe, testable, works well with async content |
| Local storage | Isar (NoSQL) | Fast, embedded, great Flutter support for large content |
| Audio | just_audio + audio_service | Background play, lock-screen controls |
| Navigation | go_router | Declarative, deep-link ready |
| Notifications | flutter_local_notifications | Daily reminders, festival alerts |

## Backend (Phase 2 — cloud sync & content updates)
| Layer | Choice |
|---|---|
| Platform | Firebase |
| Database | Firestore (content) |
| Storage | Firebase Storage (audio files) |
| Auth | Firebase Auth (anonymous + Google sign-in) |
| Remote config | Firebase Remote Config (feature flags) |
| Analytics | Firebase Analytics |

## Content Pipeline
- Content authored in JSON by app owner, version-controlled in repo under `assets/content/`
- **Audio generation:** AI TTS pipeline (ElevenLabs preferred; Google Cloud TTS `hi-IN` neural as fallback)
  - Input: Sanskrit/transliteration text from stotra JSON
  - Output: `.mp3` per stotra / per verse (for sync'd playback)
  - Generated offline, committed to Firebase Storage, referenced by URL in JSON
  - Source text kept in JSON so audio can be regenerated as TTS quality improves
- App ships with bundled seed content (works offline from day 1)
- Delta content updates fetched on launch and cached in Isar

## AI Audio Generation Workflow
```
1. Author stotra text in JSON (Sanskrit + transliteration)
2. Run generation script: scripts/generate_audio.dart
   → calls ElevenLabs API with each verse text
   → saves mp3 to /audio_output/<stotra_id>/verse_<n>.mp3
3. Upload mp3s to Firebase Storage
4. Script writes back audio URLs into JSON
5. Commit updated JSON to repo
```
Script is idempotent — skips verses that already have a valid audio URL.

## Offline Strategy
- All text content bundled in app assets (JSON)
- Audio: stream by default; user can download per-stotra for offline
- Panchang calculated locally using astronomical algorithms (no API needed)
- Last-fetched remote content cached in Isar

## Panchang Calculation
- Use `drik_panchang` Dart library or port from existing Python/JS implementations
- Inputs: Gregorian date + GPS location (for sunrise/sunset)
- Fallback location: user's configured region city

## Folder Structure
```
apps/mobile/
├── lib/
│   ├── main.dart
│   ├── app.dart                  # MaterialApp, router setup
│   ├── core/
│   │   ├── theme/
│   │   ├── constants/
│   │   └── utils/
│   ├── data/
│   │   ├── models/               # Dart data classes
│   │   ├── repositories/         # data access layer
│   │   └── local/                # Isar schemas, seed loader
│   ├── features/
│   │   ├── home/
│   │   ├── deities/
│   │   ├── calendar/
│   │   ├── texts/
│   │   ├── audio/
│   │   ├── puja/
│   │   └── vrat/
│   └── shared/
│       ├── widgets/
│       └── providers/
├── assets/
│   ├── images/
│   ├── content/                  # JSON content files
│   └── audio/                    # Bundled short audio (mantras seed set)
└── test/
```

## Phase Roadmap

### Phase 1 — MVP (3 months)
- Deity pages for top 5 deities
- Core stotra library (~50 stotras, text only)
- Panchang (today view)
- Festival calendar (year)
- Bhagavad Gita (all 18 chapters, text)
- Hindi + English + Telugu + transliteration

### Phase 2 — Content & Audio (2 months)
- Audio for top 20 stotras
- Full deity coverage (12 deities)
- Puja guides (5 pujas)
- Vrat tracker
- Temple directory (famous temples, no GPS yet)
- Background audio player

### Phase 3 — Personalization & Cloud (2 months)
- User accounts (Firebase Auth)
- Sync favorites across devices
- Daily notification engine
- Premium tier (Bhakthi Plus)
- More regional languages (Tamil, Kannada)
