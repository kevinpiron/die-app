import Foundation
import Combine

class PointsManager: ObservableObject {
    @Published var totalPoints: Int {
        didSet { UserDefaults.standard.set(totalPoints, forKey: "totalPoints") }
    }

    @Published var goals: [Goal] {
        didSet {
            if let encoded = try? JSONEncoder().encode(goals) {
                UserDefaults.standard.set(encoded, forKey: "goals")
            }
        }
    }

    @Published var history: [PointsHistory] {
        didSet {
            if let encoded = try? JSONEncoder().encode(history) {
                UserDefaults.standard.set(encoded, forKey: "pointsHistory")
            }
        }
    }

    init() {
        self.totalPoints = UserDefaults.standard.integer(forKey: "totalPoints")

        if let savedGoals = UserDefaults.standard.data(forKey: "goals"),
           let decoded = try? JSONDecoder().decode([Goal].self, from: savedGoals) {
            self.goals = decoded
        } else {
            self.goals = Goal.defaultGoals()
        }

        if let savedHistory = UserDefaults.standard.data(forKey: "pointsHistory"),
           let decoded = try? JSONDecoder().decode([PointsHistory].self, from: savedHistory) {
            self.history = decoded
        } else {
            self.history = []
        }
    }

    func completeGoal(_ goal: Goal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }),
              !goals[index].isCompleted else { return }

        goals[index].complete()
        addPoints(goal.points, reason: "Ziel erfüllt: \(goal.title)")
    }

    func addPoints(_ amount: Int, reason: String) {
        totalPoints += amount
        history.append(PointsHistory(amount: amount, reason: reason, type: .earned))
    }

    func redeemPoints(_ amount: Int) -> Bool {
        guard totalPoints >= amount else { return false }
        totalPoints -= amount
        history.append(PointsHistory(amount: amount, reason: "Apps für \(amount) Min freigeschaltet", type: .redeemed))
        return true
    }

    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }

    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }

    func resetDailyGoals() {
        for index in goals.indices {
            goals[index].isCompleted = false
            goals[index].completedAt = nil
        }
    }

    var completedTodayCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return goals.filter {
            $0.isCompleted &&
            $0.completedAt.map { Calendar.current.isDate($0, inSameDayAs: today) } == true
        }.count
    }

    var pointsEarnedToday: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return history
            .filter { $0.type == .earned && Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.amount }
    }
}

struct PointsHistory: Identifiable, Codable {
    var id: UUID = UUID()
    var amount: Int
    var reason: String
    var type: HistoryType
    var date: Date = Date()

    enum HistoryType: String, Codable {
        case earned = "Verdient"
        case redeemed = "Eingelöst"
    }
}

extension Goal {
    static func defaultGoals() -> [Goal] {
        [
            Goal(title: "Sport machen", points: 30, category: .sport),
            Goal(title: "Zimmer aufräumen", points: 20, category: .haushalt),
            Goal(title: "30 Min lesen", points: 25, category: .lernen),
            Goal(title: "Ausreichend Wasser trinken", points: 10, category: .gesundheit),
        ]
    }
}
