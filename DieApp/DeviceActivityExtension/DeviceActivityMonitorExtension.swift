import DeviceActivity
import ManagedSettings

class DieAppDeviceActivityMonitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore()

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        if activity == DeviceActivityName("dieapp.session") {
            guard
                let data = UserDefaults(suiteName: "group.com.dieapp.app")?.data(forKey: "blockedAppsSelection"),
                let selection = try? JSONDecoder().decode(FamilyActivitySelectionWrapper.self, from: data)
            else { return }

            store.shield.applications = selection.applicationTokens
            store.shield.applicationCategories = .specific(selection.categoryTokens)
        }
    }
}

private struct FamilyActivitySelectionWrapper: Codable {
    var applicationTokens: Set<ApplicationToken> = []
    var categoryTokens: Set<ActivityCategoryToken> = []
}
