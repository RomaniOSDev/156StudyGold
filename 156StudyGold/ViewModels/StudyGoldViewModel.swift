//
//  StudyGoldViewModel.swift
//  156StudyGold
//

import Foundation
import Combine

@MainActor
final class StudyGoldViewModel: ObservableObject {

    // MARK: - Published state
    @Published var subjects: [Subject] = []
    @Published var sessions: [StudySession] = []
    @Published var goals: [StudyGoal] = []
    @Published var transactions: [GoldTransaction] = []
    @Published var achievements: [Achievement] = []
    @Published var spentGold: Int = 0
    @Published var purchasedItems: [String] = []

    // MARK: - Computed properties
    var totalHours: Int {
        sessions.reduce(0) { $0 + $1.duration } / 60
    }

    var totalSessions: Int {
        sessions.count
    }

    var totalGold: Int {
        let earned = sessions.reduce(0) { $0 + $1.earnedGold }
        let bonuses = transactions.reduce(0) { $0 + $1.amount }
        return max(0, earned + bonuses - spentGold)
    }

    var weeklyHours: Int {
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return 0 }
        return sessions.filter { $0.date >= weekAgo }
            .reduce(0) { $0 + $1.duration } / 60
    }

    var weeklyGoal: Int {
        let total = subjects.reduce(0) { $0 + $1.goalHours }
        return max(total, 1)
    }

    var weeklyProgress: Double {
        min(Double(weeklyHours) / Double(weeklyGoal), 1.0)
    }

    var streakDays: Int {
        let calendar = Calendar.current
        var streak = 0
        var date = calendar.startOfDay(for: Date())

        while true {
            let hasSession = sessions.contains { calendar.isDate($0.date, inSameDayAs: date) }
            if hasSession {
                streak += 1
                guard let prev = calendar.date(byAdding: .day, value: -1, to: date) else { break }
                date = prev
            } else {
                break
            }
        }
        return streak
    }

    var completionRate: Double {
        guard totalSessions > 0 else { return 0 }
        let completed = sessions.filter { $0.isCompleted }.count
        return Double(completed) / Double(totalSessions) * 100
    }

    var averageSessionLength: Int {
        guard totalSessions > 0 else { return 0 }
        return sessions.reduce(0) { $0 + $1.duration } / totalSessions
    }

    var recentSessions: [StudySession] {
        Array(sessions.sorted { $0.date > $1.date }.prefix(10))
    }

    var lastSession: StudySession? {
        sessions.max(by: { $0.date < $1.date })
    }

    var todaysSessions: [StudySession] {
        let calendar = Calendar.current
        return sessions.filter { calendar.isDateInToday($0.date) }
    }

    var todayHours: Int {
        todaysSessions.reduce(0) { $0 + $1.duration } / 60
    }

    var todayMinutes: Int {
        todaysSessions.reduce(0) { $0 + $1.duration }
    }

    var todayGold: Int {
        todaysSessions.reduce(0) { $0 + $1.earnedGold }
    }

    var topActiveGoal: StudyGoal? {
        let active = goals.filter { !$0.isCompleted }
        let withDeadline = active.compactMap { goal -> (StudyGoal, Date)? in
            guard let deadline = goal.deadline else { return nil }
            return (goal, deadline)
        }
        if let nearest = withDeadline.min(by: { $0.1 < $1.1 }) {
            return nearest.0
        }
        return active.max(by: { $0.progress < $1.progress })
    }

    struct DayBreakdown: Identifiable {
        let id = UUID()
        let date: Date
        let label: String
        let hours: Double
        let isToday: Bool
    }

    var weeklyBreakdown: [DayBreakdown] {
        let calendar = Calendar.current
        let today = Date()
        let weekDays = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }.reversed()

        return weekDays.map { date in
            let minutes = sessions
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .reduce(0) { $0 + $1.duration }
            return DayBreakdown(
                date: date,
                label: String(formattedWeekday(date).prefix(1)),
                hours: Double(minutes) / 60.0,
                isToday: calendar.isDateInToday(date)
            )
        }
    }

    var maxDayHours: Double {
        max(weeklyBreakdown.map { $0.hours }.max() ?? 0, 1)
    }

    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isAchieved }
    }

    var nextAchievement: Achievement? {
        achievements.first { !$0.isAchieved }
    }

    func progressTowards(_ achievement: Achievement) -> Double {
        let current: Int
        switch achievement.kind {
        case .firstTenHours, .fiftyHours, .hundredHours: current = totalHours
        case .sevenDayStreak, .thirtyDayStreak: current = streakDays
        case .thousandGold: current = totalGold
        }
        guard achievement.requiredValue > 0 else { return 0 }
        return min(Double(current) / Double(achievement.requiredValue), 1.0)
    }

    var favoriteSubjects: [Subject] {
        let favorites = subjects.filter { $0.isFavorite }
        return favorites.isEmpty ? subjects : favorites
    }

    // MARK: - Charts data
    struct WeeklyActivity: Identifiable {
        let id = UUID()
        let day: String
        let hours: Double
    }

    var weeklyActivity: [WeeklyActivity] {
        let calendar = Calendar.current
        let today = Date()
        let weekDays = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }.reversed()

        return weekDays.map { date in
            let minutes = sessions
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .reduce(0) { $0 + $1.duration }
            return WeeklyActivity(
                day: formattedWeekday(date),
                hours: Double(minutes) / 60.0
            )
        }
    }

    struct TopSubject: Identifiable {
        let id = UUID()
        let name: String
        let hours: Int
    }

    var topSubjects: [TopSubject] {
        let grouped = Dictionary(grouping: sessions, by: { $0.subjectId })
        let mapped = grouped.map { subjectId, items -> TopSubject in
            let subject = subjects.first { $0.id == subjectId }
            let hours = items.reduce(0) { $0 + $1.duration } / 60
            return TopSubject(name: subject?.name ?? "Unknown", hours: hours)
        }
        return Array(mapped.sorted { $0.hours > $1.hours }.prefix(5))
    }

    // MARK: - Helpers
    func hoursForSubject(_ subjectId: UUID) -> Int {
        sessions.filter { $0.subjectId == subjectId }
            .reduce(0) { $0 + $1.duration } / 60
    }

    func minutesForSubject(_ subjectId: UUID) -> Int {
        sessions.filter { $0.subjectId == subjectId }
            .reduce(0) { $0 + $1.duration }
    }

    func sessionsForSubject(_ subjectId: UUID) -> [StudySession] {
        sessions.filter { $0.subjectId == subjectId }
            .sorted { $0.date > $1.date }
    }

    func sessionsCountForSubject(_ subjectId: UUID) -> Int {
        sessions.filter { $0.subjectId == subjectId }.count
    }

    func goldForSubject(_ subjectId: UUID) -> Int {
        sessions.filter { $0.subjectId == subjectId }
            .reduce(0) { $0 + $1.earnedGold }
    }

    func lastSessionDate(for subjectId: UUID) -> Date? {
        sessions.filter { $0.subjectId == subjectId }
            .max(by: { $0.date < $1.date })?.date
    }

    func weeklyHoursForSubject(_ subjectId: UUID) -> Int {
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return 0 }
        return sessions
            .filter { $0.subjectId == subjectId && $0.date >= weekAgo }
            .reduce(0) { $0 + $1.duration } / 60
    }

    func weeklyProgress(for subject: Subject) -> Double {
        guard subject.goalHours > 0 else { return 0 }
        return min(Double(weeklyHoursForSubject(subject.id)) / Double(subject.goalHours), 1.0)
    }

    func updateSubject(_ subject: Subject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index] = subject
            save()
        }
    }

    func addHoursToGoal(_ goal: StudyGoal, hours: Int) {
        guard hours > 0 else { return }
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        guard !goals[index].isCompleted else { return }

        goals[index].currentHours += hours
        if goals[index].currentHours >= goals[index].targetHours {
            completeGoal(goals[index])
        } else {
            save()
        }
    }

    func updateGoal(_ goal: StudyGoal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            save()
        }
    }

    // MARK: - Subjects CRUD
    func addSubject(_ subject: Subject) {
        subjects.append(subject)
        save()
    }

    func deleteSubject(_ subject: Subject) {
        subjects.removeAll { $0.id == subject.id }
        save()
    }

    func toggleFavoriteSubject(_ subject: Subject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index].isFavorite.toggle()
            save()
        }
    }

    // MARK: - Sessions CRUD
    func addSession(_ session: StudySession) {
        sessions.append(session)
        updateGoalsProgress(with: session)
        checkAchievements()
        save()
    }

    func deleteSession(_ session: StudySession) {
        sessions.removeAll { $0.id == session.id }
        save()
    }

    // MARK: - Goals CRUD
    func addGoal(_ goal: StudyGoal) {
        goals.append(goal)
        save()
    }

    func deleteGoal(_ goal: StudyGoal) {
        goals.removeAll { $0.id == goal.id }
        save()
    }

    func completeGoal(_ goal: StudyGoal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        guard !goals[index].isCompleted else { return }

        goals[index].isCompleted = true

        let transaction = GoldTransaction(
            id: UUID(),
            amount: goals[index].rewardGold,
            date: Date(),
            source: "Goal achieved: \(goals[index].title)",
            notes: nil
        )
        transactions.append(transaction)
        save()
    }

    private func updateGoalsProgress(with session: StudySession) {
        let hours = max(session.duration / 60, 0)
        guard hours > 0 else { return }

        for index in goals.indices where !goals[index].isCompleted {
            goals[index].currentHours += hours
            if goals[index].currentHours >= goals[index].targetHours {
                completeGoal(goals[index])
            }
        }
    }

    // MARK: - Shop
    func purchase(_ item: ShopItem) -> Bool {
        guard totalGold >= item.price else { return false }
        spentGold += item.price
        purchasedItems.append(item.name)

        let transaction = GoldTransaction(
            id: UUID(),
            amount: 0,
            date: Date(),
            source: "Purchased: \(item.name)",
            notes: "-\(item.price)"
        )
        transactions.append(transaction)
        save()
        return true
    }

    // MARK: - Achievements
    private func checkAchievements() {
        for index in achievements.indices where !achievements[index].isAchieved {
            let achieved: Bool
            switch achievements[index].kind {
            case .firstTenHours: achieved = totalHours >= 10
            case .fiftyHours: achieved = totalHours >= 50
            case .hundredHours: achieved = totalHours >= 100
            case .sevenDayStreak: achieved = streakDays >= 7
            case .thirtyDayStreak: achieved = streakDays >= 30
            case .thousandGold: achieved = totalGold >= 1000
            }

            if achieved {
                achievements[index].isAchieved = true
                achievements[index].achievedAt = Date()
            }
        }
    }

    // MARK: - Persistence
    private enum StorageKey {
        static let subjects = "studygold_subjects"
        static let sessions = "studygold_sessions"
        static let goals = "studygold_goals"
        static let transactions = "studygold_transactions"
        static let achievements = "studygold_achievements"
        static let spent = "studygold_spent"
        static let purchases = "studygold_purchases"
    }

    func save() {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(subjects) {
            defaults.set(encoded, forKey: StorageKey.subjects)
        }
        if let encoded = try? JSONEncoder().encode(sessions) {
            defaults.set(encoded, forKey: StorageKey.sessions)
        }
        if let encoded = try? JSONEncoder().encode(goals) {
            defaults.set(encoded, forKey: StorageKey.goals)
        }
        if let encoded = try? JSONEncoder().encode(transactions) {
            defaults.set(encoded, forKey: StorageKey.transactions)
        }
        if let encoded = try? JSONEncoder().encode(achievements) {
            defaults.set(encoded, forKey: StorageKey.achievements)
        }
        defaults.set(spentGold, forKey: StorageKey.spent)
        defaults.set(purchasedItems, forKey: StorageKey.purchases)
    }

    func load() {
        let defaults = UserDefaults.standard

        if let data = defaults.data(forKey: StorageKey.subjects),
           let decoded = try? JSONDecoder().decode([Subject].self, from: data) {
            subjects = decoded
        }
        if let data = defaults.data(forKey: StorageKey.sessions),
           let decoded = try? JSONDecoder().decode([StudySession].self, from: data) {
            sessions = decoded
        }
        if let data = defaults.data(forKey: StorageKey.goals),
           let decoded = try? JSONDecoder().decode([StudyGoal].self, from: data) {
            goals = decoded
        }
        if let data = defaults.data(forKey: StorageKey.transactions),
           let decoded = try? JSONDecoder().decode([GoldTransaction].self, from: data) {
            transactions = decoded
        }
        if let data = defaults.data(forKey: StorageKey.achievements),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }
        spentGold = defaults.integer(forKey: StorageKey.spent)
        purchasedItems = defaults.stringArray(forKey: StorageKey.purchases) ?? []

        if achievements.isEmpty {
            achievements = StudyGoldViewModel.defaultAchievements()
        }
    }

    static func defaultAchievements() -> [Achievement] {
        [
            Achievement(
                id: UUID(),
                kind: .firstTenHours,
                name: "First 10 Hours",
                details: "Spend 10 hours studying",
                icon: "star.fill",
                requiredValue: 10,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                kind: .fiftyHours,
                name: "50 Hours Studied",
                details: "Spend 50 hours studying",
                icon: "trophy.fill",
                requiredValue: 50,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                kind: .hundredHours,
                name: "100 Hours Studied",
                details: "Spend 100 hours studying",
                icon: "crown.fill",
                requiredValue: 100,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                kind: .sevenDayStreak,
                name: "7 Day Streak",
                details: "Study for 7 days in a row",
                icon: "flame.fill",
                requiredValue: 7,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                kind: .thirtyDayStreak,
                name: "30 Day Streak",
                details: "Study for 30 days in a row",
                icon: "bolt.fill",
                requiredValue: 30,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                kind: .thousandGold,
                name: "1000 Gold",
                details: "Earn 1000 gold coins",
                icon: "dollarsign.circle.fill",
                requiredValue: 1000,
                achievedAt: nil,
                isAchieved: false
            )
        ]
    }
}
