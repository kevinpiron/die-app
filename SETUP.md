# EarnTime – Setup Anleitung

## Voraussetzungen
- Mac mit Xcode 15+
- Apple Developer Account (kostenlos reicht zum Testen)
- iPhone mit iOS 16+

## Xcode Projekt erstellen

1. Xcode öffnen → „Create a new Xcode project"
2. **iOS → App** wählen
3. Einstellungen:
   - Product Name: `EarnTime`
   - Bundle Identifier: `com.earntime.app`
   - Interface: `SwiftUI`
   - Language: `Swift`

4. Alle Dateien aus dem `EarnTime/` Ordner in das Projekt ziehen

## DeviceActivity Extension hinzufügen

1. Im Xcode-Projekt: File → New → Target
2. **Device Activity Monitor Extension** wählen
3. Name: `EarnTimeDeviceActivity`
4. Die Datei `DeviceActivityExtension/DeviceActivityMonitorExtension.swift` einfügen

## Capabilities aktivieren

Im Xcode-Projekt unter **Signing & Capabilities**:
1. `+ Capability` klicken
2. **Family Controls** aktivieren
3. **App Groups** aktivieren → Gruppe `group.com.earntime.app` hinzufügen

## Family Controls Entitlement beantragen

Da Family Controls eine spezielle Genehmigung braucht:
1. Gehe zu: https://developer.apple.com/contact/request/family-controls-distribution/
2. Antrag stellen (dauert 1-2 Werktage)
3. Danach ist das Entitlement automatisch in deinem Developer Account

## App testen

1. iPhone per USB verbinden
2. In Xcode: Dein iPhone als Ziel auswählen
3. `Cmd + R` → App starten
4. Beim ersten Start: Berechtigung für Family Controls erlauben

## App Store Veröffentlichung

1. Apple Developer Account (99€/Jahr)
2. In Xcode: Product → Archive
3. Über Xcode Organizer → App Store Connect hochladen
4. In App Store Connect: App einreichen

---

## Projektstruktur

```
EarnTime/
├── EarnTimeApp.swift          # App-Einstiegspunkt
├── ContentView.swift          # Tab-Navigation
├── Models/
│   ├── Goal.swift             # Ziel-Datenmodell
│   ├── PointsManager.swift    # Punkte-Logik
│   └── AppBlockingManager.swift # App-Sperr-Logik
├── Views/
│   ├── HomeView.swift         # Startseite (Punkte, Status)
│   ├── GoalsView.swift        # Ziele verwalten
│   ├── AppsView.swift         # Apps auswählen & sperren
│   └── RedeemView.swift       # Punkte einlösen
├── DeviceActivityExtension/
│   └── DeviceActivityMonitorExtension.swift  # Hintergrund-Sperre
├── EarnTime.entitlements      # Berechtigungen
└── Info.plist                 # App-Konfiguration
```
