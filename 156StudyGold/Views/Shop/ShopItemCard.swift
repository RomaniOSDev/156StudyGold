//
//  ShopItemCard.swift
//  156StudyGold
//

import SwiftUI

struct ShopItemCard: View {
    let item: ShopItem
    let availableGold: Int
    let isPurchased: Bool

    private var canAfford: Bool { availableGold >= item.price }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            canAfford
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: [Color.studyGold.opacity(0.45), Color.studyGold.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            : AnyShapeStyle(Color.studyGray.opacity(0.18))
                        )
                        .frame(width: 56, height: 56)
                        .shadow(
                            color: canAfford ? Color.studyGold.opacity(0.4) : .clear,
                            radius: 10, x: 0, y: 4
                        )

                    Image(systemName: item.icon)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(canAfford ? .studyGold : .studyGray)
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(item.details)
                        .font(.caption)
                        .foregroundColor(.studyGray)
                        .lineLimit(2)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 3) {
                        Image(systemName: "crown.fill")
                            .font(.caption2)
                        Text("\(item.price)")
                            .font(.headline)
                            .bold()
                    }
                    .foregroundColor(.studyGold)

                    if isPurchased {
                        StatusBadge(title: "Owned", color: .studyGold, icon: "checkmark")
                    } else if canAfford {
                        StatusBadge(title: "Available", color: .studyGold, icon: "sparkles")
                    } else {
                        StatusBadge(title: "Locked", color: .studyGray, icon: "lock.fill")
                    }
                }
            }
            .padding(16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.studyBackgroundLight.opacity(0.55))

                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(LinearGradient.studyCardGradient)

                    if canAfford && !isPurchased {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.studyGold.opacity(0.18), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: canAfford
                            ? [Color.studyGold.opacity(0.7), Color.studyGold.opacity(0.2)]
                            : [Color.white.opacity(0.18), Color.white.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: canAfford ? Color.studyGold.opacity(0.22) : Color.black.opacity(0.3),
                radius: 14, x: 0, y: 8
            )

            if isPurchased {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title3)
                    .foregroundColor(.studyGold)
                    .symbolRenderingMode(.hierarchical)
                    .background(
                        Circle()
                            .fill(Color.studyBackground)
                            .frame(width: 26, height: 26)
                    )
                    .padding(10)
            }
        }
    }
}
