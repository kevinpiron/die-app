# Bauplan – die App

Dieser Ordner enthält alle Design-Entscheidungen als Referenz.
Bei Chat-Komprimierung hier nachschlagen!

## Dateien
| Datei               | Inhalt                                      |
|---------------------|---------------------------------------------|
| `farben.md`         | Alle Hex-Codes, Gradienten, Schatten        |
| `typografie.md`     | Schriftgrößen, Gewichte, Textfarben         |
| `komponenten.md`    | Buttons, Karten, Toggle, Chips etc.         |
| `design-vision.md`  | Gesamtkonzept, Dark Mode, Stil-Richtung     |

## Kurzüberblick
- **Farbschema:** Lila / Schwarz (Dark Mode)
- **Primärfarbe:** `#8b5cf6` (Lila)
- **Hintergrund:** `#0a0a0f` (fast schwarz)
- **Schrift:** System-Font (SF Pro auf iOS)
- **Stil:** Dunkel, premium, fokussiert, Glassmorphism-Elemente
- **Plattform:** iOS (SwiftUI) + Browser-Simulator (HTML/JS)

## Projekt-Struktur
```
die_app/
├── Bauplan/          ← Design-Referenz (dieser Ordner)
├── DieApp/           ← Swift-Quellcode (iOS App)
│   ├── Models/
│   ├── Views/
│   └── DeviceActivityExtension/
├── simulator.html    ← Browser-Simulator (kein Install nötig)
└── SETUP.md          ← Anleitung für Xcode/Mac
```
