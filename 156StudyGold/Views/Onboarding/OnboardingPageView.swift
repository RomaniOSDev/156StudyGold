//
//  OnboardingPageView.swift
//  156StudyGold
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var iconAppear = false
    @State private var floatPrimary = false
    @State private var floatSecondary = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: contentSpacing(for: proxy.size.height)) {
                    illustration(size: illustrationSize(for: proxy.size.height))

                    textSection(titleSize: titleSize(for: proxy.size.height))

                    highlightsSection
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity)
                .frame(minHeight: proxy.size.height, alignment: .top)
            }
        }
        .onAppear { animate() }
        .onChange(of: isActive) { active in
            if active { animate() }
        }
    }

    private var horizontalPadding: CGFloat {
        horizontalSizeClass == .regular ? 32 : 20
    }

    private var highlightsSection: some View {
        Group {
            if horizontalSizeClass == .regular {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    ForEach(page.highlights) { highlight in
                        highlightRow(highlight)
                    }
                }
            } else {
                VStack(spacing: 10) {
                    ForEach(page.highlights) { highlight in
                        highlightRow(highlight)
                    }
                }
            }
        }
        .padding(.top, 4)
    }

    private func contentSpacing(for height: CGFloat) -> CGFloat {
        height < 620 ? 16 : (horizontalSizeClass == .regular ? 28 : 20)
    }

    private func illustrationSize(for height: CGFloat) -> CGFloat {
        if height < 620 { return 140 }
        if verticalSizeClass == .compact { return 150 }
        if horizontalSizeClass == .regular { return 200 }
        return 170
    }

    private func titleSize(for height: CGFloat) -> CGFloat {
        if height < 620 { return 24 }
        if horizontalSizeClass == .regular { return 34 }
        return 28
    }

    private func textSection(titleSize: CGFloat) -> some View {
        VStack(spacing: 12) {
            Text(page.title)
                .font(.system(size: titleSize, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(page.subtitle)
                .font(.body)
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func illustration(size: CGFloat) -> some View {
        let iconScale = size / 220.0
        let mainIconSize = 96 * iconScale
        let secondarySize = 34 * iconScale
        let tertiarySize = 28 * iconScale

        return ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: page.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )

            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .frame(width: size, height: size)

            Image(systemName: page.secondaryIcon)
                .font(.system(size: secondarySize, weight: .bold))
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
                .padding(14 * iconScale)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.22))
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .offset(x: size * 0.43, y: floatPrimary ? -size * 0.37 : -size * 0.34)
                .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: floatPrimary)

            Image(systemName: page.tertiaryIcon)
                .font(.system(size: tertiarySize, weight: .bold))
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
                .padding(11 * iconScale)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.22))
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .offset(x: -size * 0.41, y: floatSecondary ? size * 0.36 : size * 0.39)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: floatSecondary)

            Image(systemName: page.icon)
                .font(.system(size: mainIconSize, weight: .bold))
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
                .scaleEffect(iconAppear ? 1.0 : 0.7)
                .opacity(iconAppear ? 1.0 : 0)
        }
        .frame(height: size + 20)
    }

    private func highlightRow(_ highlight: OnboardingPage.Highlight) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(page.glowColor.opacity(0.25))
                    .frame(width: 38, height: 38)
                Image(systemName: highlight.icon)
                    .font(.subheadline.bold())
                    .foregroundColor(page.glowColor)
                    .symbolRenderingMode(.hierarchical)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(highlight.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(highlight.subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
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
