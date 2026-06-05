//
//  GoalCard.swift
//  156StudyGold
//

import SwiftUI

enum GoalState {
    case active
    case completed
    case overdue

    var title: String {
        switch self {
        case .active: return "Active"
        case .completed: return "Completed"
        case .overdue: return "Overdue"
        }
    }

    var color: Color {
        switch self {
        case .active: return .studyGold
        case .completed: return .studyGold
        case .overdue: return Color(red: 0.95, green: 0.45, blue: 0.45)
        }
    }

    var icon: String {
        switch self {
        case .active: return "bolt.fill"
        case .completed: return "checkmark.seal.fill"
        case .overdue: return "exclamationmark.triangle.fill"
        }
    }
}

extension StudyGoal {
    var state: GoalState {
        if isCompleted { return .completed }
        if let deadline, deadline < Date() { return .overdue }
        return .active
    }

    var daysRemaining: Int? {
        guard let deadline else { return nil }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: deadline).day
        return days
    }
}

struct GoalCard: View {
    let goal: StudyGoal
    var onComplete: (() -> Void)?
    var onAddHours: (() -> Void)?
    var onDelete: (() -> Void)?

    private var state: GoalState { goal.state }

    private var deadlineText: String? {
        guard let days = goal.daysRemaining else { return nil }
        if goal.isCompleted, let deadline = goal.deadline {
            return "Was due \(formattedShortDate(deadline))"
        }
        if days < 0 { return "\(-days) d overdue" }
        if days == 0 { return "Due today" }
        return "\(days) d left"
    }

    private var cardFillColor: Color {
        if goal.isCompleted { return Color.studyBackgroundLight.opacity(0.5) }
        if state == .overdue { return Color.studyBackgroundLight.opacity(0.5) }
        return Color.studyBackgroundLight.opacity(0.45)
    }

    private var cardStrokeColor: Color {
        if state == .overdue { return state.color.opacity(0.45) }
        if goal.isCompleted { return Color.studyGold.opacity(0.45) }
        return Color.white.opacity(0.18)
    }

    private var cardShadowColor: Color {
        if goal.isCompleted { return Color.studyGold.opacity(0.20) }
        if state == .overdue { return state.color.opacity(0.20) }
        return Color.black.opacity(0.25)
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Color.studyGray.opacity(0.25), lineWidth: 7)

                    Circle()
                        .trim(from: 0, to: max(0.0001, min(goal.progress, 1)))
                        .stroke(
                            LinearGradient(
                                colors: [state.color.opacity(0.7), state.color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 7, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.6, dampingFraction: 0.85), value: goal.progress)

                    if goal.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.studyGold)
                    } else {
                        Text("\(Int(goal.progress * 100))%")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 64, height: 64)

                VStack(alignment: .leading, spacing: 6) {
                    Text(goal.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)

                    HStack(spacing: 6) {
                        StatusBadge(title: state.title, color: state.color, icon: state.icon)

                        if let text = deadlineText {
                            HStack(spacing: 3) {
                                Image(systemName: "calendar")
                                    .font(.caption2)
                                Text(text)
                                    .font(.caption2)
                            }
                            .foregroundColor(state == .overdue ? state.color : .studyGray)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(goal.currentHours) of \(goal.targetHours) hours")
                        .font(.caption)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(max(goal.targetHours - goal.currentHours, 0)) h to go")
                        .font(.caption)
                        .foregroundColor(.studyGray)
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.studyGray.opacity(0.25))
                            .frame(height: 8)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [state.color.opacity(0.7), state.color],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: max(0, min(CGFloat(goal.progress), 1) * proxy.size.width),
                                height: 8
                            )
                            .animation(.spring(response: 0.6, dampingFraction: 0.85), value: goal.progress)
                    }
                }
                .frame(height: 8)
            }

            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "crown.fill")
                        .font(.caption)
                        .foregroundColor(.studyGold)
                    Text("+\(goal.rewardGold)")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.studyGold)
                    Text("gold")
                        .font(.caption)
                        .foregroundColor(.studyGray)
                }

                Spacer()

                if !goal.isCompleted {
                    if let onAddHours {
                        Button(action: onAddHours) {
                            Image(systemName: "plus")
                                .font(.subheadline.bold())
                                .foregroundColor(.studyGold)
                                .frame(width: 36, height: 36)
                                .background(Color.studyGray.opacity(0.18))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }

                    if let onComplete {
                        Button(action: onComplete) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark")
                                Text("Complete")
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.studyBackground)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(Color.studyGold)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(cardFillColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(cardStrokeColor, lineWidth: 1)
        )
        .compositingGroup()
        .shadow(color: cardShadowColor, radius: 8, x: 0, y: 4)
    }
}
