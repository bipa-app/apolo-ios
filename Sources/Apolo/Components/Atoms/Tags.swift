//
//  Tags.swift
//  Apolo
//
//  Created by Devin on 11/01/24.
//

import SwiftUI

public enum TagStyle {
    case status(icon: String? = nil)
    case label(icon: String? = nil)

    var backgroundColor: Color {
        switch self {
        case .status: return .violet
        case .label: return .rose
        }
    }
}

public struct Tag: View {
    private let text: String
    private let style: TagStyle
    private let size: ControlSize

    public init(
        text: String,
        style: TagStyle = .label(),
        size: ControlSize = .regular
    ) {
        self.text = text
        self.style = style
        self.size = size
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            if case let .status(icon) = style, let iconName = icon {
                Image(systemName: iconName)
                    .font(.caption)
            } else if case let .label(icon) = style, let iconName = icon {
                Image(systemName: iconName)
                    .font(.caption)
            }
            Text(text)
                .caption1(weight: .medium)
        }
        .modifier(TagModifier(style: style, size: size))
    }
}

public struct TagModifier: ViewModifier {
    let style: TagStyle
    let size: ControlSize

    @Environment(\.isEnabled) private var isEnabled

    public init(style: TagStyle, size: ControlSize = .regular) {
        self.style = style
        self.size = size
    }

    private func sizeValues(for size: ControlSize) -> (height: CGFloat, padding: CGFloat) {
        switch size {
        case .small: return (20, 8)
        case .regular: return (24, 10)
        case .large: return (32, 12)
        default: return (24, 10)
        }
    }

    public func body(content: Content) -> some View {
        let sizes = sizeValues(for: size)

        content
            .padding(.horizontal, sizes.padding)
            .frame(height: sizes.height)
            .background(style.backgroundColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        // Status tags with icons
        Tag(text: "Active", style: .status(icon: "checkmark.circle.fill"))
        Tag(text: "Pending", style: .status(icon: "clock.fill"))

        // Label tags with icons
        Tag(text: "Bitcoin", style: .label(icon: "bitcoinsign.circle.fill"))
        Tag(text: "Simple Label", style: .label())

        // Size variants
        HStack {
            Tag(text: "Small", style: .label(), size: .small)
            Tag(text: "Regular", style: .label(), size: .regular)
            Tag(text: "Large", style: .label(), size: .large)
        }

        // Disabled state
        Tag(text: "Disabled", style: .status())
            .disabled(true)
    }
    .padding()
}
