//
//  Achievement.swift
//  156StudyGold
//

import Foundation

enum AchievementKind: String, Codable {
    case firstTenHours
    case fiftyHours
    case hundredHours
    case sevenDayStreak
    case thirtyDayStreak
    case thousandGold
}

struct Achievement: Identifiable, Codable, Hashable {
    let id: UUID
    var kind: AchievementKind
    var name: String
    var details: String
    var icon: String
    var requiredValue: Int
    var achievedAt: Date?
    var isAchieved: Bool
}
