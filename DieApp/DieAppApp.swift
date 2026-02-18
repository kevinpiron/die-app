import SwiftUI
import FamilyControls

@main
struct DieAppApp: App {
    @StateObject private var pointsManager = PointsManager()
    @StateObject private var appBlockingManager = AppBlockingManager()

    init() {
        Task {
            await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pointsManager)
                .environmentObject(appBlockingManager)
        }
    }
}
