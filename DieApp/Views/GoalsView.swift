import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var pointsManager: PointsManager
    @State private var showAddGoal = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(pointsManager.goals) { goal in
                        GoalRowView(goal: goal) {
                            pointsManager.completeGoal(goal)
                        }
                    }
                    .onDelete { offsets in
                        pointsManager.deleteGoal(at: offsets)
                    }
                } header: {
                    Text("Heutige Ziele")
                }

                Section {
                    Button {
                        pointsManager.resetDailyGoals()
                    } label: {
                        Label("Alle zurücksetzen", systemImage: "arrow.clockwise")
                            .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("Ziele")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddGoal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddGoal) {
                AddGoalView { newGoal in
                    pointsManager.addGoal(newGoal)
                }
            }
        }
    }
}

// MARK: - Goal Row

struct GoalRowView: View {
    let goal: Goal
    let onComplete: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(goal.isCompleted ? Color.purple.opacity(0.15) : Color(.systemGray5))
                    .frame(width: 44, height: 44)
                Image(systemName: goal.category.icon)
                    .foregroundColor(goal.isCompleted ? .purple : .secondary)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(goal.title)
                    .font(.body)
                    .strikethrough(goal.isCompleted)
                    .foregroundColor(goal.isCompleted ? .secondary : .primary)
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    Text("+\(goal.points) Punkte")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if !goal.isCompleted {
                Button {
                    onComplete()
                } label: {
                    Image(systemName: "checkmark.circle")
                        .font(.title2)
                        .foregroundColor(.purple)
                }
                .buttonStyle(.plain)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.purple)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Goal Sheet

struct AddGoalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var points = 20
    @State private var category = Goal.GoalCategory.sonstiges

    let onAdd: (Goal) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section("Ziel") {
                    TextField("z.B. Sport machen", text: $title)
                }

                Section("Kategorie") {
                    Picker("Kategorie", selection: $category) {
                        ForEach(Goal.GoalCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                }

                Section("Punkte") {
                    Stepper("\(points) Punkte", value: $points, in: 5...100, step: 5)
                }
            }
            .navigationTitle("Neues Ziel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Hinzufügen") {
                        guard !title.isEmpty else { return }
                        let goal = Goal(title: title, points: points, category: category)
                        onAdd(goal)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
