# Typografie – die App

## Schriftart
```
iOS (Swift):    -apple-system, SF Pro (automatisch)
Simulator/Web:  -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif
```
→ Immer System-Font verwenden. Kein Google Fonts / Custom Font (außer bewusste Entscheidung).

## Schriftgrößen & Gewichte

### Navigation
| Element         | Größe  | Gewicht | Verwendung              |
|-----------------|--------|---------|-------------------------|
| Nav-Titel (groß)| 28px   | 800     | Seitenüberschrift       |
| Section-Label   | 13px   | 600     | Abschnittsüberschrift   |

### Punkte-Hero
| Element         | Größe  | Gewicht | Verwendung              |
|-----------------|--------|---------|-------------------------|
| Punkte-Zahl     | 70px   | 900     | Hauptzahl               |
| Label           | 15px   | 400     | "Deine Punkte"          |
| Subtext         | 13px   | 400     | "= X Minuten verfügbar" |

### Karten & Listen
| Element         | Größe  | Gewicht | Verwendung              |
|-----------------|--------|---------|-------------------------|
| Karten-Titel    | 16px   | 600     | z.B. "Heute"            |
| Body            | 15px   | 500     | Ziel-Titel              |
| Subtext         | 13px   | 400     | Punkte, Beschreibungen  |
| Caption         | 12px   | 400     | Kleingedrucktes         |
| Tab-Label       | 10px   | 500     | Tab-Bar Beschriftungen  |

### Buttons
| Element         | Größe  | Gewicht | Verwendung              |
|-----------------|--------|---------|-------------------------|
| Haupt-Button    | 16px   | 700     | Einlösen, Hinzufügen    |
| Minuten-Button  | 18px   | 800     | Minuten-Grid            |
| Chip            | 13px   | 500     | App-Chips               |

## Textfarben
```
Primär:       #111111  (Haupttext)
Sekundär:     #6b7280  (Hilfstexte)
Deaktiviert:  #9ca3af  (erledigte Ziele, durchgestrichen)
Auf Lila:     #ffffff  (Buttons, Hero)
Auf Lila dim: rgba(255,255,255,0.7-0.8)
```

## Sonderfälle
- Erledigte Ziele: `text-decoration: line-through` + Farbe `#9ca3af`
- Punkte verdient: `#16a34a` (grün)
- Punkte eingelöst: `#ea580c` (orange)
