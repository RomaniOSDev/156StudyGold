//
//  CardStyle.swift
//  156StudyGold
//

import SwiftUI

struct ElevatedCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var shadowColor: Color = Color.black.opacity(0.30)
    var shadowRadius: CGFloat = 8
    var shadowOffsetY: CGFloat = 4
    var strokeOpacity: Double = 1.0

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.studyBackgroundLight.opacity(0.45))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        Color.white.opacity(0.18 * strokeOpacity),
                        lineWidth: 1
                    )
            )
            .compositingGroup()
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffsetY)
    }
}

struct GoldCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(LinearGradient.studyGoldGradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .compositingGroup()
            .shadow(color: Color.studyGold.opacity(0.35), radius: 10, x: 0, y: 6)
    }
}

struct InnerHighlightModifier: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    .allowsHitTesting(false)
            )
    }
}

extension View {
    func elevatedCard(
        cornerRadius: CGFloat = 20,
        shadowColor: Color = Color.black.opacity(0.30),
        shadowRadius: CGFloat = 8,
        shadowOffsetY: CGFloat = 4
    ) -> some View {
        modifier(ElevatedCardModifier(
            cornerRadius: cornerRadius,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOffsetY: shadowOffsetY
        ))
    }

    func goldCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(GoldCardModifier(cornerRadius: cornerRadius))
    }

    func innerHighlight(cornerRadius: CGFloat = 20) -> some View {
        modifier(InnerHighlightModifier(cornerRadius: cornerRadius))
    }

    func softShadow() -> some View {
        shadow(color: Color.black.opacity(0.20), radius: 6, x: 0, y: 3)
    }

    func goldGlow() -> some View {
        shadow(color: Color.studyGold.opacity(0.30), radius: 8, x: 0, y: 4)
    }
}
