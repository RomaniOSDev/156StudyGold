//
//  StreakWidget.swift
//  156StudyGold
//

import SwiftUI

struct StreakWidget: View {
    let streak: Int

    private var message: String {
        switch streak {
        case 0: return "Start your streak today"
        case 1...3: return "Keep going, you started!"
        case 4...6: return "Almost a full week!"
        case 7...13: return "On fire this week"
        case 14...29: return "Two weeks strong"
        default: return "Unstoppable!"
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.45, blue: 0.18),
                            Color.studyGold
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // decorative big flame
            Image(systemName: "flame.fill")
                .font(.system(size: 150, weight: .black))
                .foregroundColor(.white.opacity(0.18))
                .offset(x: 110, y: 30)

            // small flame top right
            Image(systemName: "flame.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 36))
                .foregroundColor(.white)
                .padding(14)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            VStack(alignment: .leading, spacing: 10) {
                Text("STREAK")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.8))

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(streak)")
                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text(streak == 1 ? "day" : "days")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.85))
                }

                Text(message)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)
            }
            .padding(16)
        }
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .compositingGroup()
        .shadow(color: Color.orange.opacity(0.35), radius: 10, x: 0, y: 6)
    }
}
