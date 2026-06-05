//
//  StudyGoal.swift
//  156StudyGold
//

import Foundation

struct StudyGoal: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var targetHours: Int
    var currentHours: Int
    var deadline: Date?
    var rewardGold: Int
    var isCompleted: Bool
    let createdAt: Date

    var progress: Double {
        guard targetHours > 0 else { return 0 }
        return min(Double(currentHours) / Double(targetHours), 1.0)
    }
}
