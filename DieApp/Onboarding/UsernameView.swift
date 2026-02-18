import SwiftUI
import FirebaseFirestore

struct UsernameView: View {
    @State private var username: String = ""
    @State private var status: UsernameStatus = .idle
    @State private var checkTask: Task<Void, Never>? = nil

    let onComplete: (String) -> Void

    enum UsernameStatus {
        case idle
        case checking
        case available
        case taken
        case tooShort
        case invalidChars
        case inappropriate
    }

    private static let blockedWords: [String] = [
        // Deutsch – sexuell
        "sex", "porno", "porn", "penis", "vagina", "ficken", "fick", "wichsen", "wichser",
        "hure", "nutte", "schlampe", "titten", "arsch", "arschloch", "schwanz", "fotze",
        // Deutsch – Beleidigungen
        "idiot", "vollidiot", "depp", "trottel", "dummkopf", "blödmann",
        "hurensohn", "bastard", "scheiße", "nazi", "spast", "mongo",
        // Englisch – sexuell
        "fuck", "shit", "bitch", "cock", "dick", "pussy", "cunt", "whore", "slut",
        "boobs", "tits", "cum", "anal", "blowjob", "handjob", "dildo", "nude", "naked",
        // Englisch – Beleidigungen
        "nigger", "faggot", "retard", "moron", "asshole", "douchebag", "scumbag", "racist",
    ]

    private func containsBlockedWord(_ value: String) -> Bool {
        Self.blockedWords.contains { value.contains($0) }
    }

    var isValid: Bool { status == .available }

    var body: some View {
        ZStack {
            Color(hex: "#0a0a0f").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Wie heißt du?")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)

                    Text("Wähle einen einzigartigen Nickname.\nAndere Nutzer finden dich damit.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.45))
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 32)

                // Input
                HStack {
                    Text("@")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.3))
                    TextField("dein_nickname", text: $username)
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .onChange(of: username) { newValue in
                            let cleaned = newValue
                                .lowercased()
                                .filter { $0.isLetter || $0.isNumber || $0 == "_" }
                            if username != cleaned { username = cleaned }
                            validateUsername(cleaned)
                        }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 1.5)
                )
                .cornerRadius(12)

                // Status
                statusView
                    .frame(height: 24)
                    .padding(.top, 8)

                Text("3–20 Zeichen · Nur Buchstaben, Zahlen & _")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.2))
                    .padding(.top, 12)
                    .padding(.bottom, 24)

                // Weiter Button
                Button {
                    guard isValid else { return }
                    onComplete(username)
                } label: {
                    Text("Weiter →")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid
                            ? LinearGradient(colors: [.purple, Color(hex: "#7c3aed")],
                                             startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.08)],
                                             startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(isValid ? .white : .white.opacity(0.3))
                        .cornerRadius(14)
                }
                .disabled(!isValid)

                Spacer()
            }
            .padding(.horizontal, 28)
        }
    }

    // MARK: - Status View

    @ViewBuilder
    var statusView: some View {
        HStack {
            switch status {
            case .idle:
                EmptyView()
            case .checking:
                ProgressView().scaleEffect(0.7)
                Text("Wird geprüft…").font(.caption).foregroundColor(.white.opacity(0.4))
            case .available:
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                Text("@\(username) ist verfügbar!").font(.caption).foregroundColor(.green)
            case .taken:
                Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                Text("@\(username) ist leider vergeben").font(.caption).foregroundColor(.red)
            case .tooShort:
                Image(systemName: "exclamationmark.triangle").foregroundColor(.orange)
                Text("Mindestens 3 Zeichen").font(.caption).foregroundColor(.orange)
            case .invalidChars:
                Image(systemName: "exclamationmark.triangle").foregroundColor(.orange)
                Text("Nur Buchstaben, Zahlen & _").font(.caption).foregroundColor(.orange)
            case .inappropriate:
                Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                Text("Dieser Name ist nicht erlaubt").font(.caption).foregroundColor(.red)
            }
        }
    }

    var borderColor: Color {
        switch status {
        case .available: return .green
        case .taken:     return .red
        default:         return .white.opacity(0.1)
        }
    }

    // MARK: - Validation

    private func validateUsername(_ value: String) {
        checkTask?.cancel()
        status = .idle

        guard !value.isEmpty else { return }
        guard value.count >= 3 else { status = .tooShort; return }
        guard !containsBlockedWord(value) else { status = .inappropriate; return }

        status = .checking

        checkTask = Task {
            try? await Task.sleep(nanoseconds: 600_000_000) // 0.6s debounce
            guard !Task.isCancelled else { return }

            let taken = await isUsernameTaken(value)

            await MainActor.run {
                status = taken ? .taken : .available
            }
        }
    }

    private func isUsernameTaken(_ username: String) async -> Bool {
        let db = Firestore.firestore()
        let doc = try? await db.collection("usernames").document(username).getDocument()
        return doc?.exists == true
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
