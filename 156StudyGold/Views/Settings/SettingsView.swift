//
//  SettingsView.swift
//  156StudyGold
//

import SwiftUI
import StoreKit
import UIKit

struct SettingsView: View {
    @ObservedObject var viewModel: StudyGoldViewModel
    @Environment(\.dismiss) private var dismiss

    @AppStorage("studygold_onboarding_done") private var onboardingDone: Bool = false
    @AppStorage("studygold_notifications_on") private var notificationsOn: Bool = true
    @AppStorage("studygold_haptics_on") private var hapticsOn: Bool = true

    @State private var showResetConfirm = false
    @State private var showResetOnboardingConfirm = false

    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        header

                        SettingsSection("Preferences") {
                            ToggleRow(
                                icon: "bell.fill",
                                title: "Notifications",
                                subtitle: "Get reminded to study",
                                tint: .studyGold,
                                isOn: $notificationsOn
                            )
                            SettingsDivider()
                            ToggleRow(
                                icon: "hand.tap.fill",
                                title: "Haptic feedback",
                                subtitle: "Tactile response on actions",
                                tint: Color(red: 0.55, green: 0.65, blue: 0.95),
                                isOn: $hapticsOn
                            )
                        }

                        SettingsSection("Support") {
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate us",
                                subtitle: "Tell us how we are doing",
                                tint: .studyGold
                            ) {
                                rateApp()
                            }
                            SettingsDivider()
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact support",
                                subtitle: "Send us a message",
                                tint: Color(red: 0.55, green: 0.65, blue: 0.95)
                            ) {
                                openLink(AppLinks.supportEmail)
                            }
                            SettingsDivider()
                            SettingsRow(
                                icon: "globe",
                                title: "Website",
                                subtitle: "Visit our site",
                                tint: Color(red: 0.55, green: 0.85, blue: 0.65)
                            ) {
                                openLink(AppLinks.website)
                            }
                        }

                        SettingsSection("Legal") {
                            SettingsRow(
                                icon: "lock.shield.fill",
                                title: "Privacy Policy",
                                subtitle: "How we handle your data",
                                tint: Color(red: 0.55, green: 0.65, blue: 0.95)
                            ) {
                                openLink(AppLinks.privacyPolicy)
                            }
                            SettingsDivider()
                            SettingsRow(
                                icon: "doc.text.fill",
                                title: "Terms of Use",
                                subtitle: "Service agreement",
                                tint: Color(red: 0.65, green: 0.55, blue: 0.95)
                            ) {
                                openLink(AppLinks.termsOfUse)
                            }
                        }

                        SettingsSection("Data") {
                            SettingsRow(
                                icon: "arrow.counterclockwise.circle.fill",
                                title: "Show onboarding again",
                                subtitle: "Replay the welcome tour",
                                tint: Color(red: 0.95, green: 0.65, blue: 0.45)
                            ) {
                                showResetOnboardingConfirm = true
                            }
                            SettingsDivider()
                            SettingsRow(
                                icon: "trash.fill",
                                title: "Reset all data",
                                subtitle: "Erase subjects, sessions and progress",
                                tint: Color(red: 0.95, green: 0.45, blue: 0.45),
                                trailing: .destructive
                            ) {
                                showResetConfirm = true
                            }
                        }

                        appBadge
                            .padding(.top, 8)
                    }
                    .padding()
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.studyBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.studyGold)
                }
            }
            .alert("Reset all data?", isPresented: $showResetConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) { resetAllData() }
            } message: {
                Text("This will permanently delete all subjects, sessions, goals and gold. This action cannot be undone.")
            }
            .alert("Show onboarding again?", isPresented: $showResetOnboardingConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Show") { resetOnboarding() }
            } message: {
                Text("The welcome tour will be shown the next time you open the app.")
            }
            .tint(.studyGold)
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient.studyGoldGradient)
                    .frame(width: 92, height: 92)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: Color.studyGold.opacity(0.5), radius: 18, x: 0, y: 10)

                Image(systemName: "gearshape.fill")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.studyBackground)
                    .symbolRenderingMode(.hierarchical)
            }

            VStack(spacing: 4) {
                Text("Tune your experience")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Manage preferences and learn more about the app")
                    .font(.caption)
                    .foregroundColor(.studyGray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }

    private var appBadge: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(.studyGold)
                Text("Made with care")
                    .font(.caption)
                    .foregroundColor(.studyGray)
            }
            Text("Version \(appVersion)")
                .font(.caption2)
                .foregroundColor(.studyGray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }

    // MARK: - Actions

    private func openLink(_ url: URL?) {
        guard let url else { return }
        UIApplication.shared.open(url)
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    private func resetOnboarding() {
        onboardingDone = false
        dismiss()
    }

    private func resetAllData() {
        viewModel.subjects = []
        viewModel.sessions = []
        viewModel.goals = []
        viewModel.transactions = []
        viewModel.spentGold = 0
        viewModel.purchasedItems = []
        viewModel.achievements = StudyGoldViewModel.defaultAchievements()
        viewModel.save()
    }
}

private struct ToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let tint: Color
    @Binding var isOn: Bool

    var body: some View {
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
                }
            }

            Spacer(minLength: 8)

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.studyGold)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
    }
}
