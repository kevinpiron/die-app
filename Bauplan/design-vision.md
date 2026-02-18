# Design Vision – die App

## Konzept
"die App" hilft dir, deine Handy-Sucht zu überwinden – indem du dir Bildschirmzeit durch echte Ziele verdienst.
Das Design soll das widerspiegeln: **dunkel, stark, fokussiert** – wie ein Werkzeug, kein Spielzeug.

---

## Farbschema: Lila / Schwarz (Dark Mode)

Das App-Design basiert auf einem **dunklen Theme** mit lila Akzenten.

### Hintergrundfarben
| Rolle              | Hex       | Verwendung                        |
|--------------------|-----------|-----------------------------------|
| App-Hintergrund    | `#0a0a0f` | Dunkelster Hintergrund            |
| Karten-Hintergrund | `#13131a` | Karten, Sheets                    |
| Erhöhte Ebene      | `#1c1c28` | Tab-Bar, Nav, sekundäre Karten    |
| Trennlinie         | `#2a2a3d` | Divider, Border                   |

### Primärfarben (Lila)
| Rolle              | Hex       | Verwendung                        |
|--------------------|-----------|-----------------------------------|
| Primär             | `#8b5cf6` | Hauptfarbe (heller als vorher)    |
| Primär stark       | `#7c3aed` | Buttons, Highlights               |
| Primär dunkel      | `#6d28d9` | Hover, Pressed                    |
| Primär glow        | `rgba(139,92,246,0.3)` | Schatten, Glow-Effekte |
| Primär subtil      | `rgba(139,92,246,0.1)` | Hintergrund aktiver Elemente |

### Textfarben
| Rolle              | Hex                    | Verwendung                    |
|--------------------|------------------------|-------------------------------|
| Primär             | `#ffffff`              | Haupttext                     |
| Sekundär           | `rgba(255,255,255,0.6)`| Hilfstexte                   |
| Tertiär            | `rgba(255,255,255,0.35)`| Deaktiviert, Placeholder     |
| Akzent             | `#a78bfa`              | Lila Texte (Punkte etc.)      |

---

## Stil-Richtung

### Keywords
- **Dunkel & Premium** – nicht billig, nicht bunt
- **Fokussiert** – klare Hierarchie, kein Overdesign
- **Lila als Energie** – Punkte, Fortschritt, Erfolge leuchten lila
- **Glassmorphism-Elemente** – leicht frosted glass für Karten

### Was vermeiden
- Keine hellen Hintergründe
- Keine bunten Farben außer Lila + Status-Farben
- Kein Flat-Look ohne Tiefe

---

## Status-Farben (angepasst für Dark Mode)
| Rolle       | Hex       | Verwendung                     |
|-------------|-----------|--------------------------------|
| Erfolg      | `#22c55e` | Punkte verdienen               |
| Warnung     | `#f97316` | Session aktiv, Einlösen        |
| Fehler      | `#ef4444` | Fehlende Punkte, Lock          |

---

## Animationen
- Übergänge: `0.2–0.3s ease`
- Scale beim Tap: `0.95`
- Erfolg-Popup: scale + fade `0.3s`
- Sheet: slide-up `0.3s`

---

## App-Struktur (Seiten)
1. **Home** – Punkte-Hero, Tagesfortschritt, Status
2. **Ziele** – Liste, hinzufügen, abhaken
3. **Apps sperren** – App-Auswahl, Toggle
4. **Einlösen** – Minuten wählen, einlösen

Jede Seite wird **einzeln durchgegangen und verfeinert**.
