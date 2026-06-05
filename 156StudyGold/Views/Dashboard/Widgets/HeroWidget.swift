//
//  HeroWidget.swift
//  156StudyGold
//

import SwiftUI

struct HeroWidget: View {
    let totalGold: Int
    let totalHours: Int
    let streak: Int
    var onAction: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(LinearGradient.studyGoldGradient)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.30), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )

            // Decorative bubbles
            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 220, height: 220)
                .offset(x: 130, y: -110)
                .blendMode(.softLight)

            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 130, height: 130)
                .offset(x: -110, y: 90)
                .blendMode(.softLight)

            // Decorative big icon
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 130, weight: .bold))
                .foregroundColor(Color.studyBackground.opacity(0.18))
                .rotationEffect(.degrees(-12))
                .offset(x: 90, y: 6)

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(greeting().uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(2)
                        .foregroundColor(Color.studyBackground.opacity(0.7))
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.subheadline)
                        .foregroundColor(.studyBackground)
                        .symbolRenderingMode(.hierarchical)
                }

                Text("Let's study\nand earn gold")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(.studyBackground)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                HStack(spacing: 14) {
                    heroStat(icon: "crown.fill", value: "\(totalGold)", label: "gold")
                    heroDivider
                    heroStat(icon: "clock.fill", value: "\(totalHours)h", label: "studied")
                    heroDivider
                    heroStat(icon: "flame.fill", value: "\(streak)", label: "streak")
                }

                Button(action: onAction) {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                        Text("Start a session")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .foregroundColor(.studyGold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.studyBackground)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.35), lineWidth: 1)
        )
        .compositingGroup()
        .shadow(color: Color.studyGold.opacity(0.35), radius: 12, x: 0, y: 8)
    }

    private func heroStat(icon: String, value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.studyBackground)

            Text(label)
                .font(.caption2)
                .foregroundColor(Color.studyBackground.opacity(0.7))
        }
    }

    private var heroDivider: some View {
        Rectangle()
            .fill(Color.studyBackground.opacity(0.25))
            .frame(width: 1, height: 28)
    }

    private func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Hello"
        }
    }
}
