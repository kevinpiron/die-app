import SwiftUI

struct HomeView: View {
    @EnvironmentObject var pointsManager: PointsManager
    @EnvironmentObject var appBlockingManager: AppBlockingManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    PointsCardView(points: pointsManager.totalPoints)

                    if appBlockingManager.activeSessionMinutes > 0 {
                        ActiveSessionBanner(minutes: appBlockingManager.activeSessionMinutes)
                    }

                    TodayProgressView(
                        completed: pointsManager.completedTodayCount,
                        total: pointsManager.goals.count,
                        pointsToday: pointsManager.pointsEarnedToday
                    )

                    BlockingStatusCard()

                    if !pointsManager.history.isEmpty {
                        RecentHistoryView(history: Array(pointsManager.history.suffix(5).reversed()))
                    }
                }
                .padding()
            }
            .navigationTitle("die App")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct PointsCardView: View {
    let points: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    colors: [.purple, .indigo],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))

            VStack(spacing: 8) {
                Text("Deine Punkte")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                Text("\(points)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("= \(points) Minuten verfügbar")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.vertical, 30)
        }
        .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 5)
    }
}

struct ActiveSessionBanner: View {
    let minutes: Int

    var body: some View {
        HStack {
            Image(systemName: "hourglass.topsection.fill")
                .foregroundColor(.orange)
            VStack(alignment: .leading) {
                Text("Aktive Session")
                    .font(.headline)
                Text("\(minutes) Minuten verbleibend")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Circle()
                .fill(.orange)
                .frame(width: 12, height: 12)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.3), lineWidth: 1))
    }
}

struct TodayProgressView: View {
    let completed: Int
    let total: Int
    let pointsToday: Int

    var progress: Double {
        total > 0 ? Double(completed) / Double(total) : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Heute")
                    .font(.headline)
                Spacer()
                Text("+\(pointsToday) Punkte")
                    .font(.subheadline)
                    .foregroundColor(.purple)
                    .fontWeight(.semibold)
            }

            ProgressView(value: progress)
                .tint(.purple)

            Text("\(completed) von \(total) Zielen erledigt")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct BlockingStatusCard: View {
    @EnvironmentObject var appBlockingManager: AppBlockingManager

    var body: some View {
        HStack {
            Image(systemName: appBlockingManager.isBlocking ? "lock.fill" : "lock.open.fill")
                .foregroundColor(appBlockingManager.isBlocking ? .red : .green)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(appBlockingManager.isBlocking ? "Apps gesperrt" : "Apps freigegeben")
                    .font(.headline)
                Text(appBlockingManager.isBlocking ? "Verdiene Punkte um Zeit freizuschalten" : "Genieße deine Zeit bewusst")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RecentHistoryView: View {
    let history: [PointsHistory]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Letzte Aktivität")
                .font(.headline)

            ForEach(history) { item in
                HStack {
                    Image(systemName: item.type == .earned ? "plus.circle.fill" : "minus.circle.fill")
                        .foregroundColor(item.type == .earned ? .green : .orange)
                    Text(item.reason)
                        .font(.subheadline)
                    Spacer()
                    Text(item.type == .earned ? "+\(item.amount)" : "-\(item.amount)")
                        .fontWeight(.semibold)
                        .foregroundColor(item.type == .earned ? .green : .orange)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
