//
//  TodayStatsWidget.swift
//  156StudyGold
//

import SwiftUI

struct TodayStatsWidget: View {
    let minutes: Int
    let sessions: Int
    let gold: Int

    private var hoursText: String {
        if minutes >= 60 {
            let h = minutes / 60
            let m = minutes % 60
            return m == 0 ? "\(h)h" : "\(h)h \(m)m"
        }
        return "\(minutes)m"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label {
                    Text("Today")
                        .font(.subheadline)
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "sun.max.fill")
                        .symbolRenderingMode(.multicolor)
                        .foregroundColor(.studyGold)
                }
                Spacer()
                Text(formattedShortDate(Date()))
                    .font(.caption2)
                    .foregroundColor(.studyGray)
            }

            HStack(alignment: .center, spacing: 12) {
                tile(
                    icon: "timer",
                    value: hoursText,
                    label: "studied",
                    accent: .studyGold
                )
                tile(
                    icon: "book.fill",
                    value: "\(sessions)",
                    label: "sessions",
                    accent: .white
                )
                tile(
                    icon: "crown.fill",
                    value: "+\(gold)",
                    label: "gold",
                    accent: .studyGold
                )
            }
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.studyBackgroundLight.opacity(0.55))
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient.studyCardGradient)
                Image(systemName: "sparkles")
                    .font(.system(size: 100))
                    .foregroundColor(.studyGold.opacity(0.08))
                    .offset(x: 120, y: -10)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient.studyCardStroke,
                    lineWidth: 1
                )
        )
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
    }

    private func tile(icon: String, value: String, label: String, accent: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(accent)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Text(label)
                .font(.caption2)
                .foregroundColor(.studyGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.studyBackground.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
