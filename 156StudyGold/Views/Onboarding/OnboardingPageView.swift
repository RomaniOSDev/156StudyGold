//
//  OnboardingPageView.swift
//  156StudyGold
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool

    @State private var iconAppear = false
    @State private var floatPrimary = false
    @State private var floatSecondary = false

    var body: some View {
        VStack(spacing: 28) {
            illustration

            VStack(spacing: 14) {
                Text(page.title)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Text(page.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineLimit(4)
            }

            VStack(spacing: 10) {
                ForEach(page.highlights) { highlight in
                    highlightRow(highlight)
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 4)

            Spacer(minLength: 0)
        }
        .padding(.top, 24)
        .onAppear { animate() }
        .onChange(of: isActive) { active in
            if active { animate() }
        }
    }

    private var illustration: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .fill(
                    LinearGradient(
                        colors: page.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 220, height: 220)
                .shadow(color: page.glowColor.opacity(0.55), radius: 40, x: 0, y: 20)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )

            // Inner highlight
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .frame(width: 220, height: 220)

            // Decorative outer dots
            ForEach(0..<8, id: \.self) { idx in
                Circle()
                    .fill(page.glowColor.opacity(0.35))
                    .frame(width: 6, height: 6)
                    .offset(y: -130)
                    .rotationEffect(.degrees(Double(idx) * 45))
            }

            // Secondary icon (top-right floating)
            Image(systemName: page.secondaryIcon)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
                .padding(14)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.35), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                .offset(x: 95, y: floatPrimary ? -82 : -76)
                .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: floatPrimary)

            // Tertiary icon (bottom-left)
            Image(systemName: page.tertiaryIcon)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
                .padding(11)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.35), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)
                .offset(x: -90, y: floatSecondary ? 80 : 86)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: floatSecondary)

            // Big main icon
            Image(systemName: page.icon)
                .font(.system(size: 96, weight: .bold))
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
                .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                .scaleEffect(iconAppear ? 1.0 : 0.7)
                .opacity(iconAppear ? 1.0 : 0)
        }
        .frame(height: 240)
    }

    private func highlightRow(_ highlight: OnboardingPage.Highlight) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [page.glowColor.opacity(0.4), page.glowColor.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)
                Image(systemName: highlight.icon)
                    .font(.subheadline.bold())
                    .foregroundColor(page.glowColor)
                    .symbolRenderingMode(.hierarchical)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(highlight.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(highlight.subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.65))
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }

    private func animate() {
        iconAppear = false
        withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.05)) {
            iconAppear = true
        }
        floatPrimary = false
        floatSecondary = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            floatPrimary = true
            floatSecondary = true
        }
    }
}
