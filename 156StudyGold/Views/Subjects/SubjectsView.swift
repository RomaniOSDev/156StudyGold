//
//  SubjectsView.swift
//  156StudyGold
//

import SwiftUI

enum SubjectFilter: String, CaseIterable, Hashable {
    case all = "All"
    case favorites = "Favorites"
}

enum SubjectSort: String, CaseIterable, Hashable {
    case name = "Name"
    case hours = "Hours"
    case recent = "Recent"
}

struct SubjectsView: View {
    @ObservedObject var viewModel: StudyGoldViewModel

    @State private var showAddSheet = false
    @State private var search: String = ""
    @State private var filter: SubjectFilter = .all
    @State private var sort: SubjectSort = .recent
    @State private var sessionPreselectedSubjectId: UUID?
    @State private var showSessionSheet = false
    @State private var detailSubject: Subject?

    private struct SubjectStats {
        var totalMinutes: Int = 0
        var weeklyMinutes: Int = 0
        var sessionsCount: Int = 0
        var totalGold: Int = 0
        var lastSession: Date?
    }

    private var subjectStats: [UUID: SubjectStats] {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        var dict: [UUID: SubjectStats] = [:]
        for session in viewModel.sessions {
            var stats = dict[session.subjectId] ?? SubjectStats()
            stats.totalMinutes += session.duration
            stats.sessionsCount += 1
            stats.totalGold += session.earnedGold
            if session.date >= weekAgo {
                stats.weeklyMinutes += session.duration
            }
            if let last = stats.lastSession {
                if session.date > last { stats.lastSession = session.date }
            } else {
                stats.lastSession = session.date
            }
            dict[session.subjectId] = stats
        }
        return dict
    }

    private var filteredSubjects: [Subject] {
        var list = viewModel.subjects

        if filter == .favorites {
            list = list.filter { $0.isFavorite }
        }

        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            list = list.filter {
                $0.name.localizedCaseInsensitiveContains(trimmed) ||
                $0.category.rawValue.localizedCaseInsensitiveContains(trimmed)
            }
        }

        let stats = subjectStats
        switch sort {
        case .name:
            list.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .hours:
            list.sort {
                (stats[$0.id]?.totalMinutes ?? 0) > (stats[$1.id]?.totalMinutes ?? 0)
            }
        case .recent:
            list.sort {
                (stats[$0.id]?.lastSession ?? .distantPast)
                > (stats[$1.id]?.lastSession ?? .distantPast)
            }
        }

        return list
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 16) {
                        summaryHeader
                        filterBar

                        if filteredSubjects.isEmpty {
                            emptyState
                        } else {
                            let stats = subjectStats
                            LazyVStack(spacing: 12) {
                                ForEach(filteredSubjects) { subject in
                                    let info = stats[subject.id] ?? SubjectStats()
                                    let weeklyHours = info.weeklyMinutes / 60
                                    let weeklyProgress: Double = subject.goalHours > 0
                                        ? min(Double(weeklyHours) / Double(subject.goalHours), 1.0)
                                        : 0
                                    SubjectCard(
                                        subject: subject,
                                        totalHours: info.totalMinutes / 60,
                                        weeklyHours: weeklyHours,
                                        totalSessions: info.sessionsCount,
                                        totalGold: info.totalGold,
                                        lastSessionDate: info.lastSession,
                                        weeklyProgress: weeklyProgress,
                                        onFavorite: {
                                            withAnimation { viewModel.toggleFavoriteSubject(subject) }
                                        },
                                        onStart: {
                                            sessionPreselectedSubjectId = subject.id
                                            showSessionSheet = true
                                        }
                                    )
                                    .onTapGesture {
                                        detailSubject = subject
                                    }
                                    .contextMenu {
                                        Button {
                                            viewModel.toggleFavoriteSubject(subject)
                                        } label: {
                                            Label(
                                                subject.isFavorite ? "Unfavorite" : "Favorite",
                                                systemImage: subject.isFavorite ? "star.slash" : "star"
                                            )
                                        }
                                        Button(role: .destructive) {
                                            withAnimation { viewModel.deleteSubject(subject) }
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
            .navigationTitle("Subjects")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.studyBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $sort) {
                            ForEach(SubjectSort.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .foregroundColor(.studyGold)
                    }
                }
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
                AddSubjectView(viewModel: viewModel)
            }
            .sheet(isPresented: $showSessionSheet) {
                AddSessionView(viewModel: viewModel, preselectedSubjectId: sessionPreselectedSubjectId)
            }
            .sheet(item: $detailSubject) { subject in
                SubjectDetailView(viewModel: viewModel, subject: subject)
            }
            .searchable(
                text: $search,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search subjects"
            )
        }
        .tint(.studyGold)
    }

    private var summaryHeader: some View {
        HStack(spacing: 12) {
            summaryTile(
                icon: "books.vertical.fill",
                title: "\(viewModel.subjects.count)",
                subtitle: "Subjects"
            )
            summaryTile(
                icon: "clock.fill",
                title: "\(viewModel.totalHours)",
                subtitle: "Total hours"
            )
            summaryTile(
                icon: "star.fill",
                title: "\(viewModel.subjects.filter { $0.isFavorite }.count)",
                subtitle: "Favorites"
            )
        }
    }

    private func summaryTile(icon: String, title: String, subtitle: String) -> some View {
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
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.caption.bold())
                    .foregroundColor(.studyGold)
            }
            Text(title)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.studyGray)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .elevatedCard(cornerRadius: 14, shadowRadius: 8, shadowOffsetY: 4)
    }

    private var filterBar: some View {
        SegmentedFilter(
            options: SubjectFilter.allCases,
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

                Image(systemName: filter == .favorites ? "star.slash" : "books.vertical")
                    .font(.system(size: 38))
                    .foregroundColor(.studyGold)
                    .symbolRenderingMode(.hierarchical)
            }
            Text(filter == .favorites ? "No favorites yet" : "No subjects yet")
                .font(.headline)
                .foregroundColor(.white)
            Text(
                filter == .favorites
                ? "Tap the star icon on a subject to mark it as favorite"
                : "Tap the plus button to add your first subject"
            )
            .font(.subheadline)
            .foregroundColor(.studyGray)
            .multilineTextAlignment(.center)

            if filter != .favorites {
                Button {
                    showAddSheet = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Subject")
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
}
