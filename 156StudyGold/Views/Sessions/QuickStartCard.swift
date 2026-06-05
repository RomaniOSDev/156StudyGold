//
//  QuickStartCard.swift
//  156StudyGold
//

import SwiftUI

struct QuickStartCard: View {
    let subject: Subject

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: subject.category.icon)
                .font(.title2)
                .foregroundColor(.studyGold)

            Text(subject.name)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text("+10/h")
                .font(.caption2)
                .foregroundColor(.studyGold)
        }
        .padding(8)
        .frame(width: 110, height: 110)
        .background(Color.studyGray.opacity(0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    subject.isFavorite ? Color.studyGold : Color.studyGray.opacity(0.3),
                    lineWidth: 1
                )
        )
        .cornerRadius(12)
    }
}
