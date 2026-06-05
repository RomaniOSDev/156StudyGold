//
//  AddSubjectView.swift
//  156StudyGold
//

import SwiftUI

struct AddSubjectView: View {
    @ObservedObject var viewModel: StudyGoldViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var category: SubjectCategory = .other
    @State private var goalHours: Int = 5
    @State private var isFavorite: Bool = false

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
            .navigationTitle("New Subject")
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
        let subject = Subject(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            category: category,
            color: nil,
            goalHours: goalHours,
            isFavorite: isFavorite,
            createdAt: Date()
        )
        viewModel.addSubject(subject)
        dismiss()
    }
}
