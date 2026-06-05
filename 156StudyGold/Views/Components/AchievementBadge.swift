//
//  AchievementBadge.swift
//  156StudyGold
//

import SwiftUI

struct AchievementBadge: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(achievement.isAchieved ? Color.studyGold.opacity(0.30) : Color.studyGray.opacity(0.18))
                    .frame(width: 46, height: 46)

                Image(systemName: achievement.icon)
                    .font(.title3)
                    .foregroundColor(achievement.isAchieved ? .studyGold : .studyGray)
                    .symbolRenderingMode(.hierarchical)
            }

            Text(achievement.name)
                .font(.caption2)
                .foregroundColor(achievement.isAchieved ? .white : .studyGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(8)
        .frame(width: 92, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(achievement.isAchieved ? Color.studyGold.opacity(0.12) : Color.studyGray.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    achievement.isAchieved ? Color.studyGold.opacity(0.45) : Color.white.opacity(0.08),
                    lineWidth: 1
                )
        )
    }
}
