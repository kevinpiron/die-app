import SwiftUI
import FamilyControls

struct AppsView: View {
    @EnvironmentObject var appBlockingManager: AppBlockingManager
    @State private var showAppPicker = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Status-Karte
                    BlockingControlCard()

                    // App-Auswahl
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gesperrte Apps")
                            .font(.headline)
                            .padding(.horizontal)

                        if appBlockingManager.hasSelection {
                            SelectionInfoCard()
                        } else {
                            EmptySelectionCard {
                                showAppPicker = true
                            }
                        }

                        Button {
                            showAppPicker = true
                        } label: {
                            Label("Apps auswählen", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // Erklärung
                    InfoCard()
                }
                .padding(.vertical)
            }
            .navigationTitle("Apps sperren")
            .familyActivityPicker(
                isPresented: $showAppPicker,
                selection: $appBlockingManager.selection
            )
            .onChange(of: appBlockingManager.selection) { _ in
                appBlockingManager.saveSelection()
                if appBlockingManager.isBlocking {
                    appBlockingManager.startBlocking()
                }
            }
        }
    }
}

// MARK: - Subviews

struct BlockingControlCard: View {
    @EnvironmentObject var appBlockingManager: AppBlockingManager

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appBlockingManager.isBlocking ? "Sperre aktiv" : "Sperre inaktiv")
                        .font(.headline)
                    Text(appBlockingManager.isBlocking
                         ? "Ausgewählte Apps sind gesperrt"
                         : "Keine Apps werden gerade gesperrt")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Toggle("", isOn: Binding(
                    get: { appBlockingManager.isBlocking },
                    set: { enabled in
                        if enabled {
                            appBlockingManager.startBlocking()
                        } else {
                            appBlockingManager.stopBlocking()
                        }
                    }
                ))
                .tint(.purple)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct SelectionInfoCard: View {
    @EnvironmentObject var appBlockingManager: AppBlockingManager

    var body: some View {
        HStack {
            Image(systemName: "checkmark.shield.fill")
                .foregroundColor(.purple)
                .font(.title2)
            VStack(alignment: .leading) {
                Text("Apps ausgewählt")
                    .font(.headline)
                Text("\(appBlockingManager.selection.applicationTokens.count) Apps, \(appBlockingManager.selection.categoryTokens.count) Kategorien")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EmptySelectionCard: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(systemName: "apps.iphone")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                Text("Keine Apps ausgewählt")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("Tippe um Apps auszuwählen, die du sperren möchtest")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(30)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

struct InfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Wie funktioniert das?", systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundColor(.blue)

            Text("• Wähle Apps aus, die du sperren möchtest\n• Aktiviere die Sperre mit dem Schalter\n• Erledige Ziele, um Punkte zu verdienen\n• Löse Punkte ein um Apps freizuschalten")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(Color.blue.opacity(0.08))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
