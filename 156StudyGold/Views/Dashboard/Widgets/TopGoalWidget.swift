//
//  TopGoalWidget.swift
//  156StudyGold
//

import SwiftUI

struct TopGoalWidget: View {
    let goal: StudyGoal
    var onLogHours: () -> Void
    var onTap: () -> Void

    private var deadlineText: String? {
        guard let days = goal.daysRemaining else { return nil }
        if days < 0 { return "\(-days) d overdue" }
        if days == 0 { return "Due today" }
        return "\(days) d left"
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label {
                        Text("Top Goal")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    } icon: {
                        Image(systemName: "target")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.studyGold)
                    }
                    Spacer()
                    if let text = deadlineText {
                        StatusBadge(title: text, color: .studyGold, icon: "calendar")
                    }
                }

                HStack(alignment: .center, spacing: 16) {
                    ZStack {
                        Circle()
                            .stroke(Color.studyGray.opacity(0.25), lineWidth: 8)

                        Circle()
                            .trim(from: 0, to: max(0.0001, goal.progress))
                            .stroke(
                                LinearGradient(
                                    colors: [Color.studyGold.opacity(0.7), Color.studyGold],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 0) {
                            Text("\(Int(goal.progress * 100))")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("%")
                                .font(.caption2)
                                .foregroundColor(.studyGray)
                        }
                    }
                    .frame(width: 78, height: 78)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(goal.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(2)

                        Text("\(goal.currentHours) of \(goal.targetHours) hours")
                            .font(.caption)
                            .foregroundColor(.studyGray)

                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundColor(.studyGold)
                            Text("+\(goal.rewardGold) gold reward")
                                .font(.caption)
                                .foregroundColor(.studyGold)
                        }
                    }

                    Spacer(minLength: 0)
                }

                Button(action: onLogHours) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        Text("Log progress")
                            .fontWeight(.semibold)
                    }
                    .font(.caption)
                    .foregroundColor(.studyBackground)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .frame(maxWidth: .infinity)
                    .background(Color.studyGold)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.studyBackgroundLight.opacity(0.55))
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(LinearGradient.studyCardGradient)
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.studyGold.opacity(0.15), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 110))
                        .foregroundColor(.studyGold.opacity(0.08))
                        .offset(x: 130, y: 36)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.studyGold.opacity(0.55), Color.studyGold.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .compositingGroup()
            .shadow(color: Color.studyGold.opacity(0.20), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
