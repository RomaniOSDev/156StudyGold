//
//  ContentView.swift
//  156StudyGold
//
//  Created by Roman on 5/7/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var viewModel = StudyGoldViewModel()
    @State private var selectedTab: Int = 0
    @AppStorage("studygold_onboarding_done") private var onboardingDone: Bool = false

    init() {
        configureTabBarAppearance()
        configureNavigationBarAppearance()
    }

    var body: some View {
        ZStack {
            mainTabs
                .opacity(onboardingDone ? 1 : 0)

            if !onboardingDone {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        onboardingDone = true
                    }
                }
                .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.load()
        }
    }

    private var mainTabs: some View {
        TabView(selection: $selectedTab) {
            DashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            SubjectsView(viewModel: viewModel)
                .tabItem {
                    Label("Subjects", systemImage: "book.fill")
                }
                .tag(1)

            GoalsView(viewModel: viewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag(2)

            ShopView(viewModel: viewModel)
                .tabItem {
                    Label("Shop", systemImage: "crown.fill")
                }
                .tag(3)

            StatsView(viewModel: viewModel)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(4)
        }
        .tint(.studyGold)
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.studyBackground)

        let goldColor = UIColor(Color.studyGold)
        let grayColor = UIColor(Color.studyGray)

        appearance.stackedLayoutAppearance.selected.iconColor = goldColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: goldColor]
        appearance.stackedLayoutAppearance.normal.iconColor = grayColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: grayColor]

        appearance.inlineLayoutAppearance.selected.iconColor = goldColor
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: goldColor]
        appearance.inlineLayoutAppearance.normal.iconColor = grayColor
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: grayColor]

        appearance.compactInlineLayoutAppearance.selected.iconColor = goldColor
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: goldColor]
        appearance.compactInlineLayoutAppearance.normal.iconColor = grayColor
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: grayColor]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.studyBackground)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.studyGold)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.studyGold)]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(Color.studyGold)
    }
}

#Preview {
    ContentView()
}
