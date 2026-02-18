# Komponenten – die App

## Layout-Grundregeln
- Seitenränder:      `16px` links & rechts
- Karten-Abstand:    `12px` zwischen Karten
- Innen-Padding:     `16px` in Karten
- Border-Radius:     `16px` Karten, `20px` Hero, `14px` Buttons, `12px` kleine Karten, `99px` Chips/Toggle

---

## Karten-Typen

### Weiße Karte
```
background: white
border-radius: 16px
margin: 0 16px 12px
box-shadow: 0 1px 3px rgba(0,0,0,0.08)
padding: 16px
```

### Graue Karte (iOS-Style)
```
background: #f2f2f7
border-radius: 16px
margin: 0 16px 12px
box-shadow: none
padding: 16px
```

### Info-Karte (blau)
```
background: #eff6ff
border: 1px solid #bfdbfe
border-radius: 16px
```

### Session-Banner (orange)
```
background: #fff7ed
border: 1px solid #fed7aa
border-radius: 12px
```

---

## Buttons

### Haupt-Button (Primär)
```
background: #7c3aed  →  hover: #6d28d9
color: white
border-radius: 14px
padding: 15-16px
font-size: 16px, font-weight: 700
width: 100%
```

### Haupt-Button (Deaktiviert/Grau)
```
background: #9ca3af
color: white
cursor: not-allowed
```

### Button (Orange/Sekundär)
```
background: #fff7ed
color: #ea580c
border: 1px solid #fed7aa
```

### Check-Button (Ziele)
```
font-size: 28px (Emoji)
background: none, border: none
```

### Minuten-Buttons (Grid)
```
Aktiv:   background #7c3aed, color white
Inaktiv: background #e5e7eb, color #374151
Nicht leistbar: opacity 0.35
border-radius: 12px
```

---

## Toggle (Ein/Aus)
```
Breite: 51px, Höhe: 31px
Aus:  background #e5e7eb
Ein:  background #7c3aed
Knopf: 27x27px, weiß, border-radius 50%
```

---

## App-Chips
```
Aus:  background #f3f4f6, color #374151
Ein:  background #7c3aed, color white
padding: 7px 13px
border-radius: 99px
font-size: 13px, font-weight: 500
margin: 4px
```

---

## Ziel-Reihe
```
display: flex, align-items: center, gap: 12px
padding: 12px 16px
border-bottom: 1px solid #f2f2f7
Icon-Kreis: 44x44px, border-radius 50%
  - Offen:    background #f2f2f7
  - Erledigt: background #ede9fe
```

---

## Progress-Bar
```
Hintergrund: #e5e7eb, height: 8px, border-radius: 99px
Füllung:     #7c3aed, transition: width 0.5s ease
```

---

## Stepper (Punkte wählen)
```
Button: 38x38px, border-radius 50%
background: #ede9fe, color: #7c3aed
font-size: 22px, font-weight: 700
```

---

## Success-Overlay
```
Hintergrund: rgba(0,0,0,0.45)
Karte: white, border-radius 24px, padding 36-40px
Animation: scale(0.8) → scale(1) + opacity 0→1, 0.3s ease
```

---

## Bottom Sheet (Add Goal)
```
Hintergrund: rgba(0,0,0,0.3)
Sheet: white, border-radius 24px 24px 0 0
Animation: translateY(100%) → translateY(0), 0.3s ease
Handle: 36x4px, background #e5e7eb, border-radius 99px
```

---

## Tab Bar
```
background: rgba(248,248,248,0.97)
border-top: 1px solid #ddd
Padding: 8px 0 22px (unten extra für Home Indicator)
Icon: 22px
Label: 10px, font-weight 500
Aktiv: color #7c3aed
Inaktiv: color #8e8e93
```
