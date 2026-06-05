//
//  SubjectCard.swift
//  156StudyGold
//

import SwiftUI

struct SubjectCard: View {
    let subject: Subject
    let totalHours: Int
    let weeklyHours: Int
    let totalSessions: Int
    let totalGold: Int
    let lastSessionDate: Date?
    let weeklyProgress: Double

    var onFavorite: () -> Void
    var onStart: () -> Void

    private var lastSessionText: String {
        guard let date = lastSessionDate else { return "No sessions yet" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return "Last: " + formatter.localizedString(for: date, relativeTo: Date())
    }

    private var goalReached: Bool {
        weeklyHours >= subject.goalHours && subject.goalHours > 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.studyGold.opacity(0.35),
                                    Color.studyGold.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)

                    Image(systemName: subject.category.icon)
                        .font(.title2)
                        .foregroundColor(.studyGold)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text(subject.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)

                        if subject.isFavorite {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.studyGold)
                        }

                        Spacer(minLength: 0)
                    }

                    HStack(spacing: 6) {
                        StatusBadge(
                            title: subject.category.rawValue,
                            color: .studyGray
                        )
                        if goalReached {
                            StatusBadge(title: "Goal hit", color: .studyGold, icon: "checkmark")
                        }
                    }
                }

                Spacer()

                CircularProgressView(
                    progress: weeklyProgress,
                    lineWidth: 6,
                    showsPercentage: true,
                    label: nil
                )
                .frame(width: 50, height: 50)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("This week")
                        .font(.caption)
                        .foregroundColor(.studyGray)
                    Spacer()
                    Text("\(weeklyHours) / \(subject.goalHours) h")
                        .font(.caption)
                        .foregroundColor(goalReached ? .studyGold : .white)
                        .bold()
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.studyGray.opacity(0.25))
                            .frame(height: 6)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.studyGold.opacity(0.7), .studyGold],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: max(0, min(CGFloat(weeklyProgress), 1) * proxy.size.width),
                                height: 6
                            )
                            .animation(.spring(response: 0.6, dampingFraction: 0.85), value: weeklyProgress)
                    }
                }
                .frame(height: 6)
            }

            HStack(spacing: 8) {
                InfoChip(icon: "clock.fill", text: "\(totalHours) h", tint: .studyGold)
                InfoChip(icon: "book.fill", text: "\(totalSessions)", tint: .studyGray)
                InfoChip(icon: "crown.fill", text: "\(totalGold)", tint: .studyGold)
                Spacer(minLength: 0)
            }

            HStack {
                Text(lastSessionText)
                    .font(.caption2)
                    .foregroundColor(.studyGray)

                Spacer()

                Button(action: onFavorite) {
                    Image(systemName: subject.isFavorite ? "star.slash" : "star")
                        .font(.subheadline)
                        .foregroundColor(.studyGold)
                        .padding(8)
                        .background(Color.studyGray.opacity(0.18))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Button(action: onStart) {
                    HStack(spacing: 4) {
                        Image(systemName: "play.fill")
                        Text("Start")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.studyBackground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.studyGold)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(subject.isFavorite
                      ? Color.studyBackgroundLight.opacity(0.55)
                      : Color.studyBackgroundLight.opacity(0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    subject.isFavorite
                    ? Color.studyGold.opacity(0.45)
                    : Color.white.opacity(0.18),
                    lineWidth: 1
                )
        )
        .overlay(alignment: .leading) {
            if subject.isFavorite {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.studyGold)
                    .frame(width: 4)
                    .padding(.vertical, 14)
            }
        }
        .compositingGroup()
        .shadow(
            color: subject.isFavorite ? Color.studyGold.opacity(0.20) : Color.black.opacity(0.25),
            radius: 8, x: 0, y: 4
        )
    }
}
