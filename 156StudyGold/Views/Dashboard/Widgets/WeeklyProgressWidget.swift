//
//  WeeklyProgressWidget.swift
//  156StudyGold
//

import SwiftUI

struct WeeklyProgressWidget: View {
    let breakdown: [StudyGoldViewModel.DayBreakdown]
    let weeklyHours: Int
    let weeklyGoal: Int
    let weeklyProgress: Double

    private var maxValue: Double {
        max(breakdown.map { $0.hours }.max() ?? 0, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Label {
                    Text("This Week")
                        .font(.subheadline)
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundColor(.studyGold)
                }
                Spacer()
                Text("\(weeklyHours)/\(weeklyGoal) h")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(weeklyHours >= weeklyGoal ? .studyGold : .studyGray)
            }

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(breakdown) { day in
                    barColumn(for: day)
                }
            }
            .frame(height: 110)

            HStack(spacing: 6) {
                Image(systemName: weeklyHours >= weeklyGoal ? "checkmark.seal.fill" : "target")
                    .font(.caption)
                    .foregroundColor(.studyGold)
                Text(
                    weeklyHours >= weeklyGoal
                    ? "Weekly goal reached"
                    : "\(max(weeklyGoal - weeklyHours, 0)) hours to your weekly goal"
                )
                .font(.caption)
                .foregroundColor(.studyGray)
                Spacer()
            }
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.studyBackgroundLight.opacity(0.55))
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient.studyCardGradient)
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 110))
                    .foregroundColor(.studyGold.opacity(0.07))
                    .offset(x: 110, y: 30)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(LinearGradient.studyCardStroke, lineWidth: 1)
        )
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
    }

    @ViewBuilder
    private func barColumn(for day: StudyGoldViewModel.DayBreakdown) -> some View {
        let ratio = max(day.hours / maxValue, 0)
        let isActive = day.hours > 0

        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.studyGray.opacity(0.18))
                    .frame(maxWidth: .infinity)
                    .frame(height: 78)

                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        isActive
                        ? AnyShapeStyle(
                            LinearGradient(
                                colors: [Color.studyGold.opacity(0.6), Color.studyGold],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        : AnyShapeStyle(Color.studyGray.opacity(0.3))
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: max(CGFloat(ratio) * 78, isActive ? 6 : 2))
                    .animation(.spring(response: 0.6, dampingFraction: 0.85), value: ratio)
            }

            Text(day.label)
                .font(.caption2)
                .fontWeight(day.isToday ? .bold : .regular)
                .foregroundColor(day.isToday ? .studyGold : .studyGray)
                .frame(width: 22, height: 22)
                .background(
                    Circle()
                        .fill(day.isToday ? Color.studyGold.opacity(0.18) : .clear)
                )
        }
    }
}
