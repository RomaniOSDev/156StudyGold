//
//  OnboardingView.swift
//  156StudyGold
//

import SwiftUI

struct OnboardingView: View {
    var onFinish: () -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var currentIndex: Int = 0
    private let pages = OnboardingPage.pages

    private var isLast: Bool { currentIndex == pages.count - 1 }
    private var currentGlow: Color { pages[currentIndex].glowColor }

    var body: some View {
        ZStack {
            backgroundLayer

            VStack(spacing: 0) {
                topBar

                TabView(selection: $currentIndex) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { idx, page in
                        OnboardingPageView(page: page, isActive: currentIndex == idx)
                            .tag(idx)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.4), value: currentIndex)

                pageIndicator
                    .padding(.top, 8)

                actionButtons
                    .padding(.horizontal, horizontalSizeClass == .regular ? 40 : 24)
                    .padding(.top, 16)
                    .padding(.bottom, horizontalSizeClass == .regular ? 40 : 24)
            }
            .adaptiveContentWidth(560)
        }
        .preferredColorScheme(.dark)
    }

    private var backgroundLayer: some View {
        ZStack {
            LinearGradient.studyBackgroundGradient
                .ignoresSafeArea()

            RadialGradient(
                colors: [currentGlow.opacity(0.45), .clear],
                center: UnitPoint(x: 0.25, y: 0.05),
                startRadius: 0,
                endRadius: 380
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: currentIndex)

            RadialGradient(
                colors: [Color.studyAccentBlue.opacity(0.30), .clear],
                center: UnitPoint(x: 0.8, y: 0.95),
                startRadius: 0,
                endRadius: 320
            )
            .ignoresSafeArea()
        }
    }

    private var topBar: some View {
        HStack {
            Spacer()
            if !isLast {
                Button {
                    skip()
                } label: {
                    Text("Skip")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .frame(height: 44)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(Array(pages.enumerated()), id: \.element.id) { idx, _ in
                Capsule()
                    .fill(
                        idx == currentIndex
                        ? AnyShapeStyle(LinearGradient.studyGoldGradient)
                        : AnyShapeStyle(Color.white.opacity(0.25))
                    )
                    .frame(width: idx == currentIndex ? 28 : 8, height: 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentIndex)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                advance()
            } label: {
                HStack(spacing: 8) {
                    Text(isLast ? "Get started" : "Continue")
                    Image(systemName: isLast ? "arrow.right.circle.fill" : "arrow.right")
                }
            }
            .buttonStyle(PrimaryGoldButtonStyle())

            if !isLast {
                Button {
                    advance()
                } label: {
                    Text("\(currentIndex + 1) of \(pages.count)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.55))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func advance() {
        if isLast {
            onFinish()
        } else {
            withAnimation(.easeInOut(duration: 0.4)) {
                currentIndex += 1
            }
        }
    }

    private func skip() {
        onFinish()
    }
}
