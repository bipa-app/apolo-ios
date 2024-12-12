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
    private let backgroundColor: Color?
    private let textColor: Color?

    public init(
        text: String,
        style: TagStyle = .label(),
        backgroundColor: Color? = nil,
        textColor: Color? = nil
    ) {
        self.text = text
        self.style = style
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }

    private var resolvedBackgroundColor: Color {
        if let backgroundColor = backgroundColor {
            return backgroundColor
        }
        switch style {
        case .status:
            return .violet
        case .label:
            return .clear
        }
    }

    private var resolvedTextColor: Color {
        if let textColor = textColor {
            return textColor
        }
        switch style {
        case .status:
            return .white
        case .label:
            return .primary
        }
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            if let iconName = style.iconName {
                Image(systemName: iconName)
                    .font(.caption)
                    .frame(width: 24, height: 24)
            }
            Text(text)
                .caption1(weight: .medium)
                .foregroundColor(resolvedTextColor)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(resolvedBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
        .opacity(Environment(\.isEnabled).wrappedValue ? 1.0 : 0.5)
    }
}

#Preview {
    VStack(spacing: 8) {
        Tag(text: "Default Status", style: .status())
        Tag(text: "Custom Status", style: .status(), backgroundColor: .rose)
        Tag(text: "Custom Text", style: .status(), textColor: .black)
        Tag(text: "Default Label", style: .label())
        Tag(text: "Custom Label", style: .label(), backgroundColor: .violet.opacity(0.1))
        Tag(text: "With Icon", style: .label(icon: "bitcoinsign"))
        Tag(text: "Custom Colors",
            style: .label(icon: "star.fill"),
            backgroundColor: .rose.opacity(0.1),
            textColor: .rose)
            .disabled(true)
    }
    .padding()
}
