//
//  CircularProgress.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - CircularProgress

public struct CircularProgress: View {
    let value: Double
    let total: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let showLabel: Bool
    let backgroundColor: Color
    let foregroundColor: Color

    public init(
        value: Double,
        total: Double = 1.0,
        lineWidth: CGFloat = 8,
        size: CGFloat = 80,
        showLabel: Bool = true,
        backgroundColor: Color = Color(.tertiarySystemFill),
        foregroundColor: Color = Tokens.Color.violet.color
    ) {
        self.value = value
        self.total = total
        self.lineWidth = lineWidth
        self.size = size
        self.showLabel = showLabel
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(max(value / total, 0), 1)
    }

    public var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    foregroundColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(Tokens.Animation.smooth, value: progress)

            // Label
            if showLabel {
                Text("\(Int(progress * 100))%")
                    .font(.abcGinto(size: size * 0.25, weight: .bold))
                    .foregroundStyle(Color(.label))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Spinner

public struct Spinner: View {
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color

    @State private var isAnimating = false

    public init(
        size: CGFloat = 40,
        lineWidth: CGFloat = 3,
        color: Color = Tokens.Color.violet.color
    ) {
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }

    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                color,
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(
                    .linear(duration: 1)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - LoadingDots

public struct LoadingDots: View {
    let dotCount: Int
    let dotSize: CGFloat
    let color: Color
    let spacing: CGFloat

    @State private var activeIndex = 0

    public init(
        dotCount: Int = 3,
        dotSize: CGFloat = 8,
        color: Color = Tokens.Color.violet.color,
        spacing: CGFloat = Tokens.Spacing.extraSmall
    ) {
        self.dotCount = dotCount
        self.dotSize = dotSize
        self.color = color
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(index == activeIndex ? 1.3 : 1.0)
                    .opacity(index == activeIndex ? 1.0 : 0.4)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                withAnimation(Tokens.Animation.bouncy) {
                    activeIndex = (activeIndex + 1) % dotCount
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.extraLarge) {
        VStack(spacing: Tokens.Spacing.medium) {
            Text("Circular Progress")
                .font(.abcGinto(style: .headline, weight: .bold))

            HStack(spacing: Tokens.Spacing.large) {
                CircularProgress(value: 0.25, size: 60)
                CircularProgress(value: 0.5, size: 60)
                CircularProgress(value: 0.75, size: 60)
                CircularProgress(value: 1.0, size: 60, foregroundColor: .green)
            }
        }

        VStack(spacing: Tokens.Spacing.medium) {
            Text("Spinners")
                .font(.abcGinto(style: .headline, weight: .bold))

            HStack(spacing: Tokens.Spacing.large) {
                Spinner(size: 24, lineWidth: 2)
                Spinner(size: 40, lineWidth: 3)
                Spinner(size: 56, lineWidth: 4, color: Tokens.Color.rose.color)
            }
        }

        VStack(spacing: Tokens.Spacing.medium) {
            Text("Loading Dots")
                .font(.abcGinto(style: .headline, weight: .bold))

            LoadingDots()
            LoadingDots(dotCount: 5, dotSize: 6, color: Tokens.Color.rose.color)
        }
    }
    .padding()
}
