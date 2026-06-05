//
//  SettingsRow.swift
//  156StudyGold
//

import SwiftUI

struct SettingsRow: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var tint: Color = .studyGold
    var trailing: Trailing = .chevron
    var action: () -> Void = {}

    enum Trailing {
        case chevron
        case value(String)
        case none
        case destructive
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [tint.opacity(0.4), tint.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .shadow(color: tint.opacity(0.3), radius: 6, x: 0, y: 3)

                    Image(systemName: icon)
                        .font(.subheadline.bold())
                        .foregroundColor(tint)
                        .symbolRenderingMode(.hierarchical)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.studyGray)
                            .lineLimit(2)
                    }
                }

                Spacer(minLength: 8)

                trailingView
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var trailingView: some View {
        switch trailing {
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.studyGray)
        case .value(let v):
            Text(v)
                .font(.caption)
                .foregroundColor(.studyGray)
        case .none:
            EmptyView()
        case .destructive:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption)
                .foregroundColor(Color(red: 0.95, green: 0.45, blue: 0.45))
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String?
    @ViewBuilder var content: Content

    init(_ title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .tracking(1.5)
                    .foregroundColor(.studyGray)
                    .padding(.horizontal, 4)
            }

            VStack(spacing: 0) {
                content
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.studyBackgroundLight.opacity(0.55))
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(LinearGradient.studyCardGradient)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(LinearGradient.studyCardStroke, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 14, x: 0, y: 8)
        }
    }
}

struct SettingsDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.07))
            .frame(height: 0.5)
            .padding(.leading, 64)
    }
}
