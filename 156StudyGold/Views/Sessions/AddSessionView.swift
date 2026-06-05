//
//  AddSessionView.swift
//  156StudyGold
//

import SwiftUI

struct AddSessionView: View {
    @ObservedObject var viewModel: StudyGoldViewModel
    @Environment(\.dismiss) private var dismiss

    var preselectedSubjectId: UUID?

    @State private var selectedSubjectId: UUID?
    @State private var newSubjectName: String = ""
    @State private var newSubjectCategory: SubjectCategory = .other
    @State private var duration: Int = 30
    @State private var difficulty: StudyDifficulty = .medium
    @State private var notes: String = ""
    @State private var date: Date = Date()
    @State private var isCompleted: Bool = true

    private var canSave: Bool {
        if let id = selectedSubjectId {
            return viewModel.subjects.contains(where: { $0.id == id }) && duration >= 5
        }
        return !newSubjectName.trimmingCharacters(in: .whitespaces).isEmpty && duration >= 5
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground(includesGoldGlow: true, includesBlueGlow: false)

                Form {
                    Section {
                        Picker("Subject", selection: $selectedSubjectId) {
                            ForEach(viewModel.subjects) { subject in
                                Text(subject.name).tag(subject.id as UUID?)
                            }
                            Text("New subject").tag(nil as UUID?)
                        }
                        .foregroundColor(.white)

                        if selectedSubjectId == nil {
                            TextField("Subject name", text: $newSubjectName)
                                .foregroundColor(.white)

                            Picker("Category", selection: $newSubjectCategory) {
                                ForEach(SubjectCategory.allCases, id: \.self) { cat in
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                            .foregroundColor(.white)
                        }
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))

                    Section {
                        DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .foregroundColor(.white)
                            .colorScheme(.dark)

                        Stepper("Duration: \(duration) min", value: $duration, in: 5...300, step: 5)
                            .foregroundColor(.white)

                        Picker("Difficulty", selection: $difficulty) {
                            ForEach(StudyDifficulty.allCases, id: \.self) { diff in
                                Text("\(diff.rawValue) (\(diff.multiplierLabel))").tag(diff)
                            }
                        }
                        .foregroundColor(.white)

                        Toggle("Completed", isOn: $isCompleted)
                            .foregroundColor(.white)
                            .tint(.studyGold)
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))

                    Section(header: Text("Notes").foregroundColor(.studyGray)) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))

                    Section {
                        HStack {
                            Text("Reward preview")
                                .foregroundColor(.studyGray)
                            Spacer()
                            Text("+\(previewReward()) gold")
                                .bold()
                                .foregroundColor(.studyGold)
                        }
                    }
                    .listRowBackground(Color.studyGray.opacity(0.15))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Session")
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
                    Button("Save") { saveSession() }
                        .foregroundColor(.studyGold)
                        .bold()
                        .disabled(!canSave)
                }
            }
            .tint(.studyGold)
            .onAppear {
                if let preselected = preselectedSubjectId {
                    selectedSubjectId = preselected
                } else if selectedSubjectId == nil, let first = viewModel.subjects.first {
                    selectedSubjectId = first.id
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func previewReward() -> Int {
        Int(Double(duration) / 60.0 * difficulty.multiplier * 10)
    }

    private func saveSession() {
        let subjectId: UUID
        let subjectName: String

        if let id = selectedSubjectId, let subj = viewModel.subjects.first(where: { $0.id == id }) {
            subjectId = subj.id
            subjectName = subj.name
        } else {
            let trimmed = newSubjectName.trimmingCharacters(in: .whitespaces)
            let newSubject = Subject(
                id: UUID(),
                name: trimmed,
                category: newSubjectCategory,
                color: nil,
                goalHours: 5,
                isFavorite: false,
                createdAt: Date()
            )
            viewModel.addSubject(newSubject)
            subjectId = newSubject.id
            subjectName = newSubject.name
        }

        let session = StudySession(
            id: UUID(),
            subjectId: subjectId,
            subjectName: subjectName,
            date: date,
            duration: duration,
            difficulty: difficulty,
            notes: notes.isEmpty ? nil : notes,
            isCompleted: isCompleted
        )

        viewModel.addSession(session)
        dismiss()
    }
}
