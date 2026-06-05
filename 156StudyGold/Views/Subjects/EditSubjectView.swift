//
//  EditSubjectView.swift
//  156StudyGold
//

import SwiftUI

struct EditSubjectView: View {
    @ObservedObject var viewModel: StudyGoldViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var category: SubjectCategory
    @State private var goalHours: Int
    @State private var isFavorite: Bool

    private let original: Subject

    init(viewModel: StudyGoldViewModel, subject: Subject) {
        self.viewModel = viewModel
        self.original = subject
        _name = State(initialValue: subject.name)
        _category = State(initialValue: subject.category)
        _goalHours = State(initialValue: subject.goalHours)
        _isFavorite = State(initialValue: subject.isFavorite)
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground(includesGoldGlow: true, includesBlueGlow: false)

                Form {
                    Section {
                        TextField("Subject name", text: $name)
                            .foregroundColor(.white)

                        Picker("Category", selection: $category) {
                            ForEach(SubjectCategory.allCases, id: \.self) { cat in
                                HStack {
                                    Image(systemName: cat.icon)
                                    Text(cat.rawValue)
                                }
                                .tag(cat)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))

                    Section {
                        Stepper("Weekly goal: \(goalHours) h", value: $goalHours, in: 1...50, step: 1)
                            .foregroundColor(.white)

                        Toggle("Favorite", isOn: $isFavorite)
                            .foregroundColor(.white)
                            .tint(.studyGold)
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Subject")
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
        var updated = original
        updated.name = name.trimmingCharacters(in: .whitespaces)
        updated.category = category
        updated.goalHours = goalHours
        updated.isFavorite = isFavorite
        viewModel.updateSubject(updated)
        dismiss()
    }
}
