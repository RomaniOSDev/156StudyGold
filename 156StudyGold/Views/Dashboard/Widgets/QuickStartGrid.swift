//
//  QuickStartGrid.swift
//  156StudyGold
//

import SwiftUI

struct QuickStartGrid: View {
    let subjects: [Subject]
    var onSelect: (Subject) -> Void
    var onAdd: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label {
                    Text("Quick Start")
                        .font(.headline)
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.studyGold)
                }
                Spacer()
                Text("\(subjects.count) subjects")
                    .font(.caption)
                    .foregroundColor(.studyGray)
            }

            if subjects.isEmpty {
                emptyTile
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(subjects) { subject in
                        Button {
                            onSelect(subject)
                        } label: {
                            QuickStartTile(subject: subject)
                        }
                        .buttonStyle(.plain)
                    }

                    Button(action: onAdd) {
                        addTile
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var emptyTile: some View {
        Button(action: onAdd) {
            VStack(spacing: 10) {
                Image(systemName: "plus.app.fill")
                    .font(.system(size: 44))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.studyGold)
                Text("Add your first subject")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("Pick a category and start tracking")
                    .font(.caption)
                    .foregroundColor(.studyGray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color.studyGray.opacity(0.12))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.studyGold.opacity(0.4), lineWidth: 1)
            )
            .cornerRadius(18)
        }
        .buttonStyle(.plain)
    }

    private var addTile: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.studyGold.opacity(0.18))
                    .frame(width: 48, height: 48)
                Image(systemName: "plus")
                    .font(.title3.bold())
                    .foregroundColor(.studyGold)
            }

            Spacer()

            Text("New subject")
                .font(.headline)
                .foregroundColor(.white)
            Text("Add another to your list")
                .font(.caption2)
                .foregroundColor(.studyGray)
        }
        .padding(14)
        .frame(height: 150)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.studyGray.opacity(0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    Color.studyGold.opacity(0.5),
                    style: StrokeStyle(lineWidth: 1, dash: [4, 3])
                )
        )
        .cornerRadius(18)
    }
}

private struct QuickStartTile: View {
    let subject: Subject

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.25), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )

            // Decorative big icon
            Image(systemName: subject.category.icon)
                .font(.system(size: 95, weight: .bold))
                .foregroundColor(.white.opacity(0.13))
                .offset(x: 80, y: 30)

            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.studyBackground.opacity(0.35))
                        .frame(width: 44, height: 44)
                    Image(systemName: subject.category.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                }

                Spacer()

                Text(subject.name)
                    .font(.headline)
                    .foregroundColor(.studyBackground)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                HStack(spacing: 4) {
                    Image(systemName: "play.fill")
                        .font(.caption2)
                    Text("Start  ·  +10/h")
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.studyBackground.opacity(0.85))
            }
            .padding(14)

            if subject.isFavorite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.studyBackground)
                    .padding(8)
                    .background(Color.white.opacity(0.4))
                    .clipShape(Circle())
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
            }
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .compositingGroup()
        .shadow(color: gradientColors.last?.opacity(0.30) ?? .black, radius: 8, x: 0, y: 4)
    }

    private var gradientColors: [Color] {
        switch subject.category {
        case .math:
            return [Color(red: 0.50, green: 0.80, blue: 0.95), Color(red: 0.30, green: 0.55, blue: 0.85)]
        case .physics:
            return [Color(red: 0.65, green: 0.55, blue: 0.95), Color(red: 0.40, green: 0.30, blue: 0.85)]
        case .chemistry:
            return [Color(red: 0.55, green: 0.90, blue: 0.65), Color(red: 0.20, green: 0.65, blue: 0.45)]
        case .biology:
            return [Color(red: 0.60, green: 0.85, blue: 0.50), Color(red: 0.35, green: 0.65, blue: 0.30)]
        case .history:
            return [Color(red: 0.95, green: 0.75, blue: 0.50), Color(red: 0.75, green: 0.50, blue: 0.30)]
        case .languages:
            return [Color(red: 0.95, green: 0.55, blue: 0.65), Color(red: 0.80, green: 0.30, blue: 0.45)]
        case .programming:
            return [Color(red: 0.30, green: 0.75, blue: 0.85), Color(red: 0.10, green: 0.50, blue: 0.65)]
        case .art:
            return [Color(red: 0.95, green: 0.60, blue: 0.85), Color(red: 0.75, green: 0.35, blue: 0.65)]
        case .music:
            return [Color(red: 0.70, green: 0.60, blue: 0.95), Color(red: 0.45, green: 0.35, blue: 0.80)]
        case .other:
            return [Color.studyGold.opacity(0.95), Color.studyGold.opacity(0.65)]
        }
    }
}
