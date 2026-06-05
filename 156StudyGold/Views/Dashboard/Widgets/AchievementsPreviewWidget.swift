//
//  AchievementsPreviewWidget.swift
//  156StudyGold
//

import SwiftUI

struct AchievementsPreviewWidget: View {
    let achievements: [Achievement]
    let nextAchievement: Achievement?
    let nextProgress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label {
                    Text("Achievements")
                        .font(.headline)
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "rosette")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.studyGold)
                }
                Spacer()
                let unlocked = achievements.filter { $0.isAchieved }.count
                Text("\(unlocked) / \(achievements.count)")
                    .font(.caption)
                    .foregroundColor(.studyGray)
            }

            if let next = nextAchievement {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .stroke(Color.studyGray.opacity(0.25), lineWidth: 6)

                        Circle()
                            .trim(from: 0, to: max(0.0001, nextProgress))
                            .stroke(
                                LinearGradient(
                                    colors: [Color.studyGold.opacity(0.7), Color.studyGold],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))

                        Image(systemName: next.icon)
                            .font(.title3)
                            .foregroundColor(.studyGold)
                    }
                    .frame(width: 60, height: 60)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Next reward")
                            .font(.caption2)
                            .foregroundColor(.studyGray)
                        Text(next.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(next.details)
                            .font(.caption2)
                            .foregroundColor(.studyGray)
                            .lineLimit(2)
                    }

                    Spacer()

                    Text("\(Int(nextProgress * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.studyGold)
                }
                .padding(12)
                .background(Color.studyBackground.opacity(0.5))
                .cornerRadius(14)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(achievements) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
            }
        }
        .padding(16)
        .elevatedCard(cornerRadius: 20, shadowRadius: 14, shadowOffsetY: 8)
    }
}
