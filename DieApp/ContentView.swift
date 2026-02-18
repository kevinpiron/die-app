import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            GoalsView()
                .tabItem {
                    Label("Ziele", systemImage: "checkmark.circle.fill")
                }

            AppsView()
                .tabItem {
                    Label("Apps", systemImage: "lock.shield.fill")
                }

            RedeemView()
                .tabItem {
                    Label("Einlösen", systemImage: "hourglass")
                }
        }
        .accentColor(.purple)
    }
}
