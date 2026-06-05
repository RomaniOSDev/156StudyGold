//
//  StudyDifficulty.swift
//  156StudyGold
//

import Foundation

enum StudyDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var multiplier: Double {
        switch self {
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 2.0
        }
    }

    var multiplierLabel: String {
        switch self {
        case .easy: return "x1"
        case .medium: return "x1.5"
        case .hard: return "x2"
        }
    }
}
