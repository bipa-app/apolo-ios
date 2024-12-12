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

    var iconName: String? {
        switch self {
        case .status(let icon), .label(let icon):
            return icon
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

    @ViewBuilder
    private func iconView() -> some View {
        if let iconName = style.iconName {
            Image(systemName: iconName)
                .font(.caption)
                .frame(width: 24, height: 24)
        }
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            iconView()
            Text(text)
                .caption1(weight: .medium)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
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

    public func body(content: Content) -> some View {
        content
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
