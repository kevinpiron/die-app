import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

class AppBlockingManager: ObservableObject {
    @Published var selection = FamilyActivitySelection()
    @Published var isBlocking: Bool = false
    @Published var activeSessionMinutes: Int = 0

    private let store = ManagedSettingsStore()
    private let deviceActivityCenter = DeviceActivityCenter()
    private var sessionTimer: Timer?

    init() {
        loadSelection()
    }

    func saveSelection() {
        if let encoded = try? JSONEncoder().encode(selection) {
            UserDefaults(suiteName: "group.com.dieapp.app")?.set(encoded, forKey: "blockedAppsSelection")
        }
    }

    private func loadSelection() {
        if let data = UserDefaults(suiteName: "group.com.dieapp.app")?.data(forKey: "blockedAppsSelection"),
           let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            self.selection = decoded
        }
    }

    func startBlocking() {
        store.shield.applications = selection.applicationTokens
        store.shield.applicationCategories = .specific(selection.categoryTokens)
        isBlocking = true
    }

    func stopBlocking() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        isBlocking = false
    }

    func startTimedSession(minutes: Int) {
        stopBlocking()
        activeSessionMinutes = minutes

        sessionTimer?.invalidate()
        sessionTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(minutes * 60), repeats: false) { [weak self] _ in
            self?.endTimedSession()
        }

        scheduleActivityEnd(minutes: minutes)
    }

    private func endTimedSession() {
        activeSessionMinutes = 0
        startBlocking()
        sessionTimer = nil
    }

    private func scheduleActivityEnd(minutes: Int) {
        let now = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: minutes, to: now)!

        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: now)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: endDate)

        let schedule = DeviceActivitySchedule(
            intervalStart: startComponents,
            intervalEnd: endComponents,
            repeats: false
        )

        try? deviceActivityCenter.startMonitoring(
            DeviceActivityName("dieapp.session"),
            during: schedule
        )
    }

    var hasSelection: Bool {
        !selection.applicationTokens.isEmpty || !selection.categoryTokens.isEmpty
    }
}
