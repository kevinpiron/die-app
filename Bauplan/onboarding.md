# Onboarding & Registrierung – die App

## Konzept
Beim ersten App-Start erscheint ein Intro (nur einmalig).
Danach wird die Registrierung durchgeführt.
Anschließend startet die App normal.

---

## Erster-Start-Erkennung
```swift
// In UserDefaults gespeichert
UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
// false  → Onboarding zeigen
// true   → direkt zur Haupt-App
```

---

## Technische Struktur (Swift)

```
DieApp/
├── Onboarding/
│   ├── OnboardingCoordinator.swift   ← Steuert Seiten-Wechsel
│   ├── OnboardingPageView.swift      ← Vorlage für einzelne Seite
│   ├── Pages/
│   │   ├── OnboardingPage1.swift     ← Intro-Seite 1
│   │   ├── OnboardingPage2.swift     ← Intro-Seite 2
│   │   ├── OnboardingPage3.swift     ← Intro-Seite N...
│   │   └── PermissionsPageView.swift ← Family Controls erlauben
│   └── Registration/
│       ├── RegistrationView.swift    ← Registrierungsformular
│       └── RegistrationViewModel.swift
```

---

## Ablauf (Flow)

```
App Start
    ↓
hasCompletedOnboarding?
    ├── JA  → ContentView (Haupt-App)
    └── NEIN → OnboardingView
                    ↓
               Intro-Seiten (swipebar / Button)
                    ↓
               Berechtigung: Family Controls
                    ↓
               Registrierung
                    ↓
               UserDefaults: hasCompletedOnboarding = true
                    ↓
               ContentView (Haupt-App)
```

---

## Registrierung – ENTSCHIEDEN ✅

**Drei Login-Optionen:**
1. Apple Sign In
2. Google Sign In
3. Email + Passwort

### Backend: Firebase (empfohlen)
- Unterstützt alle drei Login-Methoden nativ
- Kostenlos für kleine Nutzerzahlen (Spark Plan)
- Swift SDK verfügbar (`FirebaseAuth`)
- Einfache Integration

### Benötigte Firebase-Dienste
| Dienst            | Verwendung                        |
|-------------------|-----------------------------------|
| Firebase Auth     | Login (Apple, Google, Email)      |
| Firestore         | Nutzerdaten, Ziele, Punkte        |

### Ablauf nach Login
1. Nutzer wählt Login-Methode
2. Firebase authentifiziert
3. Nutzerprofil wird angelegt (Name, UID)
4. Weiter zum nächsten Onboarding-Schritt

---

## Registrierungsfelder (Vorschlag)
| Feld          | Pflicht | Hinweis                          |
|---------------|---------|----------------------------------|
| Name/Anzeigename | Ja   | Wird in der App angezeigt        |
| Profilbild/Emoji | Nein | Optional, persönlich             |
| (Account-Typ)    | –    | Abhängig von Option A/B/C        |

---

## Berechtigungen während Onboarding
- **Family Controls** → muss einmalig erlaubt werden (iOS zeigt System-Dialog)
- Guter Zeitpunkt: Als eigene Seite im Onboarding mit Erklärung

---

## Simulator (HTML)
- Onboarding-Seiten als slide-barer Intro
- Registrierungsformular simulieren
- Wird nach Design-Bestätigung umgesetzt

---

## Intro-Screen – ENTSCHIEDEN ✅

### Hintergrund
- Fast schwarz: `#0a0a0f`
- Fallende App-Icons mit Physik (Schwerkraft + Rotation + Seitliche Drift + Bounce)

### Fallende App-Icons
| App        | Farbe        | Icon |
|------------|--------------|------|
| TikTok     | `#010101`    | ♪    |
| Instagram  | Gradient     | 📷   |
| Facebook   | `#1877F2`    | f    |
| YouTube    | `#FF0000`    | ▶    |
| Twitter/X  | `#000000`    | X    |
| Snapchat   | `#FFFC00`    | 👻   |
| WhatsApp   | `#25D366`    | 💬   |
| Netflix    | `#E50914`    | N    |
| Reddit     | `#FF4500`    | 👾   |

### Physik
- Schwerkraft: `0.35 px/frame²`
- Rotation: zufällig `-3° bis +3°/frame`
- Seitliche Drift: leicht zufällig
- Boden-Bounce: Dämpfung `0.45`
- Icons starten zufällig über dem Screen, verteilt

### Provokativer Text (wechselt alle ~2.5s, fade in/out)
1. „Hast du genug vom Scrollen?"
2. „Solltest du dich nicht gerade konzentrieren?"
3. „Wie viele Stunden hast du heute schon verschwendet?"
4. „Deine Ziele warten noch auf dich."
5. „TikTok wird dich nicht weiterbringen."
6. „Was hättest du alles erreichen können?"
7. „Scroll weniger. Lebe mehr."

### CTA Button
- Text: „Jetzt ändern"
- Farbe: Lila (`#8b5cf6`)
- Position: Unten, über dem Tab-Bar
- Führt zur Registrierung

## Status
- [x] Visuelles Design Intro entschieden
- [x] Registrierungstyp entschieden → Apple + Google + Email (Firebase)
- [ ] Onboarding-Seiten Inhalt & Anzahl festlegen
- [ ] Firebase Projekt aufsetzen
- [x] Intro-Screen im Simulator gebaut
- [ ] Registrierung im Simulator
- [ ] Swift-Code schreiben
