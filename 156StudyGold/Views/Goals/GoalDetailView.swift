//
//  GoalDetailView.swift
//  156StudyGold
//

import SwiftUI

struct GoalDetailView: View {
    @ObservedObject var viewModel: StudyGoldViewModel
    let goal: StudyGoal
    @Environment(\.dismiss) private var dismiss

    @State private var showAddHours = false

    private var current: StudyGoal {
        viewModel.goals.first(where: { $0.id == goal.id }) ?? goal
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        heroCard
                        statsGrid
                        actionsCard
                    }
                    .padding()
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.studyBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.studyGold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        if !current.isCompleted {
                            Button {
                                viewModel.completeGoal(current)
                            } label: {
                                Label("Mark Complete", systemImage: "checkmark.seal")
                            }
                        }
                        Button(role: .destructive) {
                            viewModel.deleteGoal(current)
                            dismiss()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.studyGold)
                    }
                }
            }
            .sheet(isPresented: $showAddHours) {
                AddHoursToGoalView(viewModel: viewModel, goal: current)
            }
            .tint(.studyGold)
        }
        .preferredColorScheme(.dark)
    }

    private var heroCard: some View {
        VStack(spacing: 16) {
            CircularProgressView(
                progress: current.progress,
                lineWidth: 14,
                showsPercentage: true,
                label: current.isCompleted ? "done" : "progress"
            )
            .frame(width: 160, height: 160)
            .padding(.top, 6)

            Text(current.title)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                StatusBadge(
                    title: current.state.title,
                    color: current.state.color,
                    icon: current.state.icon
                )
                if let deadline = current.deadline {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(formattedShortDate(deadline))
                    }
                    .font(.caption)
                    .foregroundColor(.studyGray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.studyBackgroundLight.opacity(0.55))
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(LinearGradient.studyCardGradient)
                if current.isCompleted {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.studyGold.opacity(0.22), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: current.isCompleted
                        ? [Color.studyGold.opacity(0.7), Color.studyGold.opacity(0.2)]
                        : [Color.white.opacity(0.25), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(
            color: current.isCompleted ? Color.studyGold.opacity(0.3) : Color.black.opacity(0.3),
            radius: 18, x: 0, y: 10
        )
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(
                title: "Target",
                value: "\(current.targetHours) h",
                icon: "target",
                color: .studyGold
            )
            StatCard(
                title: "Logged",
                value: "\(current.currentHours) h",
                icon: "clock.fill",
                color: .studyGold
            )
            StatCard(
                title: "Remaining",
                value: "\(max(current.targetHours - current.currentHours, 0)) h",
                icon: "hourglass",
                color: .studyGray
            )
            StatCard(
                title: "Reward",
                value: "\(current.rewardGold)",
                icon: "crown.fill",
                color: .studyGold
            )
        }
    }

    private var actionsCard: some View {
        VStack(spacing: 10) {
            if !current.isCompleted {
                Button {
                    showAddHours = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Log Hours")
                    }
                }
                .buttonStyle(PrimaryGoldButtonStyle())

                Button {
                    viewModel.completeGoal(current)
                } label: {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Mark as Completed")
                    }
                }
                .buttonStyle(SecondaryGoldButtonStyle())
            } else {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.studyGold.opacity(0.4), Color.studyGold.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.studyGold)
                            .symbolRenderingMode(.hierarchical)
                    }
                    Text("Goal completed. Reward of \(current.rewardGold) gold has been awarded.")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.studyGold.opacity(0.18), Color.studyGold.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.studyGold.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: Color.studyGold.opacity(0.25), radius: 12, x: 0, y: 6)
            }
        }
    }
}
