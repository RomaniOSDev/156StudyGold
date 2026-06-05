//
//  GoalsView.swift
//  156StudyGold
//

import SwiftUI

enum GoalFilter: String, CaseIterable, Hashable {
    case active = "Active"
    case completed = "Completed"
    case all = "All"
}

struct GoalsView: View {
    @ObservedObject var viewModel: StudyGoldViewModel

    @State private var showAddSheet = false
    @State private var filter: GoalFilter = .active
    @State private var detailGoal: StudyGoal?
    @State private var addHoursGoal: StudyGoal?

    private var filteredGoals: [StudyGoal] {
        let list: [StudyGoal]
        switch filter {
        case .active:
            list = viewModel.goals.filter { !$0.isCompleted }
        case .completed:
            list = viewModel.goals.filter { $0.isCompleted }
        case .all:
            list = viewModel.goals
        }
        return list.sorted { lhs, rhs in
            if lhs.isCompleted != rhs.isCompleted {
                return !lhs.isCompleted
            }
            switch (lhs.deadline, rhs.deadline) {
            case let (l?, r?): return l < r
            case (nil, _?): return false
            case (_?, nil): return true
            default: return lhs.createdAt > rhs.createdAt
            }
        }
    }

    private var totalRewardEarned: Int {
        viewModel.goals.filter { $0.isCompleted }.reduce(0) { $0 + $1.rewardGold }
    }

    private var activeCount: Int {
        viewModel.goals.filter { !$0.isCompleted }.count
    }

    private var completedCount: Int {
        viewModel.goals.filter { $0.isCompleted }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 16) {
                        summaryCard
                        filterBar

                        if filteredGoals.isEmpty {
                            emptyState
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredGoals) { goal in
                                    GoalCard(
                                        goal: goal,
                                        onComplete: {
                                            withAnimation { viewModel.completeGoal(goal) }
                                        },
                                        onAddHours: {
                                            addHoursGoal = goal
                                        },
                                        onDelete: {
                                            withAnimation { viewModel.deleteGoal(goal) }
                                        }
                                    )
                                    .onTapGesture {
                                        detailGoal = goal
                                    }
                                    .contextMenu {
                                        if !goal.isCompleted {
                                            Button {
                                                viewModel.completeGoal(goal)
                                            } label: {
                                                Label("Complete", systemImage: "checkmark")
                                            }
                                            Button {
                                                addHoursGoal = goal
                                            } label: {
                                                Label("Add hours", systemImage: "plus")
                                            }
                                        }
                                        Button(role: .destructive) {
                                            withAnimation { viewModel.deleteGoal(goal) }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.studyBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.studyGold)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddGoalView(viewModel: viewModel)
            }
            .sheet(item: $detailGoal) { goal in
                GoalDetailView(viewModel: viewModel, goal: goal)
            }
            .sheet(item: $addHoursGoal) { goal in
                AddHoursToGoalView(viewModel: viewModel, goal: goal)
            }
        }
        .tint(.studyGold)
    }

    private var summaryCard: some View {
        VStack(spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Earned from goals")
                        .font(.caption)
                        .foregroundColor(.studyGray)
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.studyGold)
                            .symbolRenderingMode(.hierarchical)
                        Text("\(totalRewardEarned)")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .foregroundColor(.studyGold)
                    }
                }
                Spacer()
                completionRing
            }

            HStack(spacing: 10) {
                summaryTile(
                    title: "\(activeCount)",
                    subtitle: "Active",
                    icon: "bolt.fill"
                )
                summaryTile(
                    title: "\(completedCount)",
                    subtitle: "Completed",
                    icon: "checkmark.seal.fill"
                )
                summaryTile(
                    title: "\(viewModel.goals.count)",
                    subtitle: "Total",
                    icon: "target"
                )
            }
        }
        .padding(18)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.studyBackgroundLight.opacity(0.55))
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.studyGold.opacity(0.16), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.studyGold.opacity(0.5), Color.white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .compositingGroup()
        .shadow(color: Color.studyGold.opacity(0.18), radius: 8, x: 0, y: 4)
    }

    private var completionRing: some View {
        let progress: Double = {
            guard !viewModel.goals.isEmpty else { return 0 }
            return Double(completedCount) / Double(viewModel.goals.count)
        }()
        return CircularProgressView(progress: progress, lineWidth: 6, label: "done")
            .frame(width: 56, height: 56)
    }

    private func summaryTile(title: String, subtitle: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.studyGold.opacity(0.4), Color.studyGold.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 26, height: 26)
                Image(systemName: icon)
                    .font(.caption2.bold())
                    .foregroundColor(.studyGold)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.studyGray)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.studyBackground.opacity(0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
    }

    private var filterBar: some View {
        SegmentedFilter(
            options: GoalFilter.allCases,
            titleFor: { $0.rawValue },
            selection: $filter
        )
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.studyGold.opacity(0.25), Color.studyGold.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.studyGold.opacity(0.3), radius: 18, x: 0, y: 8)
                Image(systemName: filter == .completed ? "trophy.fill" : "target")
                    .font(.system(size: 38))
                    .foregroundColor(.studyGold)
                    .symbolRenderingMode(.hierarchical)
            }
            Text(emptyTitle)
                .font(.headline)
                .foregroundColor(.white)
            Text(emptyMessage)
                .font(.subheadline)
                .foregroundColor(.studyGray)
                .multilineTextAlignment(.center)

            if filter != .completed {
                Button {
                    showAddSheet = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Goal")
                    }
                }
                .buttonStyle(SecondaryGoldButtonStyle())
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(36)
        .elevatedCard(cornerRadius: 22, shadowRadius: 14, shadowOffsetY: 8)
    }

    private var emptyTitle: String {
        switch filter {
        case .active: return "No active goals"
        case .completed: return "No completed goals"
        case .all: return "No goals yet"
        }
    }

    private var emptyMessage: String {
        switch filter {
        case .active: return "Set a new goal to earn extra gold rewards"
        case .completed: return "Finish a goal to see it here"
        case .all: return "Create your first goal to track your progress"
        }
    }
}
