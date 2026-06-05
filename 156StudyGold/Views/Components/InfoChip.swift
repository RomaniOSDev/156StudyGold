//
//  InfoChip.swift
//  156StudyGold
//

import SwiftUI

struct InfoChip: View {
    let icon: String
    let text: String
    var tint: Color = .studyGold

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(tint)
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(tint.opacity(0.18))
        )
        .overlay(
            Capsule()
                .stroke(tint.opacity(0.4), lineWidth: 0.5)
        )
    }
}

struct StatusBadge: View {
    let title: String
    let color: Color
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(systemName: icon)
                    .font(.caption2)
            }
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .textCase(.uppercase)
        }
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(color.opacity(0.20))
        )
        .overlay(
            Capsule()
                .stroke(color.opacity(0.45), lineWidth: 0.5)
        )
    }
}
