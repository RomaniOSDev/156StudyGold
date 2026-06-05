//
//  Subject.swift
//  156StudyGold
//

import Foundation

struct Subject: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var category: SubjectCategory
    var color: String?
    var goalHours: Int
    var isFavorite: Bool
    let createdAt: Date
}
