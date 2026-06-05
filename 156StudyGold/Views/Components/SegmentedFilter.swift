//
//  SegmentedFilter.swift
//  156StudyGold
//

import SwiftUI

struct SegmentedFilter<T: Hashable>: View {
    let options: [T]
    let titleFor: (T) -> String
    @Binding var selection: T

    var body: some View {
        HStack(spacing: 6) {
            ForEach(options, id: \.self) { option in
                let isSelected = option == selection
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = option
                    }
                } label: {
                    Text(titleFor(option))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .studyBackground : .white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(
                            isSelected ? Color.studyGold : Color.studyGray.opacity(0.2)
                        )
                        .cornerRadius(20)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.studyGray.opacity(0.1))
        .cornerRadius(24)
    }
}
