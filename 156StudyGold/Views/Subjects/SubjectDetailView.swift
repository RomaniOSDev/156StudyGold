//
//  SubjectDetailView.swift
//  156StudyGold
//

import SwiftUI

struct SubjectDetailView: View {
    @ObservedObject var viewModel: StudyGoldViewModel
    let subject: Subject

    @Environment(\.dismiss) private var dismiss
    @State private var showSessionSheet = false
    @State private var showEditSheet = false

    private var current: Subject {
        viewModel.subjects.first(where: { $0.id == subject.id }) ?? subject
    }

    private var sessionList: [StudySession] {
        viewModel.sessionsForSubject(subject.id)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        heroCard
                        statsRow
                        recentSessionsSection
                    }
                    .padding()
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle(current.name)
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
                        Button {
                            viewModel.toggleFavoriteSubject(current)
                        } label: {
                            Label(
                                current.isFavorite ? "Unfavorite" : "Favorite",
                                systemImage: current.isFavorite ? "star.slash" : "star"
                            )
                        }
                        Button {
                            showEditSheet = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            viewModel.deleteSubject(current)
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
            .sheet(isPresented: $showSessionSheet) {
                AddSessionView(viewModel: viewModel, preselectedSubjectId: current.id)
            }
            .sheet(isPresented: $showEditSheet) {
                EditSubjectView(viewModel: viewModel, subject: current)
            }
            .tint(.studyGold)
        }
        .preferredColorScheme(.dark)
    }

    private var heroCard: some View {
        VStack(spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(LinearGradient.studyGoldGradient)
                        .frame(width: 72, height: 72)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: Color.studyGold.opacity(0.5), radius: 12, x: 0, y: 6)

                    Image(systemName: current.category.icon)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.studyBackground)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(current.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)

                    HStack(spacing: 6) {
                        StatusBadge(title: current.category.rawValue, color: .studyGray)
                        if current.isFavorite {
                            StatusBadge(title: "Favorite", color: .studyGold, icon: "star.fill")
                        }
                    }
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Weekly Goal")
                        .font(.subheadline)
                        .foregroundColor(.studyGray)
                    Spacer()
                    Text("\(viewModel.weeklyHoursForSubject(current.id)) / \(current.goalHours) h")
                        .font(.subheadline)
                        .foregroundColor(.studyGold)
                        .bold()
                }
                ProgressView(value: viewModel.weeklyProgress(for: current))
                    .tint(.studyGold)
                    .scaleEffect(x: 1, y: 1.6, anchor: .center)
            }

            Button {
                showSessionSheet = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Log a Session")
                }
            }
            .buttonStyle(PrimaryGoldButtonStyle())
        }
        .padding(18)
        .elevatedCard(cornerRadius: 22, shadowRadius: 16, shadowOffsetY: 10)
    }

    private var statsRow: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(
                title: "Total Hours",
                value: "\(viewModel.hoursForSubject(current.id))",
                icon: "clock.fill",
                color: .studyGold
            )
            StatCard(
                title: "Sessions",
                value: "\(viewModel.sessionsCountForSubject(current.id))",
                icon: "book.fill",
                color: .studyGray
            )
            StatCard(
                title: "Gold Earned",
                value: "\(viewModel.goldForSubject(current.id))",
                icon: "crown.fill",
                color: .studyGold
            )
            StatCard(
                title: "Avg Session",
                value: avgSessionText,
                icon: "timer",
                color: .studyGray
            )
        }
    }

    private var avgSessionText: String {
        let count = viewModel.sessionsCountForSubject(current.id)
        guard count > 0 else { return "0 m" }
        let avg = viewModel.minutesForSubject(current.id) / count
        return "\(avg) m"
    }

    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("History")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(sessionList.count)")
                    .font(.caption)
                    .foregroundColor(.studyGray)
            }

            if sessionList.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.title2)
                        .foregroundColor(.studyGray)
                        .symbolRenderingMode(.hierarchical)
                    Text("No sessions yet")
                        .font(.subheadline)
                        .foregroundColor(.studyGray)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .elevatedCard(cornerRadius: 14, shadowRadius: 6, shadowOffsetY: 3)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(sessionList) { session in
                        SessionRow(session: session)
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.deleteSession(session)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
    }
}
