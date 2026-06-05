//
//  OnboardingPage.swift
//  156StudyGold
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let secondaryIcon: String
    let tertiaryIcon: String
    let title: String
    let subtitle: String
    let highlights: [Highlight]
    let gradient: [Color]
    let glowColor: Color

    struct Highlight: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let subtitle: String
    }
}

extension OnboardingPage {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "graduationcap.fill",
            secondaryIcon: "book.closed.fill",
            tertiaryIcon: "pencil.tip.crop.circle.fill",
            title: "Master your studies",
            subtitle: "Log every study session, track time across subjects and watch your knowledge grow.",
            highlights: [
                .init(
                    icon: "timer",
                    title: "Track every minute",
                    subtitle: "Quick session logging by subject"
                ),
                .init(
                    icon: "books.vertical.fill",
                    title: "Organize your subjects",
                    subtitle: "Categories, favorites and weekly goals"
                )
            ],
            gradient: [
                Color(red: 0.30, green: 0.50, blue: 0.95),
                Color(red: 0.10, green: 0.25, blue: 0.70)
            ],
            glowColor: Color(red: 0.30, green: 0.50, blue: 0.95)
        ),
        OnboardingPage(
            icon: "target",
            secondaryIcon: "flame.fill",
            tertiaryIcon: "checkmark.seal.fill",
            title: "Set goals, build streaks",
            subtitle: "Define ambitious goals, hit your weekly hours and keep the streak alive day after day.",
            highlights: [
                .init(
                    icon: "bolt.fill",
                    title: "Daily streaks",
                    subtitle: "Stay consistent and never break the chain"
                ),
                .init(
                    icon: "chart.bar.xaxis",
                    title: "Beautiful insights",
                    subtitle: "See your progress across the week"
                )
            ],
            gradient: [
                Color(red: 0.95, green: 0.55, blue: 0.30),
                Color(red: 0.85, green: 0.30, blue: 0.45)
            ],
            glowColor: Color(red: 0.95, green: 0.55, blue: 0.30)
        ),
        OnboardingPage(
            icon: "crown.fill",
            secondaryIcon: "gift.fill",
            tertiaryIcon: "sparkles",
            title: "Earn gold, unlock rewards",
            subtitle: "Every session earns gold coins. Spend them in the rewards shop and treat yourself.",
            highlights: [
                .init(
                    icon: "rosette",
                    title: "Achievements",
                    subtitle: "Unlock badges as you reach milestones"
                ),
                .init(
                    icon: "cart.fill",
                    title: "Rewards shop",
                    subtitle: "Trade your gold for real-life treats"
                )
            ],
            gradient: [
                Color(red: 1.0, green: 0.82, blue: 0.30),
                Color(red: 0.85, green: 0.55, blue: 0.10)
            ],
            glowColor: Color.studyGold
        )
    ]
}
