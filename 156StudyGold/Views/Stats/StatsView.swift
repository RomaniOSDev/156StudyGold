//
//  StatsView.swift
//  156StudyGold
//

import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject var viewModel: StudyGoldViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        statsGrid

                        chartCard

                        topSubjectsCard

                        achievementsSection
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.studyBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .tint(.studyGold)
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(
                title: "Total Hours",
                value: "\(viewModel.totalHours)",
                icon: "clock.fill",
                color: .studyGold
            )

            StatCard(
                title: "Sessions",
                value: "\(viewModel.totalSessions)",
                icon: "book.fill",
                color: .studyGray
            )

            StatCard(
                title: "Gold",
                value: "\(viewModel.totalGold)",
                icon: "crown.fill",
                color: .studyGold
            )

            StatCard(
                title: "Accuracy",
                value: String(format: "%.0f%%", viewModel.completionRate),
                icon: "target",
                color: .studyGold
            )

            StatCard(
                title: "Avg Session",
                value: "\(viewModel.averageSessionLength) min",
                icon: "timer",
                color: .studyGray
            )

            StatCard(
                title: "Streak",
                value: "\(viewModel.streakDays) d",
                icon: "flame.fill",
                color: .studyGold
            )
        }
        .padding(.horizontal)
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text("Daily Activity")
                    .font(.headline)
                    .foregroundColor(.white)
            } icon: {
                Image(systemName: "chart.bar.xaxis")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.studyGold)
            }

            Chart {
                ForEach(viewModel.weeklyActivity) { data in
                    BarMark(
                        x: .value("Day", data.day),
                        y: .value("Hours", data.hours)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.studyGold.opacity(0.6), Color.studyGold],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .cornerRadius(6)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let hours = value.as(Double.self) {
                            Text(String(format: "%.0f", hours))
                                .foregroundColor(.studyGray)
                        }
                    }
                    AxisGridLine()
                        .foregroundStyle(Color.studyGray.opacity(0.25))
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .foregroundStyle(Color.studyGray)
                }
            }
            .frame(height: 180)
        }
        .padding(16)
        .elevatedCard(cornerRadius: 20, shadowRadius: 14, shadowOffsetY: 8)
        .padding(.horizontal)
    }

    private var topSubjectsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label {
                Text("Top Subjects")
                    .font(.headline)
                    .foregroundColor(.white)
            } icon: {
                Image(systemName: "trophy.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.studyGold)
            }

            if viewModel.topSubjects.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "tray")
                        .foregroundColor(.studyGray)
                        .symbolRenderingMode(.hierarchical)
                    Text("No data yet")
                        .font(.subheadline)
                        .foregroundColor(.studyGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                let maxHours = max(viewModel.topSubjects.first?.hours ?? 1, 1)
                VStack(spacing: 10) {
                    ForEach(Array(viewModel.topSubjects.enumerated()), id: \.element.id) { idx, subject in
                        topSubjectRow(rank: idx + 1, subject: subject, maxHours: maxHours)
                    }
                }
            }
        }
        .padding(16)
        .elevatedCard(cornerRadius: 20, shadowRadius: 14, shadowOffsetY: 8)
        .padding(.horizontal)
    }

    private func topSubjectRow(rank: Int, subject: StudyGoldViewModel.TopSubject, maxHours: Int) -> some View {
        let ratio = Double(subject.hours) / Double(maxHours)
        let medal: Color = {
            switch rank {
            case 1: return .studyGold
            case 2: return Color(red: 0.75, green: 0.75, blue: 0.78)
            case 3: return Color(red: 0.80, green: 0.50, blue: 0.20)
            default: return .studyGray
            }
        }()

        return VStack(spacing: 6) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [medal.opacity(0.45), medal.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 28, height: 28)
                    Text("\(rank)")
                        .font(.caption.bold())
                        .foregroundColor(medal)
                }

                Text(subject.name)
                    .font(.subheadline)
                    .foregroundColor(.white)

                Spacer()

                Text("\(subject.hours) h")
                    .font(.subheadline)
                    .foregroundColor(.studyGold)
                    .bold()
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.studyGray.opacity(0.2))
                        .frame(height: 4)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.studyGold.opacity(0.6), .studyGold],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, CGFloat(ratio) * proxy.size.width), height: 4)
                }
            }
            .frame(height: 4)
        }
    }

    private var achievementsSection: some View {
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
                let unlocked = viewModel.achievements.filter { $0.isAchieved }.count
                Text("\(unlocked) / \(viewModel.achievements.count)")
                    .font(.caption)
                    .foregroundColor(.studyGray)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.achievements) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
