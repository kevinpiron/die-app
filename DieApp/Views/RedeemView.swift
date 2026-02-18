import SwiftUI

struct RedeemView: View {
    @EnvironmentObject var pointsManager: PointsManager
    @EnvironmentObject var appBlockingManager: AppBlockingManager

    @State private var selectedMinutes: Int = 10
    @State private var showConfirmation = false
    @State private var showSuccess = false
    @State private var showInsufficientPoints = false

    let minuteOptions = [5, 10, 15, 20, 30, 45, 60]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // Punkte-Anzeige
                    VStack(spacing: 6) {
                        Text("Verfügbare Punkte")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(pointsManager.totalPoints)")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.purple)
                    }
                    .padding(.top)

                    // Minuten wählen
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Wie viele Minuten möchtest du?")
                            .font(.headline)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                            ForEach(minuteOptions, id: \.self) { minutes in
                                MinuteOptionButton(
                                    minutes: minutes,
                                    isSelected: selectedMinutes == minutes,
                                    isAffordable: pointsManager.totalPoints >= minutes
                                ) {
                                    selectedMinutes = minutes
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Kosten-Info
                    CostInfoView(minutes: selectedMinutes, points: pointsManager.totalPoints)

                    // Einlösen-Button
                    Button {
                        if pointsManager.totalPoints >= selectedMinutes {
                            showConfirmation = true
                        } else {
                            showInsufficientPoints = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "hourglass")
                            Text("\(selectedMinutes) Minuten freischalten")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(pointsManager.totalPoints >= selectedMinutes ? Color.purple : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }

                    // Einlöse-Verlauf
                    if !pointsManager.history.filter({ $0.type == .redeemed }).isEmpty {
                        RedeemHistoryView(
                            history: pointsManager.history.filter { $0.type == .redeemed }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Einlösen")
            .confirmationDialog(
                "Möchtest du \(selectedMinutes) Minuten freischalten?",
                isPresented: $showConfirmation,
                titleVisibility: .visible
            ) {
                Button("Ja, \(selectedMinutes) Min freischalten (\(selectedMinutes) Punkte)") {
                    redeemTime()
                }
                Button("Abbrechen", role: .cancel) {}
            } message: {
                Text("Die Apps werden für \(selectedMinutes) Minuten entsperrt. Danach wird die Sperre automatisch reaktiviert.")
            }
            .alert("Nicht genug Punkte", isPresented: $showInsufficientPoints) {
                Button("OK") {}
            } message: {
                Text("Du brauchst \(selectedMinutes) Punkte, hast aber nur \(pointsManager.totalPoints). Erledige mehr Ziele!")
            }
            .overlay {
                if showSuccess {
                    SuccessOverlay(minutes: selectedMinutes) {
                        showSuccess = false
                    }
                }
            }
        }
    }

    private func redeemTime() {
        let success = pointsManager.redeemPoints(selectedMinutes)
        if success {
            appBlockingManager.startTimedSession(minutes: selectedMinutes)
            showSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showSuccess = false
            }
        }
    }
}

// MARK: - Subviews

struct MinuteOptionButton: View {
    let minutes: Int
    let isSelected: Bool
    let isAffordable: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(minutes)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("Min")
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.purple : Color(.systemGray5))
            .foregroundColor(
                isSelected ? .white : (isAffordable ? .primary : .secondary)
            )
            .cornerRadius(10)
            .opacity(isAffordable ? 1 : 0.5)
        }
        .buttonStyle(.plain)
    }
}

struct CostInfoView: View {
    let minutes: Int
    let points: Int

    var canAfford: Bool { points >= minutes }
    var remaining: Int { max(0, points - minutes) }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Kosten: \(minutes) Punkte")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(canAfford
                     ? "Danach: \(remaining) Punkte übrig"
                     : "Fehlen: \(minutes - points) Punkte")
                    .font(.caption)
                    .foregroundColor(canAfford ? .secondary : .red)
            }
            Spacer()
            Image(systemName: canAfford ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(canAfford ? .green : .red)
                .font(.title2)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RedeemHistoryView: View {
    let history: [PointsHistory]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Eingelöste Sessions")
                .font(.headline)

            ForEach(history.suffix(5).reversed()) { item in
                HStack {
                    Image(systemName: "hourglass.fill")
                        .foregroundColor(.orange)
                    Text(item.reason)
                        .font(.subheadline)
                    Spacer()
                    Text("-\(item.amount)")
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SuccessOverlay: View {
    let minutes: Int
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                Text("Viel Spaß!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("\(minutes) Minuten freigeschaltet")
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(40)
            .background(Color(.systemGray3).opacity(0.9))
            .cornerRadius(20)
        }
        .onTapGesture { onDismiss() }
    }
}
