//
//  SessionRow.swift
//  156StudyGold
//

import SwiftUI

struct SessionRow: View {
    let session: StudySession

    private var difficultyIcon: String {
        switch session.difficulty {
        case .easy: return "leaf.fill"
        case .medium: return "scalemass.fill"
        case .hard: return "flame.fill"
        }
    }

    private var difficultyTint: Color {
        switch session.difficulty {
        case .easy: return Color(red: 0.55, green: 0.85, blue: 0.65)
        case .medium: return Color.studyGold
        case .hard: return Color(red: 0.95, green: 0.55, blue: 0.35)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [difficultyTint.opacity(0.4), difficultyTint.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)

                Image(systemName: difficultyIcon)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(difficultyTint)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(session.subjectName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                HStack(spacing: 6) {
                    Image(systemName: "timer")
                        .font(.caption2)
                    Text("\(session.duration) min")
                        .font(.caption)
                    Text("·")
                    Text(formattedShortDate(session.date))
                        .font(.caption)
                }
                .foregroundColor(.studyGray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 3) {
                    Image(systemName: "crown.fill")
                        .font(.caption2)
                    Text("+\(session.earnedGold)")
                        .font(.subheadline)
                        .bold()
                }
                .foregroundColor(.studyGold)

                Text(session.difficulty.rawValue)
                    .font(.caption2)
                    .foregroundColor(.studyGray)
            }
        }
        .padding(12)
        .elevatedCard(cornerRadius: 14, shadowRadius: 8, shadowOffsetY: 4)
    }
}
