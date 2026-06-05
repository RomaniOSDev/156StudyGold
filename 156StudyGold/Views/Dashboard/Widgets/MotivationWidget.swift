//
//  MotivationWidget.swift
//  156StudyGold
//

import SwiftUI

struct MotivationTip: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let message: String
    let gradient: [Color]
}

struct MotivationWidget: View {
    let tip: MotivationTip

    static let library: [MotivationTip] = [
        MotivationTip(
            icon: "lightbulb.fill",
            title: "Tip of the day",
            message: "Break study into 25 minute focus blocks to keep momentum high.",
            gradient: [
                Color(red: 0.55, green: 0.65, blue: 0.95),
                Color(red: 0.30, green: 0.40, blue: 0.85)
            ]
        ),
        MotivationTip(
            icon: "brain.head.profile",
            title: "Learn smarter",
            message: "Recall beats reread: close the book and explain it out loud.",
            gradient: [
                Color(red: 0.75, green: 0.55, blue: 0.95),
                Color(red: 0.45, green: 0.30, blue: 0.85)
            ]
        ),
        MotivationTip(
            icon: "leaf.fill",
            title: "Stay rested",
            message: "A short walk between sessions improves focus more than caffeine.",
            gradient: [
                Color(red: 0.45, green: 0.85, blue: 0.65),
                Color(red: 0.20, green: 0.60, blue: 0.50)
            ]
        ),
        MotivationTip(
            icon: "moon.stars.fill",
            title: "Sleep is fuel",
            message: "Aim for 7+ hours of sleep, your brain encodes memories then.",
            gradient: [
                Color(red: 0.40, green: 0.55, blue: 0.85),
                Color(red: 0.20, green: 0.30, blue: 0.65)
            ]
        ),
        MotivationTip(
            icon: "target",
            title: "Stack small wins",
            message: "Track each session, small daily progress always beats cramming.",
            gradient: [
                Color(red: 0.95, green: 0.65, blue: 0.45),
                Color(red: 0.85, green: 0.45, blue: 0.30)
            ]
        )
    ]

    static func random() -> MotivationTip {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return library[day % library.count]
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: tip.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.25), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )

            // decorative giant icon
            Image(systemName: tip.icon)
                .font(.system(size: 130, weight: .bold))
                .foregroundColor(.white.opacity(0.15))
                .offset(x: 110, y: 18)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 36, height: 36)
                        Image(systemName: tip.icon)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    Text(tip.title.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.85))
                }

                Text(tip.message)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 130)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
        .compositingGroup()
        .shadow(color: tip.gradient.last?.opacity(0.30) ?? .black, radius: 10, x: 0, y: 6)
    }
}
