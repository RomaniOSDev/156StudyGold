//
//  AddGoalView.swift
//  156StudyGold
//

import SwiftUI

struct AddGoalView: View {
    @ObservedObject var viewModel: StudyGoldViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var targetHours: Int = 10
    @State private var rewardGold: Int = 200
    @State private var hasDeadline: Bool = false
    @State private var deadline: Date = Date().addingTimeInterval(60 * 60 * 24 * 14)

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && targetHours > 0
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground(includesGoldGlow: true, includesBlueGlow: false)

                Form {
                    Section {
                        TextField("Goal title", text: $title)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))

                    Section {
                        Stepper("Target: \(targetHours) h", value: $targetHours, in: 1...500, step: 1)
                            .foregroundColor(.white)

                        Stepper("Reward: \(rewardGold) gold", value: $rewardGold, in: 50...10000, step: 50)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))

                    Section {
                        Toggle("Set deadline", isOn: $hasDeadline)
                            .foregroundColor(.white)
                            .tint(.studyGold)

                        if hasDeadline {
                            DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                                .foregroundColor(.white)
                                .colorScheme(.dark)
                        }
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.studyBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.studyGold)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .foregroundColor(.studyGold)
                        .bold()
                        .disabled(!canSave)
                }
            }
            .tint(.studyGold)
        }
        .preferredColorScheme(.dark)
    }

    private func save() {
        let goal = StudyGoal(
            id: UUID(),
            title: title.trimmingCharacters(in: .whitespaces),
            targetHours: targetHours,
            currentHours: 0,
            deadline: hasDeadline ? deadline : nil,
            rewardGold: rewardGold,
            isCompleted: false,
            createdAt: Date()
        )
        viewModel.addGoal(goal)
        dismiss()
    }
}
