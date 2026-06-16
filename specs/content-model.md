# Content Model

## Deity
```
id: string
name: { sanskrit, transliteration, hindi, telugu, english }
tradition: 'shaiva' | 'vaishnava' | 'shakta' | 'other'
aliases: string[]           // e.g. Ganesha = Vinayaka, Ganapati, Pillayar
imageAsset: string
description: LocalizedText
associatedDay: weekday      // e.g. Ganesha → Wednesday
primaryMantra: string (ref → Mantra.id)
stotras: Stotra[]
mantras: Mantra[]
festivals: Festival[]
pujaGuide: PujaGuide (ref)
```

## Stotra / Mantra
```
id: string
title: LocalizedText
deity: Deity.id
type: 'stotra' | 'ashtottara' | 'sahasranama' | 'mantra' | 'aarti' | 'bhajan'
verses: Verse[]
audioUrl: string (optional, premium)
duration: number (seconds)
language: Language[]        // original language(s) present
tags: string[]
```

## Verse
```
index: number
sanskrit: string            // Devanagari
transliteration: string     // IAST romanization
hindi: string (optional)
telugu: string (optional)
tamil: string (optional)
english: string             // meaning/translation
audioTimestamp: number      // seconds offset in audio file
```

## Festival
```
id: string
name: LocalizedText
deity: Deity.id (optional)  // null for pan-Hindu festivals
tithiMonth: number          // lunar month (1–12)
tithiDay: number            // lunar day (1–30)
tithiPaksha: 'shukla' | 'krishna'
significance: LocalizedText
rituals: string[]           // ordered steps
associatedStotras: Stotra.id[]
foodGuidelines: string
regionVariants: { region: string, localName: string }[]
```

## PanchaangDay
```
date: Date (Gregorian)
tithi: { name, number, endTime }
nakshatra: { name, endTime }
yoga: string
karana: string
vara: { name, deity }
rahuKalam: { start, end }
gulikaKalam: { start, end }
abhijitMuhurta: { start, end }
festivals: Festival.id[]
sunrise: time
sunset: time
region: string              // affects calculation base
```

## PujaGuide
```
id: string
title: LocalizedText
deity: Deity.id
estimatedDuration: number   // minutes
ingredients: Ingredient[]
steps: PujaStep[]
bestTiming: string          // e.g. "Friday morning, before sunrise"
associatedMantras: Mantra.id[]
```

## PujaStep
```
index: number
title: LocalizedText
description: LocalizedText
mantra: Mantra.id (optional)
imageAsset: string (optional)
```

## VratRule
```
id: string
name: LocalizedText
recurrence: 'weekly' | 'fortnightly' | 'monthly' | 'annual'
weekday: number (if weekly)
tithi: number (if fortnightly/monthly)
deity: Deity.id
whatToEat: string[]
whatToAvoid: string[]
prayersToRecite: Stotra.id[]
significance: LocalizedText
```

## LocalizedText
```
sanskrit: string (optional)
english: string
hindi: string (optional)
telugu: string (optional)
tamil: string (optional)
kannada: string (optional)
malayalam: string (optional)
```
