//
//  GoldTransaction.swift
//  156StudyGold
//

import Foundation

struct GoldTransaction: Identifiable, Codable, Hashable {
    let id: UUID
    let amount: Int
    let date: Date
    var source: String
    var notes: String?
}
