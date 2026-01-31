//
//  ProgressBar.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - ProgressBar

public struct ProgressBar: View {
    let value: Double
    let total: Double
    let showLabel: Bool
    let height: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let cornerRadius: CGFloat

    public init(
        value: Double,
        total: Double = 1.0,
        showLabel: Bool = false,
        height: CGFloat = 8,
        backgroundColor: Color = Color(.tertiarySystemFill),
        foregroundColor: Color = Tokens.Color.violet.color,
        cornerRadius: CGFloat = Tokens.CornerRadius.small
    ) {
        self.value = value
        self.total = total
        self.showLabel = showLabel
        self.height = height
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
    }

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(max(value / total, 0), 1)
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: Tokens.Spacing.extraExtraSmall) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor)

                    // Progress fill
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(foregroundColor)
                        .frame(width: geometry.size.width * progress)
                        .animation(Tokens.Animation.smooth, value: progress)
                }
            }
            .frame(height: height)

            if showLabel {
                Text("\(Int(progress * 100))%")
                    .font(.abcGinto(style: .caption2, weight: .medium))
                    .foregroundStyle(Color(.secondaryLabel))
            }
        }
    }
}

// MARK: - SteppedProgressBar

public struct SteppedProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    let spacing: CGFloat
    let height: CGFloat
    let activeColor: Color
    let inactiveColor: Color

    public init(
        currentStep: Int,
        totalSteps: Int,
        spacing: CGFloat = Tokens.Spacing.extraExtraSmall,
        height: CGFloat = 4,
        activeColor: Color = Tokens.Color.violet.color,
        inactiveColor: Color = Color(.tertiarySystemFill)
    ) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.spacing = spacing
        self.height = height
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<totalSteps, id: \.self) { step in
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(step < currentStep ? activeColor : inactiveColor)
                    .frame(height: height)
                    .animation(Tokens.Animation.smooth, value: currentStep)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.extraLarge) {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraSmall) {
            Text("Progress Bar")
                .font(.abcGinto(style: .headline, weight: .bold))

            ProgressBar(value: 0.3)
            ProgressBar(value: 0.6, showLabel: true)
            ProgressBar(value: 75, total: 100, showLabel: true, foregroundColor: .green)
            ProgressBar(value: 1.0, height: 12, foregroundColor: Tokens.Color.rose.color)
        }

        VStack(alignment: .leading, spacing: Tokens.Spacing.extraSmall) {
            Text("Stepped Progress")
                .font(.abcGinto(style: .headline, weight: .bold))

            SteppedProgressBar(currentStep: 1, totalSteps: 4)
            SteppedProgressBar(currentStep: 2, totalSteps: 4)
            SteppedProgressBar(currentStep: 3, totalSteps: 4)
            SteppedProgressBar(currentStep: 4, totalSteps: 4)
        }
    }
    .padding()
}
