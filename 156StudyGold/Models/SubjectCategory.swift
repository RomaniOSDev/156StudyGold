//
//  SubjectCategory.swift
//  156StudyGold
//

import Foundation

enum SubjectCategory: String, CaseIterable, Codable {
    case math = "Math"
    case physics = "Physics"
    case chemistry = "Chemistry"
    case biology = "Biology"
    case history = "History"
    case languages = "Languages"
    case programming = "Programming"
    case art = "Art"
    case music = "Music"
    case other = "Other"

    var icon: String {
        switch self {
        case .math: return "function"
        case .physics: return "atom"
        case .chemistry: return "flask.fill"
        case .biology: return "leaf.fill"
        case .history: return "clock.fill"
        case .languages: return "character.book.closed"
        case .programming: return "chevron.left.forwardslash.chevron.right"
        case .art: return "paintpalette"
        case .music: return "music.note"
        case .other: return "book.fill"
        }
    }
}
