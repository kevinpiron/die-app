# Datenbank – die App (Firebase Firestore)

## Struktur

```
Firestore
│
├── users/                          ← Ein Dokument pro Nutzer
│   └── {uid}/
│       ├── uid: string             ← Firebase Auth UID
│       ├── username: string        ← Eindeutiger Nickname (lowercase)
│       ├── displayName: string     ← Anzeigename
│       ├── createdAt: timestamp
│       ├── points: number          ← Gesamtpunkte
│       ├── friends: [uid, ...]     ← Freundesliste (für später)
│       └── goals/                  ← Subkollektion
│           └── {goalId}/
│               ├── title: string
│               ├── points: number
│               ├── icon: string
│               ├── done: boolean
│               └── completedAt: timestamp?
│
├── usernames/                      ← Für Einzigartigkeit des Nicknames
│   └── {username}/                 ← z.B. "kevin123"
│       └── uid: string             ← Wer hat diesen Username?
│
└── friendRequests/                 ← Für später (Freunde-System)
    └── {requestId}/
        ├── fromUid: string
        ├── toUid: string
        ├── status: "pending" | "accepted" | "declined"
        └── createdAt: timestamp
```

---

## Nickname-Einzigartigkeit

**Wie es funktioniert:**
1. Nutzer gibt Nickname ein
2. App prüft: existiert `/usernames/{nickname}` ?
   - Nein → frei, weiter
   - Ja → vergeben, Fehlermeldung
3. Beim Speichern: **atomare Transaktion** (beide Dokumente gleichzeitig)

```swift
// Pseudocode
let batch = db.batch()
batch.setData(["uid": uid], forDocument: db.collection("usernames").document(username))
batch.setData(userDocument, forDocument: db.collection("users").document(uid))
try await batch.commit()
```

**Warum zwei Kollektionen?**
- `users/{uid}` → schneller Zugriff per UID (Auth)
- `usernames/{name}` → schneller Einzigartigkeit-Check

---

## Username-Regeln
| Regel              | Wert                     |
|--------------------|--------------------------|
| Mindestlänge       | 3 Zeichen                |
| Maximallänge       | 20 Zeichen               |
| Erlaubte Zeichen   | a-z, 0-9, _ (underscore) |
| Großbuchstaben     | Werden automatisch klein |
| Reservierte Namen  | admin, dieapp, support   |

---

## Freunde-System (für später, noch NICHT implementiert)

**Geplanter Flow:**
1. Nutzer sucht nach Username
2. Freundschaftsanfrage senden → `friendRequests` Dokument anlegen
3. Empfänger bekommt Benachrichtigung
4. Annehmen → beide `friends` Arrays updaten

**Was man dann sehen kann:**
- Freundes Punktestand
- Freundes heutige Ziele (erledigt/offen)
- Kleiner Vergleich: wer hat heute mehr Punkte?

→ Daten liegen bereits in Firestore, nur UI fehlt noch.

---

## Sicherheitsregeln (Firestore Rules)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Nutzer kann nur eigene Daten lesen/schreiben
    match /users/{uid} {
      allow read: if request.auth != null;        // Alle eingeloggten Nutzer können lesen (für Freunde)
      allow write: if request.auth.uid == uid;    // Nur eigene Daten schreiben
    }

    // Usernames: lesen erlaubt (Einzigartigkeit prüfen), schreiben nur für Besitzer
    match /usernames/{username} {
      allow read: if true;
      allow create: if request.auth != null && request.resource.data.uid == request.auth.uid;
      allow delete: if request.auth != null &&
                       resource.data.uid == request.auth.uid;
    }

    // Freundschaftsanfragen (für später)
    match /friendRequests/{requestId} {
      allow read, write: if request.auth != null &&
        (resource.data.fromUid == request.auth.uid ||
         resource.data.toUid   == request.auth.uid);
    }
  }
}
```
