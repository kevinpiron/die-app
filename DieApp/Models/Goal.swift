import Foundation

struct Goal: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var points: Int
    var isCompleted: Bool = false
    var completedAt: Date? = nil
    var category: GoalCategory

    enum GoalCategory: String, Codable, CaseIterable {
        case sport = "Sport"
        case haushalt = "Haushalt"
        case lernen = "Lernen"
        case gesundheit = "Gesundheit"
        case soziales = "Soziales"
        case sonstiges = "Sonstiges"

        var icon: String {
            switch self {
            case .sport: return "figure.run"
            case .haushalt: return "house.fill"
            case .lernen: return "book.fill"
            case .gesundheit: return "heart.fill"
            case .soziales: return "person.2.fill"
            case .sonstiges: return "star.fill"
            }
        }
    }

    mutating func complete() {
        isCompleted = true
        completedAt = Date()
    }
}
