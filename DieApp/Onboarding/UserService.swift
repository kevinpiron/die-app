import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()

    // MARK: - Username speichern (atomare Transaktion)

    func saveUsername(_ username: String, for uid: String, displayName: String) async throws {
        let batch = db.batch()

        // 1. usernames/{username} → uid (für Einzigartigkeit)
        let usernameRef = db.collection("usernames").document(username)
        batch.setData(["uid": uid], forDocument: usernameRef)

        // 2. users/{uid} → Nutzerprofil
        let userRef = db.collection("users").document(uid)
        batch.setData([
            "uid": uid,
            "username": username,
            "displayName": displayName,
            "createdAt": FieldValue.serverTimestamp(),
            "points": 0,
            "friends": [],
        ], forDocument: userRef)

        try await batch.commit()
    }

    // MARK: - Username verfügbar?

    func isUsernameAvailable(_ username: String) async -> Bool {
        let doc = try? await db.collection("usernames").document(username).getDocument()
        return doc?.exists == false
    }

    // MARK: - Nutzerprofil laden

    func loadUser(uid: String) async -> UserProfile? {
        let doc = try? await db.collection("users").document(uid).getDocument()
        guard let data = doc?.data() else { return nil }
        return UserProfile(data: data)
    }

    // MARK: - Punkte updaten

    func updatePoints(_ points: Int, for uid: String) async {
        try? await db.collection("users").document(uid).updateData([
            "points": points
        ])
    }
}

// MARK: - UserProfile Model

struct UserProfile {
    let uid: String
    let username: String
    let displayName: String
    let points: Int
    let friends: [String]

    init?(data: [String: Any]) {
        guard
            let uid = data["uid"] as? String,
            let username = data["username"] as? String
        else { return nil }
        self.uid = uid
        self.username = username
        self.displayName = data["displayName"] as? String ?? username
        self.points = data["points"] as? Int ?? 0
        self.friends = data["friends"] as? [String] ?? []
    }
}
