//
//  StatCard.swift
//  156StudyGold
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.18))
                        .frame(width: 30, height: 30)
                    Image(systemName: icon)
                        .font(.caption.bold())
                        .foregroundColor(color)
                }
                Text(title)
                    .foregroundColor(.studyGray)
                    .font(.caption)
                Spacer(minLength: 0)
            }
            Text(value)
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(14)
        .frame(minWidth: 140, maxWidth: .infinity, minHeight: 86, alignment: .leading)
        .elevatedCard(cornerRadius: 16, shadowRadius: 10, shadowOffsetY: 5)
    }
}
