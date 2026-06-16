# Content Authoring Guide

## Who authors content
The app owner authors all content directly. No external editors or crowd-sourcing.

## Where content lives
```
apps/mobile/assets/content/
├── deities/
│   ├── ganesha.json
│   ├── lakshmi.json
│   └── ...
├── stotras/
│   ├── ganesha_ashtottara.json
│   ├── vishnu_sahasranama.json
│   └── ...
├── festivals/
│   ├── ganesh_chaturthi.json
│   └── ...
├── puja_guides/
│   ├── ganesh_puja.json
│   └── ...
└── vrat_rules/
    ├── ekadashi.json
    └── ...
```

## Stotra JSON format
```json
{
  "id": "ganesha_ashtottara",
  "title": {
    "sanskrit": "श्री गणेश अष्टोत्तरशतनामावलि",
    "transliteration": "Shri Ganesha Ashtottara Shatanamavali",
    "english": "108 Names of Lord Ganesha",
    "telugu": "శ్రీ గణేశ అష్టోత్తర శతనామావళి"
  },
  "deity": "ganesha",
  "type": "ashtottara",
  "tags": ["ganesha", "names", "wednesday"],
  "verses": [
    {
      "index": 1,
      "sanskrit": "ॐ गणेशाय नमः",
      "transliteration": "Om Ganeshaya Namah",
      "english": "Salutations to the Lord of Ganas",
      "telugu": "ఓం గణేశాయ నమః",
      "audioUrl": ""
    }
  ]
}
```

## Audio generation
Leave `audioUrl` empty when first authoring. Run the generation script once content is finalized:
```
dart run scripts/generate_audio.dart --stotra ganesha_ashtottara
```
The script fills in `audioUrl` values pointing to Firebase Storage.

## Festival JSON format
```json
{
  "id": "ganesh_chaturthi",
  "name": {
    "english": "Ganesh Chaturthi",
    "hindi": "गणेश चतुर्थी",
    "telugu": "వినాయక చవితి"
  },
  "deity": "ganesha",
  "tithiMonth": 6,
  "tithiDay": 4,
  "tithiPaksha": "shukla",
  "significance": {
    "english": "Celebrates the birthday of Lord Ganesha..."
  },
  "rituals": [
    "Install a clay Ganesha idol",
    "Offer modak (sweet dumpling)",
    "Recite Ganesha Ashtottara",
    "Perform aarti morning and evening"
  ],
  "associatedStotras": ["ganesha_ashtottara", "ganesha_atharvashirsha"],
  "foodGuidelines": "Offer modak, coconut, jaggery. Avoid non-vegetarian food."
}
```

## Puja Guide JSON format
```json
{
  "id": "ganesh_puja",
  "title": { "english": "Ganesh Puja", "telugu": "వినాయక పూజ" },
  "deity": "ganesha",
  "estimatedDuration": 30,
  "ingredients": [
    { "name": "Modak", "quantity": "21 pieces" },
    { "name": "Red flowers (hibiscus)", "quantity": "handful" },
    { "name": "Durva grass", "quantity": "small bundle" },
    { "name": "Coconut", "quantity": "1" }
  ],
  "bestTiming": "Wednesday morning, within 2 hours of sunrise",
  "steps": [
    {
      "index": 1,
      "title": { "english": "Purification" },
      "description": { "english": "Sprinkle water around the puja space chanting..." },
      "mantra": "ganesha_shuddhi_mantra"
    }
  ],
  "associatedMantras": ["om_gam_ganapataye"]
}
```

## Phase 1 content targets
| Category | Target count |
|---|---|
| Deities | 5 (Ganesha, Lakshmi, Saraswati, Shiva, Vishnu) |
| Stotras/Mantras | 30 (6 per deity: ashtottara, aarti, 4 key stotras) |
| Festivals | 20 major festivals |
| Puja guides | 5 (one per deity) |
| Bhagavad Gita verses | All 700 (18 chapters) |
| Vrat rules | 10 common vratas |
