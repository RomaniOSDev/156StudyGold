//
//  Colors.swift
//  156StudyGold
//

import SwiftUI

extension Color {
    static let studyBackground = Color(red: 0.0, green: 0.137, blue: 0.373) // #00235F
    static let studyBackgroundDark = Color(red: 0.0, green: 0.07, blue: 0.22)
    static let studyBackgroundLight = Color(red: 0.06, green: 0.20, blue: 0.50)
    static let studyGold = Color(red: 1.0, green: 0.757, blue: 0.196) // #FFC132
    static let studyGoldDark = Color(red: 0.85, green: 0.55, blue: 0.10)
    static let studyGoldLight = Color(red: 1.0, green: 0.87, blue: 0.45)
    static let studyGray = Color(red: 0.396, green: 0.396, blue: 0.396) // #656565
    static let studyAccentBlue = Color(red: 0.30, green: 0.45, blue: 0.85)
    static let studyAccentPurple = Color(red: 0.55, green: 0.40, blue: 0.85)
}

extension LinearGradient {
    static let studyBackgroundGradient = LinearGradient(
        colors: [Color.studyBackgroundDark, Color.studyBackground, Color.studyBackgroundLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let studyGoldGradient = LinearGradient(
        colors: [Color.studyGoldLight, Color.studyGold, Color.studyGoldDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let studyGoldSoft = LinearGradient(
        colors: [Color.studyGold.opacity(0.25), Color.studyGold.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let studyCardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.10),
            Color.white.opacity(0.03)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let studyCardStroke = LinearGradient(
        colors: [
            Color.white.opacity(0.25),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
