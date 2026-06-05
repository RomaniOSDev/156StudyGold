//
//  AddHoursToGoalView.swift
//  156StudyGold
//

import SwiftUI

struct AddHoursToGoalView: View {
    @ObservedObject var viewModel: StudyGoldViewModel
    let goal: StudyGoal
    @Environment(\.dismiss) private var dismiss

    @State private var hours: Int = 1

    private var maxAddable: Int {
        max(goal.targetHours - goal.currentHours, 1)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(goal.title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("\(goal.currentHours) of \(goal.targetHours) h logged")
                            .font(.subheadline)
                            .foregroundColor(.studyGray)
                    }
                    .padding(.top, 12)

                    VStack(spacing: 12) {
                        Text("\(hours) h")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundColor(.studyGold)

                        HStack(spacing: 16) {
                            stepperButton(systemName: "minus") {
                                if hours > 1 { hours -= 1 }
                            }
                            stepperButton(systemName: "plus") {
                                if hours < 50 { hours += 1 }
                            }
                        }

                        HStack(spacing: 8) {
                            ForEach([1, 2, 4, 8], id: \.self) { value in
                                Button {
                                    hours = value
                                } label: {
                                    Text("+\(value)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(hours == value ? .studyBackground : .white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(hours == value ? Color.studyGold : Color.studyGray.opacity(0.2))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .elevatedCard(cornerRadius: 22, shadowRadius: 16, shadowOffsetY: 10)

                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .font(.caption)
                        Text("Hours added here are tracked only against this goal")
                            .font(.caption)
                    }
                    .foregroundColor(.studyGray)
                    .multilineTextAlignment(.center)

                    Spacer()

                    Button {
                        viewModel.addHoursToGoal(goal, hours: hours)
                        dismiss()
                    } label: {
                        Text("Add \(hours) hour\(hours == 1 ? "" : "s")")
                    }
                    .buttonStyle(PrimaryGoldButtonStyle())
                }
                .padding()
            }
            .navigationTitle("Log Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.studyBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.studyGold)
                }
            }
            .tint(.studyGold)
            .onAppear {
                hours = min(1, maxAddable)
                if hours < 1 { hours = 1 }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func stepperButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title3.bold())
                .foregroundColor(.studyBackground)
                .frame(width: 52, height: 52)
                .background(
                    ZStack {
                        Circle()
                            .fill(LinearGradient.studyGoldGradient)
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.35), .clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.studyGold.opacity(0.5), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}
