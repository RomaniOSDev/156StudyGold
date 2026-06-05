//
//  ShopView.swift
//  156StudyGold
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var viewModel: StudyGoldViewModel

    @State private var pendingItem: ShopItem?
    @State private var showInsufficient = false

    private let items: [ShopItem] = ShopItem.defaults

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        balanceCard
                        sectionHeader

                        VStack(spacing: 12) {
                            ForEach(items) { item in
                                ShopItemCard(
                                    item: item,
                                    availableGold: viewModel.totalGold,
                                    isPurchased: viewModel.purchasedItems.contains(item.name)
                                )
                                .onTapGesture {
                                    handleTap(item)
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Rewards Shop")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.studyBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert(item: $pendingItem) { item in
                Alert(
                    title: Text("Buy \(item.name)?"),
                    message: Text("This will spend \(item.price) gold"),
                    primaryButton: .default(Text("Buy")) {
                        _ = viewModel.purchase(item)
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert("Not enough gold", isPresented: $showInsufficient) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Earn more gold by completing study sessions and goals")
            }
        }
        .tint(.studyGold)
    }

    private var balanceCard: some View {
        ZStack(alignment: .topTrailing) {
            // Decorative big crown
            Image(systemName: "crown.fill")
                .font(.system(size: 160, weight: .bold))
                .foregroundColor(.white.opacity(0.18))
                .rotationEffect(.degrees(-10))
                .offset(x: 60, y: 14)

            // Sparkles top right
            Image(systemName: "sparkles")
                .font(.subheadline)
                .foregroundColor(.studyBackground)
                .padding(12)

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 6) {
                    Image(systemName: "wallet.pass.fill")
                        .font(.caption)
                    Text("YOUR BALANCE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .tracking(2)
                }
                .foregroundColor(Color.studyBackground.opacity(0.7))

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundColor(.studyBackground)
                    Text("\(viewModel.totalGold)")
                        .font(.system(size: 52, weight: .heavy, design: .rounded))
                        .foregroundColor(.studyBackground)
                    Text("gold")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.studyBackground.opacity(0.65))
                }

                HStack(spacing: 10) {
                    miniStat(
                        icon: "books.vertical.fill",
                        text: "\(viewModel.totalSessions) sessions"
                    )
                    miniStat(
                        icon: "checkmark.seal.fill",
                        text: "\(viewModel.purchasedItems.count) bought"
                    )
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .goldCard(cornerRadius: 22)
    }

    private func miniStat(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(.studyBackground)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.studyBackground.opacity(0.18))
        )
    }

    private var sectionHeader: some View {
        HStack {
            Label {
                Text("Available rewards")
                    .font(.headline)
                    .foregroundColor(.white)
            } icon: {
                Image(systemName: "gift.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.studyGold)
            }
            Spacer()
            Text("\(items.count)")
                .font(.caption)
                .foregroundColor(.studyGray)
        }
    }

    private func handleTap(_ item: ShopItem) {
        guard !viewModel.purchasedItems.contains(item.name) else { return }
        if viewModel.totalGold >= item.price {
            pendingItem = item
        } else {
            showInsufficient = true
        }
    }
}
