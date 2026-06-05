//
//  StudySession.swift
//  156StudyGold
//

import Foundation

struct StudySession: Identifiable, Codable, Hashable {
    let id: UUID
    let subjectId: UUID
    var subjectName: String
    let date: Date
    var duration: Int // minutes
    var difficulty: StudyDifficulty
    var notes: String?
    var isCompleted: Bool

    var earnedGold: Int {
        Int(Double(duration) / 60.0 * difficulty.multiplier * 10)
    }
}
