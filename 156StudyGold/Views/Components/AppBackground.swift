//
//  AppBackground.swift
//  156StudyGold
//

import SwiftUI

struct AppBackground: View {
    var includesGoldGlow: Bool = true
    var includesBlueGlow: Bool = true

    var body: some View {
        ZStack {
            LinearGradient.studyBackgroundGradient
                .ignoresSafeArea()

            if includesGoldGlow {
                RadialGradient(
                    colors: [Color.studyGold.opacity(0.18), .clear],
                    center: UnitPoint(x: 0.15, y: 0.05),
                    startRadius: 0,
                    endRadius: 360
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }

            if includesBlueGlow {
                RadialGradient(
                    colors: [Color.studyAccentBlue.opacity(0.22), .clear],
                    center: UnitPoint(x: 0.85, y: 0.95),
                    startRadius: 0,
                    endRadius: 340
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }
        }
    }
}

extension View {
    func appBackground() -> some View {
        background(AppBackground())
    }
}
