//
//  LastSessionWidget.swift
//  156StudyGold
//

import SwiftUI

struct LastSessionWidget: View {
    let session: StudySession
    let category: SubjectCategory?

    private var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: session.date, relativeTo: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label {
                    Text("Last Session")
                        .font(.subheadline)
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "clock.arrow.circlepath")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.studyGold)
                }
                Spacer()
                Text(relativeTime)
                    .font(.caption2)
                    .foregroundColor(.studyGray)
            }

            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.studyGold.opacity(0.35),
                                    Color.studyGold.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)

                    Image(systemName: category?.icon ?? "book.fill")
                        .font(.title2)
                        .foregroundColor(.studyGold)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(session.subjectName)
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack(spacing: 6) {
                        InfoChip(
                            icon: "timer",
                            text: "\(session.duration) min",
                            tint: .studyGray
                        )
                        InfoChip(
                            icon: difficultyIcon,
                            text: session.difficulty.rawValue,
                            tint: .studyGold
                        )
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                        Text("+\(session.earnedGold)")
                            .font(.headline)
                            .bold()
                    }
                    .foregroundColor(.studyGold)
                    Text("earned")
                        .font(.caption2)
                        .foregroundColor(.studyGray)
                }
            }

            if let notes = session.notes, !notes.isEmpty {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "text.quote")
                        .font(.caption)
                        .foregroundColor(.studyGray)
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.studyBackground.opacity(0.5))
                .cornerRadius(10)
            }
        }
        .padding(16)
        .elevatedCard(cornerRadius: 20, shadowRadius: 14, shadowOffsetY: 8)
    }

    private var difficultyIcon: String {
        switch session.difficulty {
        case .easy: return "leaf.fill"
        case .medium: return "scalemass.fill"
        case .hard: return "flame.fill"
        }
    }
}
