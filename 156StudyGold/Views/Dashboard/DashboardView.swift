//
//  DashboardView.swift
//  156StudyGold
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: StudyGoldViewModel

    @State private var showAddSession = false
    @State private var preselectedSubjectId: UUID?
    @State private var showAddSubject = false
    @State private var detailGoal: StudyGoal?
    @State private var addHoursGoal: StudyGoal?
    @State private var showSettings = false

    private let tip: MotivationTip = MotivationWidget.random()

    var body: some View {
        NavigationStack {
            ZStack {
                animatedBackground

                ScrollView {
                    VStack(spacing: 18) {
                        topBar
                            .padding(.horizontal)

                        HeroWidget(
                            totalGold: viewModel.totalGold,
                            totalHours: viewModel.totalHours,
                            streak: viewModel.streakDays
                        ) {
                            preselectedSubjectId = nil
                            showAddSession = true
                        }
                        .padding(.horizontal)

                        TodayStatsWidget(
                            minutes: viewModel.todayMinutes,
                            sessions: viewModel.todaysSessions.count,
                            gold: viewModel.todayGold
                        )
                        .padding(.horizontal)

                        HStack(spacing: 12) {
                            StreakWidget(streak: viewModel.streakDays)
                                .frame(maxWidth: .infinity)
                            sessionsCounterCard
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)

                        WeeklyProgressWidget(
                            breakdown: viewModel.weeklyBreakdown,
                            weeklyHours: viewModel.weeklyHours,
                            weeklyGoal: viewModel.weeklyGoal,
                            weeklyProgress: viewModel.weeklyProgress
                        )
                        .padding(.horizontal)

                        if let topGoal = viewModel.topActiveGoal {
                            TopGoalWidget(
                                goal: topGoal,
                                onLogHours: { addHoursGoal = topGoal },
                                onTap: { detailGoal = topGoal }
                            )
                            .padding(.horizontal)
                        }

                        QuickStartGrid(
                            subjects: viewModel.subjects,
                            onSelect: { subject in
                                preselectedSubjectId = subject.id
                                showAddSession = true
                            },
                            onAdd: { showAddSubject = true }
                        )
                        .padding(.horizontal)

                        MotivationWidget(tip: tip)
                            .padding(.horizontal)

                        if let last = viewModel.lastSession {
                            LastSessionWidget(
                                session: last,
                                category: viewModel.subjects.first(where: { $0.id == last.subjectId })?.category
                            )
                            .padding(.horizontal)
                        }

                        AchievementsPreviewWidget(
                            achievements: viewModel.achievements,
                            nextAchievement: viewModel.nextAchievement,
                            nextProgress: viewModel.nextAchievement.map { viewModel.progressTowards($0) } ?? 0
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    preselectedSubjectId = nil
                    showAddSession = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.studyGold, Color.studyGold.opacity(0.75)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)
                            .shadow(color: Color.studyGold.opacity(0.4), radius: 14, x: 0, y: 8)

                        Image(systemName: "plus")
                            .font(.title.bold())
                            .foregroundColor(.studyBackground)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showAddSession) {
                AddSessionView(viewModel: viewModel, preselectedSubjectId: preselectedSubjectId)
            }
            .sheet(isPresented: $showAddSubject) {
                AddSubjectView(viewModel: viewModel)
            }
            .sheet(item: $detailGoal) { goal in
                GoalDetailView(viewModel: viewModel, goal: goal)
            }
            .sheet(item: $addHoursGoal) { goal in
                AddHoursToGoalView(viewModel: viewModel, goal: goal)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(viewModel: viewModel)
            }
        }
    }

    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Dashboard")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .tracking(1.4)
                    .foregroundColor(.studyGray)
                Text(headerDateText())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            Spacer()

            Button {
                showSettings = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.studyBackgroundLight.opacity(0.55))
                        .frame(width: 42, height: 42)

                    Image(systemName: "gearshape.fill")
                        .font(.subheadline.bold())
                        .foregroundColor(.studyGold)
                        .symbolRenderingMode(.hierarchical)
                }
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 8)
    }

    private func headerDateText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }

    private var animatedBackground: some View {
        AppBackground()
    }

    private var sessionsCounterCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.30, green: 0.45, blue: 0.85),
                            Color(red: 0.18, green: 0.30, blue: 0.65)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: "books.vertical.fill")
                .font(.system(size: 130, weight: .bold))
                .foregroundColor(.white.opacity(0.13))
                .offset(x: 90, y: 30)

            VStack(alignment: .leading, spacing: 10) {
                Text("SESSIONS")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.8))

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(viewModel.totalSessions)")
                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }

                Text("\(viewModel.subjects.count) subjects tracked")
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
        .shadow(color: Color.studyAccentBlue.opacity(0.30), radius: 10, x: 0, y: 6)
    }
}
