//
//  Skeleton.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - SkeletonShape

public enum SkeletonShape {
    case rectangle
    case rounded(CGFloat)
    case capsule
    case circle
}

// MARK: - Skeleton

public struct Skeleton: View {
    let width: CGFloat?
    let height: CGFloat
    let shape: SkeletonShape

    @State private var isAnimating = false

    public init(
        width: CGFloat? = nil,
        height: CGFloat = 20,
        shape: SkeletonShape = .rounded(Tokens.CornerRadius.small)
    ) {
        self.width = width
        self.height = height
        self.shape = shape
    }

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(.systemFill).opacity(0.3),
                Color(.systemFill).opacity(0.6),
                Color(.systemFill).opacity(0.3)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    @ViewBuilder
    private func filledShape() -> some View {
        switch shape {
        case .rectangle:
            Rectangle().fill(Color(.systemFill))
        case .rounded(let radius):
            RoundedRectangle(cornerRadius: radius).fill(Color(.systemFill))
        case .capsule:
            Capsule().fill(Color(.systemFill))
        case .circle:
            Circle().fill(Color(.systemFill))
        }
    }

    @ViewBuilder
    private func maskShape() -> some View {
        switch shape {
        case .rectangle:
            Rectangle()
        case .rounded(let radius):
            RoundedRectangle(cornerRadius: radius)
        case .capsule:
            Capsule()
        case .circle:
            Circle()
        }
    }

    public var body: some View {
        filledShape()
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geometry in
                    gradient
                        .frame(width: geometry.size.width * 2)
                        .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                }
                .mask(maskShape())
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - SkeletonText

public struct SkeletonText: View {
    let lines: Int
    let lastLineWidth: CGFloat
    let lineHeight: CGFloat
    let spacing: CGFloat

    public init(
        lines: Int = 3,
        lastLineWidth: CGFloat = 0.6,
        lineHeight: CGFloat = 16,
        spacing: CGFloat = Tokens.Spacing.extraSmall
    ) {
        self.lines = lines
        self.lastLineWidth = lastLineWidth
        self.lineHeight = lineHeight
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<lines, id: \.self) { index in
                GeometryReader { geometry in
                    Skeleton(
                        width: index == lines - 1
                            ? geometry.size.width * lastLineWidth
                            : geometry.size.width,
                        height: lineHeight,
                        shape: .rounded(4)
                    )
                }
                .frame(height: lineHeight)
            }
        }
    }
}

// MARK: - SkeletonAvatar

public struct SkeletonAvatar: View {
    let size: CGFloat

    public init(size: CGFloat = 48) {
        self.size = size
    }

    public var body: some View {
        Skeleton(
            width: size,
            height: size,
            shape: .circle
        )
    }
}

// MARK: - SkeletonCard

public struct SkeletonCard: View {
    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
            HStack(spacing: Tokens.Spacing.small) {
                SkeletonAvatar(size: 40)

                VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                    Skeleton(width: 120, height: 14)
                    Skeleton(width: 80, height: 12)
                }
            }

            SkeletonText(lines: 2, lineHeight: 14)

            Skeleton(height: 32, shape: .rounded(Tokens.CornerRadius.small))
        }
        .padding(Tokens.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// MARK: - SkeletonListRow

public struct SkeletonListRow: View {
    let showAvatar: Bool
    let showSubtitle: Bool
    let showTrailing: Bool

    public init(
        showAvatar: Bool = true,
        showSubtitle: Bool = true,
        showTrailing: Bool = true
    ) {
        self.showAvatar = showAvatar
        self.showSubtitle = showSubtitle
        self.showTrailing = showTrailing
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.small) {
            if showAvatar {
                SkeletonAvatar(size: 44)
            }

            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                Skeleton(width: 140, height: 16)

                if showSubtitle {
                    Skeleton(width: 100, height: 12)
                }
            }

            Spacer()

            if showTrailing {
                VStack(alignment: .trailing, spacing: Tokens.Spacing.extraExtraSmall) {
                    Skeleton(width: 60, height: 16)
                    Skeleton(width: 40, height: 12)
                }
            }
        }
        .padding(.vertical, Tokens.Spacing.extraSmall)
    }
}

// MARK: - SkeletonModifier

public struct SkeletonModifier: ViewModifier {
    let isLoading: Bool

    public func body(content: Content) -> some View {
        if isLoading {
            content
                .redacted(reason: .placeholder)
                .shimmering()
        } else {
            content
        }
    }
}

private struct ShimmerModifier: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            Color.white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.5)
                    .offset(x: isAnimating ? geometry.size.width * 1.5 : -geometry.size.width * 0.5)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

public extension View {
    func skeleton(isLoading: Bool) -> some View {
        modifier(SkeletonModifier(isLoading: isLoading))
    }

    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: Tokens.Spacing.extraLarge) {
            VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
                Text("Basic Skeletons")
                    .font(.abcGinto(style: .headline, weight: .bold))

                Skeleton(height: 20)
                Skeleton(width: 200, height: 20)
                Skeleton(width: 100, height: 40, shape: .capsule)
                Skeleton(width: 60, height: 60, shape: .circle)
            }

            VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
                Text("Skeleton Text")
                    .font(.abcGinto(style: .headline, weight: .bold))

                SkeletonText(lines: 3)
            }

            VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
                Text("Skeleton Card")
                    .font(.abcGinto(style: .headline, weight: .bold))

                SkeletonCard()
            }

            VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
                Text("Skeleton List")
                    .font(.abcGinto(style: .headline, weight: .bold))

                VStack(spacing: 0) {
                    SkeletonListRow()
                    Divider()
                    SkeletonListRow()
                    Divider()
                    SkeletonListRow(showAvatar: false)
                }
            }
        }
        .padding()
    }
}
