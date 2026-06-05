//
//  CircularProgressView.swift
//  156StudyGold
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    var lineWidth: CGFloat = 8
    var trackColor: Color = Color.studyGray.opacity(0.3)
    var fillColor: Color = .studyGold
    var showsPercentage: Bool = true
    var label: String? = nil

    var body: some View {
        ZStack {
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: max(0.0001, min(progress, 1.0)))
                .stroke(
                    LinearGradient(
                        colors: [fillColor.opacity(0.7), fillColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.85), value: progress)

            VStack(spacing: 0) {
                if showsPercentage {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                if let label {
                    Text(label)
                        .font(.caption2)
                        .foregroundColor(.studyGray)
                }
            }
        }
    }
}
